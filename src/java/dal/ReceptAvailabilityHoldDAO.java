package dal;

import context.DBContext;

import java.sql.*;
import java.time.LocalDate;

public class ReceptAvailabilityHoldDAO extends DBContext {

    // status int (theo bạn)
    public static final int HOLD_ACTIVE    = 1;
    public static final int HOLD_EXPIRED   = 2;
    public static final int HOLD_CONFIRMED = 3;

    // ========== PUBLIC API ==========

    /** Tạo hold và tăng held_rooms theo [checkIn, checkOut) */
    public int createHold(int userIdOrZero,
                          int roomTypeId,
                          int qty,
                          Date checkIn,
                          Date checkOut,
                          int expireMinutes) throws SQLException {

        if (qty <= 0) throw new SQLException("qty must be > 0");
        if (checkIn == null || checkOut == null || !checkIn.before(checkOut)) {
            throw new SQLException("Invalid date range");
        }

        Connection con = null;
        try {
            con = connection;
            con.setAutoCommit(false);

            // 0) Dọn hold hết hạn trước (để trả held_rooms về đúng)
            expireHoldsTx(con);

            // 1) Create hold header
            int holdId = insertHoldHeader(con, userIdOrZero, checkIn, checkOut, expireMinutes);

            // 2) Hold item
            insertHoldItem(con, holdId, roomTypeId, qty);

            // 3) Loop từng ngày: lock inventory row -> check -> insert hold_night -> update held_rooms
            LocalDate d = checkIn.toLocalDate();
            LocalDate end = checkOut.toLocalDate();

            while (d.isBefore(end)) {
                Date invDate = Date.valueOf(d);

                // lock row + check
                if (!hasEnoughInventoryForUpdate(con, roomTypeId, invDate, qty)) {
                    // rollback & throw
                    throw new SQLException("Not enough rooms on " + invDate);
                }

                insertHoldNight(con, holdId, roomTypeId, invDate, qty);
                increaseHeld(con, roomTypeId, invDate, qty);

                d = d.plusDays(1);
            }

            con.commit();
            return holdId;

        } catch (SQLException ex) {
            if (con != null) con.rollback();
            throw ex;
        } finally {
            if (con != null) con.setAutoCommit(true);
        }
    }

    /** Hủy hold: trừ held_rooms theo hold_nights rồi set status */
    public void releaseHold(int holdId, int newStatus) throws SQLException {
        Connection con = null;
        try {
            con = connection;
            con.setAutoCommit(false);

            // chỉ xử lý nếu hold đang ACTIVE
            Integer cur = getHoldStatusForUpdate(con, holdId);
            if (cur == null) throw new SQLException("Hold not found");
            if (cur != HOLD_ACTIVE) { // đã hết hạn/confirmed/cancelled thì bỏ
                con.commit();
                return;
            }
// trừ held_rooms theo nights
            String sqlUpdateInv =
                "UPDATE inv " +
                "SET inv.held_rooms = inv.held_rooms - hn.quantity " +
                "FROM dbo.room_type_inventory inv " +
                "JOIN dbo.availability_hold_nights hn " +
                "  ON hn.room_type_id = inv.room_type_id AND hn.inventory_date = inv.inventory_date " +
                "WHERE hn.hold_id = ?";

            try (PreparedStatement ps = con.prepareStatement(sqlUpdateInv)) {
                ps.setInt(1, holdId);
                ps.executeUpdate();
            }

            // set status
            try (PreparedStatement ps = con.prepareStatement(
                    "UPDATE dbo.availability_holds SET status = ? WHERE hold_id = ?")) {
                ps.setInt(1, newStatus);
                ps.setInt(2, holdId);
                ps.executeUpdate();
            }

            con.commit();
        } catch (SQLException ex) {
            if (con != null) con.rollback();
            throw ex;
        } finally {
            if (con != null) con.setAutoCommit(true);
        }
    }

    /** Dọn hold hết hạn (ACTIVE + expires_at < now) */
    public int expireHolds() throws SQLException {
        Connection con = null;
        try {
            con = connection;
            con.setAutoCommit(false);

            int affected = expireHoldsTx(con);

            con.commit();
            return affected;
        } catch (SQLException ex) {
            if (con != null) con.rollback();
            throw ex;
        } finally {
            if (con != null) con.setAutoCommit(true);
        }
    }

