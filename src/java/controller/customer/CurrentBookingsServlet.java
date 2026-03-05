package controller.customer;

import dal.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import model.BookingCardView;
import model.User;

@WebServlet("/current_bookings")
public class CurrentBookingsServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("userAccount");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<BookingCardView> bookingList = Collections.emptyList();

        Integer customerId = bookingDAO.getCustomerIdByUserId(user.getUserId());

        if (customerId != null) {
            bookingList = bookingDAO.getCurrentBookingsByCustomerId(customerId);
        }

        request.setAttribute("currentBookings", bookingList);
        request.getRequestDispatcher("/view/customer/current_bookings.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== CANCEL SERVLET HIT ===");

        User user = (User) request.getSession().getAttribute("userAccount");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer customerId = bookingDAO.getCustomerIdByUserId(user.getUserId());

        if (customerId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/customer/dashboard?tab=current"
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
                request.getContextPath() + "/customer/dashboard?tab=current"
        );
    }
}
