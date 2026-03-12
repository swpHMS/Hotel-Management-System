package dal;

import context.DBContext;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import model.RoomTypeCard;
import model.HoldSummary;

public class ReceptBookingDAO extends DBContext {

    // ===== HOLD STATUS (INT) =====
    public static final int HOLD_ACTIVE = 1;
    public static final int HOLD_CONFIRMED = 2;
    public static final int HOLD_EXPIRED = 3;

    public long calcNights(LocalDate checkIn, LocalDate checkOut) {
        if (checkIn == null || checkOut == null) {
            return 0;
        }
        long n = ChronoUnit.DAYS.between(checkIn, checkOut);
        return Math.max(0, n);
    }

    // ================================
    // 1) GET CARDS (availability by inventory)
    // ================================
    public List<RoomTypeCard> getRoomTypeCards(Date checkIn, Date checkOut, int roomsRequested) {
        List<RoomTypeCard> list = new ArrayList<>();

        String sql
                = "WITH Dates AS ( "
                + "   SELECT ? AS d "
                + "   UNION ALL "
                + "   SELECT DATEADD(DAY, 1, d) "
                + "   FROM Dates "
                + "   WHERE DATEADD(DAY, 1, d) < ? "
                + ") "
                + "SELECT rt.room_type_id, rt.name, "
                + "       COALESCE(rv.price, 0) AS rate_per_night, "
                + "       COALESCE(inv.min_available, 0) AS available_rooms "
                + "FROM dbo.room_types rt "
                + "OUTER APPLY ( "
                + "   SELECT TOP 1 price, rate_version_id "
                + "   FROM dbo.rate_versions "
                + "   WHERE room_type_id = rt.room_type_id "
                + "     AND ? BETWEEN valid_from AND valid_to "
                + "   ORDER BY valid_from DESC, rate_version_id DESC "
                + ") rv "
                + "OUTER APPLY ( "
                + "   SELECT MIN( "
                + "       COALESCE(i.total_rooms,0) - COALESCE(i.booked_rooms,0) - COALESCE(i.held_rooms,0) "
                + "   ) AS min_available "
                + "   FROM Dates x "
                + "   LEFT JOIN dbo.room_type_inventory i "
                + "     ON i.room_type_id = rt.room_type_id "
                + "    AND i.inventory_date = x.d "
                + ") inv "
                + "WHERE rt.status = 1 "
                + "ORDER BY rt.room_type_id "
                + "OPTION (MAXRECURSION 400);";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;
            ps.setDate(idx++, checkIn);
            ps.setDate(idx++, checkOut);
            ps.setDate(idx++, checkIn);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomTypeCard c = new RoomTypeCard();
                    c.setRoomTypeId(rs.getInt("room_type_id"));
c.setRoomTypeName(rs.getString("name"));
                    c.setRatePerNight(rs.getBigDecimal("rate_per_night").longValue());

                    int av = rs.getInt("available_rooms");
                    c.setAvailableRooms(av);

                    if (av <= 0) {
                        c.setUiStatus("soldout");
                    } else if (av < roomsRequested) {
                        c.setUiStatus("limited");
                    } else {
                        c.setUiStatus("ok");
                    }

                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================================
    // 2) CREATE HOLD (NEXT step) - insert holds + items + nights + increase held_rooms
    // ================================
    public int createHold(int userId, int roomTypeId, Date checkIn, Date checkOut, int qty, int expireMinutes) throws SQLException {
        if (qty <= 0) {
            throw new SQLException("qty must be > 0");
        }
        if (checkIn == null || checkOut == null) {
            throw new SQLException("checkIn/checkOut required");
        }
        if (!checkIn.before(checkOut)) {
            throw new SQLException("checkIn must be before checkOut");
        }

        final String sqlInsertHold
                = "INSERT INTO dbo.availability_holds(user_id, expires_at, check_in_date, check_out_date, status) "
                + "VALUES(?, DATEADD(MINUTE, ?, SYSDATETIME()), ?, ?, ?)";

        final String sqlInsertItem
                = "INSERT INTO dbo.availability_hold_items(hold_id, room_type_id, quantity) VALUES(?,?,?)";

        final String sqlCheckDay
                = "SELECT 1 FROM dbo.room_type_inventory "
                + "WHERE room_type_id=? AND inventory_date=? AND (total_rooms - booked_rooms - held_rooms) >= ?";

        final String sqlInsertNight
                = "INSERT INTO dbo.availability_hold_nights(hold_id, room_type_id, inventory_date, quantity) VALUES(?,?,?,?)";

        final String sqlIncHeld
                = "UPDATE dbo.room_type_inventory SET held_rooms = held_rooms + ? WHERE room_type_id=? AND inventory_date=?";

        Connection con = null;
        try {
            con = this.connection;
            con.setAutoCommit(false);

            try (Statement st = con.createStatement()) {
                st.execute("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;");
            }

            int holdId;
            try (PreparedStatement ps = con.prepareStatement(sqlInsertHold, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setInt(2, expireMinutes);
                ps.setDate(3, checkIn);
                ps.setDate(4, checkOut);
                ps.setInt(5, HOLD_ACTIVE);
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) {
throw new SQLException("Cannot get hold_id.");
                    }
                    holdId = rs.getInt(1);
                }
            }

            try (PreparedStatement ps = con.prepareStatement(sqlInsertItem)) {
                ps.setInt(1, holdId);
                ps.setInt(2, roomTypeId);
                ps.setInt(3, qty);
                ps.executeUpdate();
            }

            LocalDate d = checkIn.toLocalDate();
            LocalDate end = checkOut.toLocalDate();

            while (d.isBefore(end)) {
                Date day = Date.valueOf(d);

                boolean ok;
                try (PreparedStatement ps = con.prepareStatement(sqlCheckDay)) {
                    ps.setInt(1, roomTypeId);
                    ps.setDate(2, day);
                    ps.setInt(3, qty);
                    try (ResultSet rs = ps.executeQuery()) {
                        ok = rs.next();
                    }
                }
                if (!ok) {
                    throw new SQLException("Not enough rooms on " + day);
                }

                try (PreparedStatement ps = con.prepareStatement(sqlInsertNight)) {
                    ps.setInt(1, holdId);
                    ps.setInt(2, roomTypeId);
                    ps.setDate(3, day);
                    ps.setInt(4, qty);
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = con.prepareStatement(sqlIncHeld)) {
                    ps.setInt(1, qty);
                    ps.setInt(2, roomTypeId);
                    ps.setDate(3, day);
                    ps.executeUpdate();
                }

                d = d.plusDays(1);
            }

            con.commit();
            return holdId;

        } catch (SQLException ex) {
            if (con != null) {
                con.rollback();
            }
            throw ex;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
            }
        }
    }

    // ================================
    // 3) LOAD HOLD SUMMARY (for Step 2 + Payment)
    // ================================
    public HoldSummary getHoldSummary(int holdId) throws SQLException {
        String sql
                = "SELECT h.hold_id, h.user_id, h.expires_at, h.check_in_date, h.check_out_date, h.status, "
                + "       i.room_type_id, i.quantity, rt.name AS room_type_name, "
                + "       COALESCE(rv.price, 0) AS rate_per_night "
                + "FROM dbo.availability_holds h "
                + "JOIN dbo.availability_hold_items i ON i.hold_id = h.hold_id "
                + "JOIN dbo.room_types rt ON rt.room_type_id = i.room_type_id "
                + "OUTER APPLY ( "
                + "   SELECT TOP 1 price, rate_version_id "
                + "   FROM dbo.rate_versions "
                + "   WHERE room_type_id = i.room_type_id "
                + "     AND h.check_in_date BETWEEN valid_from AND valid_to "
+ "   ORDER BY valid_from DESC, rate_version_id DESC "
                + ") rv "
                + "WHERE h.hold_id = ?;";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, holdId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                HoldSummary s = new HoldSummary();
                s.holdId = rs.getInt("hold_id");
                s.userId = rs.getInt("user_id");
                s.expiresAt = rs.getTimestamp("expires_at");
                s.checkIn = rs.getDate("check_in_date");
                s.checkOut = rs.getDate("check_out_date");
                s.status = rs.getInt("status");
                s.roomTypeId = rs.getInt("room_type_id");
                s.roomTypeName = rs.getString("room_type_name");
                s.qty = rs.getInt("quantity");
                s.ratePerNight = rs.getBigDecimal("rate_per_night").longValue();

                long nights = calcNights(s.checkIn.toLocalDate(), s.checkOut.toLocalDate());
                s.nights = nights;
                s.total = s.ratePerNight * nights * s.qty;
                return s;
            }
        }
    }

    // ================================
    // 6) FINALIZE BOOKING FROM HOLD
    // held -> booked + insert customer + booking + payment
    // ================================
    public int finalizeBookingFromHold(
            int holdId,
            String fullName,
            String phone,
            String email,
            String identity,
            String address,
            double depositRatio,
            String paymentMethod,
            String paymentStatus
    ) throws SQLException {

        final int BOOKING_STATUS_CONFIRMED = 2;

        Connection con = null;
        try {
            con = this.connection;
            con.setAutoCommit(false);

            try (Statement st = con.createStatement()) {
                st.execute("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;");
            }

            HoldSummary hs = null;
            String sqlHold
                    = "SELECT h.hold_id, h.user_id, h.expires_at, h.check_in_date, h.check_out_date, h.status, "
                    + "       i.room_type_id, i.quantity, rt.name AS room_type_name, "
                    + "       COALESCE(rv.price, 0) AS rate_per_night "
                    + "FROM dbo.availability_holds h WITH (UPDLOCK, HOLDLOCK) "
                    + "JOIN dbo.availability_hold_items i ON i.hold_id = h.hold_id "
                    + "JOIN dbo.room_types rt ON rt.room_type_id = i.room_type_id "
                    + "OUTER APPLY ( "
                    + "   SELECT TOP 1 price, rate_version_id "
                    + "   FROM dbo.rate_versions "
                    + "   WHERE room_type_id = i.room_type_id "
                    + "     AND h.check_in_date BETWEEN valid_from AND valid_to "
+ "   ORDER BY valid_from DESC, rate_version_id DESC "
                    + ") rv "
                    + "WHERE h.hold_id = ?;";

            try (PreparedStatement ps = con.prepareStatement(sqlHold)) {
                ps.setInt(1, holdId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        throw new SQLException("Hold not found: " + holdId);
                    }

                    hs = new HoldSummary();
                    hs.holdId = rs.getInt("hold_id");
                    hs.userId = rs.getInt("user_id");
                    hs.expiresAt = rs.getTimestamp("expires_at");
                    hs.checkIn = rs.getDate("check_in_date");
                    hs.checkOut = rs.getDate("check_out_date");
                    hs.status = rs.getInt("status");
                    hs.roomTypeId = rs.getInt("room_type_id");
                    hs.roomTypeName = rs.getString("room_type_name");
                    hs.qty = rs.getInt("quantity");
                    hs.ratePerNight = rs.getBigDecimal("rate_per_night").longValue();
                    hs.nights = calcNights(hs.checkIn.toLocalDate(), hs.checkOut.toLocalDate());
                    hs.total = hs.ratePerNight * hs.nights * hs.qty;
                }
            }

            if (hs.status != HOLD_ACTIVE) {
                throw new SQLException("Hold is not ACTIVE.");
            }

            if (hs.expiresAt != null && hs.expiresAt.toInstant().isBefore(java.time.Instant.now())) {
                releaseHoldByIdTx(con, holdId);
                throw new SQLException("Hold expired.");
            }

            String sqlMinHeld
                    = "SELECT MIN(i.held_rooms) AS minHeld "
                    + "FROM dbo.room_type_inventory i WITH (UPDLOCK, HOLDLOCK) "
                    + "JOIN dbo.availability_hold_nights n ON n.inventory_date = i.inventory_date "
                    + "WHERE n.hold_id=? AND n.room_type_id=i.room_type_id AND i.room_type_id=?;";

            int minHeld = 0;
            try (PreparedStatement ps = con.prepareStatement(sqlMinHeld)) {
                ps.setInt(1, holdId);
                ps.setInt(2, hs.roomTypeId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        minHeld = rs.getInt("minHeld");
                    }
                }
            }

            if (minHeld < hs.qty) {
                throw new SQLException("Hold inventory mismatch (held_rooms < qty).");
            }

            // ===== 4) UPSERT CUSTOMER =====
            String safeFullName = (fullName == null) ? null : fullName.trim();
