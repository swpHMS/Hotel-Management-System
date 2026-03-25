package controller.customer;

import dal.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import model.User;

@WebServlet(urlPatterns = {"/current_bookings", "/customer/bookings/current/cancel"})
public class CurrentBookingsServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    private int parsePage(String raw) {
        try {
            int page = Integer.parseInt(raw);
            return Math.max(page, 1);
        } catch (Exception e) {
            return 1;
        }
    }

    private int parsePageSize(String raw) {
        try {
            int size = Integer.parseInt(raw);
            if (size == 2 || size == 5 || size == 10) {
                return size;
            }
        } catch (Exception e) {
        }
        return 2;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/customer/bookings/current");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("userAccount");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer customerId = bookingDAO.getCustomerIdByUserId(user.getUserId());

        int pageSize = parsePageSize(request.getParameter("pageSize"));
        int page = parsePage(request.getParameter("page"));

        if (customerId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/customer/bookings/current?currentPage=" + page + "&pageSize=" + pageSize
            );
            return;
        }

        String bookingIdParam = request.getParameter("bookingId");

        if (bookingIdParam != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdParam);

                boolean success = bookingDAO.cancelBooking(bookingId, customerId);

                if (success) {
                    request.getSession().setAttribute("successMessage",
                            "Booking cancelled successfully.");
                } else {
                    request.getSession().setAttribute("errorMessage",
                            "Cannot cancel this booking.");
                }

            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage",
                        "Invalid booking ID.");
            }
        }

        response.sendRedirect(
                request.getContextPath() + "/customer/bookings/current?currentPage=" + page + "&pageSize=" + pageSize
        );
    }
}
