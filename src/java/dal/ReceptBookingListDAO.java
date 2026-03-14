package dal;

import java.sql.SQLException;
import context.DBContext;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.BookingSummary;

public class ReceptBookingListDAO extends DBContext {

    private void setFilterParams(
        PreparedStatement ps,
        String keyword,
        Integer status,
        Date checkInDate,
        Date checkOutDate,
        boolean hasPaging,
        int offset,
        int size
) throws Exception {

    int index = 1;

    if (keyword != null && !keyword.trim().isEmpty()) {
        String kw = "%" + keyword.trim() + "%";
        ps.setString(index++, kw);
        ps.setString(index++, kw);
    }

    if (status != null) {
        ps.setInt(index++, status);
    }

    if (checkInDate != null) {
        ps.setDate(index++, checkInDate);
    }

    if (checkOutDate != null) {
        ps.setDate(index++, checkOutDate);
    }

    if (hasPaging) {
        ps.setInt(index++, offset);
        ps.setInt(index++, size);
    }
}

    private String buildFilterCondition(
        String keyword,
        Integer status,
        Date checkInDate,
        Date checkOutDate
) {

    StringBuilder sql = new StringBuilder();

    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append(" AND (");
        sql.append(" CAST(b.booking_id AS VARCHAR) LIKE ? ");
        sql.append(" OR c.full_name LIKE ? ");
        sql.append(" ) ");
    }

    if (status != null) {
        sql.append(" AND b.status = ? ");
    }

    if (checkInDate != null) {
        sql.append(" AND b.check_in_date = ? ");
    }

    if (checkOutDate != null) {
        sql.append(" AND b.check_out_date = ? ");
    }

