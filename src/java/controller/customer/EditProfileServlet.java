package controller.customer;

import dal.CustomerProfileDAO;
import utils.AuthUtils;
import utils.FormUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "EditProfileServlet", urlPatterns = {"/customer/profile/edit"})
public class EditProfileServlet extends HttpServlet {

    private final CustomerProfileDAO dao = new CustomerProfileDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Không dùng trang riêng nữa -> luôn quay về dashboard tab editProfile
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

        // đọc input
        String fullName = FormUtils.get(request, "fullName");
        Integer gender = FormUtils.parseIntOrNull(request.getParameter("gender"));
        Date dob = FormUtils.parseDateOrNull(request.getParameter("dateOfBirth"));
        String identityNumber = FormUtils.get(request, "identityNumber");
        String phone = FormUtils.get(request, "phone");
        String address = FormUtils.get(request, "residenceAddress");

        // validate
        String error = null;
        if (fullName == null || fullName.trim().length() < 2) {
            error = "Full name must be at least 2 characters.";
        } else if (gender != null && (gender < 1 || gender > 3)) {
            error = "Invalid gender value.";
        } else if (identityNumber != null && identityNumber.length() > 50) {
            error = "Identity number is too long (max 50).";
        } else if (phone != null && phone.length() > 20) {
            error = "Phone number is too long (max 20).";
        } else if (address != null && address.length() > 500) {
            error = "Address is too long (max 500).";
        }

        if (error != null) {
            // flash error + giữ input để dashboard render lại
            session.setAttribute("flash_error", error);

            session.setAttribute("form_fullName", fullName);
            session.setAttribute("form_gender", gender);
            session.setAttribute("form_dob", request.getParameter("dateOfBirth"));
            session.setAttribute("form_identityNumber", identityNumber);
            session.setAttribute("form_phone", phone);
            session.setAttribute("form_address", address);

            response.sendRedirect(request.getContextPath() + "/customer/dashboard?tab=editProfile");
            return;
        }

        boolean ok = dao.updateCustomerProfileByUserId(
                userId,
                fullName.trim(),
                gender,
                dob,
                identityNumber,
                phone,
                address
        );

        if (ok) {
            // ✅ Thành công: quay về editProfile để hiện ✓ + message, rồi JS tự chuyển về view_profile
            session.setAttribute("flash_success", "Profile updated successfully.");
            response.sendRedirect(request.getContextPath() + "/customer/dashboard?tab=editProfile");
        } else {
            session.setAttribute("flash_error", "Update failed. Please try again.");
            response.sendRedirect(request.getContextPath() + "/customer/dashboard?tab=editProfile");
        }
    }
}
