package dal;

import context.DBContext;
import java.util.ArrayList;
import java.util.List;
import model.BookingDashboard;
import java.sql.*;
import java.util.Map;
import model.DashboardStats;
import model.Room;
import model.StayRoomAssignment;

/**
 * @author ASUS
 */
public class BookingDAO extends DBContext {

   public List<BookingDashboard> getTodayOperations(String targetDate, String search, String status, String sort, int index, int pageSize) {
    List<BookingDashboard> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder(
        "SELECT b.booking_id, c.full_name, rt.name AS room_type_name, "
        + "b.check_in_date, b.check_out_date, b.status AS booking_status, "
        + "sra.status AS assignment_status, r.room_no, "
        + "brt.quantity, (rt.max_adult + rt.max_children) AS num_person "
        + "FROM bookings b "
        + "JOIN customers c ON b.customer_id = c.customer_id "
        + "JOIN booking_room_types brt ON b.booking_id = brt.booking_id "
        + "JOIN room_types rt ON brt.room_type_id = rt.room_type_id "
        + "LEFT JOIN stay_room_assignments sra ON b.booking_id = sra.booking_id "
        + "LEFT JOIN rooms r ON sra.room_id = r.room_id "
        + "WHERE ((b.check_in_date = ? AND b.status = 1) " 
        + "OR (b.check_out_date = ? AND sra.status IN (2, 3))) " 
    );

    // 1. Logic Tìm kiếm
    if (search != null && !search.trim().isEmpty()) {
        sql.append(" AND (c.full_name LIKE ? OR CAST(b.booking_id AS VARCHAR) LIKE ? OR c.phone LIKE ?) ");
    }

    // 2. Logic Lọc trạng thái
    if (status != null && !status.equals("0")) {
        if (status.equals("1")) sql.append(" AND b.status = 1 AND sra.status IS NULL ");
        else if (status.equals("2")) sql.append(" AND sra.status = 2 ");
        else if (status.equals("3")) sql.append(" AND sra.status = 3 ");
    }

    // 3. Logic Sắp xếp
    sql.append("Oldest".equals(sort) ? " ORDER BY b.check_in_date ASC " : " ORDER BY b.check_in_date DESC ");
    
    // 4. Phân trang
    sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

    try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
        st.setString(1, targetDate);
        st.setString(2, targetDate);
        int paramIdx = 3;

        // Set tham số search nếu có
        if (search != null && !search.trim().isEmpty()) {
            String p = "%" + search + "%";
            st.setString(paramIdx++, p);
            st.setString(paramIdx++, p);
            st.setString(paramIdx++, p);
        }
        
        // ✅ Gán tham số phân trang dựa trên paramIdx hiện tại
        st.setInt(paramIdx++, (index - 1) * pageSize); // Vị trí bắt đầu
        st.setInt(paramIdx, pageSize);               // Số lượng cần lấy
        
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
        "(SELECT SUM(rt.max_adult + rt.max_children) FROM bookings b JOIN booking_room_types brt ON b.booking_id = brt.booking_id JOIN room_types rt ON brt.room_type_id = rt.room_type_id WHERE b.check_in_date <= ? AND b.check_out_date > ?) AS total_guests, " +
        "(SELECT COUNT(*) FROM bookings WHERE check_in_date = ? AND status = 1) AS rooms_booked, " +
        "(SELECT COUNT(*) FROM stay_room_assignments WHERE CAST(actual_check_in AS DATE) = ? AND status IN (2,3)) AS check_in_today, " +
        "(SELECT COUNT(*) FROM bookings WHERE check_out_date = ? AND status IN (2,3)) AS check_out_today, " +
        "(SELECT COUNT(*) FROM bookings WHERE check_in_date = ? AND status = 4) AS no_show_today";

    try (PreparedStatement st = connection.prepareStatement(sql)) {
        for (int i = 1; i <= 6; i++) st.setString(i, targetDate);
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
    // Chỉ cập nhật những đơn có ngày Check-in NHỎ HƠN ngày hiện tại 
    // (Khách lỡ hẹn từ những ngày trước)
    String sql = "UPDATE bookings SET status = 4 "
               + "WHERE check_in_date < ? AND status = 1"; // Đổi <= thành <
    
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setString(1, targetDate);
        st.executeUpdate();
    } catch (SQLException e) { e.printStackTrace(); }
}
    
