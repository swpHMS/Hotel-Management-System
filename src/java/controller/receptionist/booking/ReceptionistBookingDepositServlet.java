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

            long deposit = Math.round(s.total * 0.5); // 50%

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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "create_booking");

        Integer holdId = parseIntOrNull(req.getParameter("holdId"));
        if (holdId == null) {
            resp.sendRedirect(req.getContextPath() + "/receptionist/booking/create");
            return;
        }

        // Payment method from UI
        String method = req.getParameter("method"); // CASH / QR
        if (method == null || method.isBlank()) method = "CASH";

        // Customer info (bạn có thể truyền từ step2 sang deposit bằng hidden, hoặc load lại từ session)
        // Tạm: lấy từ request param hidden (bạn sẽ add hidden trong step2 form redirect sang deposit)
        String fullName = req.getParameter("fullName");
        String phone    = req.getParameter("phone");
        String email    = req.getParameter("email");
        String identity = req.getParameter("identity");
        String address  = req.getParameter("address");

        try {
            // ✅ Demo: giả lập thanh toán luôn SUCCESS
            int bookingId = dao.finalizeBookingFromHold(
                    holdId,
                    fullName, phone, email, identity, address,
                    0.5,
                    method,
                    "SUCCESS"
            );

            // done -> qua trang success/chi tiết booking
            resp.sendRedirect(req.getContextPath() + "/receptionist/booking/success?bookingId=" + bookingId);

        } catch (Exception ex) {
            req.setAttribute("errors", java.util.List.of("Payment/confirm failed: " + ex.getMessage()));
            doGet(req, resp);
        }
    }
}