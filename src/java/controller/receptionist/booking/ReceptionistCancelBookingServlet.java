package controller.receptionist.booking;

import dal.ReceptBookingListDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="ReceptionistCancelBookingServlet", urlPatterns={"/receptionist/booking/cancel"})
public class ReceptionistCancelBookingServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(req.getParameter("id"));
            ReceptBookingListDAO dao = new ReceptBookingListDAO();
            
            boolean success = dao.cancelBooking(bookingId);
            
            HttpSession session = req.getSession();
            if (success) {
                session.setAttribute("successMsg", "Đã hủy thành công Booking #" + bookingId + " và hoàn trả phòng về kho!");
            } else {
                session.setAttribute("errorMsg", "Không thể hủy Booking #" + bookingId + " (Đơn không tồn tại hoặc đã thay đổi trạng thái).");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Trở về trang danh sách
        resp.sendRedirect(req.getContextPath() + "/receptionist/bookings");
    }
}