package dal;

import context.DBContext;
import model.BookingCardView;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

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

}
