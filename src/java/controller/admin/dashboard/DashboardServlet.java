package controller.admin.dashboard;

import dal.AdminDashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/admin/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            AdminDashboardDAO dao = new AdminDashboardDAO();

            int totalCustomers = dao.countCustomers();
            int totalStaff = dao.countStaff();
            int totalRoles = dao.countRoles();

            Map<String, Integer> roleDistribution = dao.getRoleDistribution();
            Map<String, Integer> customerStatus = dao.countCustomerStatus();
            Map<String, Integer> staffStatus = dao.countStaffStatus();

            request.setAttribute("staffActive", staffStatus.get("active"));
            request.setAttribute("staffInactive", staffStatus.get("inactive"));

            request.setAttribute("customerActive", customerStatus.get("active"));
            request.setAttribute("customerInactive", customerStatus.get("inactive"));

            request.setAttribute("active", "dashboard");
            request.setAttribute("staffTotal", totalStaff);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("totalRoles", totalRoles);

            Map<String, Integer> statusCounts = dao.getUserStatusCounts();
            request.setAttribute("statusCounts", statusCounts);
            request.setAttribute("roleDistribution", roleDistribution);
            request.getRequestDispatcher("/view/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("active", "dashboard");
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/view/admin/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
