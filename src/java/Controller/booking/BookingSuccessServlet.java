package controller.booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="BookingSuccessServlet", urlPatterns={"/booking/success"})
public class BookingSuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
    throws ServletException, IOException {

        String holdIdRaw = req.getParameter("holdId");
        if (holdIdRaw == null || holdIdRaw.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/booking");
            return;
        }

        int holdId;
        try { holdId = Integer.parseInt(holdIdRaw); }
        catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/booking");
            return;
        }

        // ✅ Lấy dữ liệu từ session (demo theo flow bạn đang dùng)
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/booking");
            return;
        }

        // Email: lấy từ user login nếu bạn có, demo thì lấy từ session/param
        Object acc = session.getAttribute("account"); // nếu bạn lưu user trong session
        String email = (String) session.getAttribute("email"); // demo
        if (email == null) email = "guest@email.com";

        // Room name: lấy từ session hold hoặc set demo
        String roomName = "Standard Twin Room - No View";

        // Check-in: lấy từ hold session
        String checkIn = (String) session.getAttribute("HOLD_" + holdId + "_checkIn");
        if (checkIn == null) checkIn = "2026-03-08";

        // Booking code: demo (sau này lấy từ DB)
        String bookingCode = "AGD-2026-" + String.format("%04d", holdId);

        req.setAttribute("bookingCode", bookingCode);
        req.setAttribute("email", email);
        req.setAttribute("roomName", roomName);
        req.setAttribute("checkIn", checkIn);

        req.getRequestDispatcher("/view/booking/success.jsp").forward(req, resp);
    }
}