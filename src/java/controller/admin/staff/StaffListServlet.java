package controller.admin.staff;

import dal.AdminUserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Role;
import model.UserProfile;

@WebServlet(name = "StaffListServlet", urlPatterns = {"/admin/staff"})
public class StaffListServlet extends HttpServlet {

    private int parseIntOrDefault(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        final int pageSize = 10;

        int page = parseIntOrDefault(request.getParameter("page"), 1);
        if (page < 1) page = 1;

        // roleId: all | number
        String roleIdRaw = request.getParameter("roleId");
        Integer roleId = null;
        if (roleIdRaw != null && !roleIdRaw.equalsIgnoreCase("all") && !roleIdRaw.isBlank()) {
            roleId = parseIntOrDefault(roleIdRaw, -1);
            if (roleId <= 0) roleId = null;
        }

        // status: all | 1 | 0
        String statusRaw = request.getParameter("status");
        Integer status = null;
        if (statusRaw != null && !statusRaw.equalsIgnoreCase("all") && !statusRaw.isBlank()) {
            int st = parseIntOrDefault(statusRaw, -1);
            if (st == 0 || st == 1) status = st;
        }

        AdminUserDAO dao = new AdminUserDAO();

        try {
            // 1) roles for dropdown
            List<Role> roles = dao.getAllStaffRoles();

            // 2) total for pagination (WITH FILTER)
            int totalUsers = dao.countStaff(roleId, status);
            int totalPages = (int) Math.ceil(totalUsers * 1.0 / pageSize);
            if (totalPages < 1) totalPages = 1;
            if (page > totalPages) page = totalPages;

            // 3) list (WITH FILTER + PAGING)
            List<UserProfile> users = dao.getStaffList(roleId, status, page, pageSize);

            // 4) attributes
            request.setAttribute("active", "staff_list");
            request.setAttribute("roles", roles);
            request.setAttribute("users", users);

            request.setAttribute("page", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalPages", totalPages);

            request.setAttribute("selectedRoleId", roleIdRaw == null ? "all" : roleIdRaw);
            request.setAttribute("selectedStatus", statusRaw == null ? "all" : statusRaw);

            request.getRequestDispatcher("/view/admin/staff_list.jsp").forward(request, response);

        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
