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
import java.sql.SQLException;

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

    public int createHold(Connection conn,
                      LocalDate checkIn,
                      LocalDate checkOut,
                      Integer userId,
                      int roomTypeId,
                      int quantity,
                      int holdMinutes) throws Exception {

    if (checkIn == null || checkOut == null || !checkIn.isBefore(checkOut)) {
        throw new SQLException("Invalid check-in/check-out");
    }

    if (roomTypeId <= 0) {
        throw new SQLException("Invalid roomTypeId");
    }

    if (quantity <= 0) {
        throw new SQLException("Quantity must be > 0");
    }

    String sqlHold = """
        INSERT INTO dbo.availability_holds(user_id, expires_at, check_in_date, check_out_date, status)
        VALUES(?, DATEADD(MINUTE, ?, SYSDATETIME()), ?, ?, 1)
    """;

    String sqlItem = """
        INSERT INTO dbo.availability_hold_items(hold_id, room_type_id, quantity)
        VALUES(?, ?, ?)
    """;

    String sqlCheckDay = """
        SELECT 1
        FROM dbo.room_type_inventory WITH (UPDLOCK, HOLDLOCK)
        WHERE room_type_id = ?
          AND inventory_date = ?
          AND (total_rooms - booked_rooms - held_rooms) >= ?
    """;

    String sqlInsertNight = """
        INSERT INTO dbo.availability_hold_nights(hold_id, room_type_id, inventory_date, quantity)
        VALUES(?, ?, ?, ?)
    """;

    String sqlIncreaseHeld = """
        UPDATE dbo.room_type_inventory
        SET held_rooms = held_rooms + ?
        WHERE room_type_id = ?
          AND inventory_date = ?
    """;

    int holdId;

    boolean oldAutoCommit = conn.getAutoCommit();
    try {
        conn.setAutoCommit(false);

        // 1. insert hold header
        try (PreparedStatement ps = conn.prepareStatement(sqlHold, Statement.RETURN_GENERATED_KEYS)) {
            if (userId == null) ps.setNull(1, Types.INTEGER);
            else ps.setInt(1, userId);

            ps.setInt(2, holdMinutes);
            ps.setDate(3, Date.valueOf(checkIn));
            ps.setDate(4, Date.valueOf(checkOut));

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (!rs.next()) throw new SQLException("Cannot get generated hold_id");
                holdId = rs.getInt(1);
            }
        }

        // 2. insert hold item
        try (PreparedStatement ps = conn.prepareStatement(sqlItem)) {
            ps.setInt(1, holdId);
            ps.setInt(2, roomTypeId);
            ps.setInt(3, quantity);
            ps.executeUpdate();
        }

        // 3. check inventory + insert hold nights + increase held_rooms
        LocalDate d = checkIn;
        while (d.isBefore(checkOut)) {
            Date day = Date.valueOf(d);

            boolean ok;
            try (PreparedStatement ps = conn.prepareStatement(sqlCheckDay)) {
                ps.setInt(1, roomTypeId);
                ps.setDate(2, day);
                ps.setInt(3, quantity);

                try (ResultSet rs = ps.executeQuery()) {
                    ok = rs.next();
                }
            }

            if (!ok) {
                throw new SQLException("Not enough rooms on " + day);
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlInsertNight)) {
                ps.setInt(1, holdId);
                ps.setInt(2, roomTypeId);
                ps.setDate(3, day);
                ps.setInt(4, quantity);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlIncreaseHeld)) {
                ps.setInt(1, quantity);
                ps.setInt(2, roomTypeId);
                ps.setDate(3, day);

                int updated = ps.executeUpdate();
                if (updated <= 0) {
                    throw new SQLException("Cannot update held_rooms on " + day);
                }
            }

            d = d.plusDays(1);
        }

        conn.commit();
        return holdId;

    } catch (Exception e) {
        conn.rollback();
        throw e;
    } finally {
        conn.setAutoCommit(oldAutoCommit);
    }
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