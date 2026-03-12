package controller.customer;

import dal.CustomerProfileDAO;
import utils.AuthUtils;
import utils.FormUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.regex.Pattern;

@WebServlet(name = "EditProfileServlet", urlPatterns = {"/customer/profile/edit"})
public class EditProfileServlet extends HttpServlet {

    private final CustomerProfileDAO dao = new CustomerProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(request.getContextPath() + "/customer/dashboard?tab=editProfile");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = AuthUtils.getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // ✅ (1) Clear flash cũ để không bị dính success/error từ lần trước
        session.removeAttribute("flash_error");
        session.removeAttribute("flash_success");

        // =====================
        // 1) ĐỌC INPUT
        // =====================
        String fullName = FormUtils.get(request, "fullName");
        Integer gender = FormUtils.parseIntOrNull(request.getParameter("gender"));
        Date dob = FormUtils.parseDateOrNull(request.getParameter("dateOfBirth"));
        String phone = FormUtils.get(request, "phone");
        String address = FormUtils.get(request, "residenceAddress");

        // =====================
        // 2) CHUẨN HOÁ INPUT
        // =====================
        fullName = (fullName != null) ? fullName.trim() : null;
        phone = (phone != null) ? phone.trim() : null;
        address = (address != null) ? address.trim() : null;

        if (phone != null && phone.isEmpty()) {
            phone = null;
        }
        if (address != null && address.isEmpty()) {
            address = null;
        }

        // =====================
        // 3) VALIDATE
        // =====================
        String error = null;

        final int FULLNAME_MAX = 100;
        final int ADDR_MAX = 500;

        Pattern FULLNAME_PATTERN = Pattern.compile("^[\\p{L}][\\p{L} .'-]{1,99}$");
        Pattern PHONE_PATTERN = Pattern.compile("^\\+?[0-9]{8,15}$");

        // Full name
        if (fullName == null || fullName.length() < 2) {
            error = "Full name must be at least 2 characters.";
        } else if (fullName.length() > FULLNAME_MAX) {
            error = "Full name is too long (max " + FULLNAME_MAX + ").";
        } else if (!FULLNAME_PATTERN.matcher(fullName).matches()) {
            error = "Full name contains invalid characters.";
        }

// Gender
        if (error == null && gender != null && (gender < 1 || gender > 3)) {
            error = "Invalid gender value.";
        }

// DOB
        if (error == null && dob != null) {
            LocalDate d = dob.toLocalDate();
            LocalDate today = LocalDate.now();
            LocalDate min = LocalDate.of(1900, 1, 1);

            if (d.isAfter(today) || d.isBefore(min)) {
                error = "Date of birth must be between 01/01/1900 and today.";
            }
        }

// Phone
        if (error == null && phone != null) {
            if (phone.length() > 15) {
                error = "Phone number must not exceed 15 digits.";
            } else if (!PHONE_PATTERN.matcher(phone).matches()) {
                error = "Phone number must be 8–15 digits and may start with '+'.";
            }
        }

// Address
        if (error == null && address != null) {
            if (address.length() > ADDR_MAX) {
                error = "Address is too long (max " + ADDR_MAX + ").";
            } else if (address.length() < 5) {
                error = "Address must be at least 5 characters long.";
            }
        }

        // =====================
        // 4) HANDLE ERROR
        // =====================
        if (error != null) {
            // ✅ không bao giờ để success dính khi có lỗi
            session.removeAttribute("flash_success");
            session.setAttribute("flash_error", error);

            session.setAttribute("form_fullName", fullName);
            session.setAttribute("form_gender", gender);
            session.setAttribute("form_dob", request.getParameter("dateOfBirth"));
            session.setAttribute("form_phone", phone);
            session.setAttribute("form_address", address);

            response.sendRedirect(request.getContextPath() + "/customer/dashboard?tab=editProfile");
            return;
        }

        // =====================
        // 5) UPDATE DB
        // =====================
        boolean ok = dao.updateCustomerProfileByUserId(
                userId,
                fullName,
                gender,
                dob,
                phone,
                address
        );

        if (ok) {
            session.setAttribute("flash_success", "Profile updated successfully.");

            session.removeAttribute("form_fullName");
            session.removeAttribute("form_gender");
            session.removeAttribute("form_dob");
            session.removeAttribute("form_phone");
            session.removeAttribute("form_address");

            response.sendRedirect(request.getContextPath() + "/customer/dashboard?tab=editProfile");
            return;
        }

        session.setAttribute("flash_error", "Update failed. Please try again.");
        response.sendRedirect(request.getContextPath() + "/customer/dashboard?tab=editProfile");
    }
}
