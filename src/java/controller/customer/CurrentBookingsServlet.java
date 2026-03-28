package controller.customer;

import dal.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;

@WebServlet(name = "CurrentBookingsServlet", urlPatterns = {"/customer/bookings/current"})
public class CurrentBookingsServlet extends HttpServlet {

    private final CustomerPageSupport pageSupport = new CustomerPageSupport();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = pageSupport.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        pageSupport.prepareCurrentBookings(request, userId);
        pageSupport.forwardLayout(request, response);
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

        int pageSize = CustomerPageSupport.normalizePageSize(request.getParameter("pageSize"));
        int page = CustomerPageSupport.normalizePage(request.getParameter("page"));

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
