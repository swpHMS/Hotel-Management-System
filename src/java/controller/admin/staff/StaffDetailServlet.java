package controller.admin.staff;

import dal.AdminUserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.UserProfile;

@WebServlet(name = "StaffDetailServlet", urlPatterns = {"/admin/staff/detail"})
public class StaffDetailServlet extends HttpServlet {

    private int parseIntOrDefault(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = parseIntOrDefault(request.getParameter("id"), -1);
        if (userId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/staff");
            return;
        }

        AdminUserDAO dao = new AdminUserDAO();

        try {
            UserProfile user = dao.getStaffByUserId(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/staff");
                return;
            }

            request.setAttribute("active", "staff_list");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/view/admin/staff_detail.jsp").forward(request, response);

        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
