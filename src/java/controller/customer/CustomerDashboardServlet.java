package controller.customer;

import dal.ProfileDAO;
import model.ProfileView;
import utils.AuthUtils;
import utils.NameUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "CustomerDashboardServlet", urlPatterns = {"/customer/dashboard"})
public class CustomerDashboardServlet extends HttpServlet {

    private final ProfileDAO profileDAO = new ProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = AuthUtils.getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 1) Load profile chung
        ProfileView profile = profileDAO.getCustomerProfileByUserId(userId);
        request.setAttribute("profile", profile);

        String initials = (profile != null) ? NameUtils.initials(profile.getFullName()) : "U";
        request.setAttribute("initials", initials);

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

            // sticky form (editProfile) giữ nguyên như bạn đang làm
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

        // 3) Tab routing
        String tab = request.getParameter("tab");
        if (tab == null || tab.isBlank()) {
            tab = "current";
        }

        String contentPage;
        switch (tab) {
            case "viewProfile":
                contentPage = "/view/customer/view_profile.jsp";
                break;
            case "past":
                contentPage = "/view/customer/past.jsp";
                break;
            case "editProfile":
                contentPage = "/view/customer/edit_profile.jsp";
                break;
            case "changePassword":
                contentPage = "/view/customer/change_password.jsp";
                break;
            case "current":
            default:
                tab = "current";
                contentPage = "/view/customer/current.jsp";
                break;
        }

        request.setAttribute("activeTab", tab);
        request.setAttribute("contentPage", contentPage);

        request.getRequestDispatcher("/view/customer/dashboard.jsp").forward(request, response);
    }
}