String safePhone = (phone == null) ? null : phone.trim();
String safeIdentity = (identity == null) ? null : identity.trim();
String safeAddress = (address == null) ? null : address.trim();

if (safeFullName == null || safeFullName.isEmpty()) {
    throw new SQLException("Customer full name is required.");
}
if (safePhone != null && safePhone.isEmpty()) safePhone = null;
if (safeIdentity != null && safeIdentity.isEmpty()) safeIdentity = null;
if (safeAddress != null && safeAddress.isEmpty()) safeAddress = null;

Integer customerId = null;

if (safePhone != null && !safePhone.isBlank()) {
    String sqlFindCustomerByPhone =
            "SELECT TOP 1 customer_id FROM dbo.customers WHERE phone = ? ORDER BY customer_id DESC;";
    try (PreparedStatement ps = con.prepareStatement(sqlFindCustomerByPhone)) {
        ps.setString(1, safePhone);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                customerId = rs.getInt("customer_id");
            }
        }
    }
}

if (customerId == null && safeIdentity != null && !safeIdentity.isBlank()) {
    String sqlFindCustomerByIdentity =
            "SELECT TOP 1 customer_id FROM dbo.customers WHERE identity_number = ? ORDER BY customer_id DESC;";
    try (PreparedStatement ps = con.prepareStatement(sqlFindCustomerByIdentity)) {
        ps.setString(1, safeIdentity);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                customerId = rs.getInt("customer_id");
            }
        }
    }
}
System.out.println("safeFullName = [" + safeFullName + "]");
System.out.println("safePhone = [" + safePhone + "]");
System.out.println("safeIdentity = [" + safeIdentity + "]");
System.out.println("safeAddress = [" + safeAddress + "]");
System.out.println("customerId = " + customerId);
if (customerId == null) {
    String sqlInsertCustomer =
            "INSERT INTO dbo.customers(full_name, phone, identity_number, residence_address) "
            + "VALUES(?, ?, ?, ?);";

    try (PreparedStatement ps = con.prepareStatement(sqlInsertCustomer, Statement.RETURN_GENERATED_KEYS)) {
        ps.setString(1, safeFullName);

        if (safePhone == null) ps.setNull(2, Types.VARCHAR);
        else ps.setString(2, safePhone);

        if (safeIdentity == null) ps.setNull(3, Types.VARCHAR);
        else ps.setString(3, safeIdentity);

        if (safeAddress == null) ps.setNull(4, Types.NVARCHAR);
        else ps.setString(4, safeAddress);

        ps.executeUpdate();

        try (ResultSet rs = ps.getGeneratedKeys()) {
            if (!rs.next()) {
                throw new SQLException("Cannot get customer_id.");
            }
            customerId = rs.getInt(1);
        }
    }
} else {
    String sqlUpdateCustomer =
            "UPDATE dbo.customers "
            + "SET full_name = ?, "
            + "    phone = ?, "
            + "    identity_number = ?, "
            + "    residence_address = ? "
            + "WHERE customer_id = ?;";

    try (PreparedStatement ps = con.prepareStatement(sqlUpdateCustomer)) {
        ps.setString(1, safeFullName);

        if (safePhone == null) ps.setNull(2, Types.VARCHAR);
        else ps.setString(2, safePhone);

        if (safeIdentity == null) ps.setNull(3, Types.VARCHAR);
else ps.setString(3, safeIdentity);

        if (safeAddress == null) ps.setNull(4, Types.NVARCHAR);
        else ps.setString(4, safeAddress);

        ps.setInt(5, customerId);
        ps.executeUpdate();
    }
}

            // ===== 5) INSERT BOOKING =====
            String sqlInsertBooking
                    = "INSERT INTO dbo.bookings(customer_id, status, check_in_date, check_out_date, total_amount) "
                    + "VALUES(?,?,?,?,?);";
            int bookingId;
            try (PreparedStatement ps = con.prepareStatement(sqlInsertBooking, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, customerId);
                ps.setInt(2, BOOKING_STATUS_CONFIRMED);
                ps.setDate(3, hs.checkIn);
                ps.setDate(4, hs.checkOut);
                ps.setBigDecimal(5, new java.math.BigDecimal(hs.total));
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) {
                        throw new SQLException("Cannot get booking_id.");
                    }
                    bookingId = rs.getInt(1);
                }
            }

            // ===== 6) INSERT BOOKING ROOM TYPES =====
            String sqlInsertBRT
                    = "INSERT INTO dbo.booking_room_types(booking_id, room_type_id, quantity, price_at_booking) "
                    + "VALUES(?,?,?,?);";
            try (PreparedStatement ps = con.prepareStatement(sqlInsertBRT)) {
                ps.setInt(1, bookingId);
                ps.setInt(2, hs.roomTypeId);
                ps.setInt(3, hs.qty);
                ps.setBigDecimal(4, new java.math.BigDecimal(hs.ratePerNight));
                ps.executeUpdate();
            }

            // ===== 7) INSERT PAYMENT =====
            long depositAmount = Math.round(hs.total * depositRatio);
            String sqlInsertPayment
                    = "INSERT INTO dbo.payments(booking_id, amount, method, status) VALUES(?,?,?,?);";
            try (PreparedStatement ps = con.prepareStatement(sqlInsertPayment)) {
                ps.setInt(1, bookingId);
                ps.setBigDecimal(2, new java.math.BigDecimal(depositAmount));

                int methodInt = 1; // CASH
                if ("QR".equalsIgnoreCase(paymentMethod)) {
                    methodInt = 2;
                }

                int statusInt = 1; // SUCCESS
                if ("FAILED".equalsIgnoreCase(paymentStatus)) {
                    statusInt = 0;
                }

                ps.setInt(3, methodInt);
                ps.setInt(4, statusInt);
                ps.executeUpdate();
            }

            // ===== 8) HELD -> BOOKED =====
            String sqlMoveHeldToBooked
                    = "UPDATE i "
                    + "SET i.booked_rooms = i.booked_rooms + n.quantity, "
                    + "    i.held_rooms   = i.held_rooms   - n.quantity "
                    + "FROM dbo.room_type_inventory i "
