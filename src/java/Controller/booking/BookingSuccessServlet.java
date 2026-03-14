package controller.booking;

import dal.AdminTemplateDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;
import model.BookingEmailDTO;
import utils.EmailExecutor;
import utils.EmailUtils;

@WebServlet(name = "BookingSuccessServlet", urlPatterns = {"/booking/success"})
public class BookingSuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("=== BookingSuccessServlet doGet CALLED ===");

        String holdIdRaw = req.getParameter("holdId");
        System.out.println("[DEBUG] holdIdRaw = " + holdIdRaw);

        if (holdIdRaw == null || holdIdRaw.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/booking");
            return;
        }

        int holdId;
        try {
            holdId = Integer.parseInt(holdIdRaw);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/booking");
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/booking");
            return;
        }

        AdminTemplateDAO dao = new AdminTemplateDAO();
        BookingEmailDTO bookingData = dao.getEmailDataByHoldId(holdId);

        if (bookingData == null) {
            System.err.println("[ERROR] Khong tim thay du lieu cho holdId = " + holdId);
            resp.getWriter().print("Loi: Khong tim thay thong tin dat phong trong Database.");
            return;
        }

        String email = (String) session.getAttribute("HOLD_" + holdId + "_email");

        if (email == null || email.isBlank()) {
            email = bookingData.getEmail();
        }

        if (email == null || email.isBlank()) {
            Object u = session.getAttribute("user");
            if (u == null) {
                u = session.getAttribute("account");
            }
            if (u instanceof model.User) {
                email = ((model.User) u).getEmail();
            }
        }

        if (email == null || email.isBlank()) {
            email = "minhducypbn@gmail.com";
        }

        bookingData.setEmail(email);

        System.out.println("[DEBUG] bookingData map = " + bookingData.toMap());
        System.out.println("[DEBUG] recipientEmail = " + email);

        String sentFlag = "BOOKING_MAIL_SENT_" + holdId;
        Boolean alreadySent = (Boolean) session.getAttribute(sentFlag);

        if (alreadySent == null || !alreadySent) {
            session.setAttribute(sentFlag, true);

            final String finalEmail = email;
            final int finalHoldId = holdId;
            final Map<String, String> mailData = bookingData.toMap();

            EmailExecutor.submit(() -> {
                try {
                    EmailUtils.sendBookingEmail(finalEmail, "BOOKING_CONFIRM", mailData);
                    System.out.println("[INFO] Da gui email cho holdId = " + finalHoldId);
                } catch (Exception e) {
                    System.err.println("[ERROR] Loi gui email async tai BookingSuccessServlet: " + e.getMessage());
                    e.printStackTrace();
                }
            });
        } else {
            System.out.println("[INFO] Email da gui truoc do cho holdId = " + holdId);
        }

        req.setAttribute("data", bookingData);
        req.setAttribute("email", email);

        req.setAttribute("holdId", holdId);
        req.setAttribute("bookingCode", "#BK-" + bookingData.getBookingId());
        req.setAttribute("customerEmail", email);
        req.setAttribute("roomName", bookingData.getRoomName());
        req.setAttribute("checkInDate", bookingData.getCheckInDate());
        req.setAttribute("checkIn", bookingData.getCheckInDate());
        req.setAttribute("checkOutDate", bookingData.getCheckOutDate());
        req.setAttribute("amount", bookingData.getDepositAmount());
        req.setAttribute("totalAmount", bookingData.getTotalAmount());
        req.setAttribute("depositAmount", bookingData.getDepositAmount());

        req.getRequestDispatcher("/view/booking/success.jsp").forward(req, resp);
    }
}