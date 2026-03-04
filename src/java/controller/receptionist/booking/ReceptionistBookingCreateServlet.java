package controller.receptionist.booking;


import dal.ReceptBookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import model.RoomTypeCard;
import dal.ReceptAvailabilityHoldDAO;

@WebServlet(name = "ReceptionistBookingCreateServlet", urlPatterns = {"/receptionist/booking/create"})
public class ReceptionistBookingCreateServlet extends HttpServlet {

    private final ReceptBookingDAO dao = new ReceptBookingDAO();

    private Integer parseIntOrNull(String s) {
        try {
            if (s == null || s.trim().isEmpty()) return null;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Date parseSqlDateOrNull(String s) {
        try {
            if (s == null || s.trim().isEmpty()) return null;
            return Date.valueOf(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private int clamp(int n, int min, int max) {
        return Math.max(min, Math.min(max, n));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "create_booking");

        // ===== defaults =====
        LocalDate today = LocalDate.now();
        Date checkIn = parseSqlDateOrNull(req.getParameter("checkIn"));
        Date checkOut = parseSqlDateOrNull(req.getParameter("checkOut"));

        if (checkIn == null) checkIn = Date.valueOf(today.plusDays(1));
        if (checkOut == null) checkOut = Date.valueOf(today.plusDays(2));

        // fix invalid range
        if (!checkIn.before(checkOut)) {
            checkOut = Date.valueOf(checkIn.toLocalDate().plusDays(1));
            req.setAttribute("warn", "Check-out date was adjusted to be after check-in.");
        }

        Integer rooms = parseIntOrNull(req.getParameter("rooms"));
        Integer adults = parseIntOrNull(req.getParameter("adults"));
        Integer children = parseIntOrNull(req.getParameter("children"));
        Integer roomTypeId = parseIntOrNull(req.getParameter("roomTypeId"));

        int roomsVal = clamp(rooms == null ? 1 : rooms, 1, 10);
        int adultsVal = clamp(adults == null ? 1 : adults, 1, 20);
        int childrenVal = clamp(children == null ? 0 : children, 0, 20);

        // ===== load cards (inventory-based availability) =====
        List<RoomTypeCard> cards = dao.getRoomTypeCards(checkIn, checkOut, roomsVal);

        // ===== pick selected (prefer param roomTypeId) =====
        RoomTypeCard selected = null;
        if (roomTypeId != null) {
            for (RoomTypeCard c : cards) {
                if (c.getRoomTypeId() == roomTypeId.intValue()) {
                    selected = c;
                    break;
                }
            }
        }
        if (selected == null && !cards.isEmpty()) selected = cards.get(0);

        long nights = dao.calcNights(checkIn.toLocalDate(), checkOut.toLocalDate());
        long rate = (selected != null) ? selected.getRatePerNight() : 0;
        long total = rate * nights * roomsVal;

        // ===== set attributes =====
        req.setAttribute("checkIn", checkIn);
        req.setAttribute("checkOut", checkOut);

        req.setAttribute("rooms", roomsVal);
        req.setAttribute("adults", adultsVal);
        req.setAttribute("children", childrenVal);

        req.setAttribute("cards", cards);

        req.setAttribute("roomTypeId", selected != null ? selected.getRoomTypeId() : null);
        req.setAttribute("roomTypeName", selected != null ? selected.getRoomTypeName() : "");
        req.setAttribute("availableRooms", selected != null ? selected.getAvailableRooms() : 0);

        req.setAttribute("nights", nights);
        req.setAttribute("rate", rate);
        req.setAttribute("total", total);

        // forward Step 1
        req.getRequestDispatcher("/view/receptionist/create_booking.jsp").forward(req, resp);
    }

    @Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String action = req.getParameter("action");
    if (!"holdAndNext".equals(action)) {
        resp.sendRedirect(req.getContextPath() + "/receptionist/booking/create");
        return;
    }

    Date checkIn = parseSqlDateOrNull(req.getParameter("checkIn"));
    Date checkOut = parseSqlDateOrNull(req.getParameter("checkOut"));
    Integer rooms = parseIntOrNull(req.getParameter("rooms"));
    Integer roomTypeId = parseIntOrNull(req.getParameter("roomTypeId"));

    int roomsVal = (rooms == null || rooms < 1) ? 1 : rooms;
    if (roomTypeId == null) {
        req.setAttribute("err", "Please select room type.");
        doGet(req, resp);
        return;
    }

    // (khuyến nghị) expire trước khi tạo hold
    ReceptAvailabilityHoldDAO holdDao = new ReceptAvailabilityHoldDAO();

    try {
        // userId: nếu receptionist đang login thì lấy từ session
        // tạm thời set 0 nếu không có
        int userId = 0;

        int holdId = holdDao.createHold(userId, roomTypeId, roomsVal, checkIn, checkOut, 15);

        // lưu holdId vào session để step2 lấy
        HttpSession session = req.getSession(true);
        session.setAttribute("HOLD_ID", holdId);

        resp.sendRedirect(req.getContextPath()
            + "/receptionist/booking/customer?holdId=" + holdId);

    } catch (Exception ex) {
        req.setAttribute("err", ex.getMessage()); // "Not enough rooms..."
        doGet(req, resp);
    }
}
}