+ "JOIN dbo.availability_hold_nights n "
                    + "  ON n.room_type_id = i.room_type_id AND n.inventory_date = i.inventory_date "
                    + "WHERE n.hold_id = ?;";

            try (PreparedStatement ps = con.prepareStatement(sqlMoveHeldToBooked)) {
                ps.setInt(1, holdId);
                int aff = ps.executeUpdate();
                if (aff <= 0) {
                    throw new SQLException("No inventory rows moved held->booked.");
                }
            }

            // ===== 9) HOLD -> CONFIRMED =====
            String sqlUpdateHold
                    = "UPDATE dbo.availability_holds SET status = ? WHERE hold_id = ?;";
            try (PreparedStatement ps = con.prepareStatement(sqlUpdateHold)) {
                ps.setInt(1, HOLD_CONFIRMED);
                ps.setInt(2, holdId);
                ps.executeUpdate();
            }

            con.commit();
            return bookingId;

        } catch (SQLException ex) {
            if (con != null) {
                con.rollback();
            }
            throw ex;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
            }
        }
    }

    // ================================
    // 7) RELEASE HOLD BY ID (public)
    // ================================
    public void releaseHoldById(int holdId) throws SQLException {
        Connection con = null;
        try {
            con = this.connection;
            con.setAutoCommit(false);
            try (Statement st = con.createStatement()) {
                st.execute("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;");
            }
            releaseHoldByIdTx(con, holdId);
            con.commit();
        } catch (SQLException ex) {
            if (con != null) {
                con.rollback();
            }
            throw ex;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
            }
        }
    }

    // ===== internal tx helper =====
