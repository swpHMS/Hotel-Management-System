package controller.receptionist.booking;

import dal.ReceptBookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import model.RoomTypeCard;
import model.User;

@WebServlet(
        name = "ReceptionistBookingCreateServlet",
        urlPatterns = {"/receptionist/booking/create"}
)
public class ReceptionistBookingCreateServlet extends HttpServlet {

    private final ReceptBookingDAO dao = new ReceptBookingDAO();

    private Integer parseIntOrNull(String s) {
        try {
            return (s == null || s.trim().isEmpty())
                    ? null
                    : Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Date parseSqlDateOrNull(String s) {
        try {
            return (s == null || s.trim().isEmpty())
                    ? null
                    : Date.valueOf(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private int clamp(int n, int min, int max) {
        return Math.max(min, Math.min(max, n));
    }

    // ================================
    // BỎ RULE 14:00 - LUÔN CHO PHÉP BOOK TRONG NGÀY
// ================================
    private LocalDate getMinCheckInDate() {
        // Ngày check-in nhỏ nhất luôn luôn là ngày hôm nay
        return LocalDate.now();
    }

    // ================================
    // GET CREATE BOOKING PAGE
    // ================================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "create_booking");

        LocalDate minCheckIn = getMinCheckInDate();
        LocalDate maxCheckIn = LocalDate.now().plusMonths(3); // ---> THÊM MỚI: Tối đa 3 tháng

        Date checkIn = parseSqlDateOrNull(req.getParameter("checkIn"));
        Date checkOut = parseSqlDateOrNull(req.getParameter("checkOut"));

        // Kiểm tra mốc Check-in min và max
        if (checkIn == null || checkIn.toLocalDate().isBefore(minCheckIn)) {
            checkIn = Date.valueOf(minCheckIn);
        } else if (checkIn.toLocalDate().isAfter(maxCheckIn)) { // ---> THÊM MỚI
            checkIn = Date.valueOf(maxCheckIn);
        }

        if (checkOut == null) {
            checkOut = Date.valueOf(checkIn.toLocalDate().plusDays(1));
        }

        if (!checkIn.before(checkOut)) {
            checkOut = Date.valueOf(checkIn.toLocalDate().plusDays(1));
        }

        // ---> THÊM ĐOẠN NÀY: Tự động ép về 30 ngày nếu chọn quá <---
        if (java.time.temporal.ChronoUnit.DAYS.between(checkIn.toLocalDate(), checkOut.toLocalDate()) > 30) {
            checkOut = Date.valueOf(checkIn.toLocalDate().plusDays(30));
        }

        Integer roomsParam = parseIntOrNull(req.getParameter("rooms"));
        Integer adultsParam = parseIntOrNull(req.getParameter("adults"));
        Integer childrenParam = parseIntOrNull(req.getParameter("children"));
        Integer roomTypeId = parseIntOrNull(req.getParameter("roomTypeId"));

        int rooms = clamp(roomsParam == null ? 1 : roomsParam, 1, 10);
        int adults = clamp(adultsParam == null ? 1 : adultsParam, 1, 20);
        int children = clamp(childrenParam == null ? 0 : childrenParam, 0, 20);

        try {
            dao.expireHolds();
        } catch (Exception e) {
            System.out.println("Lỗi khi dọn dẹp hold hết hạn: " + e.getMessage());
        }

        List<RoomTypeCard> cards = dao.getRoomTypeCards(checkIn, checkOut, rooms);

        RoomTypeCard selected = null;

        if (roomTypeId != null) {
            for (RoomTypeCard c : cards) {
                if (c.getRoomTypeId() == roomTypeId) {
                    selected = c;
                    break;
                }
            }
        }

        if (selected == null && !cards.isEmpty()) {
            selected = cards.get(0);
        }

        long nights = dao.calcNights(checkIn.toLocalDate(),checkOut.toLocalDate());

        long rate = selected != null ? selected.getRatePerNight() : 0;

        long total = rate * nights * rooms;

        req.setAttribute("minCheckInDate", minCheckIn.toString());
        req.setAttribute("maxCheckInDate", maxCheckIn.toString()); // ---> THÊM MỚI

        req.setAttribute("checkIn", checkIn);
        req.setAttribute("checkOut", checkOut);
        req.setAttribute("rooms", rooms);
        req.setAttribute("adults", adults);
        req.setAttribute("children", children);

        req.setAttribute("cards", cards);

        req.setAttribute("roomTypeId", selected != null ? selected.getRoomTypeId() : null);

        req.setAttribute("roomTypeName", selected != null ? selected.getRoomTypeName() : "");

        req.setAttribute("availableRooms",selected != null ? selected.getAvailableRooms() : 0);

        req.setAttribute("nights", nights);
        req.setAttribute("rate", rate);
        req.setAttribute("total", total);

        req.getRequestDispatcher("/view/receptionist/create_booking.jsp").forward(req, resp);
    }

    // ================================
    // CREATE HOLD
    // ================================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp
    ) throws ServletException, IOException {

        req.setAttribute("active", "create_booking");

        HttpSession session = req.getSession(false);

        User loggedInUser
                = (session == null) ? null : (User) session.getAttribute("userAccount");

        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = loggedInUser.getUserId();

        Date checkIn = parseSqlDateOrNull(req.getParameter("checkIn"));
        Date checkOut = parseSqlDateOrNull(req.getParameter("checkOut"));

        Integer roomsRaw = parseIntOrNull(req.getParameter("rooms"));
        Integer roomTypeId = parseIntOrNull(req.getParameter("roomTypeId"));

        LocalDate minCheckIn = getMinCheckInDate();
        LocalDate maxCheckIn = LocalDate.now().plusMonths(3); // ---> THÊM MỚI: Tối đa 3 tháng


        if (checkIn == null) {
            checkIn = Date.valueOf(minCheckIn);
        }

        if (checkIn.toLocalDate().isBefore(minCheckIn)) {
            req.setAttribute(
                    "errors",
                    java.util.List.of("Ngày Check-in không hợp lệ (không được chọn ngày trong quá khứ).")
            );
            doGet(req, resp);
            return;
        }
        
        // ---> THÊM MỚI: Chặn lỗi nếu vượt quá 3 tháng
        if (checkIn.toLocalDate().isAfter(maxCheckIn)) {
            req.setAttribute("errors", java.util.List.of("Chỉ được đặt phòng trước tối đa 3 tháng."));
            doGet(req, resp);
            return;
        }

        if (checkOut == null) {
            checkOut = Date.valueOf(checkIn.toLocalDate().plusDays(1));
        }

        if (!checkIn.before(checkOut)) {
            checkOut = Date.valueOf(checkIn.toLocalDate().plusDays(1));
        }

        // ---> THÊM ĐOẠN NÀY: Quăng lỗi nếu cố tình truyền tham số > 30 ngày <---
        if (java.time.temporal.ChronoUnit.DAYS.between(checkIn.toLocalDate(), checkOut.toLocalDate()) > 30) {
            req.setAttribute("errors", java.util.List.of("Số ngày đặt phòng tối đa không được vượt quá 30 ngày!"));
            doGet(req, resp);
            return;
        }

        int rooms = clamp(roomsRaw == null ? 1 : roomsRaw, 1, 10);

        if (roomTypeId == null) {

            req.setAttribute(
                    "errors",
                    java.util.List.of("Please select a room type.")
            );

            doGet(req, resp);
            return;
        }

        try {
            dao.expireHolds();
        } catch (Exception e) {
            System.out.println("Lỗi khi dọn dẹp hold hết hạn: " + e.getMessage());
        }

        try {

            int holdId = dao.createHold(
                    userId, roomTypeId, checkIn, checkOut, rooms,15);

            resp.sendRedirect(
                    req.getContextPath() + "/receptionist/booking/customer?holdId=" + holdId);

        } catch (Exception ex) {

            req.setAttribute(
                    "errors",
                    java.util.List.of( "Not enough rooms available for the selected dates.")
            );
            doGet(req, resp);
        }
    }
}