    // ========== INTERNAL TX HELPERS ==========

    private int insertHoldHeader(Connection con, int userIdOrZero, Date checkIn, Date checkOut, int expireMinutes) throws SQLException {
        String sql =
            "INSERT INTO dbo.availability_holds(user_id, expires_at, check_in_date, check_out_date, status) " +
            "VALUES(?, DATEADD(MINUTE, ?, SYSDATETIME()), ?, ?, ?)";

        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (userIdOrZero > 0) ps.setInt(1, userIdOrZero);
            else ps.setNull(1, Types.INTEGER);

            ps.setInt(2, expireMinutes);
            ps.setDate(3, checkIn);
            ps.setDate(4, checkOut);
            ps.setInt(5, HOLD_ACTIVE);

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Cannot create holdId");
    }

    private void insertHoldItem(Connection con, int holdId, int roomTypeId, int qty) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(
                "INSERT INTO dbo.availability_hold_items(hold_id, room_type_id, quantity) VALUES(?,?,?)")) {
            ps.setInt(1, holdId);
            ps.setInt(2, roomTypeId);
            ps.setInt(3, qty);
ps.executeUpdate();
        }
    }

    private boolean hasEnoughInventoryForUpdate(Connection con, int roomTypeId, Date invDate, int qty) throws SQLException {
        String sql =
            "SELECT 1 " +
            "FROM dbo.room_type_inventory WITH (UPDLOCK, HOLDLOCK) " +
            "WHERE room_type_id = ? AND inventory_date = ? " +
            "  AND (total_rooms - booked_rooms - held_rooms) >= ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, roomTypeId);
            ps.setDate(2, invDate);
            ps.setInt(3, qty);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private void insertHoldNight(Connection con, int holdId, int roomTypeId, Date invDate, int qty) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(
                "INSERT INTO dbo.availability_hold_nights(hold_id, room_type_id, inventory_date, quantity) VALUES(?,?,?,?)")) {
            ps.setInt(1, holdId);
            ps.setInt(2, roomTypeId);
            ps.setDate(3, invDate);
            ps.setInt(4, qty);
            ps.executeUpdate();
        }
    }

    private void increaseHeld(Connection con, int roomTypeId, Date invDate, int qty) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(
                "UPDATE dbo.room_type_inventory SET held_rooms = held_rooms + ? WHERE room_type_id = ? AND inventory_date = ?")) {
            ps.setInt(1, qty);
            ps.setInt(2, roomTypeId);
            ps.setDate(3, invDate);
            ps.executeUpdate();
        }
    }

    private Integer getHoldStatusForUpdate(Connection con, int holdId) throws SQLException {
        String sql = "SELECT status FROM dbo.availability_holds WITH (UPDLOCK, HOLDLOCK) WHERE hold_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, holdId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
                return null;
            }
        }
    }

    private int expireHoldsTx(Connection con) throws SQLException {
        // lấy danh sách hold cần expire (lock nhẹ)
        String select =
            "SELECT hold_id " +
            "FROM dbo.availability_holds " +
            "WHERE status = ? AND expires_at < SYSDATETIME()";

        int count = 0;

        try (PreparedStatement psSel = con.prepareStatement(select)) {
            psSel.setInt(1, HOLD_ACTIVE);

            try (ResultSet rs = psSel.executeQuery()) {
                while (rs.next()) {
                    int holdId = rs.getInt(1);

                    // trừ inventory
                    try (PreparedStatement psInv = con.prepareStatement(
                            "UPDATE inv SET inv.held_rooms = inv.held_rooms - hn.quantity " +
                            "FROM dbo.room_type_inventory inv " +
"JOIN dbo.availability_hold_nights hn " +
                            "  ON hn.room_type_id = inv.room_type_id AND hn.inventory_date = inv.inventory_date " +
                            "WHERE hn.hold_id = ?")) {
                        psInv.setInt(1, holdId);
                        psInv.executeUpdate();
                    }

                    // set expired
                    try (PreparedStatement psUp = con.prepareStatement(
                            "UPDATE dbo.availability_holds SET status = ? WHERE hold_id = ?")) {
                        psUp.setInt(1, HOLD_EXPIRED);
                        psUp.setInt(2, holdId);
                        psUp.executeUpdate();
                    }

                    count++;
                }
            }
        }

        return count;
    }
}