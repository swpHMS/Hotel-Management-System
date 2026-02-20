package controller.admin.policy;
import dal.AdminTemplateDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;
import model.EmailTemplate;
/**
 *
 * @author DieuBHHE191686
 */
@WebServlet(name="AdminTemplateServlet", urlPatterns={"/admin/templates"})
public class AdminTemplateServlet extends HttpServlet {

    private int parseIntOrDefault(String s, int def){
        try { return Integer.parseInt(s); } catch(Exception e){ return def; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AdminTemplateDAO dao = new AdminTemplateDAO();
        List<EmailTemplate> templates = dao.getAll();

        int id = parseIntOrDefault(request.getParameter("id"), -1);

        EmailTemplate selected = null;
        if (id > 0) selected = dao.getById(id);

        // default chọn template đầu tiên
        if (selected == null && !templates.isEmpty()) {
            selected = templates.get(0);
            id = selected.getTemplateId();
        }

        request.setAttribute("templates", templates);
        request.setAttribute("selectedTemplate", selected);
        request.setAttribute("selectedId", id);

        // highlight sidebar admin (nếu bạn dùng)
        request.setAttribute("active", "system_config");

        request.getRequestDispatcher("/view/admin/template_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int id = parseIntOrDefault(request.getParameter("templateId"), -1);
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        boolean isActive = "1".equals(request.getParameter("isActive")) || "on".equals(request.getParameter("isActive"));

        if (id > 0) {
            EmailTemplate t = new EmailTemplate();
            t.setTemplateId(id);
            t.setSubject(subject == null ? "" : subject.trim());
            t.setContent(content == null ? "" : content.trim());
            t.setActive(isActive);

            new AdminTemplateDAO().update(t);
        }

        response.sendRedirect(request.getContextPath() + "/admin/templates?id=" + id + "&saved=1");
    }
}