package controller.customer;

import dal.CustomerDAO;
import model.CustomerProfile;
import utils.AuthUtils;
import utils.NameUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "CustomerDashboardServlet", urlPatterns = {"/customer/dashboard"})
public class CustomerDashboardServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = AuthUtils.getUserId(request);

        // Sau này login xong sẽ set SESSION_USER_ID => không cần sửa code này
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CustomerProfile profile = customerDAO.getProfileByUserId(userId);
        request.setAttribute("profile", profile);

        String initials = (profile != null) ? NameUtils.initials(profile.getFullName()) : "U";
        request.setAttribute("initials", initials);

        request.getRequestDispatcher("/view/customer/dashboard.jsp").forward(request, response);
    }
}
