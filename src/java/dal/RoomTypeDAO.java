package dal;

import model.RoomType;
import model.RoomTypeForm;
import model.RoomTypeManagementView;
import context.DBContext;
import model.Amenity;
import model.RoomTypeImage;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RoomTypeDAO {

    private volatile String lastErrorMessage;
    private static final LocalDate OPEN_ENDED_RATE_DATE = LocalDate.of(9999, 12, 31);

    // =====================================================
    // BOOKING SEARCH (DATE RANGE + AVAILABILITY BY INVENTORY + CAPACITY BY ROOMQTY + KEYWORD)
    // =====================================================
    //
    // ✅ Rule:
    // available = MIN(total_rooms - booked_rooms - held_rooms) in [checkIn, checkOut)
    //
    // Overlap condition in inventory:
    // inventory_date >= checkIn AND inventory_date < checkOut
    //
    // NOTE:
    // - This uses dbo.room_type_inventory to keep the same logic as receptionist side.
    // - held_rooms is included.
    //

    private static final String SQL_SEARCH_BOOKING_BASE =
            "WITH inv AS ( " +
            "   SELECT rti.room_type_id, " +
            "          MIN(rti.total_rooms - rti.booked_rooms - rti.held_rooms) AS available_rooms " +
            "   FROM dbo.room_type_inventory rti " +
            "   WHERE rti.inventory_date >= ? " +
            "     AND rti.inventory_date < ? " +
            "   GROUP BY rti.room_type_id " +
            ") " +
            "SELECT TOP (%d) " +
            "  rt.room_type_id, rt.name, rt.description, rt.max_adult, rt.max_children, rt.image_url, rt.status, " +
            "  rv.price AS price_today, " +
            "  COALESCE(inv.available_rooms, 0) AS available_rooms " +
            "FROM dbo.room_types rt " +
            "LEFT JOIN inv ON inv.room_type_id = rt.room_type_id " +
            "OUTER APPLY ( " +
            "   SELECT TOP 1 price, valid_from, valid_to, rate_version_id " +
            "   FROM dbo.rate_versions " +
            "   WHERE room_type_id = rt.room_type_id " +
            "     AND ? BETWEEN valid_from AND valid_to " +
            "   ORDER BY valid_from DESC, rate_version_id DESC " +
            ") rv " +
            "WHERE rt.status=1 " +
            "  AND COALESCE(inv.available_rooms, 0) >= ? " +
            "  AND ( ? = '' OR rt.name LIKE '%%' + ? + '%%' OR rt.description LIKE '%%' + ? + '%%' ) " +
            "  AND ( ? <= rt.max_adult * ? ) " +
            "  AND ( ? <= rt.max_children * ? ) ";
    private static final String SQL_SEARCH_BOOKING_BASE
            = "WITH booked AS ( "
            + "   SELECT brt.room_type_id, SUM(brt.quantity) AS booked_qty "
            + "   FROM dbo.bookings b "
            + "   JOIN dbo.booking_room_types brt ON brt.booking_id = b.booking_id "
            + "   WHERE b.status IN (2,3) "
            + "     AND b.check_in_date < ? "
            + "     AND b.check_out_date > ? "
            + "   GROUP BY brt.room_type_id "
            + "), total_rooms AS ( "
            + "   SELECT room_type_id, COUNT(*) AS total_rooms "
            + "   FROM dbo.rooms "
            + "   WHERE status IN (1) "
            + "   GROUP BY room_type_id "
            + ") "
            + "SELECT TOP (%d) "
            + "  rt.room_type_id, rt.name, rt.description, rt.max_adult, rt.max_children, rt.image_url, rt.status, "
            + "  rv.price AS price_today, "
            + "  (COALESCE(tr.total_rooms,0) - COALESCE(bk.booked_qty,0)) AS available_rooms "
            + "FROM dbo.room_types rt "
            + "LEFT JOIN total_rooms tr ON tr.room_type_id = rt.room_type_id "
            + "LEFT JOIN booked bk      ON bk.room_type_id = rt.room_type_id "
            + "OUTER APPLY ( "
            + "   SELECT TOP 1 price, valid_from, valid_to, rate_version_id "
            + "   FROM dbo.rate_versions "
            + "   WHERE room_type_id = rt.room_type_id "
            + "     AND ? BETWEEN valid_from AND valid_to "
            + "   ORDER BY valid_from DESC, rate_version_id DESC "
            + ") rv "
            + "WHERE rt.status=1 "
            + "  AND (COALESCE(tr.total_rooms,0) - COALESCE(bk.booked_qty,0)) >= ? "
            + "  AND ( ? = '' OR rt.name LIKE '%%' + ? + '%%' OR rt.description LIKE '%%' + ? + '%%' ) "
            + "  AND ( ? <= rt.max_adult * ? ) "
            + "  AND ( ? <= rt.max_children * ? ) ";

    // =====================================================
    // NORMAL HOME LOAD (NO DATE FILTER)
    // =====================================================
    private static final String SQL_WITH_RATE_TEMPLATE
            = "SELECT TOP (%d) "
            + "  rt.room_type_id, rt.name, rt.description, rt.max_adult, rt.max_children, rt.image_url, rt.status, "
            + "  rv.price AS price_today "
            + "FROM dbo.room_types rt "
            + "OUTER APPLY ( "
            + "   SELECT TOP 1 price, valid_from, valid_to, rate_version_id "
            + "   FROM dbo.rate_versions "
            + "   WHERE room_type_id = rt.room_type_id "
            + "     AND CAST(GETDATE() AS date) BETWEEN valid_from AND valid_to "
            + "   ORDER BY valid_from DESC, rate_version_id DESC "
            + ") rv "
            + "WHERE rt.status = 1 "
            + "ORDER BY rt.room_type_id DESC";

    private static final String SQL_NO_RATE_TEMPLATE
            = "SELECT TOP (%d) "
            + "  room_type_id, name, description, max_adult, max_children, image_url, status "
            + "FROM dbo.room_types "
            + "WHERE status = 1 "
            + "ORDER BY room_type_id DESC";

    private static final String SQL_COUNT_ACTIVE_ROOMTYPES
            = "SELECT COUNT(*) AS total FROM dbo.room_types WHERE status = 1";

    // ✅ NEW: lấy availableQty từ inventory theo khoảng ngày
    private static final String SQL_GET_AVAILABLE_ROOM_QTY =
            "SELECT MIN(rti.total_rooms - rti.booked_rooms - rti.held_rooms) AS available_qty " +
            "FROM dbo.room_type_inventory rti " +
            "WHERE rti.room_type_id = ? " +
            "  AND rti.inventory_date >= ? " +
            "  AND rti.inventory_date < ? ";

    // =====================================================
    // PUBLIC METHODS
    // =====================================================
    public List<RoomType> getActiveRoomTypesForHome(int limit) {
        List<RoomType> withRate;

        try {
            withRate = fetch(limit, true);
            if (withRate != null && !withRate.isEmpty()) {
                return withRate;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            return fetch(limit, false);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ArrayList<>();
    }

    /**
     * Booking search with date range + keyword + capacity by roomQty + sort
     */
    public List<RoomType> searchForBooking(LocalDate checkIn,
            LocalDate checkOut,
            String q,
            int adults,
            int children,
            int roomQty,
            int limit,
            String sort) {

        List<RoomType> list = new ArrayList<>();
        DBContext db = new DBContext();

        String orderBy;
if ("priceAsc".equalsIgnoreCase(sort)) {
    orderBy = " ORDER BY COALESCE(rv.price, 999999999) ASC, rt.room_type_id DESC";
} else if ("priceDesc".equalsIgnoreCase(sort)) {
    orderBy = " ORDER BY COALESCE(rv.price, 0) DESC, rt.room_type_id DESC";
} else {
    orderBy = " ORDER BY COALESCE(inv.available_rooms, 0) DESC, rt.room_type_id DESC";
}

        String sql = String.format(SQL_SEARCH_BOOKING_BASE, limit) + orderBy;
        String keyword = (q == null) ? "" : q.trim();

        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            int idx = 1;

            // inventory range params
            ps.setDate(idx++, Date.valueOf(checkIn));
            ps.setDate(idx++, Date.valueOf(checkOut));

            // rate at checkIn
            ps.setDate(idx++, Date.valueOf(checkIn));

            // availability >= roomQty
            ps.setInt(idx++, roomQty);

            // keyword
            ps.setString(idx++, keyword);
            ps.setString(idx++, keyword);
            ps.setString(idx++, keyword);

            // capacity adults
            ps.setInt(idx++, adults);
            ps.setInt(idx++, roomQty);

            // capacity children
            ps.setInt(idx++, children);
            ps.setInt(idx++, roomQty);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomType rt = new RoomType();
                    rt.setRoomTypeId(rs.getInt("room_type_id"));
                    rt.setName(rs.getString("name"));
                    rt.setDescription(rs.getString("description"));
                    rt.setMaxAdult(rs.getInt("max_adult"));
                    rt.setMaxChildren(rs.getInt("max_children"));
                    rt.setImageUrl(rs.getString("image_url"));
                    rt.setStatus(rs.getInt("status"));
                    rt.setPriceToday(rs.getBigDecimal("price_today"));
                    rt.setAvailableQty(rs.getInt("available_rooms"));
                    list.add(rt);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Overload có sort, limit mặc định = 200
     */
    public List<RoomType> searchForBooking(LocalDate checkIn,
            LocalDate checkOut,
            String q,
            int adults,
            int children,
            int roomQty,
            String sort) {
        return searchForBooking(checkIn, checkOut, q, adults, children, roomQty, 200, sort);
    }

    /**
     * Method cũ giữ lại để không vỡ code cũ
     */
    public List<RoomType> searchForBooking(LocalDate checkIn,
            LocalDate checkOut,
            String q,
            int adults,
            int children,
            int roomQty,
            int limit) {
        return searchForBooking(checkIn, checkOut, q, adults, children, roomQty, limit, "");
    }

    /**
     * Convenience overload cũ
     */
    public List<RoomType> searchForBooking(LocalDate checkIn,
            LocalDate checkOut,
            String q,
            int adults,
            int children,
            int roomQty) {
        return searchForBooking(checkIn, checkOut, q, adults, children, roomQty, 200, "");
    }

    public int countActiveRoomTypes() throws Exception {
        DBContext db = new DBContext();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(SQL_COUNT_ACTIVE_ROOMTYPES); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    // ✅ NEW: dùng cho BookingServlet / JSP để biết tối đa còn bao nhiêu phòng
    public int getAvailableRoomQty(int roomTypeId, LocalDate checkIn, LocalDate checkOut) {
        if (roomTypeId <= 0 || checkIn == null || checkOut == null || !checkOut.isAfter(checkIn)) {
            return 0;
        }

        DBContext db = new DBContext();

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_GET_AVAILABLE_ROOM_QTY)) {

            ps.setInt(1, roomTypeId);
            ps.setDate(2, Date.valueOf(checkIn));
            ps.setDate(3, Date.valueOf(checkOut));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int available = rs.getInt("available_qty");
                    if (rs.wasNull()) {
                        return 0;
                    }
                    return Math.max(available, 0);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // =====================================================
    // PRIVATE FETCH METHODS (HOME)
    // =====================================================
    private List<RoomType> fetch(int limit, boolean withRate) throws Exception {

        List<RoomType> list = new ArrayList<>();
        DBContext db = new DBContext();

        String sql = withRate
                ? String.format(SQL_WITH_RATE_TEMPLATE, limit)
                : String.format(SQL_NO_RATE_TEMPLATE, limit);

        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RoomType rt = new RoomType();

                rt.setRoomTypeId(rs.getInt("room_type_id"));
                rt.setName(rs.getString("name"));
                rt.setDescription(rs.getString("description"));
                rt.setMaxAdult(rs.getInt("max_adult"));
                rt.setMaxChildren(rs.getInt("max_children"));
                rt.setImageUrl(rs.getString("image_url"));
                rt.setStatus(rs.getInt("status"));

                if (withRate) {
                    rt.setPriceToday(rs.getBigDecimal("price_today"));
                } else {
                    rt.setPriceToday(null);
                }

                list.add(rt);
            }
        }

        return list;
    }

    // =====================================================
    // EXISTING: get room type by id with rate (keep)
    // =====================================================
    public RoomType getRoomTypeByIdWithRate(int roomTypeId, LocalDate atDate) {
        String sql
                = "SELECT rt.room_type_id, rt.name, rt.description, rt.max_adult, rt.max_children, rt.image_url, rt.status, "
                + "       rv.price AS price_today "
                + "FROM dbo.room_types rt "
                + "OUTER APPLY ( "
                + "   SELECT TOP 1 price, valid_from, valid_to, rate_version_id "
                + "   FROM dbo.rate_versions "
                + "   WHERE room_type_id = rt.room_type_id "
                + "     AND ? BETWEEN valid_from AND valid_to "
                + "   ORDER BY valid_from DESC, rate_version_id DESC "
                + ") rv "
                + "WHERE rt.room_type_id = ? AND rt.status = 1";

        DBContext db = new DBContext();

        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, Date.valueOf(atDate));
            ps.setInt(2, roomTypeId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RoomType rt = new RoomType();
                    rt.setRoomTypeId(rs.getInt("room_type_id"));
                    rt.setName(rs.getString("name"));
                    rt.setDescription(rs.getString("description"));
                    rt.setMaxAdult(rs.getInt("max_adult"));
                    rt.setMaxChildren(rs.getInt("max_children"));
                    rt.setImageUrl(rs.getString("image_url"));
                    rt.setStatus(rs.getInt("status"));
                    rt.setPriceToday(rs.getBigDecimal("price_today"));
                    return rt;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
       // =====================================================
    // MANAGER ROOM TYPE MANAGEMENT
    // =====================================================

    public List<RoomTypeManagementView> getRoomTypesForManager(String keyword) {
        String sql = """
                SELECT
                    rt.room_type_id,
                    rt.name,
                    rt.description,
                    rt.max_adult,
                    rt.max_children,
                    COALESCE(rt.image_url, thumb.image_url) AS image_url,
                    rt.status,
                    rv.price,
                    rv.valid_from,
                    rv.valid_to
                FROM dbo.room_types rt
                OUTER APPLY (
                    SELECT TOP 1 image_url
                    FROM dbo.room_type_images
                    WHERE room_type_id = rt.room_type_id
                    ORDER BY is_thumbnail DESC, sort_order ASC, image_id ASC
                ) thumb
                OUTER APPLY (
                    SELECT TOP 1 price, valid_from, valid_to, rate_version_id
                    FROM dbo.rate_versions
                    WHERE room_type_id = rt.room_type_id
                    ORDER BY valid_from DESC, rate_version_id DESC
                ) rv
                WHERE (? = '' OR rt.name LIKE N'%' + ? + N'%' OR rt.description LIKE N'%' + ? + N'%')
                ORDER BY rt.room_type_id DESC
                """;

        List<RoomTypeManagementView> list = new ArrayList<>();
        DBContext db = new DBContext();
        String q = keyword == null ? "" : keyword.trim();

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, q);
            ps.setString(2, q);
            ps.setString(3, q);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomTypeManagementView v = new RoomTypeManagementView();
                    v.setRoomTypeId(rs.getInt("room_type_id"));
                    v.setName(rs.getString("name"));
                    v.setImageUrl(rs.getString("image_url"));
                    v.setMaxAdult(rs.getInt("max_adult"));
                    v.setMaxChildren(rs.getInt("max_children"));
                    v.setStatus(rs.getInt("status"));
                    v.setCurrentPrice(rs.getBigDecimal("price"));

                    Date validFrom = rs.getDate("valid_from");
                    Date validTo = rs.getDate("valid_to");
                    v.setValidFrom(validFrom == null ? null : validFrom.toLocalDate());
                    v.setValidTo(validTo == null ? null : validTo.toLocalDate());

                    fillMetadata(v, rs.getString("description"));
                    hydrateAmenities(con, v);
                    hydrateImages(con, v);
                    list.add(v);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public RoomTypeManagementView getRoomTypeForManagerById(int roomTypeId) {
        List<RoomTypeManagementView> items = getRoomTypesForManager(null);
        for (RoomTypeManagementView item : items) {
            if (item.getRoomTypeId() == roomTypeId) {
                return item;
            }
        }
        return null;
    }

    public List<Amenity> getAllActiveAmenities() {
        String sql = "SELECT amenity_id, code, name, description, category, is_active FROM dbo.amenities WHERE is_active = 1 ORDER BY name";
        List<Amenity> list = new ArrayList<>();
        DBContext db = new DBContext();

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Amenity a = new Amenity();
                a.setAmenityId(rs.getInt("amenity_id"));
                a.setCode(rs.getString("code"));
                a.setName(rs.getString("name"));
                a.setDescription(rs.getString("description"));
                a.setCategory(rs.getInt("category"));
                a.setActive(rs.getBoolean("is_active"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean existsRoomTypeName(String name, Integer excludeRoomTypeId) {
        if (name == null || name.trim().isEmpty()) {
            return false;
        }

        String sql = """
                SELECT TOP 1 1
                FROM dbo.room_types
                WHERE LOWER(LTRIM(RTRIM(name))) = LOWER(LTRIM(RTRIM(?)))
                  AND (? IS NULL OR room_type_id <> ?)
                """;

        DBContext db = new DBContext();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            if (excludeRoomTypeId == null) {
                ps.setNull(2, Types.INTEGER);
                ps.setNull(3, Types.INTEGER);
            } else {
                ps.setInt(2, excludeRoomTypeId);
                ps.setInt(3, excludeRoomTypeId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            lastErrorMessage = describeError(e);
            e.printStackTrace();
            return false;
        }
    }

    public boolean createRoomType(RoomTypeForm form, String imageUrl) {
        return createRoomType(form, imageUrl, new ArrayList<>());
    }

    public boolean createRoomType(RoomTypeForm form, String imageUrl, List<String> galleryImageUrls) {
        lastErrorMessage = null;
        String insertRoomType = "INSERT INTO dbo.room_types(name, description, max_adult, max_children, image_url, status) VALUES (?, ?, ?, ?, ?, ?)";
        String selectIdentity = "SELECT CAST(SCOPE_IDENTITY() AS int) AS room_type_id";
        String insertAmenity = "INSERT INTO dbo.room_type_amenities(room_type_id, amenity_id) VALUES (?, ?)";

        DBContext db = new DBContext();
        try (Connection con = db.getConnection()) {
            con.setAutoCommit(false);

            int roomTypeId;
            try (PreparedStatement ps = con.prepareStatement(insertRoomType)) {
                ps.setString(1, form.getName().trim());
                ps.setString(2, form.toStoredDescription());
                ps.setInt(3, form.getMaxAdult());
                ps.setInt(4, form.getMaxChildren());
                ps.setString(5, imageUrl);
                ps.setInt(6, form.getStatus());
                int inserted = ps.executeUpdate();
                if (inserted <= 0) {
                    lastErrorMessage = "Room type insert returned no affected rows.";
                    con.rollback();
                    return false;
                }
            }

            try (PreparedStatement psIdentity = con.prepareStatement(selectIdentity);
                 ResultSet key = psIdentity.executeQuery()) {
                if (key == null || !key.next()) {
                    lastErrorMessage = "Could not read inserted room type ID.";
                    con.rollback();
                    return false;
                }
                roomTypeId = key.getInt("room_type_id");
                if (roomTypeId <= 0) {
                    lastErrorMessage = "Inserted room type ID was invalid.";
                    con.rollback();
                    return false;
                }
            }

            if (imageUrl != null && !imageUrl.isBlank()) {
                upsertThumbnailImage(con, roomTypeId, imageUrl);
            }

            insertGalleryImages(con, roomTypeId, galleryImageUrls);

            if (form.getAmenityIds() != null && !form.getAmenityIds().isEmpty()) {
                try (PreparedStatement psAmenity = con.prepareStatement(insertAmenity)) {
                    for (Integer amenityId : uniqueAmenityIds(form.getAmenityIds())) {
                        psAmenity.setInt(1, roomTypeId);
                        psAmenity.setInt(2, amenityId);
                        psAmenity.addBatch();
                    }
                    psAmenity.executeBatch();
                }
            }

            if (form.getPrice() != null) {
                upsertRateVersion(con, roomTypeId, form.getPrice(), LocalDate.now().plusDays(1));
            }

            con.commit();
            return true;
        } catch (Exception e) {
            lastErrorMessage = describeError(e);
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateRoomType(int roomTypeId, RoomTypeForm form, String imageUrl, boolean replaceImage) {
        return updateRoomType(roomTypeId, form, imageUrl, replaceImage, new ArrayList<>());
    }

    public boolean updateRoomType(int roomTypeId, RoomTypeForm form, String imageUrl, boolean replaceImage, List<String> galleryImageUrls) {
        lastErrorMessage = null;
        String updateRoomType = "UPDATE dbo.room_types SET name=?, description=?, max_adult=?, max_children=?, status=?, image_url = CASE WHEN ? = 1 THEN ? ELSE image_url END WHERE room_type_id=?";
        String deleteAmenity = "DELETE FROM dbo.room_type_amenities WHERE room_type_id = ?";
        String insertAmenity = "INSERT INTO dbo.room_type_amenities(room_type_id, amenity_id) VALUES (?, ?)";

        DBContext db = new DBContext();
        try (Connection con = db.getConnection()) {
            con.setAutoCommit(false);

            try (PreparedStatement ps = con.prepareStatement(updateRoomType)) {
                ps.setString(1, form.getName().trim());
                ps.setString(2, form.toStoredDescription());
                ps.setInt(3, form.getMaxAdult());
                ps.setInt(4, form.getMaxChildren());
                ps.setInt(5, form.getStatus());
                ps.setInt(6, replaceImage ? 1 : 0);
                ps.setString(7, imageUrl);
                ps.setInt(8, roomTypeId);
                ps.executeUpdate();
            }

            if (replaceImage && imageUrl != null && !imageUrl.isBlank()) {
                upsertThumbnailImage(con, roomTypeId, imageUrl);
            }

            insertGalleryImages(con, roomTypeId, galleryImageUrls);

            try (PreparedStatement psDeleteAmenity = con.prepareStatement(deleteAmenity)) {
                psDeleteAmenity.setInt(1, roomTypeId);
                psDeleteAmenity.executeUpdate();
            }

            if (form.getAmenityIds() != null && !form.getAmenityIds().isEmpty()) {
                try (PreparedStatement psAmenity = con.prepareStatement(insertAmenity)) {
                    for (Integer amenityId : uniqueAmenityIds(form.getAmenityIds())) {
                        psAmenity.setInt(1, roomTypeId);
                        psAmenity.setInt(2, amenityId);
                        psAmenity.addBatch();
                    }
                    psAmenity.executeBatch();
                }
            }

            if (form.getPrice() != null) {
                upsertRateVersion(con, roomTypeId, form.getPrice(), LocalDate.now());
            }

            con.commit();
            return true;
        } catch (Exception e) {
            lastErrorMessage = describeError(e);
            e.printStackTrace();
            return false;
        }
    }

    private void hydrateAmenities(Connection con, RoomTypeManagementView view) {
        String sql = """
                SELECT a.amenity_id, a.name
                FROM dbo.room_type_amenities rta
                JOIN dbo.amenities a ON a.amenity_id = rta.amenity_id
                WHERE rta.room_type_id = ?
                ORDER BY a.name
                """;

        List<Integer> amenityIds = new ArrayList<>();
        List<String> amenityNames = new ArrayList<>();

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, view.getRoomTypeId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    amenityIds.add(rs.getInt("amenity_id"));
                    amenityNames.add(rs.getString("name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        view.setAmenityIds(amenityIds);
        view.setAmenityNames(amenityNames);
    }

    private void hydrateImages(Connection con, RoomTypeManagementView view) {
        String sql = """
                SELECT image_id, room_type_id, image_url, is_thumbnail, sort_order, created_at
                FROM dbo.room_type_images
                WHERE room_type_id = ?
                ORDER BY is_thumbnail DESC, sort_order ASC, image_id ASC
                """;

        List<RoomTypeImage> images = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, view.getRoomTypeId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomTypeImage image = new RoomTypeImage();
                    image.setImageId(rs.getInt("image_id"));
                    image.setRoomTypeId(rs.getInt("room_type_id"));
                    image.setImageUrl(rs.getString("image_url"));
                    image.setThumbnail(rs.getBoolean("is_thumbnail"));
                    image.setSortOrder(rs.getInt("sort_order"));
                    image.setCreatedAt(rs.getTimestamp("created_at"));
                    images.add(image);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        view.setImages(images);
    }

    public boolean deleteGalleryImage(int roomTypeId, int imageId) {
        lastErrorMessage = null;
        String sql = """
                DELETE FROM dbo.room_type_images
                WHERE room_type_id = ? AND image_id = ? AND ISNULL(is_thumbnail, 0) = 0
                """;

        DBContext db = new DBContext();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.setInt(2, imageId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            lastErrorMessage = describeError(e);
            e.printStackTrace();
            return false;
        }
    }

    public String getLastErrorMessage() {
        return lastErrorMessage;
    }

    private String describeError(Exception e) {
        if (e == null) {
            return "Unknown error";
        }
        String message = e.getMessage();
        if (message != null && !message.isBlank()) {
            return e.getClass().getSimpleName() + ": " + message;
        }
        return e.toString();
    }

    private Set<Integer> uniqueAmenityIds(List<Integer> amenityIds) {
        Set<Integer> set = new LinkedHashSet<>();
        for (Integer id : amenityIds) {
            if (id != null && id > 0) {
                set.add(id);
            }
        }
        return set;
    }

    private void upsertThumbnailImage(Connection con, int roomTypeId, String imageUrl) throws SQLException {
        String clearThumbnail = "UPDATE dbo.room_type_images SET is_thumbnail = 0 WHERE room_type_id = ?";
        String updateExisting = """
                UPDATE dbo.room_type_images
                SET image_url = ?, is_thumbnail = 1, sort_order = COALESCE(sort_order, 0)
                WHERE image_id = (
                    SELECT TOP 1 image_id
                    FROM dbo.room_type_images
                    WHERE room_type_id = ?
                    ORDER BY is_thumbnail DESC, sort_order ASC, image_id ASC
                )
                """;
        String insertNew = """
                INSERT INTO dbo.room_type_images(room_type_id, image_url, is_thumbnail, sort_order, created_at)
                VALUES (?, ?, 1, 0, GETDATE())
                """;

        try (PreparedStatement psClear = con.prepareStatement(clearThumbnail)) {
            psClear.setInt(1, roomTypeId);
            psClear.executeUpdate();
        }

        int updated;
        try (PreparedStatement psUpdate = con.prepareStatement(updateExisting)) {
            psUpdate.setString(1, imageUrl);
            psUpdate.setInt(2, roomTypeId);
            updated = psUpdate.executeUpdate();
        }

        if (updated == 0) {
            try (PreparedStatement psInsert = con.prepareStatement(insertNew)) {
                psInsert.setInt(1, roomTypeId);
                psInsert.setString(2, imageUrl);
                psInsert.executeUpdate();
            }
        }
    }

    private void insertGalleryImages(Connection con, int roomTypeId, List<String> imageUrls) throws SQLException {
        if (imageUrls == null || imageUrls.isEmpty()) {
            return;
        }

        String nextOrderSql = "SELECT COALESCE(MAX(sort_order), 0) FROM dbo.room_type_images WHERE room_type_id = ?";
        String insertSql = """
                INSERT INTO dbo.room_type_images(room_type_id, image_url, is_thumbnail, sort_order, created_at)
                VALUES (?, ?, 0, ?, GETDATE())
                """;

        int nextSortOrder = 1;
        try (PreparedStatement psOrder = con.prepareStatement(nextOrderSql)) {
            psOrder.setInt(1, roomTypeId);
            try (ResultSet rs = psOrder.executeQuery()) {
                if (rs.next()) {
                    nextSortOrder = rs.getInt(1) + 1;
                }
            }
        }

        try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
            for (String imageUrl : imageUrls) {
                if (imageUrl == null || imageUrl.isBlank()) {
                    continue;
                }
                psInsert.setInt(1, roomTypeId);
                psInsert.setString(2, imageUrl);
                psInsert.setInt(3, nextSortOrder++);
                psInsert.addBatch();
            }
            psInsert.executeBatch();
        }
    }

    private void upsertRateVersion(Connection con, int roomTypeId, java.math.BigDecimal price, LocalDate effectiveFrom) throws SQLException {
        String closeOpenRateSql = """
                UPDATE dbo.rate_versions
                SET valid_to = ?
                WHERE room_type_id = ?
                  AND valid_to = ?
                  AND valid_from < ?
                """;
        String updateSameDayRateSql = """
                UPDATE dbo.rate_versions
                SET price = ?, valid_to = ?
                WHERE room_type_id = ?
                  AND valid_from = ?
                """;
        String insertRateSql = """
                INSERT INTO dbo.rate_versions(room_type_id, price, valid_from, valid_to)
                VALUES (?, ?, ?, ?)
                """;

        LocalDate previousValidTo = effectiveFrom.minusDays(1);

        try (PreparedStatement psUpdateSameDay = con.prepareStatement(updateSameDayRateSql)) {
            psUpdateSameDay.setBigDecimal(1, price);
            psUpdateSameDay.setDate(2, Date.valueOf(OPEN_ENDED_RATE_DATE));
            psUpdateSameDay.setInt(3, roomTypeId);
            psUpdateSameDay.setDate(4, Date.valueOf(effectiveFrom));
            if (psUpdateSameDay.executeUpdate() > 0) {
                return;
            }
        }

        try (PreparedStatement psClose = con.prepareStatement(closeOpenRateSql)) {
            psClose.setDate(1, Date.valueOf(previousValidTo));
            psClose.setInt(2, roomTypeId);
            psClose.setDate(3, Date.valueOf(OPEN_ENDED_RATE_DATE));
            psClose.setDate(4, Date.valueOf(effectiveFrom));
            psClose.executeUpdate();
        }

        try (PreparedStatement psInsert = con.prepareStatement(insertRateSql)) {
            psInsert.setInt(1, roomTypeId);
            psInsert.setBigDecimal(2, price);
            psInsert.setDate(3, Date.valueOf(effectiveFrom));
            psInsert.setDate(4, Date.valueOf(OPEN_ENDED_RATE_DATE));
            psInsert.executeUpdate();
        }
    }

    private void fillMetadata(RoomTypeManagementView view, String storedDescription) {
        view.setDescriptionRaw(storedDescription == null ? "" : storedDescription);

        String bed = extractToken(storedDescription, "BED");
        String roomView = extractToken(storedDescription, "VIEW");
        String size = extractToken(storedDescription, "SIZE");

        if ((bed == null || bed.isBlank()) && (roomView == null || roomView.isBlank()) && (size == null || size.isBlank())) {
            LegacyDescriptionParts legacyParts = parseLegacyDescription(storedDescription);
            bed = legacyParts.bedType;
            roomView = legacyParts.viewType;
            size = legacyParts.roomSize;
            view.setDescriptionPlain(legacyParts.plainDescription);
        }

        view.setBedType(bed == null ? "N/A" : bed);
        view.setViewType(roomView == null ? "N/A" : roomView);

        int sqm = 0;
        try {
            if (size != null && !size.isBlank()) {
                sqm = Integer.parseInt(size.trim());
            }
        } catch (NumberFormatException ignore) {
            sqm = 0;
        }
        view.setRoomSize(sqm);

        String plain = storedDescription == null ? "" : storedDescription;
        plain = plain.replaceAll("\\[BED:[^\\]]*\\]", "")
                     .replaceAll("\\[VIEW:[^\\]]*\\]", "")
                     .replaceAll("\\[SIZE:[^\\]]*\\]", "")
                     .trim();
        if (view.getDescriptionPlain() == null || view.getDescriptionPlain().isBlank()) {
            view.setDescriptionPlain(plain);
        }
    }

    private String extractToken(String text, String token) {
        if (text == null) return null;
        String marker = "[" + token + ":";
        int start = text.indexOf(marker);
        if (start < 0) return null;
        int end = text.indexOf("]", start);
        if (end < 0) return null;
        return text.substring(start + marker.length(), end).trim();
    }

    private LegacyDescriptionParts parseLegacyDescription(String description) {
        LegacyDescriptionParts parts = new LegacyDescriptionParts();
        if (description == null || description.isBlank()) {
            return parts;
        }

        String normalized = description.trim().replaceAll("\\s*[•·]\\s*", " • ");
        String[] segments = normalized.split("\\s+•\\s+");

        if (segments.length > 0) {
            parts.bedType = blankToNull(segments[0]);
        }
        if (segments.length > 1) {
            parts.viewType = blankToNull(segments[1]);
        }
        if (segments.length > 2) {
            parts.roomSize = extractDigits(segments[2]);
        }
        if (segments.length > 3) {
            StringBuilder plain = new StringBuilder();
            for (int i = 3; i < segments.length; i++) {
                if (segments[i] == null || segments[i].isBlank()) {
                    continue;
                }
                if (plain.length() > 0) {
                    plain.append(" ");
                }
                plain.append(segments[i].trim());
            }
            parts.plainDescription = plain.toString();
        }

        if (parts.roomSize == null) {
            parts.roomSize = extractDigits(normalized);
        }

        if (parts.plainDescription == null) {
            // Legacy descriptions usually only contain metadata, so keep the plain description empty.
            parts.plainDescription = "";
        }
        return parts;
    }

    private String extractDigits(String text) {
        if (text == null) {
            return null;
        }
        Matcher matcher = Pattern.compile("(\\d+)").matcher(text);
        return matcher.find() ? matcher.group(1) : null;
    }

    private String blankToNull(String text) {
        if (text == null) {
            return null;
        }
        String trimmed = text.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private static class LegacyDescriptionParts {
        private String bedType;
        private String viewType;
        private String roomSize;
        private String plainDescription;
    }
}
