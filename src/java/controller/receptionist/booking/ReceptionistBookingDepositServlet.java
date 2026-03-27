package controller.receptionist.booking;

import dal.ReceptBookingDAO;
import model.HoldSummary;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="ReceptionistBookingDepositServlet", urlPatterns={"/receptionist/booking/deposit"})
public class ReceptionistBookingDepositServlet extends HttpServlet {

    private final ReceptBookingDAO dao = new ReceptBookingDAO();

    private Integer parseIntOrNull(String s) {
        try { return (s==null||s.trim().isEmpty()) ? null : Integer.parseInt(s.trim()); }
        catch (Exception e) { return null; }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "create_booking");

        Integer holdId = parseIntOrNull(req.getParameter("holdId"));
        if (holdId == null) {
            resp.sendRedirect(req.getContextPath() + "/receptionist/booking/create");
            return;
        }

        try {
            HoldSummary s = dao.getHoldSummary(holdId);
            if (s == null) {
                resp.sendRedirect(req.getContextPath() + "/receptionist/booking/create");
                return;
            }

            long deposit =  Math.round(s.total * 0.5); // 50%

            req.setAttribute("holdId", s.holdId);
            req.setAttribute("roomTypeName", s.roomTypeName);
            req.setAttribute("checkIn", s.checkIn);
            req.setAttribute("checkOut", s.checkOut);
            req.setAttribute("rooms", s.qty);
            req.setAttribute("nights", s.nights);
            req.setAttribute("rate", s.ratePerNight);
            req.setAttribute("total", s.total);
            req.setAttribute("deposit", deposit);

            req.getRequestDispatcher("/view/receptionist/deposit_payment.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

    req.setAttribute("active", "create_booking");

    Integer holdId = parseIntOrNull(req.getParameter("holdId"));

    // ===== CHỐT CHẶN 1: phải có holdId =====
    if (holdId == null) {
        resp.sendRedirect(req.getContextPath() + "/receptionist/booking/create");
        return;
    }

    // ===== Lấy phương thức thanh toán =====
    String method = req.getParameter("method");
    if (method == null || method.isBlank()) {
        method = "CASH";
    }

    HttpSession session = req.getSession();

    // ===== Lấy thông tin khách từ session =====
    String fullName = (String) session.getAttribute("cus_fullName");
    String phone    = (String) session.getAttribute("cus_phone");
    String identity = (String) session.getAttribute("cus_identity");
    String address  = (String) session.getAttribute("cus_address");

    // ===== CHỐT CHẶN 2: phải có thông tin khách =====
    if (fullName == null || phone == null || identity == null || address == null) {
    session.setAttribute("errorMsg", "Customer information is missing. Please re-enter customer details.");
    resp.sendRedirect(req.getContextPath() + "/receptionist/booking/customer?holdId=" + holdId);
    return;
}

    try {

        HoldSummary s = dao.getHoldSummary(holdId);

        // ===== CHỐT CHẶN 3: hold phải tồn tại =====
        if (s == null) {

            session.setAttribute(
                    "errorMsg",
                    "Hold not found. Please create a new booking."
            );

            resp.sendRedirect(
                    req.getContextPath()
                    + "/receptionist/booking/create"
            );

            return;
        }

        // ===== CHỐT CHẶN 4: hold phải còn ACTIVE =====
        if (s.status != ReceptBookingDAO.HOLD_ACTIVE) {

            session.setAttribute(
                    "errorMsg",
                    "This hold is no longer active. Please create a new booking."
            );

            resp.sendRedirect(
                    req.getContextPath()
                    + "/receptionist/booking/create"
            );

            return;
        }

        // ===== FINALIZE BOOKING =====
        int bookingId = dao.finalizeBookingFromHold(
                holdId,
                fullName,
                phone,
                null,
                identity,
                address,
                0.5,
                method,
                "SUCCESS"
        );

        // ===== Thông báo thành công =====
        session.setAttribute(
                "successMsg",
                "Tạo Booking #" + bookingId + " thành công!"
        );

        // ===== Dọn session =====
        session.removeAttribute("cus_fullName");
        session.removeAttribute("cus_phone");
        session.removeAttribute("cus_email");
        session.removeAttribute("cus_identity");
        session.removeAttribute("cus_address");

        // ===== Redirect về booking list =====
        resp.sendRedirect(
                req.getContextPath()
                + "/receptionist/bookings"
        );

    } catch (Exception ex) {

        req.setAttribute(
                "errors",
                java.util.List.of(
                        "Payment/confirm failed: " + ex.getMessage()
                )
        );

        doGet(req, resp);
    }
}
}