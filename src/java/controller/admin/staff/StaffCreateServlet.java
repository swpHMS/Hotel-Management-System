package controller.admin.staff;

import dal.AdminUserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Role;
import org.mindrot.jbcrypt.BCrypt;
import utils.Validation;

@WebServlet(name = "StaffCreateServlet", urlPatterns = {"/admin/staff/create"})
public class StaffCreateServlet extends HttpServlet {

    private int parseIntOrDefault(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private void forwardWithForm(HttpServletRequest request, HttpServletResponse response,
            AdminUserDAO dao,
            Map<String, String> errors,
            Map<String, String> oldValues)
            throws Exception {

        List<Role> roles = dao.getAllNonCustomerRoles();

        request.setAttribute("active", "staff_create");
        request.setAttribute("roles", roles);

        request.setAttribute("errors", errors);
        for (Map.Entry<String, String> e : oldValues.entrySet()) {
            request.setAttribute(e.getKey(), e.getValue());
        }

        request.getRequestDispatcher("/view/admin/staff_create.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AdminUserDAO dao = new AdminUserDAO();
        try {
            request.setAttribute("active", "staff_create");
            request.setAttribute("roles", dao.getAllNonCustomerRoles());
            request.getRequestDispatcher("/view/admin/staff_create.jsp").forward(request, response);
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ===== 1) Read params =====
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String roleIdRaw = request.getParameter("roleId");
        int status = 1;//khi tạo luôn là active
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String genderRaw = request.getParameter("gender");
        String dobRaw = request.getParameter("dob");
        String identityNumber = request.getParameter("identityNumber");

        // hỗ trợ 2 tên param
        String address = request.getParameter("address");
        if (address == null) {
            address = request.getParameter("residenceAddress");
        }

        // ===== 2) Prepare =====
        Map<String, String> errors = new LinkedHashMap<>();
        Map<String, String> old = new LinkedHashMap<>();

        // giữ lại dữ liệu để render lại
        old.put("email", email == null ? "" : email);
        old.put("roleId", roleIdRaw == null ? "" : roleIdRaw);
        old.put("status", "1");

        old.put("fullName", fullName == null ? "" : fullName);
        old.put("phone", phone == null ? "" : phone);
        old.put("gender", genderRaw == null ? "1" : genderRaw);
        old.put("dob", dobRaw == null ? "" : dobRaw);
        old.put("identityNumber", identityNumber == null ? "" : identityNumber);
        old.put("address", address == null ? "" : address);

        AdminUserDAO dao = new AdminUserDAO();

        try {
            // ===== 3) Validate =====

            // Email
            if (isBlank(email)) {
                errors.put("email", "Email is required.");
            } else {
                email = email.trim();
                String emailRegex = "^[\\w.%+-]+@[\\w.-]+\\.[A-Za-z]{2,}$";
                if (!email.matches(emailRegex)) {
                    errors.put("email", "Invalid email format.");
                }
            }

            // Password
            if (isBlank(password)) {
                errors.put("password", "Password is required.");
            } else if (password.length() < 6) {
                errors.put("password", "Password must be at least 6 characters.");
            }
            if (isBlank(confirmPassword)) {
                errors.put("confirmPassword", "Confirm password is required.");
            } else if (!confirmPassword.equals(password)) {
                errors.put("confirmPassword", "Confirm password does not match.");
            }

            // Role
            int roleId = parseIntOrDefault(roleIdRaw, -1);
            if (roleId <= 0) {
                errors.put("roleId", "Role is required.");
            }

            // Full name
            if (isBlank(fullName)) {
                errors.put("fullName", "Full name is required.");
            } else {
                fullName = fullName.trim().replaceAll("\\s+", " "); // gom nhiều space thành 1

                // Không được có số (và có thể chặn ký tự lạ)
                if (fullName.matches(".*\\d.*")) {
                    errors.put("fullName", "Full name must not contain numbers.");
                } // (Tuỳ chọn) chỉ cho chữ + khoảng trắng (hỗ trợ tiếng Việt)
                else if (!fullName.matches("^[\\p{L} ]+$")) {
                    errors.put("fullName", "Full name only allows letters and spaces.");
                }
            }

            // Phone 
            if (isBlank(phone)) {
                errors.put("phone", "Phone is required.");
            } else {
                phone = phone.trim();
                if (!phone.matches("^0\\d{9,10}$")) {
                    errors.put("phone", "Phone must start with 0 and have 10–11 digits.");
                }
            }

            // Gender
            int gender = parseIntOrDefault(genderRaw, -1);
            if (!(gender == 1 || gender == 2 || gender == 3)) {
                errors.put("gender", "Gender is invalid.");
            }

            // Identity Number
            if (isBlank(identityNumber)) {
                errors.put("identityNumber", "Identity number is required.");
            } else {
                identityNumber = identityNumber.trim();
                if (identityNumber.length() < 6 || identityNumber.length() > 50) {
                    errors.put("identityNumber", "Identity number length is invalid.");
                }
            }

            String dobError = Validation.validateDobForStaff(dobRaw);
            Date dob = null;

            if (dobError != null) {
                errors.put("dob", dobError);
            } else {
                dob = Validation.parseDateOrNull(dobRaw); // đã chắc chắn không null
            }

            // ===== 4) Check duplicate (DB) nếu DAO có hỗ trợ =====
            // Nếu bạn CHƯA có 2 hàm này trong AdminUserDAO thì comment 2 đoạn dưới.
            if (!errors.containsKey("email") && dao.emailExists(email)) {
                errors.put("email", "Email already exists.");
            }
            if (!errors.containsKey("identityNumber") && dao.identityExists(identityNumber)) {
                errors.put("identityNumber", "Identity number already exists.");
            }

            // ===== 5) If errors -> forward back =====
            if (!errors.isEmpty()) {
                forwardWithForm(request, response, dao, errors, old);
                return;
            }

            // ===== 6) Insert =====
            String hash = BCrypt.hashpw(password, BCrypt.gensalt(10));

            int newUserId = dao.createStaffAccount(
                    email,
                    hash,
                    roleId,
                    status,
                    fullName,
                    gender,
                    dob,
                    identityNumber,
                    phone,
                    address
            );

            response.sendRedirect(request.getContextPath() + "/admin/staff/detail?id=" + newUserId);

        } catch (java.sql.SQLException sqlEx) {
            // fallback nếu chưa dùng emailExists/identityExists hoặc DB báo unique
            String msg = sqlEx.getMessage();
            if (msg != null && (msg.contains("2627") || msg.contains("2601"))) {
                errors.put("common", "Duplicate data: email or identity number already exists.");
                try {
                    forwardWithForm(request, response, dao, errors, old);
                    return;
                } catch (Exception e) {
                    throw new ServletException(e);
                }
            }
            throw new ServletException(sqlEx);

        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
}
