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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CustomerDashboardServlet", urlPatterns = {"/customer/dashboard"})
public class CustomerDashboardServlet extends HttpServlet {

    private final CustomerProfileDAO profileDAO = new CustomerProfileDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    private int parsePage(String pageParam) {
        try {
            int page = Integer.parseInt(pageParam);
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

    private List<String> buildPageTokens(int currentPage, int totalPages) {
        List<String> tokens = new ArrayList<>();
        if (totalPages <= 1) {
            return tokens;
        }

        if (totalPages <= 3) {
            for (int i = 1; i <= totalPages; i++) {
                tokens.add(String.valueOf(i));
            }
            return tokens;
        }

        if (currentPage <= 2) {
            tokens.add("1");
            tokens.add("2");
            tokens.add("...");
            tokens.add(String.valueOf(totalPages));
            return tokens;
        }

        if (currentPage >= totalPages - 1) {
            tokens.add("1");
            tokens.add("...");
            tokens.add(String.valueOf(totalPages - 1));
            tokens.add(String.valueOf(totalPages));
            return tokens;
        }

        tokens.add(String.valueOf(currentPage - 1));
        tokens.add(String.valueOf(currentPage));
        tokens.add("...");
        tokens.add(String.valueOf(totalPages));
        return tokens;
    }

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
        if (tab == null || tab.isBlank()) {
            tab = "current";
        }

        // ===== Resolve customerId =====
        Integer customerId = null;
        if (profile != null && profile.getCustomerId() > 0) {
            customerId = profile.getCustomerId();
        } else {
            customerId = bookingDAO.getCustomerIdByUserId(userId);
        }

        String contentPage;
        final int pageSize = parsePageSize(request.getParameter("pageSize"));
        request.setAttribute("pageSize", pageSize);

        switch (tab) {
            case "current" -> {
                contentPage = "/view/customer/current_bookings.jsp";

                if (customerId != null) {
                    int currentPage = parsePage(request.getParameter("currentPage"));
                    int totalItems = bookingDAO.countCurrentBookingsByCustomerId(customerId);
                    int totalPages = (int) Math.ceil((double) totalItems / pageSize);

                    if (totalPages <= 0) {
                        totalPages = 0;
                        currentPage = 1;
                    } else if (currentPage > totalPages) {
                        currentPage = totalPages;
                    }

                    List<BookingCardView> currentBookings
                            = bookingDAO.getCurrentBookingsByCustomerIdPaging(customerId, currentPage, pageSize);

                    request.setAttribute("currentBookings", currentBookings);
                    request.setAttribute("currentPage", currentPage);
                    request.setAttribute("totalPages", totalPages);
                    request.setAttribute("currentPageTokens", buildPageTokens(currentPage, totalPages));
                }
            }

            case "past" -> {
                contentPage = "/view/customer/past_stays.jsp";

                if (customerId != null) {
                    int pastPage = parsePage(request.getParameter("pastPage"));
                    int totalItems = bookingDAO.countPastStaysByCustomerId(customerId);
                    int totalPages = (int) Math.ceil((double) totalItems / pageSize);

                    if (totalPages <= 0) {
                        totalPages = 0;
                        pastPage = 1;
                    } else if (pastPage > totalPages) {
                        pastPage = totalPages;
                    }

                    List<BookingCardView> pastStays
                            = bookingDAO.getPastStaysByCustomerIdPaging(customerId, pastPage, pageSize);

                    request.setAttribute("pastStays", pastStays);
                    request.setAttribute("pastCurrentPage", pastPage);
                    request.setAttribute("pastTotalPages", totalPages);
                    request.setAttribute("pastPageTokens", buildPageTokens(pastPage, totalPages));
                }
            }

            case "viewProfile" ->
                contentPage = "/view/customer/view_profile.jsp";
            case "editProfile" ->
                contentPage = "/view/customer/edit_profile.jsp";
            case "changePassword" ->
                contentPage = "/view/customer/change_password.jsp";

            default -> {
                tab = "current";
                contentPage = "/view/customer/current_bookings.jsp";

                if (customerId != null) {
                    int currentPage = parsePage(request.getParameter("currentPage"));
                    int totalItems = bookingDAO.countCurrentBookingsByCustomerId(customerId);
                    int totalPages = (int) Math.ceil((double) totalItems / pageSize);

                    if (totalPages <= 0) {
                        totalPages = 0;
                        currentPage = 1;
                    } else if (currentPage > totalPages) {
                        currentPage = totalPages;
                    }

                    List<BookingCardView> currentBookings
                            = bookingDAO.getCurrentBookingsByCustomerIdPaging(customerId, currentPage, pageSize);

                    request.setAttribute("currentBookings", currentBookings);
                    request.setAttribute("currentPage", currentPage);
                    request.setAttribute("totalPages", totalPages);
                    request.setAttribute("currentPageTokens", buildPageTokens(currentPage, totalPages));
                }
            }
        }

        request.setAttribute("activeTab", tab);
        request.setAttribute("contentPage", contentPage);
        request.getRequestDispatcher("/view/customer/dashboard.jsp").forward(request, response);
    }
}
