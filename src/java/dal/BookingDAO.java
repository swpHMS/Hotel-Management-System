package dal;

import context.DBContext;
import model.BookingCardView;

import java.util.ArrayList;
import java.util.List;
import model.BookingDashboard;
import java.sql.*;
import java.util.Map;
import model.DashboardStats;
import model.Room;
import model.StayRoomAssignment;

public class BookingDAO extends DBContext {

    // =========================================================
    // STATUS
    // 1 = Pending
    // 2 = Confirmed
    // 3 = Checked-in
    // 4 = Checked-out
    // 5 = Cancelled
    // 6 = No-show
    // =========================================================
    // =========================================================
    // GET CUSTOMER ID
    // =========================================================
    public int countCurrentBookingsByCustomerId(int customerId) {
    updateNoShowBookings();

    String sql = """
        SELECT COUNT(*)
        FROM (
            SELECT
                b.booking_id,
                rt.room_type_id
            FROM dbo.bookings b
            JOIN dbo.booking_room_types brt
                 ON brt.booking_id = b.booking_id
            JOIN dbo.room_types rt
                 ON rt.room_type_id = brt.room_type_id
            WHERE b.customer_id = ?
              AND b.status IN (1,2,3)
              AND b.check_out_date >= CAST(GETDATE() AS DATE)
            GROUP BY b.booking_id, rt.room_type_id
        ) x
    """;

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, customerId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}

public List<BookingCardView> getCurrentBookingsByCustomerIdPaging(int customerId, int page, int pageSize) {
    updateNoShowBookings();

    String sql = """
        SELECT
            b.booking_id       AS bookingId,
            b.status           AS bookingStatus,
            b.check_in_date    AS checkInDate,
            b.check_out_date   AS checkOutDate,
            b.total_amount     AS totalAmount,

            rt.room_type_id    AS roomTypeId,
            rt.name            AS roomTypeName,
            rt.description     AS roomMeta,
            rt.max_adult       AS maxAdult,
            rt.max_children    AS maxChildren,

            rti.imageUrls      AS imageUrls,
            SUM(brt.quantity)  AS quantity,
            MAX(brt.price_at_booking) AS priceAtBooking,
            amen.amenitiesText AS amenitiesText

        FROM dbo.bookings b
        JOIN dbo.booking_room_types brt ON brt.booking_id = b.booking_id
        JOIN dbo.room_types rt ON rt.room_type_id = brt.room_type_id

        OUTER APPLY (
            SELECT STRING_AGG(image_url, '|') AS imageUrls
            FROM dbo.room_type_images
            WHERE room_type_id = rt.room_type_id
        ) rti

        OUTER APPLY (
            SELECT STRING_AGG(a.name, ', ') AS amenitiesText
            FROM dbo.room_type_amenities rta
            JOIN dbo.amenities a ON a.amenity_id = rta.amenity_id
            WHERE rta.room_type_id = rt.room_type_id
              AND a.is_active = 1
        ) amen

        WHERE b.customer_id = ?
          AND b.status IN (1,2,3)
          AND b.check_out_date >= CAST(GETDATE() AS DATE)

        GROUP BY
            b.booking_id, b.status, b.check_in_date, b.check_out_date, b.total_amount,
            rt.room_type_id, rt.name, rt.description, rt.max_adult, rt.max_children,
            rti.imageUrls, amen.amenitiesText

        ORDER BY b.check_in_date ASC, b.booking_id DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

    List<BookingCardView> list = new ArrayList<>();
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, customerId);
        ps.setInt(2, (page - 1) * pageSize);
        ps.setInt(3, pageSize);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(mapBookingCard(rs));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

public int countPastStaysByCustomerId(int customerId) {
    String sql = """
        SELECT COUNT(*)
        FROM (
            SELECT
                b.booking_id,
                rt.room_type_id
            FROM dbo.bookings b
            JOIN dbo.booking_room_types brt
                 ON brt.booking_id = b.booking_id
            JOIN dbo.room_types rt
                 ON rt.room_type_id = brt.room_type_id
            WHERE b.customer_id = ?
              AND b.status IN (4,5,6)
            GROUP BY b.booking_id, rt.room_type_id
        ) x
    """;

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, customerId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}

public List<BookingCardView> getPastStaysByCustomerIdPaging(int customerId, int page, int pageSize) {
    String sql = """
        SELECT
            b.booking_id       AS bookingId,
            b.status           AS bookingStatus,
            b.check_in_date    AS checkInDate,
            b.check_out_date   AS checkOutDate,
            b.total_amount     AS totalAmount,

            rt.room_type_id    AS roomTypeId,
            rt.name            AS roomTypeName,
            rt.description     AS roomMeta,
            rt.max_adult       AS maxAdult,
            rt.max_children    AS maxChildren,

            rti.imageUrls      AS imageUrls,
            SUM(brt.quantity)  AS quantity,
            MIN(brt.price_at_booking) AS priceAtBooking,
            amen.amenitiesText AS amenitiesText

        FROM dbo.bookings b
        JOIN dbo.booking_room_types brt ON brt.booking_id = b.booking_id
        JOIN dbo.room_types rt ON rt.room_type_id = brt.room_type_id

        OUTER APPLY (
            SELECT STRING_AGG(image_url, '|') AS imageUrls
            FROM dbo.room_type_images
            WHERE room_type_id = rt.room_type_id
        ) rti

        OUTER APPLY (
            SELECT STRING_AGG(a.name, ', ') AS amenitiesText
            FROM dbo.room_type_amenities rta
            JOIN dbo.amenities a ON a.amenity_id = rta.amenity_id
            WHERE rta.room_type_id = rt.room_type_id
              AND a.is_active = 1
        ) amen

        WHERE b.customer_id = ?
          AND b.status IN (4,5,6)

        GROUP BY
            b.booking_id, b.status, b.check_in_date, b.check_out_date, b.total_amount,
            rt.room_type_id, rt.name, rt.description, rt.max_adult, rt.max_children,
            rti.imageUrls, amen.amenitiesText

        ORDER BY b.check_out_date DESC, b.booking_id DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

    List<BookingCardView> list = new ArrayList<>();
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, customerId);
        ps.setInt(2, (page - 1) * pageSize);
        ps.setInt(3, pageSize);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(mapBookingCard(rs));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
    
