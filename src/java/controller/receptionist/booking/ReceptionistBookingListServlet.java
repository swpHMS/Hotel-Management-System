package controller.receptionist.booking;

import dal.ReceptBookingListDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name="ReceptionistBookingListServlet", urlPatterns={"/receptionist/bookings"})
public class ReceptionistBookingListServlet extends HttpServlet {

    private int parseInt(String s, int def){
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "booking_list");

        // ✅ Read pagination params
        int page = parseInt(req.getParameter("page"), 1);
        int size = parseInt(req.getParameter("size"), 10);

        // ✅ validate
        if (page < 1) page = 1;
        if (size != 5 && size != 10 && size != 20 && size != 50) size = 10;

        ReceptBookingListDAO dao = new ReceptBookingListDAO();
        try {
            int total = dao.countBookings();
            int totalPages = (int) Math.ceil(total * 1.0 / size);
            if (totalPages < 1) totalPages = 1;
            if (page > totalPages) page = totalPages;

            List<model.BookingSummary> list = dao.getBookingListPaging(page, size);

            req.setAttribute("bookings", list);
            req.setAttribute("page", page);
            req.setAttribute("size", size);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("total", total);

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("/view/receptionist/booking_list.jsp").forward(req, resp);
    }
}