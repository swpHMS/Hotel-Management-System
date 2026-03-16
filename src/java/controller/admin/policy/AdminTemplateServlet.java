package controller.admin.policy;

import dal.AdminTemplateDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.EmailTemplate;

@WebServlet(name = "AdminTemplateServlet", urlPatterns = {"/admin/templates"})
public class AdminTemplateServlet extends HttpServlet {

    private int parseIntOrDefault(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private String normalizeCode(String code) {
        if (code == null) {
            return "";
        }
        return code.trim()
                .replaceAll("\\s+", "_")
                .toUpperCase();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AdminTemplateDAO dao = new AdminTemplateDAO();
        List<EmailTemplate> templates = dao.getAll();

        int id = parseIntOrDefault(request.getParameter("id"), -1);

        EmailTemplate selected = null;
        if (id > 0) {
            selected = dao.getById(id);
        }

        if (selected == null && !templates.isEmpty()) {
            selected = templates.get(0);
            id = selected.getTemplateId();
        }

        request.setAttribute("templates", templates);
        request.setAttribute("selectedTemplate", selected);
        request.setAttribute("selectedId", id);
        request.setAttribute("active", "system_config");

        request.getRequestDispatcher("/view/admin/template_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        AdminTemplateDAO dao = new AdminTemplateDAO();
        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            action = "updateTemplate";
        }

        switch (action) {
            case "addTemplate": {
                String newCode = normalizeCode(request.getParameter("newTemplateCode"));

                if (!newCode.isEmpty() && !dao.existsByCode(newCode)) {
                    EmailTemplate t = new EmailTemplate();
                    t.setCode(newCode);
                    t.setSubject("");
                    t.setContent("");
                    t.setActive(true);

                    int newId = dao.insert(t);
                    if (newId > 0) {
                        response.sendRedirect(request.getContextPath() + "/admin/templates?id=" + newId + "&created=1");
                        return;
                    }
                }

                response.sendRedirect(request.getContextPath() + "/admin/templates?error=duplicate");
                return;
            }

            case "renameTemplate": {
                int templateId = parseIntOrDefault(request.getParameter("templateId"), -1);
                String renameValue = normalizeCode(request.getParameter("renameValue"));

                if (templateId > 0 && !renameValue.isEmpty() && !dao.existsByCodeExceptId(renameValue, templateId)) {
                    dao.renameTemplate(templateId, renameValue);
                    response.sendRedirect(request.getContextPath() + "/admin/templates?id=" + templateId + "&renamed=1");
                    return;
                }

                response.sendRedirect(request.getContextPath() + "/admin/templates?id=" + templateId + "&error=duplicate");
                return;
            }

            case "deleteTemplate": {
                int templateId = parseIntOrDefault(request.getParameter("templateId"), -1);

                if (templateId > 0) {
                    dao.delete(templateId);
                }

                List<EmailTemplate> templates = dao.getAll();
                if (!templates.isEmpty()) {
                    int nextId = templates.get(0).getTemplateId();
                    response.sendRedirect(request.getContextPath() + "/admin/templates?id=" + nextId + "&deleted=1");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/templates?deleted=1");
                }
                return;
            }

            case "updateTemplate":
            default: {
                int id = parseIntOrDefault(request.getParameter("templateId"), -1);
                String subject = request.getParameter("subject");
                String content = request.getParameter("content");
                boolean isActive = "1".equals(request.getParameter("isActive"))
                        || "on".equals(request.getParameter("isActive"));

                if (id > 0) {
                    EmailTemplate old = dao.getById(id);
                    if (old != null) {
                        EmailTemplate t = new EmailTemplate();
                        t.setTemplateId(id);
                        t.setCode(old.getCode());
                        t.setSubject(subject == null ? "" : subject.trim());
                        t.setContent(content == null ? "" : content.trim());
                        t.setActive(isActive);

                        dao.update(t);
                    }
                }

                response.sendRedirect(request.getContextPath() + "/admin/templates?id=" + id + "&saved=1");
                return;
            }
        }
    }
}