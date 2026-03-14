package controller.receptionist.booking;

import dal.ReceptBookingListDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(
        name = "ReceptionistBookingListServlet",
        urlPatterns = {"/receptionist/bookings"}
)
public class ReceptionistBookingListServlet extends HttpServlet {

    private int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private Date parseDate(String s) {
        try {
            if (s == null || s.trim().isEmpty()) {
                return null;
            }
            return Date.valueOf(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        req.setAttribute("active", "booking_list");

        int page = parseInt(req.getParameter("page"), 1);
        int size = parseInt(req.getParameter("size"), 10);

        if (page < 1) {
            page = 1;
        }

        if (size != 5 && size != 10 && size != 20 && size != 50) {
            size = 10;
        }

        String keyword = req.getParameter("keyword");
        String statusRaw = req.getParameter("status");
        String checkInDateRaw = req.getParameter("checkInDate");
        String checkOutDateRaw = req.getParameter("checkOutDate");

        Integer status = null;
        if (statusRaw != null && !statusRaw.trim().isEmpty()) {
            try {
                status = Integer.parseInt(statusRaw.trim());
            } catch (Exception e) {
                status = null;
            }
        }

        Date checkInDate = parseDate(checkInDateRaw);
        Date checkOutDate = parseDate(checkOutDateRaw);

        ReceptBookingListDAO dao = new ReceptBookingListDAO();

        try {
            // ---> THÊM DÒNG NÀY ĐỂ HỆ THỐNG TỰ ĐỘNG CHỐT NO-SHOW & NHẢ PHÒNG TRƯỚC KHI HIỂN THỊ <---
            dao.updateNoShowBookings();
            
            int total = dao.countBookingsFiltered(
                    keyword,
                    status,
                    checkInDate,
                    checkOutDate
            );

            int totalPages = (int) Math.ceil(total * 1.0 / size);

            if (totalPages < 1) {
                totalPages = 1;
            }

            if (page > totalPages) {
                page = totalPages;
            }

            List<model.BookingSummary> list = dao.getBookingListPagingFiltered(
                    keyword,
                    status,
                    checkInDate,
                    checkOutDate,
                    page,
                    size
            );

            req.setAttribute("bookings", list);
            req.setAttribute("page", page);
            req.setAttribute("size", size);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("total", total);

            req.setAttribute("keyword", keyword);
            req.setAttribute("status", statusRaw);
            req.setAttribute("checkInDate", checkInDateRaw);
            req.setAttribute("checkOutDate", checkOutDateRaw);

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("/view/receptionist/booking_list.jsp")
           .forward(req, resp);
    }
}