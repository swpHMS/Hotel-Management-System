package dal;

import context.DBContext;
import model.BookingCardView;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.BookingDashboard;
import java.sql.*;
import java.util.Map;
import model.DashboardStats;
import model.Room;
import model.StayRoomAssignment;

public class BookingDAO extends DBContext {

    // =========================================================
    // STATUS
    // 1 = Pending
    // 2 = Confirmed
    // 3 = Checked-in
    // 4 = Checked-out
    // 5 = Cancelled
    // 6 = No-show
    // =========================================================
    // =========================================================
    // GET CUSTOMER ID
    // =========================================================
    public Integer getCustomerIdByUserId(int userId) {

        String sql = """
            SELECT customer_id
            FROM dbo.customers
            WHERE user_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("customer_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =========================================================
    // AUTO UPDATE NO-SHOW
    // =========================================================
    private void updateNoShowBookings() {

        String sql = """
            UPDATE dbo.bookings
            SET status = 6
            WHERE status IN (1,2)
                AND check_in_date < CAST(GETDATE() AS DATE)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================================================
    // CURRENT BOOKINGS
    // =========================================================
    public List<BookingCardView> getCurrentBookingsByCustomerId(int customerId) {

        updateNoShowBookings();

        String sql = """
            SELECT
                b.booking_id       AS bookingId,
                b.status           AS bookingStatus,
                b.check_in_date    AS checkInDate,
                b.check_out_date   AS checkOutDate,
                b.total_amount     AS totalAmount,

                rt.room_type_id    AS roomTypeId,
                rt.name            AS roomTypeName,
                rt.description     AS roomMeta,
                rt.max_adult       AS maxAdult,
                rt.max_children    AS maxChildren,

                rti.imageUrls AS imageUrls,

                SUM(brt.quantity)         AS quantity,
                MIN(brt.price_at_booking) AS priceAtBooking,

                amen.amenitiesText AS amenitiesText

            FROM dbo.bookings b
            JOIN dbo.booking_room_types brt 
                 ON brt.booking_id = b.booking_id

            JOIN dbo.room_types rt 
                 ON rt.room_type_id = brt.room_type_id

            OUTER APPLY (
                SELECT STRING_AGG(image_url, '|') AS imageUrls
                FROM dbo.room_type_images
                WHERE room_type_id = rt.room_type_id
            ) rti
               
            OUTER APPLY (
                SELECT STRING_AGG(a.name, ', ') AS amenitiesText
                FROM dbo.room_type_amenities rta
                JOIN dbo.amenities a 
                     ON a.amenity_id = rta.amenity_id
                WHERE rta.room_type_id = rt.room_type_id
                  AND a.is_active = 1
            ) amen

            WHERE b.customer_id = ?
              AND b.status IN (1,2,3)
              AND b.check_out_date >= CAST(GETDATE() AS DATE)

            GROUP BY
                b.booking_id, b.status, b.check_in_date, 
                b.check_out_date, b.total_amount,
                rt.room_type_id, rt.name, rt.description, 
                rt.max_adult, rt.max_children,
                     rti.imageUrls,
                amen.amenitiesText

            ORDER BY b.check_in_date ASC
        """;

        return executeBookingQuery(sql, customerId);
    }


    // =========================================================
    public boolean cancelBooking(int bookingId, int customerId) {

        String lockSql = """
        SELECT status, check_in_date, check_out_date
        FROM dbo.bookings WITH (UPDLOCK, ROWLOCK)
        WHERE booking_id = ?
          AND customer_id = ?
    """;

        String restoreInventorySql = """
        UPDATE rti
        SET rti.booked_rooms =
            CASE
                WHEN rti.booked_rooms - brt.quantity < 0
                THEN 0
                ELSE rti.booked_rooms - brt.quantity
            END
        FROM dbo.booking_room_types brt
        JOIN dbo.bookings b 
             ON b.booking_id = brt.booking_id
        JOIN dbo.room_type_inventory rti
             ON rti.room_type_id = brt.room_type_id
            AND rti.inventory_date >= b.check_in_date
            AND rti.inventory_date < b.check_out_date
        WHERE brt.booking_id = ?
    """;

        String updateSql = """
        UPDATE dbo.bookings
        SET status = 5,
            cancelled_at = GETDATE()
        WHERE booking_id = ?
    """;

        try {

            connection.setAutoCommit(false);

            int status;
            java.sql.Date checkInDate;

            // 🔒 LOCK BOOKING
            try (PreparedStatement ps = connection.prepareStatement(lockSql)) {
                ps.setInt(1, bookingId);
                ps.setInt(2, customerId);

                ResultSet rs = ps.executeQuery();

                if (!rs.next()) {
                    connection.rollback();
                    return false;
                }

                status = rs.getInt("status");
                checkInDate = rs.getDate("check_in_date");
            }

            if (checkInDate == null) {
                connection.rollback();
                return false;
            }

            // ✅ Chỉ Pending (1) hoặc Confirmed (2)
            if (status != 1 && status != 2) {
                connection.rollback();
                return false;
            }

            // ✅ Logic chuẩn: phải huỷ trước 1 ngày
            java.time.LocalDate today = java.time.LocalDate.now();
            java.time.LocalDate checkIn = checkInDate.toLocalDate();
            java.time.LocalDate deadline = checkIn.minusDays(1);

            if (today.isAfter(deadline)) {
                connection.rollback();
                return false;
            }

            // 📦 Restore inventory
            try (PreparedStatement ps = connection.prepareStatement(restoreInventorySql)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            // ❌ Update booking
            int updated;
            try (PreparedStatement ps = connection.prepareStatement(updateSql)) {
                ps.setInt(1, bookingId);
                updated = ps.executeUpdate();
            }

            if (updated == 0) {
                connection.rollback();
                return false;
            }

            connection.commit();
            return true;

        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ignore) {
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception ignore) {
            }
        }
    }

    // =========================================================
    // SHARED EXECUTOR
    // =========================================================
    private List<BookingCardView> executeBookingQuery(String sql, int customerId) {

        List<BookingCardView> list = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapBookingCard(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================================================
    // MAPPER
    // =========================================================
    private BookingCardView mapBookingCard(ResultSet rs) throws Exception {

        BookingCardView b = new BookingCardView();

        b.setBookingId(rs.getInt("bookingId"));
        b.setBookingStatus(rs.getInt("bookingStatus"));
        b.setCheckInDate(rs.getDate("checkInDate"));
        b.setCheckOutDate(rs.getDate("checkOutDate"));
        b.setTotalAmount(rs.getBigDecimal("totalAmount"));

        b.setRoomTypeId(rs.getInt("roomTypeId"));
        b.setRoomTypeName(rs.getString("roomTypeName"));
        b.setRoomMeta(rs.getString("roomMeta"));
        b.setMaxAdult(rs.getInt("maxAdult"));
        b.setMaxChildren(rs.getInt("maxChildren"));

        b.setQuantity(rs.getInt("quantity"));
        b.setPriceAtBooking(rs.getBigDecimal("priceAtBooking"));

        // ===== FIX: LẤY DANH SÁCH ẢNH =====
        String rawImages = rs.getString("imageUrls");
        List<String> images = new ArrayList<>();

        if (rawImages != null && !rawImages.isBlank()) {
            String[] arr = rawImages.split("\\|");
            for (String img : arr) {
                if (img != null && !img.isBlank()) {
                    images.add(img.trim());
                }
            }
        }

        b.setImageUrls(images);

        b.setAmenitiesText(rs.getString("amenitiesText"));

        return b;
    }

    public List<BookingCardView> getPastStaysByCustomerId(int customerId) {

        String sql = """
        SELECT
            b.booking_id       AS bookingId,
            b.status           AS bookingStatus,
            b.check_in_date    AS checkInDate,
            b.check_out_date   AS checkOutDate,
            b.total_amount     AS totalAmount,

            rt.room_type_id    AS roomTypeId,
            rt.name            AS roomTypeName,
            rt.description     AS roomMeta,
            rt.max_adult       AS maxAdult,
            rt.max_children    AS maxChildren,

            rti.imageUrls      AS imageUrls,

            SUM(brt.quantity)         AS quantity,
            MIN(brt.price_at_booking) AS priceAtBooking,

            amen.amenitiesText AS amenitiesText

        FROM dbo.bookings b
        JOIN dbo.booking_room_types brt 
             ON brt.booking_id = b.booking_id

        JOIN dbo.room_types rt 
             ON rt.room_type_id = brt.room_type_id

        OUTER APPLY (
            SELECT STRING_AGG(image_url, '|') AS imageUrls
            FROM dbo.room_type_images
            WHERE room_type_id = rt.room_type_id
        ) rti

        OUTER APPLY (
            SELECT STRING_AGG(a.name, ', ') AS amenitiesText
            FROM dbo.room_type_amenities rta
            JOIN dbo.amenities a 
                 ON a.amenity_id = rta.amenity_id
            WHERE rta.room_type_id = rt.room_type_id
              AND a.is_active = 1
        ) amen

        WHERE b.customer_id = ?
          AND b.status IN (4,5,6)

        GROUP BY
            b.booking_id, b.status, b.check_in_date, 
            b.check_out_date, b.total_amount,
            rt.room_type_id, rt.name, rt.description, 
            rt.max_adult, rt.max_children,
            rti.imageUrls,
            amen.amenitiesText

        ORDER BY b.check_out_date DESC
    """;

        return executeBookingQuery(sql, customerId);
    }
    
    // 1. Lấy danh sách hoạt động trong ngày (Dashboard List)
    public List<BookingDashboard> getTodayOperations(String targetDate, String search, String status, String sort, int index, int pageSize) {
        List<BookingDashboard> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT b.booking_id, c.full_name, rt.name AS room_type_name, "
            + "b.check_in_date, b.check_out_date, b.status AS booking_status, "
            + "sra.status AS assignment_status, r.room_no, "
            + "brt.quantity, (rt.max_adult + rt.max_children) AS num_person "
            + "FROM bookings b "
            + "JOIN customers c ON b.customer_id = c.customer_id "
            + "LEFT JOIN booking_room_types brt ON b.booking_id = brt.booking_id "
            + "LEFT JOIN room_types rt ON brt.room_type_id = rt.room_type_id "
            + "LEFT JOIN stay_room_assignments sra ON b.booking_id = sra.booking_id "
            + "LEFT JOIN rooms r ON sra.room_id = r.room_id "
            + "WHERE 1=1 " 
        );

        if (status == null || status.equals("0")) {
            sql.append(" AND ( ")
               .append(" (CAST(b.check_in_date AS DATE) = ? AND b.status = 1) ") 
               .append(" OR (CAST(b.check_in_date AS DATE) <= ? AND CAST(b.check_out_date AS DATE) >= ? AND sra.status = 2) ")
               .append(" OR (CAST(sra.actual_check_out AS DATE) = ? AND sra.status = 3) ")
               .append(" ) ");
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (c.full_name LIKE ? OR CAST(b.booking_id AS VARCHAR) LIKE ? OR c.phone LIKE ?) ");
        }

        if (status != null && !status.equals("0")) {
            if (status.equals("1")) {
                sql.append(" AND b.status = 1 AND (sra.status IS NULL OR sra.status = 1) ");
            } else if (status.equals("2")) {
                sql.append(" AND sra.status = 2 "); 
            } else if (status.equals("3")) {
                sql.append(" AND sra.status = 3 AND CAST(sra.actual_check_out AS DATE) = ? "); 
            }
        }

        sql.append("Oldest".equals(sort) ? " ORDER BY b.check_in_date ASC " : " ORDER BY b.check_in_date DESC ");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIdx = 1;
            if (status == null || status.equals("0")) {
                st.setString(paramIdx++, targetDate);
                st.setString(paramIdx++, targetDate);
                st.setString(paramIdx++, targetDate);
                st.setString(paramIdx++, targetDate);
            }
            if (search != null && !search.trim().isEmpty()) {
                String p = "%" + search + "%";
                st.setString(paramIdx++, p);
                st.setString(paramIdx++, p);
                st.setString(paramIdx++, p);
            }
if (status != null && status.equals("3")) {
                st.setString(paramIdx++, targetDate);
            }
            st.setInt(paramIdx++, (index - 1) * pageSize);
            st.setInt(paramIdx, pageSize);
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                BookingDashboard d = new BookingDashboard();
                d.setBookingId(rs.getInt("booking_id"));
                d.setGuestName(rs.getNString("full_name"));
                d.setRoomTypeName(rs.getNString("room_type_name"));
                d.setCheckInDate(rs.getDate("check_in_date"));
                d.setCheckOutDate(rs.getDate("check_out_date"));
                d.setBookingStatus(rs.getInt("booking_status"));
                d.setAssignmentStatus(rs.getInt("assignment_status"));
                d.setRoomNo(rs.getString("room_no"));
                d.setNumRooms(rs.getInt("quantity"));
                d.setNumPersons(rs.getInt("num_person"));
                list.add(d);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    
    public DashboardStats getDashboardStats(String targetDate) {
        DashboardStats stats = new DashboardStats();
        String sql = "SELECT " +
            "(SELECT COUNT(srg.stay_guest_id) FROM stay_room_guests srg " +
            " JOIN stay_room_assignments sra ON srg.assignment_id = sra.assignment_id " +
            " WHERE sra.status = 2) AS total_guests, " +
            
            "(SELECT COUNT(*) FROM bookings WHERE CAST(check_in_date AS DATE) = ? AND status = 1) AS rooms_booked, " +
            
            "(SELECT COUNT(*) FROM stay_room_assignments WHERE CAST(actual_check_in AS DATE) = ? AND status IN (2,3)) AS check_in_today, " +
            
            "(SELECT COUNT(*) FROM stay_room_assignments sra " +
            " JOIN bookings b ON sra.booking_id = b.booking_id " +
            " WHERE CAST(b.check_out_date AS DATE) = ? AND sra.status = 2) AS check_out_today, " +
            
            // CHỈ ĐẾM NO-SHOW CỦA NGÀY HÔM NAY ĐỂ TRÁNH HIỆN SỐ 11
            "(SELECT COUNT(*) FROM bookings WHERE CAST(check_in_date AS DATE) = ? AND status = 4) AS no_show_today";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, targetDate);
            st.setString(2, targetDate);
            st.setString(3, targetDate);
            st.setString(4, targetDate);
            
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                stats.setTotalGuests(rs.getInt("total_guests"));
                stats.setRoomsBooked(rs.getInt("rooms_booked"));
                stats.setCheckInToday(rs.getInt("check_in_today"));
                stats.setCheckOutToday(rs.getInt("check_out_today"));
                stats.setNoShowToday(rs.getInt("no_show_today"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return stats;
    }
public void updateNoShowStatus(String targetDate) {
    
    java.time.LocalTime now = java.time.LocalTime.now();
    int currentHour = now.getHour();

    
    if (currentHour >= 18) {
        
        String sql = "UPDATE bookings SET status = 4 "
                   + "WHERE CAST(check_in_date AS DATE) = ? AND status = 1";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, targetDate);
            st.executeUpdate();
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }
    
}

    
    public int getTotalTodayOperations(String targetDate, String search, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM bookings b "
                + "JOIN customers c ON b.customer_id = c.customer_id "
                + "LEFT JOIN stay_room_assignments sra ON b.booking_id = sra.booking_id "
                + "WHERE 1=1 ");
        
        if (status == null || status.equals("0")) {
            sql.append(" AND ((CAST(b.check_in_date AS DATE) = ? AND b.status = 1) ")
               .append(" OR (CAST(b.check_in_date AS DATE) <= ? AND CAST(b.check_out_date AS DATE) >= ? AND sra.status IN (2, 3))) ");
        }
        
        if (search != null && !search.isEmpty()) sql.append(" AND (c.full_name LIKE ? OR CAST(b.booking_id AS VARCHAR) LIKE ? OR c.phone LIKE ?) ");
        
        if (status != null && !status.equals("0")) {
            if (status.equals("1")) sql.append(" AND b.status = 1 AND (sra.status IS NULL OR sra.status = 1) ");
            else if (status.equals("2")) sql.append(" AND sra.status = 2 ");
            else if (status.equals("3")) sql.append(" AND sra.status = 3 ");
        }

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIdx = 1;
            if (status == null || status.equals("0")) {
                st.setString(paramIdx++, targetDate);
                st.setString(paramIdx++, targetDate);
                st.setString(paramIdx++, targetDate);
            }
            if (search != null && !search.isEmpty()) {
                String p = "%" + search + "%";
                st.setString(paramIdx++, p);
                st.setString(paramIdx++, p);
                st.setString(paramIdx++, p);
            }
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
    
    
    public BookingDashboard getBookingById(int bookingId) {
        String sql = "SELECT b.booking_id, c.full_name, b.check_in_date, b.check_out_date, b.total_amount, " +
                     "ISNULL((SELECT SUM(amount) FROM payments WHERE booking_id = b.booking_id AND status = 1), 0) AS deposit_amount " +
                     "FROM bookings b JOIN customers c ON b.customer_id = c.customer_id " +
                     "WHERE b.booking_id = ?";
try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, bookingId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                BookingDashboard b = new BookingDashboard();
                b.setBookingId(rs.getInt("booking_id"));
                b.setGuestName(rs.getNString("full_name"));
                b.setCheckInDate(rs.getDate("check_in_date"));
                b.setCheckOutDate(rs.getDate("check_out_date"));
                b.setTotalAmount(rs.getDouble("total_amount"));
                b.setDeposit(rs.getDouble("deposit_amount")); 
                return b;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    
    public List<StayRoomAssignment> getAssignmentsByBooking(int bookingId) {
        List<StayRoomAssignment> list = new ArrayList<>();
        String sql = "SELECT sra.assignment_id, rt.name AS room_type_name, sra.assignment_type, " +
                     "(rt.max_adult + rt.max_children) as capacity " +
                     "FROM stay_room_assignments sra " +
                     "JOIN room_types rt ON sra.assignment_type = rt.room_type_id " + 
                     "WHERE sra.booking_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, bookingId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                StayRoomAssignment a = new StayRoomAssignment();
                a.setAssignmentId(rs.getInt("assignment_id"));
                a.setRoomTypeName(rs.getNString("room_type_name"));
                a.setNumPersons(rs.getInt("capacity"));
                a.setRoomTypeId(rs.getInt("assignment_type")); 
                list.add(a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    
    public List<Room> getAvailableRooms() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.room_id, r.room_no, r.room_type_id, r.floor, rt.name AS room_type_name, ISNULL(rv.price, 0) AS price " +
                     "FROM rooms r " +
                     "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                     "LEFT JOIN rate_versions rv ON r.room_type_id = rv.room_type_id " +
                     "AND CAST(GETDATE() AS DATE) BETWEEN rv.valid_from AND rv.valid_to " +
                     "WHERE r.status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Room r = new Room();
                r.setRoomId(rs.getInt("room_id"));
                r.setRoomNo(rs.getString("room_no"));
                r.setRoomTypeId(rs.getInt("room_type_id"));
                r.setFloor(rs.getInt("floor"));
                r.setRoomTypeName(rs.getNString("room_type_name")); 
                r.setPrice(rs.getDouble("price")); 
                list.add(r);
}
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    
    public boolean finalizeCheckIn(int bookingId, Map<Integer, Integer> roomAssignmentsMap, 
                                 Map<Integer, List<String[]>> occupantsMap, Map<Integer, Double> upgradeFeesMap) {
        double totalUpgrade = 0;
        for (Double f : upgradeFeesMap.values()) totalUpgrade += f;

        String sqlAsm = "UPDATE stay_room_assignments SET room_id = ?, status = 2, actual_check_in = GETDATE() WHERE assignment_id = ?";
        String sqlRoom = "UPDATE rooms SET status = 2 WHERE room_id = ?";
        String sqlBook = "UPDATE bookings SET status = 2, total_amount = total_amount + ? WHERE booking_id = ?";

        try {
            connection.setAutoCommit(false);
            try (PreparedStatement psAsm = connection.prepareStatement(sqlAsm);
                 PreparedStatement psRoom = connection.prepareStatement(sqlRoom);
                 PreparedStatement psBook = connection.prepareStatement(sqlBook)) {
                
                for (Map.Entry<Integer, Integer> entry : roomAssignmentsMap.entrySet()) {
                    psAsm.setInt(1, entry.getValue());
                    psAsm.setInt(2, entry.getKey());
                    psAsm.addBatch();
                    psRoom.setInt(1, entry.getValue());
                    psRoom.addBatch();
                }
                psAsm.executeBatch();
                psRoom.executeBatch();
                psBook.setDouble(1, totalUpgrade);
                psBook.setInt(2, bookingId);
                psBook.executeUpdate();
            }
            connection.commit();
            return true;
        } catch (SQLException e) { 
            try { connection.rollback(); } catch (SQLException ex) {}
            return false; 
        } finally { 
            try { connection.setAutoCommit(true); } catch (SQLException e) {}
        }
    }
}



