package controller.customer;

import dal.BookingDAO;
import dal.CustomerProfileDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.BookingCardView;
import model.ProfileView;
import utils.AuthUtils;
import utils.NameUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

final class CustomerPageSupport {

    static final String PAGE_CURRENT = "current";
    static final String PAGE_PAST = "past";
    static final String PAGE_VIEW_PROFILE = "viewProfile";
    static final String PAGE_EDIT_PROFILE = "editProfile";
    static final String PAGE_CHANGE_PASSWORD = "changePassword";

    private final CustomerProfileDAO profileDAO = new CustomerProfileDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    Integer requireUserId(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer userId = AuthUtils.getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return userId;
    }

    void prepareBaseData(HttpServletRequest request, Integer userId) {
        ProfileView profile = profileDAO.getCustomerProfileByUserId(userId);
        request.setAttribute("profile", profile);
        request.setAttribute("initials", profile != null ? NameUtils.initials(profile.getFullName()) : "U");

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
            request.setAttribute("form_identity", session.getAttribute("form_identity"));
            request.setAttribute("form_phone", session.getAttribute("form_phone"));
            request.setAttribute("form_address", session.getAttribute("form_address"));

            session.removeAttribute("form_fullName");
            session.removeAttribute("form_gender");
            session.removeAttribute("form_dob");
            session.removeAttribute("form_identity");
            session.removeAttribute("form_phone");
            session.removeAttribute("form_address");
        }
    }

    void prepareCurrentBookings(HttpServletRequest request, Integer userId) {
        prepareBaseData(request, userId);

        Integer customerId = resolveCustomerId((ProfileView) request.getAttribute("profile"), userId);
        int pageSize = parsePageSize(request.getParameter("pageSize"));
        request.setAttribute("pageSize", pageSize);

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

        setPageAttributes(
                request,
                PAGE_CURRENT,
                "Current Bookings",
                "/view/customer/current_bookings.jsp",
                Arrays.asList("current-bookings.css")
        );
    }

    void preparePastStays(HttpServletRequest request, Integer userId) {
        prepareBaseData(request, userId);

        Integer customerId = resolveCustomerId((ProfileView) request.getAttribute("profile"), userId);
        int pageSize = parsePageSize(request.getParameter("pageSize"));
        request.setAttribute("pageSize", pageSize);

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

        setPageAttributes(
                request,
                PAGE_PAST,
                "Past Stays",
                "/view/customer/past_stays.jsp",
                Arrays.asList("past-stays.css")
        );
    }

    void prepareViewProfile(HttpServletRequest request, Integer userId) {
        prepareBaseData(request, userId);
        setPageAttributes(
                request,
                PAGE_VIEW_PROFILE,
                "View Profile",
                "/view/customer/view_profile.jsp",
                Arrays.asList("pages.css")
        );
    }

    void prepareEditProfile(HttpServletRequest request, Integer userId) {
        prepareBaseData(request, userId);
        setPageAttributes(
                request,
                PAGE_EDIT_PROFILE,
                "Edit Profile",
                "/view/customer/edit_profile.jsp",
                Arrays.asList("pages.css")
        );
    }

    void prepareChangePassword(HttpServletRequest request, Integer userId) {
        prepareBaseData(request, userId);
        setPageAttributes(
                request,
                PAGE_CHANGE_PASSWORD,
                "Change Password",
                "/view/customer/change_password.jsp",
                Arrays.asList("change-password.css")
        );
    }

    void forwardLayout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/view/customer/layout.jsp").forward(request, response);
    }

    private void setPageAttributes(
            HttpServletRequest request,
            String activeTab,
            String pageTitle,
            String contentPage,
            List<String> pageStyles) {
        request.setAttribute("activeTab", activeTab);
        request.setAttribute("pageTitle", pageTitle);
        request.setAttribute("contentPage", contentPage);
        request.setAttribute("pageStyles", pageStyles != null ? pageStyles : Collections.emptyList());
    }

    private Integer resolveCustomerId(ProfileView profile, Integer userId) {
        if (profile != null && profile.getCustomerId() > 0) {
            return profile.getCustomerId();
        }
        return bookingDAO.getCustomerIdByUserId(userId);
    }

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
}
