package controller.receptionist.booking;

import dal.ReceptBookingListDAO;
import model.BookingSummary;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="ReceptionistBookingDetailServlet", urlPatterns={"/receptionist/booking/detail"})
public class ReceptionistBookingDetailServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Giữ active sidebar ở mục booking_list
        req.setAttribute("active", "booking_list"); 
        
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            ReceptBookingListDAO dao = new ReceptBookingListDAO();
            BookingSummary booking = dao.getBookingById(id);
            
            if (booking != null) {
                req.setAttribute("booking", booking);
                req.getRequestDispatcher("/view/receptionist/booking_detail.jsp").forward(req, resp);
            } else {
                // Nếu không tìm thấy, quay về danh sách và báo lỗi
                req.getSession().setAttribute("errorMsg", "Không tìm thấy thông tin Booking!");
                resp.sendRedirect(req.getContextPath() + "/receptionist/bookings");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/receptionist/bookings");
        }
    }
}