private void releaseHoldByIdTx(Connection con, int holdId) throws SQLException {
    String sqlDec
            = "UPDATE i "
            + "SET i.held_rooms = CASE "
            + "    WHEN i.held_rooms >= n.quantity THEN i.held_rooms - n.quantity "
            + "    ELSE 0 "
            + "END "
            + "FROM dbo.room_type_inventory i "
            + "JOIN dbo.availability_hold_nights n "
            + "  ON n.room_type_id = i.room_type_id "
            + " AND n.inventory_date = i.inventory_date "
            + "WHERE n.hold_id = ?;";

    try (PreparedStatement ps = con.prepareStatement(sqlDec)) {
        ps.setInt(1, holdId);
        ps.executeUpdate();
    }

    String sqlHold
            = "UPDATE dbo.availability_holds "
            + "SET status = ? "
            + "WHERE hold_id = ? AND status = ?;";

    try (PreparedStatement ps = con.prepareStatement(sqlHold)) {
        ps.setInt(1, HOLD_EXPIRED);
        ps.setInt(2, holdId);
        ps.setInt(3, HOLD_ACTIVE);
        ps.executeUpdate();
    }
}

// ================================
// DỌN DẸP CÁC HOLD QUÁ HẠN
// ================================
public int expireHolds() throws SQLException {
    Connection con = null;
    try {
        con = connection;
        con.setAutoCommit(false);
        int affected = expireHoldsTx(con);
        con.commit();
        return affected;
    } catch (SQLException ex) {
        if (con != null) {
            con.rollback();
        }
        throw ex;
    } finally {
        if (con != null) {
            con.setAutoCommit(true);
        }
    }
}

