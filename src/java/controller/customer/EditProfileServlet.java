package controller.customer;

import dal.CustomerProfileDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.AuthUtils;
import utils.FormUtils;
import utils.Validation;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.regex.Pattern;

@WebServlet(name = "EditProfileServlet", urlPatterns = {"/customer/profile/edit"})
public class EditProfileServlet extends HttpServlet {

    private static final Pattern CUSTOMER_PHONE_PATTERN = Pattern.compile("^0\\d{9}$");

    private final CustomerProfileDAO dao = new CustomerProfileDAO();
    private final CustomerPageSupport pageSupport = new CustomerPageSupport();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = pageSupport.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        pageSupport.prepareEditProfile(request, userId);
        pageSupport.forwardLayout(request, response);
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
        session.removeAttribute("flash_error");
        session.removeAttribute("flash_success");

        String fullName = FormUtils.get(request, "fullName");
        Integer gender = FormUtils.parseIntOrNull(request.getParameter("gender"));
        Date dob = FormUtils.parseDateOrNull(request.getParameter("dateOfBirth"));
        String identityNumber = FormUtils.get(request, "identityNumber");
        String phone = FormUtils.get(request, "phone");
        String address = FormUtils.get(request, "residenceAddress");

        fullName = fullName != null ? fullName.trim() : null;
        identityNumber = identityNumber != null ? identityNumber.trim() : null;
        phone = phone != null ? phone.trim() : null;
        address = address != null ? address.trim() : null;

        if (identityNumber != null && identityNumber.isEmpty()) {
            identityNumber = null;
        }
        if (phone != null && phone.isEmpty()) {
            phone = null;
        }
        if (address != null && address.isEmpty()) {
            address = null;
        }

        String error = null;

        final int FULLNAME_MAX = 100;
        final int ADDR_MAX = 500;
        Pattern fullNamePattern = Pattern.compile("^[\\p{L}][\\p{L} .'-]{1,99}$");

        if (fullName == null || fullName.length() < 2) {
            error = "Full name must be at least 2 characters.";
        } else if (fullName.length() > FULLNAME_MAX) {
            error = "Full name is too long (max " + FULLNAME_MAX + ").";
        } else if (!fullNamePattern.matcher(fullName).matches()) {
            error = "Full name contains invalid characters.";
        }

        if (error == null && gender != null && (gender < 1 || gender > 3)) {
            error = "Invalid gender value.";
        }

        if (error == null && dob != null) {
            LocalDate date = dob.toLocalDate();
            LocalDate today = LocalDate.now();
            LocalDate min = LocalDate.of(1900, 1, 1);

            if (date.isAfter(today) || date.isBefore(min)) {
                error = "Date of birth must be between 01/01/1900 and today.";
            }
        }

        if (error == null && identityNumber != null && !Validation.isCCCD(identityNumber)) {
            error = "Identity Number must be 12 digits.";
        }

        if (error == null) {
            if (phone == null) {
                error = "Phone is required.";
            } else if (!CUSTOMER_PHONE_PATTERN.matcher(phone).matches()) {
                error = "Phone number must start with 0 and contain exactly 10 digits.";
            }
        }

        if (error == null && address != null) {
            if (address.length() > ADDR_MAX) {
                error = "Address is too long (max " + ADDR_MAX + ").";
            } else if (address.length() < 5) {
                error = "Address must be at least 5 characters long.";
            }
        }

        if (error != null) {
            session.removeAttribute("flash_success");
            session.setAttribute("flash_error", error);
            session.setAttribute("form_fullName", fullName);
            session.setAttribute("form_gender", gender);
            session.setAttribute("form_dob", request.getParameter("dateOfBirth"));
            session.setAttribute("form_identity", identityNumber);
            session.setAttribute("form_phone", phone);
            session.setAttribute("form_address", address);
            response.sendRedirect(request.getContextPath() + "/customer/profile/edit");
            return;
        }

        boolean ok = dao.updateCustomerProfileByUserId(
                userId,
                fullName,
                gender,
                dob,
                identityNumber,
                phone,
                address
        );

        if (ok) {
            session.setAttribute("flash_success", "Profile updated successfully.");
            session.removeAttribute("form_fullName");
            session.removeAttribute("form_gender");
            session.removeAttribute("form_dob");
            session.removeAttribute("form_identity");
            session.removeAttribute("form_phone");
            session.removeAttribute("form_address");
            response.sendRedirect(request.getContextPath() + "/customer/profile/edit");
            return;
        }

        session.setAttribute("flash_error", "Update failed. Please try again.");
        response.sendRedirect(request.getContextPath() + "/customer/profile/edit");
    }
}
