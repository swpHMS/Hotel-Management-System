package controller.admin.policy;

import dal.Admin_PolicyRuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;
import model.PolicyRule;

/**
 *
 * @author DieuBHHE191686
 */
@WebServlet(name = "AdminPolicyServlet", urlPatterns = {"/admin/policies"})
public class AdminPolicyServlet extends HttpServlet {

    private Map<String, String> sidebarMap() {
        Map<String, String> m = new LinkedHashMap<>();
        m.put("BOOKING", "Booking and Reservation");
        m.put("PAYMENT", "Payment and Fees");
        m.put("CANCELLATION", "Cancellation and Refund");
        m.put("RESPONSIBILITY", "Guest Responsibilities");
        m.put("LIABILITY", "Limitation of Liability");
        return m;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String key = request.getParameter("key");
        if (key == null || key.isBlank()) key = "BOOKING";

        Admin_PolicyRuleDAO dao = new Admin_PolicyRuleDAO();
        PolicyRule selected = dao.getByName(key);
        
        if (selected == null) {
            key = "BOOKING";
            selected = dao.getByName(key);
        }

        request.setAttribute("sidebarMap", sidebarMap());
        request.setAttribute("activeKey", key);
        request.setAttribute("selectedPolicy", selected);
        request.setAttribute("active", "system_config");

        request.getRequestDispatcher("/view/admin/policy_list.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String key = request.getParameter("key");
        if (key == null || key.isBlank()) key = "BOOKING";

        int policyId = 0;
        try { policyId = Integer.parseInt(request.getParameter("policyId")); } catch (Exception ignored) {}

        String content = request.getParameter("content");
        if (content == null) content = "";

        Admin_PolicyRuleDAO dao = new Admin_PolicyRuleDAO();
        dao.updateContent(policyId, content.trim());

        response.sendRedirect(request.getContextPath() + "/admin/policies?key=" + key + "&saved=1");
    }
}