package dal;

import context.DBContext;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import model.RoomTypeCard;

public class ReceptBookingDAO extends DBContext {

    public long calcNights(LocalDate checkIn, LocalDate checkOut) {
        if (checkIn == null || checkOut == null) return 0;
        long n = ChronoUnit.DAYS.between(checkIn, checkOut);
        return Math.max(0, n);
    }

    // ================================
    // 1) GET CARDS (availability by inventory)
    // ================================
    public List<RoomTypeCard> getRoomTypeCards(Date checkIn, Date checkOut, int roomsRequested) {
        List<RoomTypeCard> list = new ArrayList<>();

        String sql =
            "WITH Dates AS ( " +
            "   SELECT ? AS d " +
            "   UNION ALL " +
            "   SELECT DATEADD(DAY, 1, d) " +
            "   FROM Dates " +
            "   WHERE DATEADD(DAY, 1, d) < ? " +
            ") " +
            "SELECT rt.room_type_id, rt.name, " +
            "       COALESCE(rv.price, 0) AS rate_per_night, " +
            "       COALESCE(inv.min_available, 0) AS available_rooms " +
            "FROM dbo.room_types rt " +
            "OUTER APPLY ( " +
            "   SELECT TOP 1 price, rate_version_id " +
            "   FROM dbo.rate_versions " +
            "   WHERE room_type_id = rt.room_type_id " +
            "     AND ? BETWEEN valid_from AND valid_to " +
            "   ORDER BY valid_from DESC, rate_version_id DESC " +
            ") rv " +
            "OUTER APPLY ( " +
            "   SELECT MIN( " +
            "       COALESCE(i.total_rooms,0) - COALESCE(i.booked_rooms,0) - COALESCE(i.held_rooms,0) " +
            "   ) AS min_available " +
            "   FROM Dates x " +
            "   LEFT JOIN dbo.room_type_inventory i " +
            "     ON i.room_type_id = rt.room_type_id " +
            "    AND i.inventory_date = x.d " +
            ") inv " +
            "WHERE rt.status = 1 " +
            "ORDER BY rt.room_type_id " +
            "OPTION (MAXRECURSION 400);";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;

            // Dates
            ps.setDate(idx++, checkIn);
            ps.setDate(idx++, checkOut);

            // rate at checkIn
            ps.setDate(idx++, checkIn);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomTypeCard c = new RoomTypeCard();
                    c.setRoomTypeId(rs.getInt("room_type_id"));
                    c.setRoomTypeName(rs.getString("name"));
                    c.setRatePerNight(rs.getBigDecimal("rate_per_night").longValue());

                    int av = rs.getInt("available_rooms");
                    c.setAvailableRooms(av);

                    // UI status for requested rooms
                    if (av <= 0) c.setUiStatus("soldout");
                    else if (av < roomsRequested) c.setUiStatus("limited");
                    else c.setUiStatus("ok");

                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================================
    // 2) SEARCH BY QTY (optional reuse)
    // ================================
    public List<RoomTypeCard> searchByQty(Date checkIn, Date checkOut, int roomsRequested) {
        // basically same as getRoomTypeCards but you could filter min_available >= roomsRequested
        List<RoomTypeCard> list = new ArrayList<>();

        String sql =
            "WITH Dates AS ( " +
            "   SELECT ? AS d " +
            "   UNION ALL " +
            "   SELECT DATEADD(DAY, 1, d) " +
            "   FROM Dates " +
            "   WHERE DATEADD(DAY, 1, d) < ? " +
            ") " +
            "SELECT rt.room_type_id, rt.name, " +
            "       COALESCE(rv.price, 0) AS rate_per_night, " +
            "       COALESCE(inv.min_available, 0) AS available_rooms " +
            "FROM dbo.room_types rt " +
            "OUTER APPLY ( " +
            "   SELECT TOP 1 price, rate_version_id " +
            "   FROM dbo.rate_versions " +
            "   WHERE room_type_id = rt.room_type_id " +
            "     AND ? BETWEEN valid_from AND valid_to " +
            "   ORDER BY valid_from DESC, rate_version_id DESC " +
            ") rv " +
            "OUTER APPLY ( " +
            "   SELECT MIN( " +
            "       COALESCE(i.total_rooms,0) - COALESCE(i.booked_rooms,0) - COALESCE(i.held_rooms,0) " +
            "   ) AS min_available " +
            "   FROM Dates x " +
            "   LEFT JOIN dbo.room_type_inventory i " +
            "     ON i.room_type_id = rt.room_type_id " +
            "    AND i.inventory_date = x.d " +
            ") inv " +
            "WHERE rt.status = 1 " +
            "  AND COALESCE(inv.min_available,0) >= ? " +
            "ORDER BY inv.min_available DESC, rt.room_type_id DESC " +
            "OPTION (MAXRECURSION 400);";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;
            ps.setDate(idx++, checkIn);
            ps.setDate(idx++, checkOut);
            ps.setDate(idx++, checkIn);
            ps.setInt(idx++, roomsRequested);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomTypeCard c = new RoomTypeCard();
                    c.setRoomTypeId(rs.getInt("room_type_id"));
                    c.setRoomTypeName(rs.getString("name"));
                    c.setRatePerNight(rs.getBigDecimal("rate_per_night").longValue());

                    int av = rs.getInt("available_rooms");
                    c.setAvailableRooms(av);
                    c.setUiStatus("ok"); // since filtered >= roomsRequested
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================================
    // 3) HOLD rooms (increase held_rooms) with transaction + availability check
    // ================================
    public void holdInventory(int roomTypeId, Date checkIn, Date checkOut, int rooms) throws SQLException {
        if (rooms <= 0) throw new SQLException("rooms must be > 0");
        if (checkIn == null || checkOut == null) throw new SQLException("checkIn/checkOut required");
        if (!checkIn.before(checkOut)) throw new SQLException("checkIn must be before checkOut");

        String sqlCheck =
            "WITH Dates AS ( " +
            "   SELECT ? AS d " +
            "   UNION ALL " +
            "   SELECT DATEADD(DAY, 1, d) " +
            "   FROM Dates " +
            "   WHERE DATEADD(DAY, 1, d) < ? " +
            ") " +
            "SELECT MIN(COALESCE(i.total_rooms,0) - COALESCE(i.booked_rooms,0) - COALESCE(i.held_rooms,0)) AS min_av " +
            "FROM Dates x " +
            "LEFT JOIN dbo.room_type_inventory i " +
            "  ON i.room_type_id = ? AND i.inventory_date = x.d " +
            "OPTION (MAXRECURSION 400);";

        String sqlUpdate =
            "WITH Dates AS ( " +
            "   SELECT ? AS d " +
            "   UNION ALL " +
            "   SELECT DATEADD(DAY, 1, d) " +
            "   FROM Dates " +
            "   WHERE DATEADD(DAY, 1, d) < ? " +
            ") " +
            "UPDATE i " +
            "SET held_rooms = held_rooms + ? " +
            "FROM dbo.room_type_inventory i " +
            "JOIN Dates x ON i.inventory_date = x.d " +
            "WHERE i.room_type_id = ? " +
            "OPTION (MAXRECURSION 400);";

        Connection con = null;
        try {
            con = this.connection;
            con.setAutoCommit(false);

            // lock rows to prevent race: use SERIALIZABLE for correctness
            try (Statement st = con.createStatement()) {
                st.execute("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;");
            }

            int minAv = 0;
            try (PreparedStatement ps = con.prepareStatement(sqlCheck)) {
                ps.setDate(1, checkIn);
                ps.setDate(2, checkOut);
                ps.setInt(3, roomTypeId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) minAv = rs.getInt("min_av");
                }
            }

            if (minAv < rooms) {
                con.rollback();
                throw new SQLException("Not enough availability to hold. min_available=" + minAv + ", requested=" + rooms);
            }

            try (PreparedStatement ps = con.prepareStatement(sqlUpdate)) {
                ps.setDate(1, checkIn);
                ps.setDate(2, checkOut);
                ps.setInt(3, rooms);
                ps.setInt(4, roomTypeId);
                int affected = ps.executeUpdate();
                if (affected <= 0) {
                    con.rollback();
                    throw new SQLException("Hold failed: no inventory rows updated. Did you seed inventory for all days?");
                }
            }

            con.commit();
        } catch (SQLException ex) {
            if (con != null) con.rollback();
            throw ex;
        } finally {
            if (con != null) con.setAutoCommit(true);
        }
    }

    // ================================
    // 4) CONFIRM rooms (held -> booked)
    // ================================
    public void confirmInventory(int roomTypeId, Date checkIn, Date checkOut, int rooms) throws SQLException {
        if (rooms <= 0) throw new SQLException("rooms must be > 0");

        String sql =
            "WITH Dates AS ( " +
            "   SELECT ? AS d " +
            "   UNION ALL " +
            "   SELECT DATEADD(DAY, 1, d) " +
            "   FROM Dates " +
            "   WHERE DATEADD(DAY, 1, d) < ? " +
            ") " +
            "UPDATE i " +
            "SET booked_rooms = booked_rooms + ?, " +
            "    held_rooms   = held_rooms - ? " +
            "FROM dbo.room_type_inventory i " +
            "JOIN Dates x ON i.inventory_date = x.d " +
            "WHERE i.room_type_id = ? " +
            "OPTION (MAXRECURSION 400);";

        Connection con = null;
        try {
            con = this.connection;
            con.setAutoCommit(false);
            try (Statement st = con.createStatement()) {
                st.execute("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;");
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setDate(1, checkIn);
                ps.setDate(2, checkOut);
                ps.setInt(3, rooms);
                ps.setInt(4, rooms);
                ps.setInt(5, roomTypeId);
                int affected = ps.executeUpdate();
                if (affected <= 0) {
                    con.rollback();
                    throw new SQLException("Confirm failed: no inventory rows updated.");
                }
            }

            con.commit();
        } catch (SQLException ex) {
            if (con != null) con.rollback();
            throw ex;
        } finally {
            if (con != null) con.setAutoCommit(true);
        }
    }

    // ================================
    // 5) RELEASE HOLD (decrease held_rooms)
    // ================================
    public void releaseHold(int roomTypeId, Date checkIn, Date checkOut, int rooms) throws SQLException {
        if (rooms <= 0) throw new SQLException("rooms must be > 0");

        String sql =
            "WITH Dates AS ( " +
            "   SELECT ? AS d " +
            "   UNION ALL " +
            "   SELECT DATEADD(DAY, 1, d) " +
            "   FROM Dates " +
            "   WHERE DATEADD(DAY, 1, d) < ? " +
            ") " +
            "UPDATE i " +
            "SET held_rooms = CASE WHEN held_rooms >= ? THEN held_rooms - ? ELSE 0 END " +
            "FROM dbo.room_type_inventory i " +
            "JOIN Dates x ON i.inventory_date = x.d " +
            "WHERE i.room_type_id = ? " +
            "OPTION (MAXRECURSION 400);";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, checkIn);
            ps.setDate(2, checkOut);
            ps.setInt(3, rooms);
            ps.setInt(4, rooms);
            ps.setInt(5, roomTypeId);
            ps.executeUpdate();
        }
    }
}