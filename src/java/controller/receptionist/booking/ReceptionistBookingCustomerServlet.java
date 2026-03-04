package controller.receptionist.booking;

import dal.ReceptBookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import model.RoomTypeCard;
import utils.Validation;

@WebServlet(name = "ReceptionistBookingCustomerServlet", urlPatterns = {"/receptionist/booking/customer"})
public class ReceptionistBookingCustomerServlet extends HttpServlet {

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
            return Date.valueOf(s.trim()); // yyyy-MM-dd
        } catch (Exception e) {
            return null;
        }
    }

    private int clamp(int n, int min, int max) {
        return Math.max(min, Math.min(max, n));
    }

    /** Build right summary for Step 2 (and re-show form when errors) */
    private void buildSummary(HttpServletRequest req,
                              Date checkIn, Date checkOut,
                              int roomsVal,
                              Integer roomTypeId) {

        // Load cards to compute selected summary
        List<RoomTypeCard> cards = dao.getRoomTypeCards(checkIn, checkOut, roomsVal);

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

        // Put data for JSP
        req.setAttribute("checkIn", checkIn);
        req.setAttribute("checkOut", checkOut);
        req.setAttribute("rooms", roomsVal);

        req.setAttribute("roomTypeId", selected != null ? selected.getRoomTypeId() : null);
        req.setAttribute("roomTypeName", selected != null ? selected.getRoomTypeName() : "");
        req.setAttribute("availableRooms", selected != null ? selected.getAvailableRooms() : 0);

        req.setAttribute("nights", nights);
        req.setAttribute("rate", rate);
        req.setAttribute("total", total);
    }

    /** Normalize stay data (default + fix invalid ranges) */
    private Date[] normalizeStay(HttpServletRequest req) {
        LocalDate today = LocalDate.now();
        Date checkIn = parseSqlDateOrNull(req.getParameter("checkIn"));
        Date checkOut = parseSqlDateOrNull(req.getParameter("checkOut"));

        if (checkIn == null) checkIn = Date.valueOf(today.plusDays(1));
        if (checkOut == null) checkOut = Date.valueOf(today.plusDays(2));

        if (!checkIn.before(checkOut)) {
            checkOut = Date.valueOf(checkIn.toLocalDate().plusDays(1));
            req.setAttribute("warn", "Check-out date was adjusted to be after check-in.");
        }
        return new Date[]{checkIn, checkOut};
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "create_booking");

        Date[] stay = normalizeStay(req);
        Date checkIn = stay[0];
        Date checkOut = stay[1];

        Integer rooms = parseIntOrNull(req.getParameter("rooms"));
        Integer roomTypeId = parseIntOrNull(req.getParameter("roomTypeId"));

        int roomsVal = clamp(rooms == null ? 1 : rooms, 1, 10);

        buildSummary(req, checkIn, checkOut, roomsVal, roomTypeId);

        req.getRequestDispatcher("/view/receptionist/customer_info.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "create_booking");

        // ===== stay =====
        Date[] stay = normalizeStay(req);
        Date checkIn = stay[0];
        Date checkOut = stay[1];

        Integer rooms = parseIntOrNull(req.getParameter("rooms"));
        Integer roomTypeId = parseIntOrNull(req.getParameter("roomTypeId"));
        int roomsVal = clamp(rooms == null ? 1 : rooms, 1, 10);

        // ===== customer normalize =====
        String fullName = Validation.trimToNull(req.getParameter("fullName"));
        String phone    = Validation.trimToNull(req.getParameter("phone"));
        String email    = Validation.trimToNull(req.getParameter("email"));
        String identity = Validation.trimToNull(req.getParameter("identity"));
        String address  = Validation.trimToNull(req.getParameter("address"));

        // ===== validate =====
        List<String> errors = new ArrayList<>();

        if (roomTypeId == null) {
            errors.add("Please select a room type.");
        }

        if (fullName == null) {
            errors.add("Full Name is required.");
        } else if (!Validation.isValidFullNameNoNumber(fullName)) {
            errors.add("Full Name is invalid (no numbers, only letters/spaces).");
        }

        if (phone == null) {
            errors.add("Phone is required.");
        } else if (!Validation.isPhoneVN(phone)) {
            errors.add("Phone must start with 0 and have 10–11 digits. (VN format, e.g. 0xxxxxxxxx).");
        }

        if (email != null && !Validation.isEmail(email)) {
            errors.add("Email is invalid.");
        }

        if (identity != null && !Validation.isCCCD(identity)) {
            errors.add("Identity/CCCD must be exactly 12 digits.");
        }

        if (address == null) {
            errors.add("Address is required.");
        } else if (!Validation.minLen(address, 5)) {
            errors.add("Address is too short.");
        }

        // ===== If errors: build summary + forward (NO doGet call) =====
        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);

            // keep user input in requestScope
            req.setAttribute("fullName", fullName);
            req.setAttribute("phone", phone);
            req.setAttribute("email", email);
            req.setAttribute("identity", identity);
            req.setAttribute("address", address);

            // keep stay info for hidden fields / back link
            req.setAttribute("checkIn", checkIn);
            req.setAttribute("checkOut", checkOut);
            req.setAttribute("rooms", roomsVal);
            req.setAttribute("roomTypeId", roomTypeId);

            // rebuild right summary
            buildSummary(req, checkIn, checkOut, roomsVal, roomTypeId);

            req.getRequestDispatcher("/view/receptionist/customer_info.jsp").forward(req, resp);
            return;
        }

        // ===== (Optional) hold inventory here =====
        // try { dao.holdInventory(roomTypeId, checkIn, checkOut, roomsVal); }
        // catch (Exception ex) { ... forward with errors ... }

        // TODO: insert customer + booking (PENDING_DEPOSIT) in 1 transaction
        resp.sendRedirect(req.getContextPath() + "/receptionist/booking/deposit");
    }
}