    public int getTotalTodayOperations(String targetDate, String search, String status) {
    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM bookings b "
            + "JOIN customers c ON b.customer_id = c.customer_id "
            + "LEFT JOIN stay_room_assignments sra ON b.booking_id = sra.booking_id "
            + "WHERE ((b.check_in_date = ? AND b.status = 1) OR (b.check_out_date = ? AND sra.status IN (2, 3))) ");
    
    if (search != null && !search.isEmpty()) sql.append(" AND (c.full_name LIKE ? OR CAST(b.booking_id AS VARCHAR) LIKE ? OR c.phone LIKE ?) ");
    if (status != null && !status.equals("0")) {
        if (status.equals("1")) sql.append(" AND b.status = 1 AND sra.status IS NULL ");
        else if (status.equals("2")) sql.append(" AND sra.status = 2 ");
        else if (status.equals("3")) sql.append(" AND sra.status = 3 ");
    }

    try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
        st.setString(1, targetDate);
        st.setString(2, targetDate);
        int paramIdx = 3;
        
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
    
    // 1. Lấy thông tin tổng quan của đơn đặt (Cột trái Ảnh 1)
public BookingDashboard getBookingById(int bookingId) {
    String sql = "SELECT b.booking_id, c.full_name, b.check_in_date, b.check_out_date, b.total_amount " +
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
            return b;
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return null;
}

public List<StayRoomAssignment> getAssignmentsByBooking(int bookingId) {
    List<StayRoomAssignment> list = new ArrayList<>();
    // SỬA: Map cột 'assignment_type' với bảng room_types
    String sql = "SELECT sra.assignment_id, rt.name AS room_type_name, sra.assignment_type, " +
                 "(rt.max_adult + rt.max_children) as capacity " +
                 "FROM stay_room_assignments sra " +
                 "JOIN bookings b ON sra.booking_id = b.booking_id " +
                 "JOIN room_types rt ON sra.assignment_type = rt.room_type_id " +
                 "WHERE b.booking_id = ?";
    
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setInt(1, bookingId);
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            StayRoomAssignment a = new StayRoomAssignment();
            a.setAssignmentId(rs.getInt("assignment_id"));
            a.setRoomTypeName(rs.getNString("room_type_name"));
            // Lưu ý: Đảm bảo model StayRoomAssignment có thuộc tính roomTypeId ứng với assignment_type
            a.setNumPersons(rs.getInt("capacity"));
            list.add(a);
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return list;
}

// 3. Lấy danh sách phòng trống thực tế
public List<Room> getAvailableRooms() {
    List<Room> list = new ArrayList<>();
    String sql = "SELECT room_id, room_no, floor FROM rooms WHERE status = 1"; // 1 = Available
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            Room r = new Room();
            r.setRoomId(rs.getInt("room_id"));
            r.setRoomNo(rs.getString("room_no"));
            r.setFloor(rs.getInt("floor"));
            list.add(r);
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return list;
}
    
    public boolean finalizeCheckIn(int bookingId, Map<Integer, Integer> roomAssignmentsMap) {
    try {
        connection.setAutoCommit(false); // Bắt đầu Transaction
        String sql = "UPDATE stay_room_assignments SET room_id = ?, status = 2 WHERE assignment_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (Map.Entry<Integer, Integer> entry : roomAssignmentsMap.entrySet()) {
                ps.setInt(1, entry.getValue()); // roomId
                ps.setInt(2, entry.getKey());   // assignmentId
                ps.addBatch();
            }
            ps.executeBatch();
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