    public Integer getCustomerIdByUserId(int userId) {

        String sql = """
            SELECT customer_id
            FROM dbo.customers
            WHERE user_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("customer_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =========================================================
    // AUTO UPDATE NO-SHOW
    // =========================================================
    private void updateNoShowBookings() {

        String sql = """
            UPDATE dbo.bookings
            SET status = 6
            WHERE status IN (1,2)
                AND check_in_date < CAST(GETDATE() AS DATE)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // =========================================================
    // CURRENT BOOKINGS
    // =========================================================
    public List<BookingCardView> getCurrentBookingsByCustomerId(int customerId) {

        updateNoShowBookings();

        String sql = """
            SELECT
                b.booking_id       AS bookingId,
                b.status           AS bookingStatus,
                b.check_in_date    AS checkInDate,
                b.check_out_date   AS checkOutDate,
                b.total_amount     AS totalAmount,

                rt.room_type_id    AS roomTypeId,
                rt.name            AS roomTypeName,
                rt.description     AS roomMeta,
                rt.max_adult       AS maxAdult,
                rt.max_children    AS maxChildren,

                rti.imageUrls AS imageUrls,

                SUM(brt.quantity)         AS quantity,
                MAX(brt.price_at_booking) AS priceAtBooking,

                amen.amenitiesText AS amenitiesText

            FROM dbo.bookings b
            JOIN dbo.booking_room_types brt 
                 ON brt.booking_id = b.booking_id

            JOIN dbo.room_types rt 
                 ON rt.room_type_id = brt.room_type_id

            OUTER APPLY (
                SELECT STRING_AGG(image_url, '|') AS imageUrls
                FROM dbo.room_type_images
                WHERE room_type_id = rt.room_type_id
            ) rti
               
            OUTER APPLY (
                SELECT STRING_AGG(a.name, ', ') AS amenitiesText
                FROM dbo.room_type_amenities rta
                JOIN dbo.amenities a 
                     ON a.amenity_id = rta.amenity_id
                WHERE rta.room_type_id = rt.room_type_id
                  AND a.is_active = 1
            ) amen

            WHERE b.customer_id = ?
              AND b.status IN (1,2,3)
              AND b.check_out_date >= CAST(GETDATE() AS DATE)

            GROUP BY
                b.booking_id, b.status, b.check_in_date, 
                b.check_out_date, b.total_amount,
                rt.room_type_id, rt.name, rt.description, 
                rt.max_adult, rt.max_children,
                     rti.imageUrls,
                amen.amenitiesText

            ORDER BY b.check_in_date ASC
        """;

        return executeBookingQuery(sql, customerId);
    }

    // =========================================================
    public boolean cancelBooking(int bookingId, int customerId) {

        String lockSql = """
        SELECT status, check_in_date, check_out_date
        FROM dbo.bookings WITH (UPDLOCK, ROWLOCK)
        WHERE booking_id = ?
          AND customer_id = ?
    """;

        String restoreInventorySql = """
        UPDATE rti
        SET rti.booked_rooms =
            CASE
                WHEN rti.booked_rooms - brt.quantity < 0
                THEN 0
                ELSE rti.booked_rooms - brt.quantity
            END
        FROM dbo.booking_room_types brt
        JOIN dbo.bookings b 
             ON b.booking_id = brt.booking_id
        JOIN dbo.room_type_inventory rti
             ON rti.room_type_id = brt.room_type_id
            AND rti.inventory_date >= b.check_in_date
            AND rti.inventory_date < b.check_out_date
        WHERE brt.booking_id = ?
    """;

        String updateSql = """
        UPDATE dbo.bookings
        SET status = 5,
            cancelled_at = GETDATE()
        WHERE booking_id = ?
    """;

        try {

            connection.setAutoCommit(false);

            int status;
            java.sql.Date checkInDate;

            // 🔒 LOCK BOOKING
            try (PreparedStatement ps = connection.prepareStatement(lockSql)) {
                ps.setInt(1, bookingId);
                ps.setInt(2, customerId);

                ResultSet rs = ps.executeQuery();

                if (!rs.next()) {
                    connection.rollback();
                    return false;
                }

                status = rs.getInt("status");
                checkInDate = rs.getDate("check_in_date");
            }

            if (checkInDate == null) {
                connection.rollback();
                return false;
            }

            // ✅ Chỉ Pending (1) hoặc Confirmed (2)
            if (status != 1 && status != 2) {
                connection.rollback();
                return false;
            }

            // ✅ Logic chuẩn: phải huỷ trước 1 ngày
            java.time.LocalDate today = java.time.LocalDate.now();
            java.time.LocalDate checkIn = checkInDate.toLocalDate();
            java.time.LocalDate deadline = checkIn.minusDays(1);

            if (today.isAfter(deadline)) {
                connection.rollback();
                return false;
            }

            // 📦 Restore inventory
            try (PreparedStatement ps = connection.prepareStatement(restoreInventorySql)) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }

            // ❌ Update booking
            int updated;
            try (PreparedStatement ps = connection.prepareStatement(updateSql)) {
                ps.setInt(1, bookingId);
                updated = ps.executeUpdate();
            }

            if (updated == 0) {
                connection.rollback();
                return false;
            }

            connection.commit();
            return true;

        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ignore) {
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception ignore) {
            }
        }
    }

    // =========================================================
    // SHARED EXECUTOR
    // =========================================================
    private List<BookingCardView> executeBookingQuery(String sql, int customerId) {

        List<BookingCardView> list = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapBookingCard(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================================================
    // MAPPER
    // =========================================================
    private BookingCardView mapBookingCard(ResultSet rs) throws Exception {

        BookingCardView b = new BookingCardView();

        b.setBookingId(rs.getInt("bookingId"));
        b.setBookingStatus(rs.getInt("bookingStatus"));
        b.setCheckInDate(rs.getDate("checkInDate"));
        b.setCheckOutDate(rs.getDate("checkOutDate"));
        b.setTotalAmount(rs.getBigDecimal("totalAmount"));

        b.setRoomTypeId(rs.getInt("roomTypeId"));
        b.setRoomTypeName(rs.getString("roomTypeName"));
        b.setRoomMeta(rs.getString("roomMeta"));
        b.setMaxAdult(rs.getInt("maxAdult"));
        b.setMaxChildren(rs.getInt("maxChildren"));

        b.setQuantity(rs.getInt("quantity"));
        b.setPriceAtBooking(rs.getBigDecimal("priceAtBooking"));

        // ===== FIX: LẤY DANH SÁCH ẢNH =====
        String rawImages = rs.getString("imageUrls");
        List<String> images = new ArrayList<>();

        if (rawImages != null && !rawImages.isBlank()) {
            String[] arr = rawImages.split("\\|");
            for (String img : arr) {
                if (img != null && !img.isBlank()) {
                    images.add(img.trim());
                }
            }
        }

        b.setImageUrls(images);

        b.setAmenitiesText(rs.getString("amenitiesText"));

        return b;
    }

    public List<BookingCardView> getPastStaysByCustomerId(int customerId) {

        String sql = """
        SELECT
            b.booking_id       AS bookingId,
            b.status           AS bookingStatus,
            b.check_in_date    AS checkInDate,
            b.check_out_date   AS checkOutDate,
            b.total_amount     AS totalAmount,

            rt.room_type_id    AS roomTypeId,
            rt.name            AS roomTypeName,
            rt.description     AS roomMeta,
            rt.max_adult       AS maxAdult,
            rt.max_children    AS maxChildren,

            rti.imageUrls      AS imageUrls,

            SUM(brt.quantity)         AS quantity,
            MIN(brt.price_at_booking) AS priceAtBooking,

            amen.amenitiesText AS amenitiesText

        FROM dbo.bookings b
        JOIN dbo.booking_room_types brt 
             ON brt.booking_id = b.booking_id

        JOIN dbo.room_types rt 
             ON rt.room_type_id = brt.room_type_id

        OUTER APPLY (
            SELECT STRING_AGG(image_url, '|') AS imageUrls
            FROM dbo.room_type_images
            WHERE room_type_id = rt.room_type_id
        ) rti

        OUTER APPLY (
            SELECT STRING_AGG(a.name, ', ') AS amenitiesText
            FROM dbo.room_type_amenities rta
            JOIN dbo.amenities a 
                 ON a.amenity_id = rta.amenity_id
            WHERE rta.room_type_id = rt.room_type_id
              AND a.is_active = 1
        ) amen

        WHERE b.customer_id = ?
          AND b.status IN (4,5,6)

        GROUP BY
            b.booking_id, b.status, b.check_in_date, 
            b.check_out_date, b.total_amount,
            rt.room_type_id, rt.name, rt.description, 
            rt.max_adult, rt.max_children,
            rti.imageUrls,
            amen.amenitiesText

        ORDER BY b.check_out_date DESC
    """;

        return executeBookingQuery(sql, customerId);
    }

public List<BookingDashboard> getTodayOperations(String targetDate, String search, String status, String sort, int index, int pageSize) {
    List<BookingDashboard> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder();
    sql.append(
            "SELECT "
            + " b.booking_id, "
            + " c.full_name, "
            + " c.phone, "
            + " u.email, "
            + " rt.name AS room_type_name, "
            + " b.check_in_date, "
            + " b.check_out_date, "
            + " b.status AS booking_status, "
            + " brt.quantity, "
            + " N'' AS note, "

            + " ISNULL(( "
            + "     SELECT STRING_AGG(CAST(r2.room_no AS VARCHAR(20)), ', ') "
            + "     FROM dbo.stay_room_assignments sra2 "
            + "     JOIN dbo.rooms r2 ON sra2.room_id = r2.room_id "
            + "     WHERE sra2.booking_id = b.booking_id "
            + " ), N'—') AS assigned_room_nos, "

            + " ISNULL(( "
            + "     SELECT STRING_AGG( "
            + "         CAST(r2.room_no AS VARCHAR(20)) "
            + "         + N' - Floor ' + CAST(r2.floor AS NVARCHAR(10)) "
            + "         + N' - ' + rt2.name "
            + "     , N', ') "
            + "     FROM dbo.stay_room_assignments sra3 "
            + "     JOIN dbo.rooms r2 ON sra3.room_id = r2.room_id "
            + "     JOIN dbo.room_types rt2 ON r2.room_type_id = rt2.room_type_id "
            + "     WHERE sra3.booking_id = b.booking_id "
            + " ), N'—') AS assigned_room_details, "

            + " ISNULL(( "
            + "     SELECT COUNT(*) "
            + "     FROM dbo.stay_room_guests srg "
            + "     JOIN dbo.stay_room_assignments sra4 ON srg.assignment_id = sra4.assignment_id "
            + "     WHERE sra4.booking_id = b.booking_id "
            + " ), 0) AS num_person "

            + "FROM dbo.bookings b "
            + "JOIN dbo.customers c ON b.customer_id = c.customer_id "
            + "LEFT JOIN dbo.users u ON c.user_id = u.user_id "
            + "LEFT JOIN dbo.booking_room_types brt ON b.booking_id = brt.booking_id "
            + "LEFT JOIN dbo.room_types rt ON brt.room_type_id = rt.room_type_id "
            + "WHERE b.status IN (2, 3, 4) "
    );

    if (status == null || status.equals("0")) {
        sql.append(" AND ( ")
           .append("      (CONVERT(DATE, b.check_in_date) = ? AND b.status = 2) ")
           .append("   OR (b.status = 3) ")
           .append("   OR (b.status = 4 AND EXISTS ( ")
           .append("          SELECT 1 ")
           .append("          FROM dbo.stay_room_assignments sraC ")
           .append("          WHERE sraC.booking_id = b.booking_id ")
           .append("            AND CONVERT(DATE, sraC.actual_check_out) = ? ")
           .append("       )) ")
           .append(" ) ");
    } else if (status.equals("2")) {
        sql.append(" AND b.status = 2 AND CONVERT(DATE, b.check_in_date) = ? ");
    } else if (status.equals("3")) {
        sql.append(" AND b.status = 3 ");
    } else if (status.equals("4")) {
        sql.append(" AND b.status = 4 AND EXISTS ( ")
           .append("      SELECT 1 ")
           .append("      FROM dbo.stay_room_assignments sraC ")
           .append("      WHERE sraC.booking_id = b.booking_id ")
           .append("        AND CONVERT(DATE, sraC.actual_check_out) = ? ")
           .append(" ) ");
    }

    if (search != null && !search.trim().isEmpty()) {
        sql.append(" AND (")
           .append(" c.full_name LIKE ? ")
           .append(" OR CAST(b.booking_id AS VARCHAR(20)) LIKE ? ")
           .append(" OR EXISTS ( ")
           .append("      SELECT 1 ")
           .append("      FROM dbo.stay_room_assignments sraS ")
           .append("      JOIN dbo.rooms rS ON sraS.room_id = rS.room_id ")
           .append("      WHERE sraS.booking_id = b.booking_id ")
           .append("        AND CAST(rS.room_no AS VARCHAR(20)) LIKE ? ")
           .append(" ) ")
           .append(") ");
    }

    String orderBy = "Oldest".equalsIgnoreCase(sort) ? "ASC" : "DESC";
    sql.append(" ORDER BY b.check_in_date ").append(orderBy)
       .append(", b.booking_id DESC ")
       .append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

    try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
        int paramIdx = 1;

        if (status == null || status.equals("0")) {
            st.setString(paramIdx++, targetDate);
            st.setString(paramIdx++, targetDate);
        } else if (status.equals("2") || status.equals("4")) {
            st.setString(paramIdx++, targetDate);
        }

        if (search != null && !search.trim().isEmpty()) {
            String keyword = "%" + search.trim() + "%";
            st.setString(paramIdx++, keyword);
            st.setString(paramIdx++, keyword);
            st.setString(paramIdx++, keyword);
        }

        st.setInt(paramIdx++, (index - 1) * pageSize);
        st.setInt(paramIdx, pageSize);

        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            BookingDashboard d = new BookingDashboard();

            d.setBookingId(rs.getInt("booking_id"));
            d.setGuestName(rs.getNString("full_name"));
            d.setPhone(rs.getString("phone"));
            d.setEmail(rs.getString("email"));
            d.setRoomTypeName(rs.getNString("room_type_name"));
            d.setCheckInDate(rs.getDate("check_in_date"));
            d.setCheckOutDate(rs.getDate("check_out_date"));
            d.setNumRooms(rs.getInt("quantity"));
            d.setNumPersons(rs.getInt("num_person"));
            d.setBookingStatus(rs.getInt("booking_status"));
            d.setAssignedRoomNos(rs.getString("assigned_room_nos"));
            d.setAssignedRoomDetails(rs.getString("assigned_room_details"));
            d.setRoomNo(rs.getString("assigned_room_nos"));
            d.setNote(rs.getNString("note"));

            list.add(d);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return list;
}

    public DashboardStats getDashboardStats(String targetDate) {
    DashboardStats stats = new DashboardStats();

    String sql = "SELECT "
            + "(SELECT COUNT(*) "
            + "   FROM stay_room_guests srg "
            + "   JOIN stay_room_assignments sra ON srg.assignment_id = sra.assignment_id "
            + "   WHERE sra.status = 2) AS total_guests, "

            + "(SELECT COUNT(*) "
            + "   FROM bookings "
            + "   WHERE CAST(check_in_date AS DATE) = ? AND status = 2) AS pending_check_in, "

            + "(SELECT COUNT(*) "
            + "   FROM stay_room_assignments "
            + "   WHERE CAST(actual_check_in AS DATE) = ? AND status = 2) AS check_in_today, "

            + "(SELECT COUNT(DISTINCT b.booking_id) "
            + "   FROM bookings b "
            + "   JOIN stay_room_assignments sra ON b.booking_id = sra.booking_id "
            + "   WHERE b.status = 4 "
            + "     AND CAST(sra.actual_check_out AS DATE) = ?) AS check_out_today, "

            + "(SELECT COUNT(*) "
            + "   FROM bookings "
            + "   WHERE CAST(check_in_date AS DATE) = ? AND status IN (2, 3)) AS arrival_today";

    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setString(1, targetDate);
        st.setString(2, targetDate);
        st.setString(3, targetDate);
        st.setString(4, targetDate);

        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            stats.setTotalGuests(rs.getInt("total_guests"));
            stats.setPendingCheckIn(rs.getInt("pending_check_in"));
            stats.setCheckInToday(rs.getInt("check_in_today"));
            stats.setCheckOutToday(rs.getInt("check_out_today"));
            stats.setArrivalToday(rs.getInt("arrival_today"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return stats;
}


   public int getTotalTodayOperations(String targetDate, String search, String status) {
    StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) "
            + "FROM dbo.bookings b "
            + "JOIN dbo.customers c ON b.customer_id = c.customer_id "
            + "WHERE b.status IN (2, 3, 4) "
    );

    if (status == null || status.equals("0")) {
        sql.append(" AND ( ")
           .append("      (CAST(b.check_in_date AS DATE) = ? AND b.status = 2) ")
           .append("   OR (b.status = 3) ")
           .append("   OR (b.status = 4 AND EXISTS ( ")
           .append("          SELECT 1 ")
           .append("          FROM dbo.stay_room_assignments sraC ")
           .append("          WHERE sraC.booking_id = b.booking_id ")
           .append("            AND CAST(sraC.actual_check_out AS DATE) = ? ")
           .append("       )) ")
           .append(" ) ");
    } else if (status.equals("2")) {
        sql.append(" AND b.status = 2 AND CAST(b.check_in_date AS DATE) = ? ");
    } else if (status.equals("3")) {
        sql.append(" AND b.status = 3 ");
    } else if (status.equals("4")) {
        sql.append(" AND b.status = 4 AND EXISTS ( ")
           .append("      SELECT 1 ")
           .append("      FROM dbo.stay_room_assignments sraC ")
           .append("      WHERE sraC.booking_id = b.booking_id ")
           .append("        AND CAST(sraC.actual_check_out AS DATE) = ? ")
           .append(" ) ");
    }

    if (search != null && !search.trim().isEmpty()) {
        sql.append(" AND (")
           .append(" c.full_name LIKE ? ")
           .append(" OR CAST(b.booking_id AS VARCHAR(20)) LIKE ? ")
           .append(" OR EXISTS ( ")
           .append("      SELECT 1 ")
           .append("      FROM dbo.stay_room_assignments sraS ")
           .append("      JOIN dbo.rooms rS ON sraS.room_id = rS.room_id ")
           .append("      WHERE sraS.booking_id = b.booking_id ")
           .append("        AND CAST(rS.room_no AS VARCHAR(20)) LIKE ? ")
           .append(" ) ")
           .append(") ");
    }

    try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
        int paramIdx = 1;

        if (status == null || status.equals("0")) {
            st.setString(paramIdx++, targetDate);
            st.setString(paramIdx++, targetDate);
        } else if (status.equals("2") || status.equals("4")) {
            st.setString(paramIdx++, targetDate);
        }

        if (search != null && !search.trim().isEmpty()) {
            String p = "%" + search.trim() + "%";
            st.setString(paramIdx++, p);
            st.setString(paramIdx++, p);
            st.setString(paramIdx++, p);
        }

        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}

    public BookingDashboard getBookingById(int bookingId) {
        String sql = "SELECT b.booking_id, c.full_name, b.check_in_date, b.check_out_date, b.total_amount, "
                + "ISNULL((SELECT SUM(amount) FROM payments WHERE booking_id = b.booking_id AND status = 1), 0) AS deposit_amount "
                + "FROM bookings b JOIN customers c ON b.customer_id = c.customer_id "
                + "WHERE b.booking_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, bookingId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                BookingDashboard b = new BookingDashboard();
                b.setBookingId(rs.getInt("booking_id"));
                b.setGuestName(rs.getNString("full_name"));
                b.setCheckInDate(rs.getDate("check_in_date"));
                b.setCheckOutDate(rs.getDate("check_out_date"));
                b.setTotalAmount(rs.getDouble("total_amount"));
                b.setDeposit(rs.getDouble("deposit_amount"));
                return b;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<StayRoomAssignment> getAssignmentsToCheckIn(int bookingId) {
        List<StayRoomAssignment> list = new ArrayList<>();
        // Truy vấn vào bảng đơn đặt phòng (booking_room_types) để lấy 'kế hoạch' gán phòng
        String sql = "SELECT brt.room_type_id, rt.name AS room_type_name, "
                + "(rt.max_adult + rt.max_children) AS capacity, brt.quantity "
                + "FROM dbo.booking_room_types brt "
                + "JOIN dbo.room_types rt ON brt.room_type_id = rt.room_type_id "
                + "WHERE brt.booking_id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, bookingId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int quantity = rs.getInt("quantity");
                for (int i = 0; i < quantity; i++) {
                    StayRoomAssignment a = new StayRoomAssignment();
                    a.setBookingId(bookingId);
                    a.setRoomTypeId(rs.getInt("room_type_id"));
                    a.setRoomTypeName(rs.getNString("room_type_name"));
                    a.setNumPersons(rs.getInt("capacity"));
                    // Gán tạm assignmentId là 0 vì chưa có trong DB
                    a.setAssignmentId(0);
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Room> getAvailableRooms() {
    List<Room> list = new ArrayList<>();

    String sql = "SELECT r.room_id, r.room_no, r.room_type_id, r.floor, rt.name AS room_type_name, "
            + "ISNULL(MAX(rv.price), 0) AS price "
            + "FROM rooms r "
            + "JOIN room_types rt ON r.room_type_id = rt.room_type_id "
            + "LEFT JOIN rate_versions rv ON r.room_type_id = rv.room_type_id "
            + "    AND CAST(GETDATE() AS DATE) BETWEEN rv.valid_from AND rv.valid_to "
            + "WHERE r.status = 1 "
            + "GROUP BY r.room_id, r.room_no, r.room_type_id, r.floor, rt.name";

    try (PreparedStatement st = connection.prepareStatement(sql)) {
        ResultSet rs = st.executeQuery();
        while (rs.next()) {
            Room r = new Room();
            r.setRoomId(rs.getInt("room_id"));
            r.setRoomNo(rs.getString("room_no"));
            r.setRoomTypeId(rs.getInt("room_type_id"));
            r.setFloor(rs.getInt("floor"));
            r.setRoomTypeName(rs.getNString("room_type_name"));
            r.setPrice(rs.getDouble("price"));
            list.add(r);
        }
        System.out.println("SERVER LOG: Found " + list.size() + " rooms available.");
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}

    public boolean finalizeCheckIn(int bookingId, Map<Integer, Integer> roomAssignmentsMap,
        Map<Integer, List<String[]>> occupantsMap, Map<Integer, Double> upgradeFeesMap) {

    String sqlBook = "UPDATE bookings SET status = 3, total_amount = total_amount + ? WHERE booking_id = ?";
    String sqlAsm = "INSERT INTO stay_room_assignments (booking_id, room_id, status, actual_check_in, assignment_type) VALUES (?, ?, 2, GETDATE(), 0)";
    String sqlRoom = "UPDATE rooms SET status = 2 WHERE room_id = ? AND status = 1";
    String sqlCheckRoom = "SELECT room_id FROM rooms WHERE room_id = ? AND status = 1";

    String sqlGetGuest = "SELECT guest_id FROM guests WHERE identity_number = ?";
    String sqlInsertGuest = "INSERT INTO guests (full_name, identity_number) VALUES (?, ?)";
    String sqlStayGuest = "INSERT INTO stay_room_guests (assignment_id, guest_id) VALUES (?, ?)";

    double totalUpgrade = 0;
    for (Double f : upgradeFeesMap.values()) {
        totalUpgrade += f;
    }

    try {
        connection.setAutoCommit(false);

        try (
                PreparedStatement psBook = connection.prepareStatement(sqlBook);
                PreparedStatement psAsm = connection.prepareStatement(sqlAsm, java.sql.Statement.RETURN_GENERATED_KEYS);
                PreparedStatement psRoom = connection.prepareStatement(sqlRoom);
                PreparedStatement psCheckRoom = connection.prepareStatement(sqlCheckRoom);
                PreparedStatement psGetGuest = connection.prepareStatement(sqlGetGuest);
                PreparedStatement psInsertGuest = connection.prepareStatement(sqlInsertGuest, java.sql.Statement.RETURN_GENERATED_KEYS);
                PreparedStatement psStayGuest = connection.prepareStatement(sqlStayGuest)
        ) {
            // 1. Update booking
            psBook.setDouble(1, totalUpgrade);
            psBook.setInt(2, bookingId);
            psBook.executeUpdate();

            // 2. Duyệt từng phòng được chọn
            for (Map.Entry<Integer, Integer> entry : roomAssignmentsMap.entrySet()) {
                int index = entry.getKey();
                int roomId = entry.getValue();

                // Check phòng còn available không
                psCheckRoom.setInt(1, roomId);
                try (ResultSet rsCheck = psCheckRoom.executeQuery()) {
                    if (!rsCheck.next()) {
                        throw new SQLException("Room " + roomId + " is no longer available.");
                    }
                }

                // Insert stay_room_assignments
                psAsm.setInt(1, bookingId);
                psAsm.setInt(2, roomId);
                int insertedAsm = psAsm.executeUpdate();

                if (insertedAsm <= 0) {
                    throw new SQLException("Cannot insert stay_room_assignment for room " + roomId);
                }

                int generatedAsmId = 0;
                try (ResultSet rsAsm = psAsm.getGeneratedKeys()) {
                    if (rsAsm.next()) {
                        generatedAsmId = rsAsm.getInt(1);
                    }
                }

                if (generatedAsmId <= 0) {
                    throw new SQLException("Cannot get generated assignment_id for room " + roomId);
                }

                // 3. Xử lý khách
                List<String[]> guests = occupantsMap.get(index);
                if (guests != null) {
                    for (String[] g : guests) {
                        String name = g[0];
                        String idNum = g[1];
                        int finalGuestId = 0;

                        psGetGuest.setString(1, idNum);
                        try (ResultSet rsG = psGetGuest.executeQuery()) {
                            if (rsG.next()) {
                                finalGuestId = rsG.getInt("guest_id");
                            }
                        }

                        if (finalGuestId <= 0) {
                            psInsertGuest.setNString(1, name);
                            psInsertGuest.setString(2, idNum);

                            int insertedGuest = psInsertGuest.executeUpdate();
                            if (insertedGuest <= 0) {
                                throw new SQLException("Cannot insert guest with identity " + idNum);
                            }

                            try (ResultSet rsNewG = psInsertGuest.getGeneratedKeys()) {
                                if (rsNewG.next()) {
                                    finalGuestId = rsNewG.getInt(1);
                                }
                            }
                        }

                        if (finalGuestId <= 0) {
                            throw new SQLException("Cannot get guest_id for identity " + idNum);
                        }

                        psStayGuest.setInt(1, generatedAsmId);
                        psStayGuest.setInt(2, finalGuestId);
                        psStayGuest.executeUpdate();
                    }
                }

                // 4. Update trạng thái phòng
                psRoom.setInt(1, roomId);
                int updatedRoom = psRoom.executeUpdate();
                if (updatedRoom <= 0) {
                    throw new SQLException("Cannot update room status for room " + roomId);
                }
            }
        }

        connection.commit();
        System.out.println("Finalize Check-in thành công cho Booking: " + bookingId);
        return true;

    } catch (SQLException e) {
        try {
            connection.rollback();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        System.err.println("Lỗi finalizeCheckIn: " + e.getMessage());
        e.printStackTrace();
        return false;
    } finally {
        try {
            connection.setAutoCommit(true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

}