    return sql.toString();
}

    // ================================
    // COUNT BOOKING CÓ FILTER
    // ================================
    public int countBookingsFiltered(
            String keyword,
            Integer status,
            Date checkInDate,
            Date checkOutDate
    ) {

        String sql =
                "SELECT COUNT(*) "
                + "FROM dbo.bookings b "
                + "JOIN dbo.customers c ON b.customer_id = c.customer_id "
                + "WHERE 1 = 1 "
                + buildFilterCondition(keyword, status, checkInDate, checkOutDate);

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            setFilterParams(
                    ps,
                    keyword,
                    status,
                    checkInDate,
                    checkOutDate,
                    false,
                    0,
                    0
            );

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // ================================
    // LẤY BOOKING CÓ FILTER + PHÂN TRANG
    // ================================
    public List<BookingSummary> getBookingListPagingFiltered(
            String keyword,
            Integer status,
            Date checkInDate,
            Date checkOutDate,
            int page,
            int size
    ) {

        List<BookingSummary> list = new ArrayList<>();
        int offset = (page - 1) * size;

        String sql =
                "SELECT "
                + "       b.booking_id, "
                + "       c.full_name, "
                + "       c.phone, "
                + "       b.check_in_date, "
                + "       b.check_out_date, "
                + "       b.status, "
                + "       b.total_amount "
                + "FROM dbo.bookings b "
                + "JOIN dbo.customers c ON b.customer_id = c.customer_id "
                + "WHERE 1 = 1 "
                + buildFilterCondition(keyword, status, checkInDate, checkOutDate)
                + "ORDER BY b.booking_id DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            setFilterParams(
                    ps,
                    keyword,
                    status,
                    checkInDate,
                    checkOutDate,
                    true,
                    offset,
                    size
            );

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
                        b.setTotalAmount(
                                rs.getBigDecimal("total_amount").longValue()
                        );
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
    // COUNT tổng booking
    // ================================
    public int countBookings() {
        return countBookingsFiltered(null, null, null, null);
    }

    // ================================
    // LẤY BOOKING THEO TRANG
    // ================================
    public List<BookingSummary> getBookingListPaging(int page, int size) {
        return getBookingListPagingFiltered(null, null, null, null, page, size);
    }

    // ================================
    // LẤY DANH SÁCH BOOKING KHÔNG PHÂN TRANG
    // ================================
    public List<BookingSummary> getBookingList() {

        List<BookingSummary> list = new ArrayList<>();

        String sql =
                "SELECT "
                + "       b.booking_id, "
                + "       c.full_name, "
                + "       c.phone, "
                + "       b.check_in_date, "
                + "       b.check_out_date, "
                + "       b.status, "
                + "       b.total_amount "
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
                        b.setTotalAmount(
                                rs.getBigDecimal("total_amount").longValue()
                        );
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
                    "SELECT "
                    + "       b.check_in_date, "
                    + "       b.check_out_date, "
                    + "       brt.room_type_id, "
                    + "       brt.quantity "
                    + "FROM dbo.bookings b "
                    + "JOIN dbo.booking_room_types brt "
                    + "     ON b.booking_id = brt.booking_id "
                    + "WHERE b.booking_id = ? "
                    + "  AND b.status IN (1, 2)";

            Date checkIn = null;
            Date checkOut = null;
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

            String updateStatus =
                    "UPDATE dbo.bookings "
                    + "SET status = 5 "
                    + "WHERE booking_id = ?";

            try (PreparedStatement ps = con.prepareStatement(updateStatus)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            String refundInv =
                    "UPDATE dbo.room_type_inventory "
                    + "SET booked_rooms = booked_rooms - ? "
                    + "WHERE room_type_id = ? "
                    + "  AND inventory_date >= ? "
                    + "  AND inventory_date < ?";

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
    
    // ==========================================
    // CẬP NHẬT TRẠNG THÁI NO-SHOW VÀ NHẢ PHÒNG
    // ==========================================
    public void updateNoShowBookings() {
        // 1. Trả lại phòng vào kho (giảm booked_rooms trong bảng room_type_inventory)
        String sqlReleaseInventory =
            "UPDATE i " +
            "SET i.booked_rooms = CASE " +
            "    WHEN i.booked_rooms >= brt.quantity THEN i.booked_rooms - brt.quantity " +
            "    ELSE 0 " +
            "END " +
            "FROM dbo.room_type_inventory i " +
            "JOIN dbo.booking_room_types brt ON i.room_type_id = brt.room_type_id " +
            "JOIN dbo.bookings b ON b.booking_id = brt.booking_id " +
            "WHERE b.status IN (1, 2) " + // Chỉ lấy các đơn Pending hoặc Confirmed
            "  AND b.check_in_date < CAST(SYSDATETIME() AS DATE) " + // Đã qua 24h của ngày check-in (nhỏ hơn ngày hiện tại)
            "  AND i.inventory_date >= b.check_in_date " +
            "  AND i.inventory_date < b.check_out_date";

        // 2. Hủy các phòng thực tế đã được gán sẵn cho khách này (nếu có)
        String sqlReleaseAssignments =
            "UPDATE dbo.stay_room_assignments " +
            "SET status = 0 " + // 0: Cancelled
            "WHERE booking_id IN (" +
            "    SELECT booking_id FROM dbo.bookings " +
            "    WHERE status IN (1, 2) AND check_in_date < CAST(SYSDATETIME() AS DATE)" +
            ") AND status = 1"; // 1: Assigned

        // 3. Đổi trạng thái Booking thành No-Show (status = 6)
        String sqlUpdateStatus =
            "UPDATE dbo.bookings " +
            "SET status = 6 " + // 6: No Show
            "WHERE status IN (1, 2) " +
            "  AND check_in_date < CAST(SYSDATETIME() AS DATE)";

        Connection con = null;
        try {
            con = connection;
            con.setAutoCommit(false); // Bắt đầu Transaction

            // Thực thi trả phòng về kho
            try (PreparedStatement ps1 = con.prepareStatement(sqlReleaseInventory)) {
                ps1.executeUpdate();
            }
            // Thực thi hủy phòng đã gán
            try (PreparedStatement ps2 = con.prepareStatement(sqlReleaseAssignments)) {
                ps2.executeUpdate();
            }
            // Thực thi đổi trạng thái Booking
            try (PreparedStatement ps3 = con.prepareStatement(sqlUpdateStatus)) {
                ps3.executeUpdate();
            }

            con.commit(); // Lưu thay đổi
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }
}