package dal;

import model.RoomType;
import context.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeDAO {

    // =====================================================
    // BOOKING SEARCH (DATE RANGE + AVAILABILITY BY COUNT BOOKINGS + CAPACITY BY ROOMQTY + KEYWORD)
    // =====================================================
    //
    // ✅ Rule:
    // available = total_rooms_of_type - SUM(booked quantity overlapping [checkIn, checkOut))
    //
    // Overlap condition:
    // booking.check_in < checkOut AND booking.check_out > checkIn
    //
    // NOTE:
    // - This approach does NOT count "holds" (availability_holds).
    // - It counts existing bookings in DB to decide availability.
    //
    private static final String SQL_SEARCH_BOOKING_TEMPLATE =
            "WITH booked AS ( " +
            "   SELECT brt.room_type_id, SUM(brt.quantity) AS booked_qty " +
            "   FROM dbo.bookings b " +
            "   JOIN dbo.booking_room_types brt ON brt.booking_id = b.booking_id " +
            "   WHERE b.status IN (2,3) " + // ✅ CONFIRMED / CHECKED_IN (bạn có thể thêm 1 nếu muốn)
            "     AND b.check_in_date < ? " +  // checkOut
            "     AND b.check_out_date > ? " + // checkIn
            "   GROUP BY brt.room_type_id " +
            "), total_rooms AS ( " +
            "   SELECT room_type_id, COUNT(*) AS total_rooms " +
            "   FROM dbo.rooms " +
            "   WHERE status IN (1) " +        // ✅ AVAILABLE rooms only (tuỳ nghiệp vụ, có thể bỏ filter status)
            "   GROUP BY room_type_id " +
            ") " +
            "SELECT TOP (%d) " +
            "  rt.room_type_id, rt.name, rt.description, rt.max_adult, rt.max_children, rt.image_url, rt.status, " +
            "  rv.price AS price_today, " +
            "  (COALESCE(tr.total_rooms,0) - COALESCE(bk.booked_qty,0)) AS available_rooms " +
            "FROM dbo.room_types rt " +
            "LEFT JOIN total_rooms tr ON tr.room_type_id = rt.room_type_id " +
            "LEFT JOIN booked bk      ON bk.room_type_id = rt.room_type_id " +
            "OUTER APPLY ( " +
            "   SELECT TOP 1 price, valid_from, valid_to, rate_version_id " +
            "   FROM dbo.rate_versions " +
            "   WHERE room_type_id = rt.room_type_id " +
            "     AND ? BETWEEN valid_from AND valid_to " +
            "   ORDER BY valid_from DESC, rate_version_id DESC " +
            ") rv " +
            "WHERE rt.status=1 " +
            "  AND (COALESCE(tr.total_rooms,0) - COALESCE(bk.booked_qty,0)) >= ? " + // >= roomQty
            "  AND ( ? = '' OR rt.name LIKE '%%' + ? + '%%' OR rt.description LIKE '%%' + ? + '%%' ) " +
            "  AND ( ? <= rt.max_adult * ? ) " +        // adults <= max_adult * roomQty
            "  AND ( ? <= rt.max_children * ? ) " +     // children <= max_children * roomQty
            "ORDER BY (COALESCE(tr.total_rooms,0) - COALESCE(bk.booked_qty,0)) DESC, rt.room_type_id DESC";

    // =====================================================
    // NORMAL HOME LOAD (NO DATE FILTER)
    // =====================================================

    private static final String SQL_WITH_RATE_TEMPLATE =
            "SELECT TOP (%d) " +
            "  rt.room_type_id, rt.name, rt.description, rt.max_adult, rt.max_children, rt.image_url, rt.status, " +
            "  rv.price AS price_today " +
            "FROM dbo.room_types rt " +
            "OUTER APPLY ( " +
            "   SELECT TOP 1 price, valid_from, valid_to, rate_version_id " +
            "   FROM dbo.rate_versions " +
            "   WHERE room_type_id = rt.room_type_id " +
            "     AND CAST(GETDATE() AS date) BETWEEN valid_from AND valid_to " +
            "   ORDER BY valid_from DESC, rate_version_id DESC " +
            ") rv " +
            "WHERE rt.status = 1 " +
            "ORDER BY rt.room_type_id DESC";

    private static final String SQL_NO_RATE_TEMPLATE =
            "SELECT TOP (%d) " +
            "  room_type_id, name, description, max_adult, max_children, image_url, status " +
            "FROM dbo.room_types " +
            "WHERE status = 1 " +
            "ORDER BY room_type_id DESC";

    private static final String SQL_COUNT_ACTIVE_ROOMTYPES =
            "SELECT COUNT(*) AS total FROM dbo.room_types WHERE status = 1";

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
     * ✅ Booking search with date range + keyword + capacity by roomQty
     * Used by HomeServlet + BookingServlet
     */
    public List<RoomType> searchForBooking(LocalDate checkIn,
                                          LocalDate checkOut,
                                          String q,
                                          int adults,
                                          int children,
                                          int roomQty,
                                          int limit) {

        List<RoomType> list = new ArrayList<>();
        DBContext db = new DBContext();

        String sql = String.format(SQL_SEARCH_BOOKING_TEMPLATE, limit);
        String keyword = (q == null) ? "" : q.trim();

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int idx = 1;

            // booked CTE overlap params
            ps.setDate(idx++, Date.valueOf(checkOut)); // b.check_in < checkOut
            ps.setDate(idx++, Date.valueOf(checkIn));  // b.check_out > checkIn

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

                    // price can be null if no rate
                    rt.setPriceToday(rs.getBigDecimal("price_today"));

                    // available_rooms column exists; ignore if your model doesn't have field
                    // rt.setAvailableRooms(rs.getInt("available_rooms"));

                    list.add(rt);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Convenience overload (limit default)
    public List<RoomType> searchForBooking(LocalDate checkIn,
                                          LocalDate checkOut,
                                          String q,
                                          int adults,
                                          int children,
                                          int roomQty) {
        return searchForBooking(checkIn, checkOut, q, adults, children, roomQty, 200);
    }

    public int countActiveRoomTypes() throws Exception {
        DBContext db = new DBContext();
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL_COUNT_ACTIVE_ROOMTYPES);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt("total");
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

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
        String sql =
                "SELECT rt.room_type_id, rt.name, rt.description, rt.max_adult, rt.max_children, rt.image_url, rt.status, " +
                "       rv.price AS price_today " +
                "FROM dbo.room_types rt " +
                "OUTER APPLY ( " +
                "   SELECT TOP 1 price, valid_from, valid_to, rate_version_id " +
                "   FROM dbo.rate_versions " +
                "   WHERE room_type_id = rt.room_type_id " +
                "     AND ? BETWEEN valid_from AND valid_to " +
                "   ORDER BY valid_from DESC, rate_version_id DESC " +
                ") rv " +
                "WHERE rt.room_type_id = ? AND rt.status = 1";

        DBContext db = new DBContext();

        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

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
}
