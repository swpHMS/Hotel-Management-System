package controller.admin.staff;

import dal.AdminUserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import model.Role;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "StaffCreateServlet", urlPatterns = {"/admin/staff/create"})
public class StaffCreateServlet extends HttpServlet {

    private int parseIntOrDefault(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AdminUserDAO dao = new AdminUserDAO();
        try {
            List<Role> roles = dao.getAllNonCustomerRoles();
            request.setAttribute("active", "staff_create");
            request.setAttribute("roles", roles);
            request.getRequestDispatcher("/view/admin/staff_create.jsp").forward(request, response);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        int roleId = parseIntOrDefault(request.getParameter("roleId"), -1);
        int status = parseIntOrDefault(request.getParameter("status"), 1);

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        int gender = parseIntOrDefault(request.getParameter("gender"), 1);
        String dobRaw = request.getParameter("dob");
        String identityNumber = request.getParameter("identityNumber");
        String address = request.getParameter("address");

        AdminUserDAO dao = new AdminUserDAO();

        try {
            // roles luôn cần để render lại form khi lỗi
            request.setAttribute("roles", dao.getAllNonCustomerRoles());
            request.setAttribute("active", "staff_create");

            // validate cơ bản
            if (email == null || email.isBlank() || password == null || password.length() < 6
                    || roleId <= 0
                    || fullName == null || fullName.isBlank()
                    || phone == null || phone.isBlank()
                    || identityNumber == null || identityNumber.isBlank()
                    || dobRaw == null || dobRaw.isBlank()) {

                request.setAttribute("error", "Please fill all required fields correctly.");
                request.getRequestDispatcher("/view/admin/staff_create.jsp").forward(request, response);
                return;
            }

            Date dob = Date.valueOf(dobRaw);

            // hash password
            String hash = BCrypt.hashpw(password, BCrypt.gensalt(10));

            int newUserId = dao.createStaffAccount(
                    email.trim(),
                    hash,
                    roleId,
                    (status == 0 ? 0 : 1),
                    fullName.trim(),
                    gender,
                    dob,
                    identityNumber.trim(),
                    phone.trim(),
                    address
            );

            // redirect qua detail cho giống flow hệ thống
            response.sendRedirect(request.getContextPath() + "/admin/staff/detail?id=" + newUserId);

        } catch (java.sql.SQLException sqlEx) {
            // lỗi trùng UNIQUE (email hoặc identity_number nếu bạn set unique)
            String msg = sqlEx.getMessage();
            if (msg != null && (msg.contains("2627") || msg.contains("2601"))) {
                request.setAttribute("error", "Duplicate data: email or identity number already exists.");
                request.getRequestDispatcher("/view/admin/staff_create.jsp").forward(request, response);
            } else {
                throw new ServletException(sqlEx);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