private int expireHoldsTx(Connection con) throws SQLException {
    String select = "SELECT hold_id FROM dbo.availability_holds WHERE status = ? AND expires_at < SYSDATETIME()";
    int count = 0;

    try (PreparedStatement psSel = con.prepareStatement(select)) {
        psSel.setInt(1, HOLD_ACTIVE);

        try (ResultSet rs = psSel.executeQuery()) {
            while (rs.next()) {
                int holdId = rs.getInt(1);

                try (PreparedStatement psInv = con.prepareStatement(
                        "UPDATE inv "
                        + "SET inv.held_rooms = CASE "
                        + "    WHEN inv.held_rooms >= hn.quantity THEN inv.held_rooms - hn.quantity "
                        + "    ELSE 0 "
                        + "END "
                        + "FROM dbo.room_type_inventory inv "
                        + "JOIN dbo.availability_hold_nights hn "
                        + "  ON hn.room_type_id = inv.room_type_id "
                        + " AND hn.inventory_date = inv.inventory_date "
                        + "WHERE hn.hold_id = ?")) {
                    psInv.setInt(1, holdId);
                    psInv.executeUpdate();
                }

                try (PreparedStatement psUp = con.prepareStatement(
                        "UPDATE dbo.availability_holds SET status = ? WHERE hold_id = ? AND status = ?")) {
                    psUp.setInt(1, HOLD_EXPIRED);
                    psUp.setInt(2, holdId);
                    psUp.setInt(3, HOLD_ACTIVE);
                    psUp.executeUpdate();
                }

                count++;
            }
        }
    }

    return count;
}
}