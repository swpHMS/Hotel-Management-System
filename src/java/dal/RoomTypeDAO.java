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
    // BOOKING SEARCH (DATE RANGE + AVAILABILITY PER NIGHT + CAPACITY BY ROOMQTY + KEYWORD)
    // =====================================================
    //
    // ✅ Your real schema:
    // - rooms(room_id, room_type_id, status, ...)
    // - bookings(booking_id, check_in_date, check_out_date, status, ...)
    // - booking_room_types(booking_room_id, booking_id, room_type_id, quantity, price_at_booking)
    //
    // - availability_holds(hold_id, check_in_date, check_out_date, status, expires_at, ...)
    // - availability_hold_items(hold_id, room_type_id, quantity)
    //
    // HOLD STATUS in your schema:
    // - 1: ACTIVE, 2: CONFIRMED, 3: EXPIRED
    //
    // BOOKING STATUS in your schema:
    // - 1:PENDING,2:CONFIRMED,3:CHECKED_IN,4:CHECKED_OUT,5:CANCELLED
    //
    // Availability rule per night:
    // available = total_available_rooms - booked_qty - held_qty
    // for EVERY night in [checkIn, checkOut)
    //
    private static final String SQL_SEARCH_BOOKING_TEMPLATE =
            "WITH d AS ( " +
            "   SELECT DATEADD(DAY, v.number, ?) AS stay_date " +
            "   FROM master..spt_values v " +
            "   WHERE v.type='P' AND DATEADD(DAY, v.number, ?) < ? " +
            "), total_rooms AS ( " +
            "   SELECT room_type_id, COUNT(*) AS total_rooms " +
            "   FROM dbo.rooms " +
            "   WHERE status = 1 " +                       // ✅ only AVAILABLE rooms
            "   GROUP BY room_type_id " +
            "), booked AS ( " +
            "   SELECT d.stay_date, brt.room_type_id, SUM(brt.quantity) AS booked_qty " +
            "   FROM d " +
            "   JOIN dbo.bookings b ON b.status IN (1,2,3) " + // ✅ PENDING/CONFIRMED/CHECKED_IN
            "       AND d.stay_date >= b.check_in_date " +
            "       AND d.stay_date <  b.check_out_date " +
            "   JOIN dbo.booking_room_types brt ON brt.booking_id = b.booking_id " + // ✅ correct table
            "   GROUP BY d.stay_date, brt.room_type_id " +
            "), held AS ( " +
            "   SELECT d.stay_date, hi.room_type_id, SUM(hi.quantity) AS held_qty " +
            "   FROM d " +
            "   JOIN dbo.availability_holds h " +
            "       ON h.expires_at > SYSDATETIME() " +
            "       AND h.status = 1 " +                     // ✅ ACTIVE = 1
            "       AND d.stay_date >= h.check_in_date " +
            "       AND d.stay_date <  h.check_out_date " +
            "   JOIN dbo.availability_hold_items hi ON hi.hold_id = h.hold_id " +
            "   GROUP BY d.stay_date, hi.room_type_id " +
            "), avail AS ( " +
            "   SELECT tr.room_type_id, d.stay_date, " +
            "          tr.total_rooms " +
            "          - COALESCE(b.booked_qty,0) " +
            "          - COALESCE(h.held_qty,0) AS available " +
            "   FROM d " +
            "   JOIN total_rooms tr ON 1=1 " +
            "   LEFT JOIN booked b ON b.room_type_id=tr.room_type_id AND b.stay_date=d.stay_date " +
            "   LEFT JOIN held  h ON h.room_type_id=tr.room_type_id AND h.stay_date=d.stay_date " +
            "), min_avail AS ( " +
            "   SELECT room_type_id, MIN(available) min_available " +
            "   FROM avail GROUP BY room_type_id " +
            ") " +
            "SELECT TOP (%d) " +
            "  rt.room_type_id, rt.name, rt.description, rt.max_adult, rt.max_children, rt.image_url, rt.status, " +
            "  rv.price AS price_today, " +
            "  ma.min_available AS available_rooms " +
            "FROM dbo.room_types rt " +
            "JOIN min_avail ma ON ma.room_type_id=rt.room_type_id " +
            "OUTER APPLY ( " +
            "   SELECT TOP 1 price, valid_from, valid_to, rate_version_id " +
            "   FROM dbo.rate_versions " +
            "   WHERE room_type_id = rt.room_type_id " +
            "     AND ? BETWEEN valid_from AND valid_to " +
            "   ORDER BY valid_from DESC, rate_version_id DESC " +
            ") rv " +
            "WHERE rt.status=1 " +
            "  AND ma.min_available >= ? " +
            "  AND ( ? = '' OR rt.name LIKE '%%' + ? + '%%' ) " +
            "  AND ( ? <= rt.max_adult * ? ) " +        // ✅ keep your original “capacity by roomQty”
            "  AND ( ? <= rt.max_children * ? ) " +
            "ORDER BY ma.min_available DESC, rt.room_type_id DESC";

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
     * Used by BookingServlet
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

            // d() date range generator params
            ps.setDate(idx++, Date.valueOf(checkIn));   // start date
            ps.setDate(idx++, Date.valueOf(checkIn));   // for DATEADD limit
            ps.setDate(idx++, Date.valueOf(checkOut));  // exclusive end

            // rate at checkIn
            ps.setDate(idx++, Date.valueOf(checkIn));

            // min_available >= roomQty
            ps.setInt(idx++, roomQty);

            // keyword: (?='' OR name like %?%)
            ps.setString(idx++, keyword);
            ps.setString(idx++, keyword);

            // capacity adults <= max_adult * roomQty
            ps.setInt(idx++, adults);
            ps.setInt(idx++, roomQty);

            // capacity children <= max_children * roomQty
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

                    // available_rooms column is selected; map it if your RoomType has a field for it.
                    // (If not, you can ignore it or add: private int availableRooms; + getter/setter)
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
