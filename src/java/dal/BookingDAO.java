package dal;

import context.DBContext;
import model.BookingCardView;

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
                MAX(brt.price_at_booking) AS priceAtBooking,

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
    
   
// 1. Lấy danh sách hoạt động trong ngày (Dashboard List) - Sửa đếm số người thực tế
// 1. Lấy danh sách hoạt động trong ngày (Dashboard List) - BẢN SỬA LỖI ĐẾM NGƯỜI THEO PHÒNG  
public List<BookingDashboard> getTodayOperations(String targetDate, String search, String status, String sort, int index, int pageSize) {
    List<BookingDashboard> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder(
        "SELECT b.booking_id, c.full_name, rt.name AS room_type_name, "
        + "b.check_in_date, b.check_out_date, b.status AS booking_status, "
        + "sra.status AS assignment_status, r.room_no, brt.quantity, "
        + "sra.assignment_id, " // Lấy thêm assignment_id để đồng bộ dữ liệu
        
        // --- ĐOẠN SỬA CHUẨN: Đếm số người của RIÊNG từng phòng dựa trên assignment_id ---
        + "(SELECT COUNT(*) FROM dbo.stay_room_guests srg "
        + " WHERE srg.assignment_id = sra.assignment_id) AS num_person "
        // ---------------------------------------------------------------------------
        
        + "FROM dbo.bookings b "
        + "JOIN dbo.customers c ON b.customer_id = c.customer_id "
        + "LEFT JOIN dbo.booking_room_types brt ON b.booking_id = brt.booking_id "
        + "LEFT JOIN dbo.room_types rt ON brt.room_type_id = rt.room_type_id "
        + "LEFT JOIN dbo.stay_room_assignments sra ON b.booking_id = sra.booking_id "
        + "LEFT JOIN dbo.rooms r ON sra.room_id = r.room_id "
        + "WHERE b.status IN (2, 3, 4) " 
    );

    // Xử lý bộ lọc theo trạng thái
    if (status == null || status.equals("0")) {
        sql.append(" AND ( (CONVERT(DATE, b.check_in_date) = ? AND b.status = 2) ")
           .append(" OR (b.status = 3 AND sra.status = 2) ")
           .append(" OR (CONVERT(DATE, b.check_out_date) = ? AND b.status = 4) ) ");
    } else if (status.equals("1")) {
        sql.append(" AND b.status = 2 AND (sra.status IS NULL OR sra.status = 1) AND CONVERT(DATE, b.check_in_date) = ? ");
    } else if (status.equals("2")) {
        sql.append(" AND b.status = 3 AND sra.status = 2 ");
    } else if (status.equals("3")) {
        sql.append(" AND b.status = 4 AND CONVERT(DATE, b.check_out_date) = ? ");
    }

    if (search != null && !search.trim().isEmpty()) {
        sql.append(" AND (c.full_name LIKE ? OR CAST(b.booking_id AS VARCHAR) LIKE ? OR c.phone LIKE ?) ");
    }

    // Xử lý Sort
    String orderBy = "Oldest".equals(sort) ? "ASC" : "DESC";
    sql.append(" ORDER BY b.check_in_date ").append(orderBy).append(", b.booking_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

    try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
        int paramIdx = 1;
        
        if (status == null || status.equals("0")) {
            st.setString(paramIdx++, targetDate);
            st.setString(paramIdx++, targetDate);
        } else if (status.equals("1") || status.equals("3")) {
            st.setString(paramIdx++, targetDate);
        }

        if (search != null && !search.trim().isEmpty()) {
            String p = "%" + search + "%";
            st.setString(paramIdx++, p);
            st.setString(paramIdx++, p);
            st.setString(paramIdx++, p);
        }
        
        st.setInt(paramIdx++, (index - 1) * pageSize);
        st.setInt(paramIdx, pageSize);
        
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            BookingDashboard d = new BookingDashboard();
            d.setBookingId(rs.getInt("booking_id"));
            d.setGuestName(rs.getNString("full_name"));
            d.setRoomTypeName(rs.getNString("room_type_name"));
            d.setNumRooms(rs.getInt("quantity"));
            
            // Kết quả bây giờ sẽ là 1 cho phòng 102 và 2 cho phòng 501
            d.setNumPersons(rs.getInt("num_person"));
            
            d.setCheckInDate(rs.getDate("check_in_date"));
            d.setCheckOutDate(rs.getDate("check_out_date"));
            d.setBookingStatus(rs.getInt("booking_status"));
            d.setAssignmentStatus(rs.getInt("assignment_status"));
            d.setRoomNo(rs.getString("room_no"));
            
            list.add(d);
        }
    } catch (SQLException e) { 
        e.printStackTrace(); 
    }
    return list;
}

    
    public DashboardStats getDashboardStats(String targetDate) {
    DashboardStats stats = new DashboardStats();
    // Chú ý các số 2, 3 trong câu SQL bên dưới
    String sql = "SELECT " +
        // 1. Đếm tổng khách đang ở (StayRoomAssignment status = 2 là In House)
        "(SELECT COUNT(*) FROM stay_room_guests srg " +
        " JOIN stay_room_assignments sra ON srg.assignment_id = sra.assignment_id " +
        " WHERE sra.status = 2) AS total_guests, " +
        
        // 2. Đếm số đơn CONFIRMED (status = 2) có ngày đến là hôm nay
        "(SELECT COUNT(*) FROM bookings WHERE CAST(check_in_date AS DATE) = ? AND status = 2) AS rooms_booked, " +
        
        // 3. Đếm số phòng vừa thực hiện Check-in hôm nay
        "(SELECT COUNT(*) FROM stay_room_assignments WHERE CAST(actual_check_in AS DATE) = ? AND status = 2) AS check_in_today, " +
        
        // 4. Đếm số đơn đã CHECKED_OUT (status = 4) trong ngày hôm nay
        "(SELECT COUNT(*) FROM bookings WHERE CAST(check_out_date AS DATE) = ? AND status = 4) AS check_out_today, " +
        
        // 5. Đếm số đơn NO-SHOW (status = 6) hôm nay
        "(SELECT COUNT(*) FROM bookings WHERE CAST(check_in_date AS DATE) = ? AND status = 6) AS no_show_today";

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

    
    public List<StayRoomAssignment> getAssignmentsToCheckIn(int bookingId) {
    List<StayRoomAssignment> list = new ArrayList<>();
    // Truy vấn vào bảng đơn đặt phòng (booking_room_types) để lấy 'kế hoạch' gán phòng
    String sql = "SELECT brt.room_type_id, rt.name AS room_type_name, " +
                 "(rt.max_adult + rt.max_children) AS capacity, brt.quantity " +
                 "FROM dbo.booking_room_types brt " +
                 "JOIN dbo.room_types rt ON brt.room_type_id = rt.room_type_id " +
                 "WHERE brt.booking_id = ?";
    
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setInt(1, bookingId);
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            int quantity = rs.getInt("quantity");
            for (int i = 0; i < quantity; i++) {
                StayRoomAssignment a = new StayRoomAssignment();
                a.setBookingId(bookingId);
                a.setRoomTypeId(rs.getInt("room_type_id"));
                a.setRoomTypeName(rs.getNString("room_type_name"));
                a.setNumPersons(rs.getInt("capacity"));
                // Gán tạm assignmentId là 0 vì chưa có trong DB
                a.setAssignmentId(0); 
                list.add(a);
            }
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return list;
}

    
   // Bản này đã sẵn sàng để sử dụng
public List<Room> getAvailableRooms() {
    List<Room> list = new ArrayList<>();
    // Dùng MAX(rv.price) để đảm bảo mỗi phòng chỉ xuất hiện 1 dòng duy nhất
    String sql = "SELECT r.room_id, r.room_no, r.room_type_id, r.floor, rt.name AS room_type_name, " +
                 "ISNULL(MAX(rv.price), rt.status) AS price " + // rt.status ở đây mình lấy tạm làm giá giả định nếu rv.price null, bạn nên để rt.room_type_id hoặc giá mặc định
                 "FROM rooms r " +
                 "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                 "LEFT JOIN rate_versions rv ON r.room_type_id = rv.room_type_id " +
                 "AND CAST(GETDATE() AS DATE) BETWEEN rv.valid_from AND rv.valid_to " +
                 "WHERE r.status = 1 " + // Chỉ lấy phòng trống
                 "GROUP BY r.room_id, r.room_no, r.room_type_id, r.floor, rt.name, rt.status";

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
        System.out.println("SERVER LOG: Found " + list.size() + " rooms available.");
    } catch (SQLException e) { e.printStackTrace(); }
    return list;
}

