package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReceptBookingListDAO extends DBContext {

    // ================================
    // COUNT tổng booking (để tính totalPages)
    // ================================
    public int countBookings() {
        String sql = "SELECT COUNT(*) " +
                     "FROM dbo.bookings b " +
                     "JOIN dbo.customers c ON b.customer_id = c.customer_id";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // ================================
    // LẤY BOOKING THEO TRANG (PAGING)
    // ================================
    public List<model.BookingSummary> getBookingListPaging(int page, int size) {
        List<model.BookingSummary> list = new ArrayList<>();
        int offset = (page - 1) * size;

        String sql =
            "SELECT b.booking_id, c.full_name, c.phone, b.check_in_date, b.check_out_date, b.status, b.total_amount " +
            "FROM dbo.bookings b " +
            "JOIN dbo.customers c ON b.customer_id = c.customer_id " +
            "ORDER BY b.booking_id DESC " +
            "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, size);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.BookingSummary b = new model.BookingSummary();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setCustomerName(rs.getString("full_name"));
                    b.setPhone(rs.getString("phone"));
                    b.setCheckInDate(rs.getDate("check_in_date"));
                    b.setCheckOutDate(rs.getDate("check_out_date"));
                    b.setStatus(rs.getString("status"));

                    // total_amount: bạn đang set long, giữ nguyên theo code của bạn
                    b.setTotalAmount(rs.getBigDecimal("total_amount").longValue());

                    list.add(b);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================================
    // (GIỮ LẠI) LẤY DANH SÁCH BOOKING KHÔNG PHÂN TRANG (nếu cần)
    // ================================
    public List<model.BookingSummary> getBookingList() {
        List<model.BookingSummary> list = new ArrayList<>();
        String sql =
            "SELECT b.booking_id, c.full_name, c.phone, b.check_in_date, b.check_out_date, b.status, b.total_amount " +
            "FROM dbo.bookings b " +
            "JOIN dbo.customers c ON b.customer_id = c.customer_id " +
            "ORDER BY b.booking_id DESC";

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
    
   public model.BookingSummary getBookingById(int bookingId) {
    String sql = "SELECT b.booking_id, c.full_name, c.phone, " +
                 "b.check_in_date, b.check_out_date, b.status, b.total_amount, " +
                 "(SELECT ISNULL(SUM(amount), 0) FROM dbo.payments p WHERE p.booking_id = b.booking_id AND p.status = 1) AS deposit " +
                 "FROM dbo.bookings b " +
                 "JOIN dbo.customers c ON b.customer_id = c.customer_id " +
                 "WHERE b.booking_id = ?";
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, bookingId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                model.BookingSummary b = new model.BookingSummary();
                b.setBookingId(rs.getInt("booking_id"));
                b.setCustomerName(rs.getString("full_name"));
                b.setPhone(rs.getString("phone"));
                
                // (Đã xoá 3 dòng b.setEmail, b.setIdentity, b.setAddress ở đây)
                
                b.setCheckInDate(rs.getDate("check_in_date"));
                b.setCheckOutDate(rs.getDate("check_out_date"));
                b.setStatus(rs.getString("status"));
                b.setTotalAmount(rs.getBigDecimal("total_amount").longValue());
                b.setDeposit(rs.getLong("deposit")); // Vẫn giữ lại dòng này
                return b;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

    // ================================
    // HỦY BOOKING VÀ HOÀN TRẢ PHÒNG VỀ KHO (giữ nguyên)
    // ================================
    public boolean cancelBooking(int bookingId) throws Exception {
        java.sql.Connection con = null;
        try {
            con = connection;
            con.setAutoCommit(false);

            String getInfo =
                "SELECT b.check_in_date, b.check_out_date, brt.room_type_id, brt.quantity " +
                "FROM dbo.bookings b " +
                "JOIN dbo.booking_room_types brt ON b.booking_id = brt.booking_id " +
                "WHERE b.booking_id = ? AND b.status IN ('1', '2')";

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

            if (!found) {
                con.rollback();
                return false;
            }

            String updateStatus = "UPDATE dbo.bookings SET status = 5 WHERE booking_id = ?";
            try (PreparedStatement ps = con.prepareStatement(updateStatus)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            String refundInv =
                "UPDATE dbo.room_type_inventory " +
                "SET booked_rooms = booked_rooms - ? " +
                "WHERE room_type_id = ? AND inventory_date >= ? AND inventory_date < ?";

            try (PreparedStatement ps = con.prepareStatement(refundInv)) {
                ps.setInt(1, qty);
                ps.setInt(2, roomTypeId);
                ps.setDate(3, checkIn);
                ps.setDate(4, checkOut);
                ps.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            if (con != null) con.setAutoCommit(true);
        }
    }
}