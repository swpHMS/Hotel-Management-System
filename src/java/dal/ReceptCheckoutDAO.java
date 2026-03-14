package dal;

import context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.CheckoutBill;
import model.CheckoutServiceItem;
import model.CheckoutSummary;

public class ReceptCheckoutDAO extends DBContext {

    // ==========================================
    // 1. LẤY DỮ LIỆU HÓA ĐƠN CUỐI CÙNG (FINAL BILL)
    // ==========================================
    public CheckoutBill getCheckoutBill(int bookingId) {
        CheckoutBill bill = new CheckoutBill();
        
        // Query 1: Lấy thông tin Booking, Customer, Tiền phòng và Tiền Cọc
        String sqlBooking = 
            "SELECT b.booking_id, c.full_name, c.phone, c.email, " +
            "       b.check_in_date, b.check_out_date, b.total_amount AS room_charges, " +
            "       (SELECT ISNULL(SUM(amount), 0) FROM dbo.payments WHERE booking_id = b.booking_id AND status = 1) AS deposit_paid " +
            "FROM dbo.bookings b " +
            "JOIN dbo.customers c ON b.customer_id = c.customer_id " +
            "WHERE b.booking_id = ?";

        // Query 2: Lấy các dịch vụ đã chốt (POSTED - status = 1) do Staff đẩy lên
        String sqlServices = 
            "SELECT s.name AS service_name, soi.quantity, soi.unit_price_snapshot, " +
            "       (soi.quantity * soi.unit_price_snapshot) AS total_price " +
            "FROM dbo.service_orders so " +
            "JOIN dbo.service_order_items soi ON so.service_order_id = soi.service_order_id " +
            "JOIN dbo.services s ON soi.service_id = s.service_id " +
            "WHERE so.booking_id = ? AND so.status = 1";

        try (Connection con = connection) {
            // Thực thi Query 1
            try (PreparedStatement ps = con.prepareStatement(sqlBooking)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        bill.setBookingId(rs.getInt("booking_id"));
                        bill.setCustomerName(rs.getString("full_name"));
                        bill.setPhone(rs.getString("phone"));
                        bill.setEmail(rs.getString("email"));
                        bill.setCheckInDate(rs.getDate("check_in_date"));
                        bill.setCheckOutDate(rs.getDate("check_out_date"));
                        
                        long roomCharges = rs.getBigDecimal("room_charges").longValue();
                        long depositPaid = rs.getBigDecimal("deposit_paid").longValue();
                        
                        // Tính số đêm (Công thức đơn giản, bạn có thể dùng ChronoUnit như trong ReceptBookingDAO)
                        long diff = bill.getCheckOutDate().getTime() - bill.getCheckInDate().getTime();
                        long nights = Math.max(1, diff / (1000 * 60 * 60 * 24));
                        
                        bill.setNights(nights);
                        bill.setRoomCharges(roomCharges);
                        bill.setDepositPaid(depositPaid);
                    } else {
                        return null; // Không tìm thấy booking
                    }
                }
            }

            // Thực thi Query 2
            List<CheckoutServiceItem> usedServices = new ArrayList<>();
            long totalServiceCharges = 0;
            
