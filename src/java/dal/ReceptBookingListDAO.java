package dal;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.BookingSummary;

public class ReceptBookingListDAO extends DBContext {

    // ================================
    // COUNT tổng booking
    // ================================
    public int countBookings() {
        String sql = "SELECT COUNT(*) "
                + "FROM dbo.bookings b "
                + "JOIN dbo.customers c ON b.customer_id = c.customer_id";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // ================================
    // LẤY BOOKING THEO TRANG
    // ================================
    public List<BookingSummary> getBookingListPaging(int page, int size) {
        List<BookingSummary> list = new ArrayList<>();
        int offset = (page - 1) * size;

        String sql = "SELECT b.booking_id, c.full_name, c.phone, "
                + "       b.check_in_date, b.check_out_date, b.status, b.total_amount "
                + "FROM dbo.bookings b "
                + "JOIN dbo.customers c ON b.customer_id = c.customer_id "
                + "ORDER BY b.booking_id DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, size);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingSummary b = new BookingSummary();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setCustomerName(rs.getString("full_name"));
                    b.setPhone(rs.getString("phone"));
                    b.setCheckInDate(rs.getDate("check_in_date"));
                    b.setCheckOutDate(rs.getDate("check_out_date"));
                    b.setStatus(String.valueOf(rs.getInt("status")));

                    if (rs.getBigDecimal("total_amount") != null) {
                        b.setTotalAmount(rs.getBigDecimal("total_amount").longValue());
                    } else {
                        b.setTotalAmount(0);
                    }

                    list.add(b);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================================
    // LẤY DANH SÁCH BOOKING KHÔNG PHÂN TRANG
    // ================================
    public List<BookingSummary> getBookingList() {
        List<BookingSummary> list = new ArrayList<>();

        String sql = "SELECT b.booking_id, c.full_name, c.phone, "
                + "       b.check_in_date, b.check_out_date, b.status, b.total_amount "
                + "FROM dbo.bookings b "
                + "JOIN dbo.customers c ON b.customer_id = c.customer_id "
                + "ORDER BY b.booking_id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BookingSummary b = new BookingSummary();
                b.setBookingId(rs.getInt("booking_id"));
                b.setCustomerName(rs.getString("full_name"));
                b.setPhone(rs.getString("phone"));
                b.setCheckInDate(rs.getDate("check_in_date"));
                b.setCheckOutDate(rs.getDate("check_out_date"));
                b.setStatus(String.valueOf(rs.getInt("status")));

                if (rs.getBigDecimal("total_amount") != null) {
                    b.setTotalAmount(rs.getBigDecimal("total_amount").longValue());
                } else {
                    b.setTotalAmount(0);
                }

                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================================
    // LẤY CHI TIẾT BOOKING THEO ID
    // ================================
    public BookingSummary getBookingById(int bookingId) {
        String sql =
                "SELECT TOP 1 "
                + "       b.booking_id, "
                + "       c.full_name, "
                + "       c.phone, "
                + "       b.check_in_date, "
                + "       b.check_out_date, "
                + "       b.status, "
                + "       b.total_amount, "
                + "       rt.name AS room_type_name, "
                + "       ISNULL(brt.quantity, 0) AS quantity, "
                + "       (SELECT ISNULL(SUM(p.amount), 0) "
                + "          FROM dbo.payments p "
                + "         WHERE p.booking_id = b.booking_id AND p.status = 1) AS deposit "
                + "FROM dbo.bookings b "
                + "JOIN dbo.customers c ON b.customer_id = c.customer_id "
                + "LEFT JOIN dbo.booking_room_types brt ON b.booking_id = brt.booking_id "
                + "LEFT JOIN dbo.room_types rt ON brt.room_type_id = rt.room_type_id "
                + "WHERE b.booking_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BookingSummary b = new BookingSummary();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setCustomerName(rs.getString("full_name"));
                    b.setPhone(rs.getString("phone"));
                    b.setCheckInDate(rs.getDate("check_in_date"));
                    b.setCheckOutDate(rs.getDate("check_out_date"));
                    b.setStatus(String.valueOf(rs.getInt("status")));

                    if (rs.getBigDecimal("total_amount") != null) {
                        b.setTotalAmount(rs.getBigDecimal("total_amount").longValue());
                    } else {
                        b.setTotalAmount(0);
                    }

                    b.setDeposit(rs.getLong("deposit"));
                    b.setRoomTypeName(rs.getString("room_type_name"));
                    b.setQuantity(rs.getInt("quantity"));

                    return b;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ================================
    // HỦY BOOKING VÀ HOÀN TRẢ PHÒNG VỀ KHO
    // ================================
    public boolean cancelBooking(int bookingId) throws Exception {
        Connection con = null;
        try {
            con = connection;
            con.setAutoCommit(false);

            String getInfo =
                    "SELECT b.check_in_date, b.check_out_date, brt.room_type_id, brt.quantity "
                    + "FROM dbo.bookings b "
                    + "JOIN dbo.booking_room_types brt ON b.booking_id = brt.booking_id "
                    + "WHERE b.booking_id = ? AND b.status IN (1, 2)";

            java.sql.Date checkIn = null;
            java.sql.Date checkOut = null;
            int roomTypeId = 0;
            int qty = 0;
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
                    "UPDATE dbo.room_type_inventory "
                    + "SET booked_rooms = booked_rooms - ? "
                    + "WHERE room_type_id = ? AND inventory_date >= ? AND inventory_date < ?";

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
            if (con != null) {
                con.rollback();
            }
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
            }
        }
    }
}