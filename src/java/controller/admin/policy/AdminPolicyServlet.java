package controller.admin.policy;

import dal.Admin_PolicyRuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import model.PolicyRule;

@WebServlet(name = "AdminPolicyServlet", urlPatterns = {"/admin/policies"})
public class AdminPolicyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Admin_PolicyRuleDAO dao = new Admin_PolicyRuleDAO();
        List<PolicyRule> policies = dao.getAllPolicies();

        if (policies == null || policies.isEmpty()) {
            request.setAttribute("policies", policies);
            request.setAttribute("activeKey", "");
            request.setAttribute("selectedPolicy", null);
            request.setAttribute("active", "system_config");
            request.getRequestDispatcher("/view/admin/policy_list.jsp").forward(request, response);
            return;
        }

        String key = request.getParameter("key");
        if (key == null || key.isBlank()) {
            key = policies.get(0).getName();
        }

        PolicyRule selected = dao.getByName(key);
        if (selected == null) {
            selected = policies.get(0);
            key = selected.getName();
        }

        request.setAttribute("policies", policies);
        request.setAttribute("activeKey", key);
        request.setAttribute("selectedPolicy", selected);
        request.setAttribute("active", "system_config");

        request.getRequestDispatcher("/view/admin/policy_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        Admin_PolicyRuleDAO dao = new Admin_PolicyRuleDAO();

        String action = request.getParameter("action");
        if (action == null) action = "saveContent";

        switch (action) {
            case "addPolicy": {
                String newName = request.getParameter("newPolicyName");
                if (newName == null) newName = "";
                newName = newName.trim();

                if (!newName.isEmpty() && !dao.existsByName(newName)) {
                    dao.insertPolicy(newName, "");
                    response.sendRedirect(request.getContextPath() + "/admin/policies?key="
                            + URLEncoder.encode(newName, StandardCharsets.UTF_8));
                    return;
                }

                response.sendRedirect(request.getContextPath() + "/admin/policies?error=add");
                return;
            }

            case "renamePolicy": {
                int policyId = parseInt(request.getParameter("policyId"));
                String newName = request.getParameter("renameValue");
                if (newName == null) newName = "";
                newName = newName.trim();

                if (policyId > 0 && !newName.isEmpty() && !dao.existsByName(newName)) {
                    dao.updateName(policyId, newName);
                    response.sendRedirect(request.getContextPath() + "/admin/policies?key="
                            + URLEncoder.encode(newName, StandardCharsets.UTF_8) + "&renamed=1");
                    return;
                }

                PolicyRule p = dao.getById(policyId);
                String fallbackKey = (p != null) ? p.getName() : "";
                response.sendRedirect(request.getContextPath() + "/admin/policies?key="
                        + URLEncoder.encode(fallbackKey, StandardCharsets.UTF_8) + "&error=rename");
                return;
            }

            case "deletePolicy": {
                int policyId = parseInt(request.getParameter("policyId"));
                dao.deletePolicy(policyId);

                List<PolicyRule> remain = dao.getAllPolicies();
                if (remain != null && !remain.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/admin/policies?key="
                            + URLEncoder.encode(remain.get(0).getName(), StandardCharsets.UTF_8) + "&deleted=1");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/policies?deleted=1");
                }
                return;
            }

            default: {
                int policyId = parseInt(request.getParameter("policyId"));
                String key = request.getParameter("key");
                String content = request.getParameter("content");

                if (content == null) content = "";
                if (key == null) key = "";

                dao.updateContent(policyId, content.trim());

                response.sendRedirect(request.getContextPath() + "/admin/policies?key="
                        + URLEncoder.encode(key, StandardCharsets.UTF_8) + "&saved=1");
            }
        }
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return 0;
        }
    }
}