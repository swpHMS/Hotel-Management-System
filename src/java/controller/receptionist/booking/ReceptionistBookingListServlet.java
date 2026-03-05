package controller.receptionist.booking;

import dal.ReceptBookingListDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

// Map đúng với đường dẫn trong sidebar
@WebServlet(name="ReceptionistBookingListServlet", urlPatterns={"/receptionist/bookings"})
public class ReceptionistBookingListServlet extends HttpServlet {
    
     @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "booking_list");
        
        // GỌI TỚI FILE DAO MỚI TẠO
        ReceptBookingListDAO dao = new ReceptBookingListDAO();
        try {
            List<model.BookingSummary> list = dao.getBookingList();
            req.setAttribute("bookings", list);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        req.getRequestDispatcher("/view/receptionist/booking_list.jsp").forward(req, resp);
    }
}