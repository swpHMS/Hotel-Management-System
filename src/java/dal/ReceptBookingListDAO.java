package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReceptBookingListDAO extends DBContext {

    // ================================
    // LẤY DANH SÁCH BOOKING (Cho trang Booking List)
    // ================================
    public List<model.BookingSummary> getBookingList() {
        List<model.BookingSummary> list = new ArrayList<>();
        // Kết hợp bảng bookings và customers
        String sql = "SELECT b.booking_id, c.full_name, c.phone, b.check_in_date, b.check_out_date, b.status, b.total_amount " +
                     "FROM dbo.bookings b " +
                     "JOIN dbo.customers c ON b.customer_id = c.customer_id " +
                     "ORDER BY b.booking_id DESC"; // Xếp đơn mới nhất lên đầu
                     
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                model.BookingSummary b = new model.BookingSummary();
                b.setBookingId(rs.getInt("booking_id"));
                b.setCustomerName(rs.getString("full_name"));
                b.setPhone(rs.getString("phone"));
                b.setCheckInDate(rs.getDate("check_in_date"));
                b.setCheckOutDate(rs.getDate("check_out_date"));
                b.setStatus(rs.getString("status"));
                b.setTotalAmount(rs.getBigDecimal("total_amount").longValue());
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // ================================
    // HỦY BOOKING VÀ HOÀN TRẢ PHÒNG VỀ KHO
    // ================================
    public boolean cancelBooking(int bookingId) throws Exception {
        java.sql.Connection con = null;
        try {
            con = connection;
            con.setAutoCommit(false); // Bật Transaction an toàn

            // 1. Lấy thông tin phòng của Booking này (chỉ lấy nếu status = 1 là đang chờ)
            String getInfo = "SELECT b.check_in_date, b.check_out_date, brt.room_type_id, brt.quantity " +
                             "FROM dbo.bookings b " +
                             "JOIN dbo.booking_room_types brt ON b.booking_id = brt.booking_id " +
                             "WHERE b.booking_id = ? AND b.status = 1"; 
                             
            java.sql.Date checkIn = null;
            java.sql.Date checkOut = null;
            int roomTypeId = 0, qty = 0;
            boolean found = false;

            try (PreparedStatement ps = con.prepareStatement(getInfo)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        checkIn = rs.getDate("check_in_date");
                        checkOut = rs.getDate("check_out_date");
                        roomTypeId = rs.getInt("room_type_id");
                        qty = rs.getInt("quantity");
                        found = true;
                    }
                }
            }

            // Nếu đơn không tồn tại hoặc đã check-in thì không cho hủy
            if (!found) {
                con.rollback();
                return false; 
            }

            // 2. Chuyển trạng thái Booking thành 0 (Đã hủy)
            String updateStatus = "UPDATE dbo.bookings SET status = 0 WHERE booking_id = ?";
            try (PreparedStatement ps = con.prepareStatement(updateStatus)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            // 3. Hoàn trả phòng bằng cách TRỪ đi số booked_rooms trong kho
            String refundInv = "UPDATE dbo.room_type_inventory " +
                               "SET booked_rooms = booked_rooms - ? " +
                               "WHERE room_type_id = ? AND inventory_date >= ? AND inventory_date < ?";
            try (PreparedStatement ps = con.prepareStatement(refundInv)) {
                ps.setInt(1, qty);
                ps.setInt(2, roomTypeId);
                ps.setDate(3, checkIn);
                ps.setDate(4, checkOut);
                ps.executeUpdate();
            }

            con.commit(); // Chốt lưu toàn bộ
            return true;

        } catch (Exception e) {
            if (con != null) con.rollback(); // Gặp lỗi thì thu hồi lại hết
            throw e;
        } finally {
            if (con != null) con.setAutoCommit(true);
        }
    }
}