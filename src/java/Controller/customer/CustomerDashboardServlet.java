package controller.customer;

import dal.BookingDAO;
import dal.CustomerProfileDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.BookingCardView;
import model.ProfileView;
import utils.AuthUtils;
import utils.NameUtils;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerDashboardServlet", urlPatterns = {"/customer/dashboard"})
public class CustomerDashboardServlet extends HttpServlet {

    private final CustomerProfileDAO profileDAO = new CustomerProfileDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = AuthUtils.getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ===== Load profile =====
        ProfileView profile = profileDAO.getCustomerProfileByUserId(userId);
        request.setAttribute("profile", profile);

        String initials = (profile != null) ? NameUtils.initials(profile.getFullName()) : "U";
        request.setAttribute("initials", initials);

        // ===== Flash + sticky form =====
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object flashError = session.getAttribute("flash_error");
            Object flashSuccess = session.getAttribute("flash_success");

            if (flashError != null) {
                request.setAttribute("flash_error", flashError);
                session.removeAttribute("flash_error");
            }
            if (flashSuccess != null) {
                request.setAttribute("flash_success", flashSuccess);
                session.removeAttribute("flash_success");
            }

            request.setAttribute("form_fullName", session.getAttribute("form_fullName"));
            request.setAttribute("form_gender", session.getAttribute("form_gender"));
            request.setAttribute("form_dob", session.getAttribute("form_dob"));
            request.setAttribute("form_phone", session.getAttribute("form_phone"));
            request.setAttribute("form_address", session.getAttribute("form_address"));
            session.removeAttribute("form_fullName");
            session.removeAttribute("form_gender");
            session.removeAttribute("form_dob");
            session.removeAttribute("form_phone");
            session.removeAttribute("form_address");
        }

        // ===== Tab =====
        String tab = request.getParameter("tab");
        if (tab == null || tab.isBlank()) tab = "current";

        // ===== Resolve customerId (robust) =====
        Integer customerId = null;

        // ưu tiên lấy từ profile nếu hợp lệ
        if (profile != null && profile.getCustomerId() > 0) {
            customerId = profile.getCustomerId();
        } else {
            // fallback: query thẳng theo user_id
            customerId = bookingDAO.getCustomerIdByUserId(userId);
        }

        // ===== Load data for each tab + pick content page =====
        String contentPage;
        switch (tab) {
            case "current" -> {
                contentPage = "/view/customer/current_bookings.jsp";
                if (customerId != null) {
                    List<BookingCardView> currentBookings =
                            bookingDAO.getCurrentBookingsByCustomerId(customerId);
                    request.setAttribute("currentBookings", currentBookings);
                }
            }
            case "past" -> {
                contentPage = "/view/customer/past_stays.jsp";
                if (customerId != null) {
                    List<BookingCardView> pastStays =
                            bookingDAO.getPastStaysByCustomerId(customerId);
                    request.setAttribute("pastStays", pastStays);
                }
            }
            case "viewProfile" -> contentPage = "/view/customer/view_profile.jsp";
            case "editProfile" -> contentPage = "/view/customer/edit_profile.jsp";
            case "changePassword" -> contentPage = "/view/customer/change_password.jsp";
            default -> {
                tab = "current";
                contentPage = "/view/customer/current_bookings.jsp";
                if (customerId != null) {
                    List<BookingCardView> currentBookings =
                            bookingDAO.getCurrentBookingsByCustomerId(customerId);
                    request.setAttribute("currentBookings", currentBookings);
                }
            }
        }

        request.setAttribute("activeTab", tab);
        request.setAttribute("contentPage", contentPage);
        request.getRequestDispatcher("/view/customer/dashboard.jsp").forward(request, response);
    }
}