            try (PreparedStatement ps = con.prepareStatement(sqlServices)) {
                ps.setInt(1, bookingId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String name = rs.getString("service_name");
                        int qty = rs.getInt("quantity");
                        long price = rs.getBigDecimal("unit_price_snapshot").longValue();
                        long total = rs.getBigDecimal("total_price").longValue();
                        
                        usedServices.add(new CheckoutServiceItem(name, qty, price, total));
                        totalServiceCharges += total;
                    }
                }
            }
            
            // Tổng hợp tài chính
            bill.setUsedServices(usedServices);
            bill.setServiceCharges(totalServiceCharges);
            bill.setTotalAmount(bill.getRoomCharges() + totalServiceCharges);
            bill.setBalanceDue(bill.getTotalAmount() - bill.getDepositPaid());

            // Tạm thời lấy tên Room Type của phòng đầu tiên (nếu cần hiển thị)
            bill.setRoomTypeName("Theo đơn đặt phòng"); 
            bill.setRoomQuantity(1);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bill;
    }

    // ==========================================
    // 2. TRANSACTION CHECK-OUT VÀ LƯU THANH TOÁN
    // ==========================================
    public boolean processCheckout(int bookingId, long finalAmountPaid, String paymentMethod) throws SQLException {
        Connection con = null;
        try {
            con = connection;
            con.setAutoCommit(false); // Bắt đầu Transaction

            // 1. Thêm bản ghi Payment mới cho số tiền thu thêm (nếu có)
            if (finalAmountPaid > 0) {
                String sqlPayment = "INSERT INTO dbo.payments(booking_id, amount, method, status) VALUES(?, ?, ?, 1)";
                try (PreparedStatement ps = con.prepareStatement(sqlPayment)) {
                    ps.setInt(1, bookingId);
                    ps.setBigDecimal(2, new java.math.BigDecimal(finalAmountPaid));
                    ps.setInt(3, "QR".equalsIgnoreCase(paymentMethod) ? 2 : 1); // 1: CASH, 2: TRANSFER
                    ps.executeUpdate();
                }
            }

            // 2. Cập nhật bảng Bookings (status = 4: CHECKED_OUT)
            String sqlBooking = "UPDATE dbo.bookings SET status = 4 WHERE booking_id = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlBooking)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            // 3. Cập nhật bảng Stay Room Assignments (status = 3: ENDED, actual_check_out = NOW)
            String sqlSRA = "UPDATE dbo.stay_room_assignments " +
                            "SET status = 3, actual_check_out = SYSDATETIME() " +
                            "WHERE booking_id = ? AND status = 2"; // Chỉ đổi phòng đang IN_HOUSE
            try (PreparedStatement ps = con.prepareStatement(sqlSRA)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            // 4. Cập nhật trạng thái Phòng trong bảng Rooms (status = 4: DIRTY)
            String sqlRoom = "UPDATE dbo.rooms " +
                             "SET status = 4 " +
                             "WHERE room_id IN (SELECT room_id FROM dbo.stay_room_assignments WHERE booking_id = ?)";
            try (PreparedStatement ps = con.prepareStatement(sqlRoom)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            // 5. Cập nhật hoặc tạo Folio (status = 0: CLOSED)
            String sqlFolio = "UPDATE dbo.folios SET status = 0, closed_at = SYSDATETIME() WHERE booking_id = ?";
            try (PreparedStatement ps = con.prepareStatement(sqlFolio)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            con.commit(); // Hoàn tất Transaction
            return true;

        } catch (SQLException ex) {
            if (con != null) con.rollback();
            throw ex;
        } finally {
            if (con != null) con.setAutoCommit(true);
        }
    }
    
    // ==========================================
    // 3. LẤY DANH SÁCH KHÁCH ĐANG IN-HOUSE (CHỜ CHECK-OUT)
    // ==========================================
    public int countInHouseBookings(String keyword, String statusFilter) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM dbo.bookings b " +
            "JOIN dbo.customers c ON b.customer_id = c.customer_id " +
            "WHERE b.status = 3 " // Chỉ lấy khách đang IN-HOUSE (Đã Check-in)
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (CAST(b.booking_id AS VARCHAR) LIKE ? OR c.full_name LIKE ? OR c.phone LIKE ?) ");
        }
        if ("4".equals(statusFilter)) {
            // Lọc ra khách Departing Today (Trả phòng hôm nay)
            sql.append(" AND CAST(b.check_out_date AS DATE) = CAST(SYSDATETIME() AS DATE) ");
        }

        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, kw);
                ps.setString(paramIndex++, kw);
                ps.setString(paramIndex++, kw);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<CheckoutSummary> getInHouseBookings(String keyword, String statusFilter, String sortFilter, int page, int size) {
        List<CheckoutSummary> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT b.booking_id, c.full_name, c.phone, b.check_in_date, b.check_out_date, " +
            "       (SELECT ISNULL(SUM(amount), 0) FROM dbo.payments WHERE booking_id = b.booking_id AND status = 1) AS deposit_paid, " +
            "       (SELECT TOP 1 r.room_no FROM dbo.stay_room_assignments sra JOIN dbo.rooms r ON sra.room_id = r.room_id WHERE sra.booking_id = b.booking_id AND sra.status = 2) AS room_no " +
            "FROM dbo.bookings b " +
            "JOIN dbo.customers c ON b.customer_id = c.customer_id " +
            "WHERE b.status = 3 "
        );

        // Điều kiện tìm kiếm
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (CAST(b.booking_id AS VARCHAR) LIKE ? OR c.full_name LIKE ? OR c.phone LIKE ?) ");
        }
        
        // Điều kiện trạng thái (Departing Today)
        if ("4".equals(statusFilter)) {
            sql.append(" AND CAST(b.check_out_date AS DATE) = CAST(SYSDATETIME() AS DATE) ");
        }

        // Điều kiện sắp xếp
        if ("Oldest".equalsIgnoreCase(sortFilter)) {
            sql.append(" ORDER BY b.check_in_date ASC, b.booking_id ASC ");
        } else {
            sql.append(" ORDER BY b.check_in_date DESC, b.booking_id DESC "); // Mặc định Newest
        }

        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection con = connection; PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, kw);
                ps.setString(paramIndex++, kw);
                ps.setString(paramIndex++, kw);
            }
            ps.setInt(paramIndex++, (page - 1) * size);
            ps.setInt(paramIndex++, size);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CheckoutSummary summary = new CheckoutSummary();
                    summary.setBookingId(rs.getInt("booking_id"));
                    summary.setCustomerName(rs.getString("full_name"));
                    summary.setPhone(rs.getString("phone"));
                    summary.setCheckInDate(rs.getDate("check_in_date"));
                    summary.setCheckOutDate(rs.getDate("check_out_date"));
                    summary.setDepositPaid(rs.getBigDecimal("deposit_paid").longValue());
                    summary.setRoomNo(rs.getString("room_no"));
                    list.add(summary);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
