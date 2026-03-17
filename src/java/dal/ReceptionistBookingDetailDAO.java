package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.BookingSummary;
import model.AssignedRoomView;
import model.PaymentView;
import model.StayGuestView;

public class ReceptionistBookingDetailDAO extends DBContext {

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
                    b.setRoomTypeName(rs.getString("room_type_name"));
                    b.setQuantity(rs.getInt("quantity"));

                    if (rs.getBigDecimal("total_amount") != null) {
                        b.setTotalAmount(rs.getBigDecimal("total_amount").longValue());
                    } else {
                        b.setTotalAmount(0);
                    }

                    b.setDeposit(rs.getLong("deposit"));
                    return b;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<AssignedRoomView> getAssignedRooms(int bookingId) {
    List<AssignedRoomView> list = new ArrayList<>();
    Map<Integer, AssignedRoomView> map = new LinkedHashMap<>();

    String sql =
            "SELECT sra.assignment_id, "
            + "       sra.status, "
            + "       r.room_no, "
            + "       rt.name AS room_type_name, "
            + "       g.guest_id, "
            + "       g.full_name, "
            + "       g.identity_number "
            + "FROM dbo.stay_room_assignments sra "
            + "JOIN dbo.rooms r ON sra.room_id = r.room_id "
            + "JOIN dbo.room_types rt ON r.room_type_id = rt.room_type_id "
            + "LEFT JOIN dbo.stay_room_guests srg ON sra.assignment_id = srg.assignment_id "
            + "LEFT JOIN dbo.guests g ON srg.guest_id = g.guest_id "
            + "WHERE sra.booking_id = ? "
            + "ORDER BY r.room_no, g.full_name";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, bookingId);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int assignmentId = rs.getInt("assignment_id");

                AssignedRoomView room = map.get(assignmentId);
                if (room == null) {
                    room = new AssignedRoomView();
                    room.setAssignmentId(assignmentId);
                    room.setRoomNo(rs.getString("room_no"));
                    room.setRoomTypeName(rs.getString("room_type_name"));
                    map.put(assignmentId, room);
                }

                Object guestIdObj = rs.getObject("guest_id");
                if (guestIdObj != null) {
                    StayGuestView guest = new StayGuestView();
                    guest.setGuestId(rs.getInt("guest_id"));
                    guest.setFullName(rs.getString("full_name"));
                    guest.setIdentityNumber(rs.getString("identity_number"));
                    room.getGuests().add(guest);
                }
            }
        }

        list.addAll(map.values());
    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

    public List<PaymentView> getPaymentsByBooking(int bookingId) {
        List<PaymentView> list = new ArrayList<>();

        String sql =
                "SELECT payment_id, amount, method, status, paid_at "
                + "FROM dbo.payments "
                + "WHERE booking_id = ? "
                + "ORDER BY paid_at DESC, payment_id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PaymentView p = new PaymentView();
                    p.setPaymentId(rs.getInt("payment_id"));

                    if (rs.getBigDecimal("amount") != null) {
                        p.setAmount(rs.getBigDecimal("amount").longValue());
                    } else {
                        p.setAmount(0);
                    }

                    p.setMethod(rs.getInt("method"));
                    p.setStatus(rs.getInt("status"));
                    p.setPaidAt(rs.getTimestamp("paid_at"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}