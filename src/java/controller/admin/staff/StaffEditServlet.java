package controller.admin.staff;

import dal.AdminUserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Role;
import model.UserProfile;

@WebServlet(name = "StaffEditServlet", urlPatterns = {"/admin/staff/edit"})
public class StaffEditServlet extends HttpServlet {

    private int parseIntOrDefault(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
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

            List<Role> roles = dao.getAllNonCustomerRoles();

            request.setAttribute("active", "staff_list");
            request.setAttribute("user", user);
            request.setAttribute("roles", roles);

            request.getRequestDispatcher("/view/admin/staff_edit.jsp").forward(request, response);

        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int userId = parseIntOrDefault(request.getParameter("id"), -1);
        int roleId = parseIntOrDefault(request.getParameter("roleId"), -1);
        int status = parseIntOrDefault(request.getParameter("status"), -1);

        if (userId <= 0 || roleId <= 0 || !(status == 0 || status == 1)) {
            response.sendRedirect(request.getContextPath() + "/admin/staff");
            return;
        }

        AdminUserDAO dao = new AdminUserDAO();

        try {
            // đảm bảo userId là staff (không phải CUSTOMER)
            UserProfile user = dao.getStaffByUserId(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/staff");
                return;
            }

            dao.updateUserRoleStatus(userId, roleId, status);
            response.sendRedirect(request.getContextPath() + "/admin/staff");
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