public boolean finalizeCheckIn(int bookingId, Map<Integer, Integer> roomAssignmentsMap, 
                               Map<Integer, List<String[]>> occupantsMap, Map<Integer, Double> upgradeFeesMap) {
    String sqlBook = "UPDATE bookings SET status = 3, total_amount = total_amount + ? WHERE booking_id = ?";
    String sqlAsm = "INSERT INTO stay_room_assignments (booking_id, room_id, status, actual_check_in, assignment_type) VALUES (?, ?, 2, GETDATE(), 0)";
    String sqlRoom = "UPDATE rooms SET status = 2 WHERE room_id = ?";
    
    // Logic mới: Chèn vào bảng guests trước để lấy ID, sau đó mới vào stay_room_guests
    String sqlGetGuest = "SELECT guest_id FROM guests WHERE identity_number = ?";
    String sqlInsertGuest = "INSERT INTO guests (full_name, identity_number) VALUES (?, ?)";
    String sqlStayGuest = "INSERT INTO stay_room_guests (assignment_id, guest_id) VALUES (?, ?)";

    double totalUpgrade = 0;
    for (Double f : upgradeFeesMap.values()) totalUpgrade += f;

    try {
        connection.setAutoCommit(false);
        try (PreparedStatement psBook = connection.prepareStatement(sqlBook);
             PreparedStatement psAsm = connection.prepareStatement(sqlAsm, java.sql.Statement.RETURN_GENERATED_KEYS);
             PreparedStatement psRoom = connection.prepareStatement(sqlRoom);
             PreparedStatement psGetGuest = connection.prepareStatement(sqlGetGuest);
             PreparedStatement psInsertGuest = connection.prepareStatement(sqlInsertGuest, java.sql.Statement.RETURN_GENERATED_KEYS);
             PreparedStatement psStayGuest = connection.prepareStatement(sqlStayGuest)) {
            
            // 1. Cập nhật đơn hàng
            psBook.setDouble(1, totalUpgrade);
            psBook.setInt(2, bookingId);
            psBook.executeUpdate();

            // 2. Duyệt từng phòng
            for (Map.Entry<Integer, Integer> entry : roomAssignmentsMap.entrySet()) {
                int index = entry.getKey();
                int roomId = entry.getValue();

                // Lưu Assignment
                psAsm.setInt(1, bookingId);
                psAsm.setInt(2, roomId);
                psAsm.executeUpdate();

                ResultSet rsAsm = psAsm.getGeneratedKeys();
                int generatedAsmId = 0;
                if (rsAsm.next()) generatedAsmId = rsAsm.getInt(1);

                // 3. Xử lý khách hàng
                List<String[]> guests = occupantsMap.get(index);
                if (guests != null) {
                    for (String[] g : guests) {
                        String name = g[0];
                        String idNum = g[1];
                        int finalGuestId = 0;

                        // Kiểm tra xem khách đã có trong hệ thống chưa
                        psGetGuest.setString(1, idNum);
                        ResultSet rsG = psGetGuest.executeQuery();
                        if (rsG.next()) {
                            finalGuestId = rsG.getInt("guest_id");
                        } else {
                            // Chưa có thì chèn mới vào bảng guests
                            psInsertGuest.setNString(1, name);
                            psInsertGuest.setString(2, idNum);
                            psInsertGuest.executeUpdate();
                            ResultSet rsNewG = psInsertGuest.getGeneratedKeys();
                            if (rsNewG.next()) finalGuestId = rsNewG.getInt(1);
                        }

                        // Chèn vào bảng trung gian stay_room_guests
                        psStayGuest.setInt(1, generatedAsmId);
                        psStayGuest.setInt(2, finalGuestId);
                        psStayGuest.executeUpdate();
                    }
                }

                // 4. Update trạng thái phòng
                psRoom.setInt(1, roomId);
                psRoom.executeUpdate();
            }
        }
        connection.commit();
        System.out.println("Finalize Check-in thành công cho Booking: " + bookingId);
        return true;
    } catch (SQLException e) {
        try { connection.rollback(); } catch (Exception ex) {}
        System.err.println("Lỗi finalizeCheckIn: " + e.getMessage());
        e.printStackTrace();
        return false;
    } finally {
        try { connection.setAutoCommit(true); } catch (Exception e) {}
    }
}
    
}



