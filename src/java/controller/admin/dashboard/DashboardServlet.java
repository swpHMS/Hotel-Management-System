package controller.admin.dashboard;

import dal.AdminDashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/admin/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    try {
        AdminDashboardDAO dao = new AdminDashboardDAO();

        int totalUsers = dao.countUsers();
        int activeUsers = dao.countUsersByStatus(1);
        int inactiveUsers = dao.countUsersByStatus(0);

        int totalCustomers = dao.countCustomers();

        int totalAccounts = totalUsers + totalCustomers;
        int activeAccounts = activeUsers; // customers không có status
        int engagement = totalAccounts == 0 ? 0 : (int)Math.round(activeAccounts * 100.0 / totalAccounts);

        request.setAttribute("active", "dashboard"); // highlight menu
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("activeUsers", activeUsers);
        request.setAttribute("inactiveUsers", inactiveUsers);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("engagement", engagement);

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
