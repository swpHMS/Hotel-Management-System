package controller.customer;

import dal.ProfileDAO;
import model.ProfileView;
import utils.AuthUtils;
import utils.NameUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/customer/profile"})
public class ProfileServlet extends HttpServlet {

    private final ProfileDAO profileDAO = new ProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = AuthUtils.getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ProfileView profile = profileDAO.getCustomerProfileByUserId(userId);
        request.setAttribute("profile", profile);

        String initials = (profile != null) ? NameUtils.initials(profile.getFullName()) : "U";
        request.setAttribute("initials", initials);

        request.getRequestDispatcher("/view/customer/profile.jsp").forward(request, response);
    }
}
