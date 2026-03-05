package dal;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class HoldDAO {

    public static class HoldItem {
        public int roomTypeId;
        public int quantity;
    }

    public static class HoldInfo {
        public int holdId;
        public Date checkIn;
        public Date checkOut;
        public int status; // 1 ACTIVE, 2 CONFIRMED, 3 EXPIRED
        public List<HoldItem> items = new ArrayList<>();
    }

    /**
     * ✅ Tạo HOLD thật trong DB + 1 item room_type (giống flow của bạn)
     * Trả về hold_id (IDENTITY)
     */
    public int createHold(Connection conn,
                          LocalDate checkIn,
                          LocalDate checkOut,
                          Integer userId,
                          int roomTypeId,
                          int quantity,
                          int holdMinutes) throws Exception {

        String sqlHold = """
            INSERT INTO dbo.availability_holds(user_id, expires_at, check_in_date, check_out_date, status)
            VALUES(?, DATEADD(MINUTE, ?, SYSDATETIME()), ?, ?, 1)
        """;

        String sqlItem = """
            INSERT INTO dbo.availability_hold_items(hold_id, room_type_id, quantity)
            VALUES(?, ?, ?)
        """;

        int holdId;

        try (PreparedStatement ps = conn.prepareStatement(sqlHold, Statement.RETURN_GENERATED_KEYS)) {
            if (userId == null) ps.setNull(1, Types.INTEGER);
            else ps.setInt(1, userId);

            ps.setInt(2, holdMinutes);
            ps.setDate(3, Date.valueOf(checkIn));
            ps.setDate(4, Date.valueOf(checkOut));

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (!rs.next()) throw new RuntimeException("Cannot get generated hold_id");
                holdId = rs.getInt(1);
            }
        }

        try (PreparedStatement ps = conn.prepareStatement(sqlItem)) {
            ps.setInt(1, holdId);
            ps.setInt(2, roomTypeId);
            ps.setInt(3, quantity);
            ps.executeUpdate();
        }

        return holdId;
    }

    /**
     * ✅ Load hold + items (đúng schema, không có booking_id)
     */
    public HoldInfo getHoldWithItems(Connection conn, int holdId) throws Exception {
        HoldInfo h = null;

        String sqlHold = """
            SELECT hold_id, check_in_date, check_out_date, status
            FROM dbo.availability_holds
            WHERE hold_id = ?
        """;

        try (PreparedStatement ps = conn.prepareStatement(sqlHold)) {
            ps.setInt(1, holdId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    h = new HoldInfo();
                    h.holdId = rs.getInt("hold_id");
                    h.checkIn = rs.getDate("check_in_date");
                    h.checkOut = rs.getDate("check_out_date");
                    h.status = rs.getInt("status");
                }
            }
        }

        if (h == null) return null;

        String sqlItems = """
            SELECT room_type_id, quantity
            FROM dbo.availability_hold_items
            WHERE hold_id = ?
        """;

        try (PreparedStatement ps = conn.prepareStatement(sqlItems)) {
            ps.setInt(1, holdId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HoldItem it = new HoldItem();
                    it.roomTypeId = rs.getInt("room_type_id");
                    it.quantity = rs.getInt("quantity");
                    h.items.add(it);
                }
            }
        }

        return h;
    }

    /**
     * ✅ Mark hold CONFIRMED (schema bạn chỉ có status)
     */
    public void markConfirmed(Connection conn, int holdId) throws Exception {
        String sql = """
            UPDATE dbo.availability_holds
            SET status = 2
            WHERE hold_id = ?
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, holdId);
            ps.executeUpdate();
        }
    }
}