package dal;

import context.DBContext;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;

public class BookingFinalizeDAO {

    public static class FinalizeResult {
        public int bookingId;
        public String bookingCode;
    }

    private static class HoldData {
        int holdId;
        int status; // 1 ACTIVE, 2 CONFIRMED, 3 EXPIRED
        LocalDate checkIn;
        LocalDate checkOut;
        Map<Integer, Integer> items = new LinkedHashMap<>();
    }

    private HoldData loadHoldWithItems(Connection conn, int holdId) throws Exception {
        HoldData h = null;

        try (PreparedStatement ps = conn.prepareStatement("""
            SELECT hold_id, check_in_date, check_out_date, status
            FROM dbo.availability_holds
            WHERE hold_id = ?
        """)) {
            ps.setInt(1, holdId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    h = new HoldData();
                    h.holdId = rs.getInt("hold_id");
                    h.checkIn = rs.getDate("check_in_date").toLocalDate();
                    h.checkOut = rs.getDate("check_out_date").toLocalDate();
                    h.status = rs.getInt("status");
                }
            }
        }

        if (h == null) return null;

        try (PreparedStatement ps = conn.prepareStatement("""
            SELECT room_type_id, quantity
            FROM dbo.availability_hold_items
            WHERE hold_id = ?
        """)) {
            ps.setInt(1, holdId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    h.items.put(rs.getInt("room_type_id"), rs.getInt("quantity"));
                }
            }
        }

        return h;
    }

    private Integer findCustomerIdByUserId(Connection conn, int userId) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT customer_id FROM dbo.customers WHERE user_id = ?")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return null;
    }

    // ✅ FIX: userId có thể NULL (guest)
    private int createCustomerForUser(Connection conn, Integer userId, String fullName) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO dbo.customers(user_id, full_name) VALUES(?, ?)",
                Statement.RETURN_GENERATED_KEYS)) {

            if (userId == null) ps.setNull(1, Types.INTEGER);
            else ps.setInt(1, userId);

            ps.setString(2, (fullName == null || fullName.isBlank()) ? "Guest" : fullName.trim());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Cannot create customer (user_id=" + userId + ")");
    }

    public FinalizeResult finalizeAfterVnpaySuccess(
            int holdId,
            Integer userId,          // ✅ nullable
            String fullName,
            BigDecimal totalAmount,
            BigDecimal paidAmount
    ) throws Exception {

        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);

            try {
                HoldData hold = loadHoldWithItems(conn, holdId);
                if (hold == null) throw new RuntimeException("Hold not found: " + holdId);

                // nếu hold không ACTIVE thì không finalize lại
                if (hold.status != 1) {
                    throw new RuntimeException("Hold status is not ACTIVE (status=" + hold.status + ").");
                }
                if (hold.items.isEmpty()) {
                    throw new RuntimeException("Hold has no items: " + holdId);
                }

                // ✅ FIX: Cho phép guest
                Integer customerId = null;

                if (userId != null && userId > 0) {
                    customerId = findCustomerIdByUserId(conn, userId);
                    if (customerId == null) {
                        customerId = createCustomerForUser(conn, userId, fullName);
                    }
                } else {
                    // guest booking -> customers.user_id = NULL
                    customerId = createCustomerForUser(conn, null, fullName);
                }

                // 1) Insert bookings (status=2 CONFIRMED)
                int bookingId;
                try (PreparedStatement ps = conn.prepareStatement("""
                    INSERT INTO bookings(customer_id, hold_id, status, check_in_date, check_out_date, total_amount)
                    VALUES (?, ?, 2, ?, ?, ?)
                """, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, customerId);
ps.setInt(2, holdId);
ps.setDate(3, Date.valueOf(hold.checkIn));
ps.setDate(4, Date.valueOf(hold.checkOut));
ps.setBigDecimal(5, totalAmount);
                    ps.executeUpdate();

                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (!rs.next()) throw new SQLException("Cannot get booking_id");
                        bookingId = rs.getInt(1);
                    }
                }

                // 2) Insert booking_room_types (price_at_booking tạm = 0)
                try (PreparedStatement ps = conn.prepareStatement("""
                    INSERT INTO dbo.booking_room_types(booking_id, room_type_id, quantity, price_at_booking)
                    VALUES(?, ?, ?, ?)
                """)) {
                    for (Map.Entry<Integer, Integer> e : hold.items.entrySet()) {
                        ps.setInt(1, bookingId);
                        ps.setInt(2, e.getKey());
                        ps.setInt(3, e.getValue());
                        ps.setBigDecimal(4, BigDecimal.ZERO);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }

                // 3) Insert payments (method=2 TRANSFER, status=1 SUCCESS)
                try (PreparedStatement ps = conn.prepareStatement("""
                    INSERT INTO dbo.payments(booking_id, amount, method, status)
                    VALUES(?, ?, 2, 1)
                """)) {
                    ps.setInt(1, bookingId);
                    ps.setBigDecimal(2, paidAmount);
                    ps.executeUpdate();
                }

                // 4) Update hold -> CONFIRMED
//try (PreparedStatement ps = conn.prepareStatement("""
//    UPDATE dbo.availability_holds
//    SET status = 3
//    WHERE hold_id = ?
//""")) {
//                    ps.setInt(1, holdId);
//                    ps.executeUpdate();
//                }

                conn.commit();

                FinalizeResult r = new FinalizeResult();
                r.bookingId = bookingId;
                r.bookingCode = "BK-" + bookingId;
                return r;

            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
}