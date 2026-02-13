package controller.admin.staff;

import dal.AdminUserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.LinkedHashMap;
import java.util.Map;
import model.UserProfile;
import utils.Validation;

@WebServlet(name = "StaffEditProfileServlet", urlPatterns = {"/admin/staff/edit-profile"})
public class StaffEditProfileServlet extends HttpServlet {

    private int parseIntOrDefault(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private String normalizeSpaces(String s) {
        if (s == null) return null;
        return s.trim().replaceAll("\\s+", " ");
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
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
            UserProfile staff = dao.getStaffByUserId(userId);
            if (staff == null) {
                response.sendRedirect(request.getContextPath() + "/admin/staff");
                return;
            }

            request.setAttribute("active", "staff_list");
            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/view/admin/staff_edit_profile.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int userId = parseIntOrDefault(request.getParameter("userId"), -1);
        if (userId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/staff");
            return;
        }

        String fullName = normalizeSpaces(request.getParameter("fullName"));
        String phone = Validation.trimToNull(request.getParameter("phone"));
        String email = Validation.trimToNull(request.getParameter("email"));
        String residenceAddress = Validation.trimToNull(request.getParameter("residenceAddress"));

        int gender = parseIntOrDefault(request.getParameter("gender"), 0); // 1/2/3
        String dobRaw = request.getParameter("dateOfBirth");              // yyyy-MM-dd
        Date dob = Validation.parseDateOrNull(dobRaw);

        Map<String, String> errors = new LinkedHashMap<>();
        AdminUserDAO dao = new AdminUserDAO();

        try {
            UserProfile staff = dao.getStaffByUserId(userId);
            if (staff == null) {
                response.sendRedirect(request.getContextPath() + "/admin/staff");
                return;
            }

            // ===== VALIDATE =====

            // Full name: required + không có số
            if (isBlank(fullName)) {
                errors.put("fullName", "Full name is required.");
            } else if (!Validation.isValidFullNameNoNumber(fullName)) {
                errors.put("fullName", "Full name must not contain numbers.");
            }

            // Gender: chỉ 1/2/3
            if (!(gender == 1 || gender == 2 || gender == 3)) {
                errors.put("gender", "Please select a valid gender.");
            }

            // DOB: dùng đúng hàm bạn đã viết (>=18)
            String dobErr = Validation.validateDobForStaff(dobRaw);
            if (dobErr != null) {
                errors.put("dateOfBirth", dobErr);
            }

            // Email: required + format + trùng (trừ chính mình)
            if (email == null) {
                errors.put("email", "Email is required.");
            } else if (!Validation.isEmail(email)) {
                errors.put("email", "Invalid email format.");
            } else if (dao.emailExistsExceptUserId(email, userId)) {
                errors.put("email", "Email already exists.");
            }

            // Phone: optional nhưng nếu có thì phải đúng VN
            if (phone != null && !Validation.isPhoneVN(phone)) {
                errors.put("phone", "Invalid phone number (VN format).");
            }

            // Address: optional, bạn có thể bắt buộc nếu muốn
            // if (residenceAddress == null) errors.put("residenceAddress", "Address is required.");

            // ===== Nếu có lỗi -> forward lại, giữ data =====
            if (!errors.isEmpty()) {
                staff.setFullName(fullName);
                staff.setGender(gender);
                staff.setDateOfBirth(dob);
                staff.setResidenceAddress(residenceAddress);
                staff.setPhone(phone);
                staff.setEmail(email);

                request.setAttribute("active", "staff_list");
                request.setAttribute("staff", staff);
                request.setAttribute("errors", errors);
                request.getRequestDispatcher("/view/admin/staff_edit_profile.jsp").forward(request, response);
                return;
            }

            // ===== Update DB =====
            staff.setFullName(fullName);
            staff.setGender(gender);
            staff.setDateOfBirth(dob);
            staff.setResidenceAddress(residenceAddress);
            staff.setPhone(phone);
            staff.setEmail(email);

            dao.updateStaffProfile(staff);

            // redirect về detail (PRG)
            response.sendRedirect(request.getContextPath() + "/admin/staff/detail?id=" + userId + "&updatedProfile=1");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
