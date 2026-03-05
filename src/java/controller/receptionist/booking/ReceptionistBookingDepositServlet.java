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

        // 1. Lấy phương thức thanh toán
        String method = req.getParameter("method"); 
        if (method == null || method.isBlank()) method = "CASH";

        // 2. LẤY THÔNG TIN KHÁCH TỪ SESSION (Tuyệt đối không dùng req.getParameter nữa)
        HttpSession session = req.getSession();
        String fullName = (String) session.getAttribute("cus_fullName");
        String phone    = (String) session.getAttribute("cus_phone");
        String email    = (String) session.getAttribute("cus_email");
        String identity = (String) session.getAttribute("cus_identity");
        String address  = (String) session.getAttribute("cus_address");

        try {
            // 3. Chốt Booking
            int bookingId = dao.finalizeBookingFromHold(
                holdId, fullName, phone, email, identity, address, 0.5, method, "SUCCESS"
            );

            // 4. Tạo thông báo Popup màu xanh
            session.setAttribute("successMsg", "Tạo Booking #" + bookingId + " thành công!");

            // 5. Dọn dẹp Session
            session.removeAttribute("cus_fullName");
            session.removeAttribute("cus_phone");
            session.removeAttribute("cus_email");
            session.removeAttribute("cus_identity");
            session.removeAttribute("cus_address");

            // 6. CHUYỂN HƯỚNG VỀ TRANG BOOKING LIST
            resp.sendRedirect(req.getContextPath() + "/receptionist/bookings");
            return;

        } catch (Exception ex) {
            req.setAttribute("errors", java.util.List.of("Payment/confirm failed: " + ex.getMessage()));
            doGet(req, resp);
        }
    }
}