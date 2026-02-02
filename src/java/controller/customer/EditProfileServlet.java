package controller.customer;

import dal.CustomerProfileDAO;
import model.ProfileView;
import utils.AuthUtils;
import utils.FormUtils;
import utils.NameUtils;

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

        Integer userId = AuthUtils.getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ProfileView profile = dao.getCustomerProfileByUserId(userId);
        request.setAttribute("profile", profile);

        String initials = (profile != null) ? NameUtils.initials(profile.getFullName()) : "U";
        request.setAttribute("initials", initials);

        request.getRequestDispatcher("/view/customer/edit_profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = AuthUtils.getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // đọc input
        String fullName = FormUtils.get(request, "fullName");
        Integer gender = FormUtils.parseIntOrNull(request.getParameter("gender"));
        Date dob = FormUtils.parseDateOrNull(request.getParameter("dateOfBirth"));
        String phone = FormUtils.get(request, "phone");
        String address = FormUtils.get(request, "residenceAddress");

        // validate tối thiểu (bạn có thể siết thêm)
        String error = null;
        if (fullName == null || fullName.length() < 2) {
            error = "Full name must be at least 2 characters.";
        } else if (gender != null && (gender < 1 || gender > 3)) {
            error = "Invalid gender value.";
        } else if (phone != null && phone.length() > 20) {
            error = "Phone number is too long (max 20).";
        } else if (address != null && address.length() > 500) {
            error = "Address is too long (max 500).";
        }

        if (error != null) {
            // load lại profile để render form + giữ input người dùng
            ProfileView profile = dao.getCustomerProfileByUserId(userId);
            request.setAttribute("profile", profile);
            request.setAttribute("initials", profile != null ? NameUtils.initials(profile.getFullName()) : "U");

            request.setAttribute("error", error);

            // giữ lại input user đã nhập
            request.setAttribute("form_fullName", fullName);
            request.setAttribute("form_gender", gender);
            request.setAttribute("form_dob", request.getParameter("dateOfBirth"));
            request.setAttribute("form_phone", phone);
            request.setAttribute("form_address", address);

            request.getRequestDispatcher("/view/customer/edit_profile.jsp").forward(request, response);
            return;
        }

        boolean ok = dao.updateCustomerProfileByUserId(userId, fullName, gender, dob, phone, address);

        // PRG: redirect để tránh F5 submit lại
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/customer/profile?updated=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/customer/profile/edit?error=1");
        }
    }
}
