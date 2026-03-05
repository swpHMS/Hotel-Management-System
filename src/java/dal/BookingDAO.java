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
 * @author Minh Đức
 */
public class BookingDAO extends DBContext {

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

    // 2. Lấy thống kê Dashboard (4 ô màu)
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

    // 3. Cập nhật No-show sau 18:00 (Chỉ quét đơn của ngày hôm nay)
    public void updateNoShowStatus(String targetDate) {
    // 1. Lấy giờ hiện tại của Việt Nam (GMT+7)
    java.time.LocalTime now = java.time.LocalTime.now();
    int currentHour = now.getHour();

    // 2. CHỈ QUÉT NẾU ĐÃ QUA 18:00
    if (currentHour >= 18) {
        // Chỉ quét đơn của RIÊNG NGÀY HÔM NAY (targetDate)
        String sql = "UPDATE bookings SET status = 4 "
                   + "WHERE CAST(check_in_date AS DATE) = ? AND status = 1";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, targetDate);
            st.executeUpdate();
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }
    // Nếu chưa đến 18:00, hàm này tuyệt đối không chạy Update
}

    // 4. Đếm tổng số bản ghi cho phân trang
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
    
    // 5. Lấy chi tiết đơn đặt phòng (Cập nhật lấy thêm DEPOSIT)
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

    // 6. Lấy danh sách gán phòng theo Booking
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

    // 7. Lấy danh sách phòng trống kèm giá
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

    // 8. Hoàn tất Check-in
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