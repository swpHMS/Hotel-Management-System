package controller.staff.profile;

import dal.StaffDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.StaffProfile;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "StaffProfileServlet", urlPatterns = {"/staff-profile"})
public class StaffProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userAccount");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        StaffDAO dao = new StaffDAO();
        StaffProfile staff = dao.getStaffByUserId(user.getUserId());

        if (staff != null) {
            int totalOrders = dao.getTotalServiceOrdersByStaffId(staff.getStaffId());

            request.setAttribute("staff", staff);
            request.setAttribute("totalOrders", totalOrders);

            request.getRequestDispatcher("view/staff/profile.jsp").forward(request, response);
        } else {
            response.getWriter().println("Profile not found. Please contact Admin.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("userAccount");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        StaffDAO dao = new StaffDAO();

        try {
            if ("changePassword".equals(action)) {
                handleChangePassword(request, response, session, user, dao);
            } else {
                handleUpdateProfile(request, response, session, dao);
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("flash_error", "Something went wrong. Please try again.");
            response.sendRedirect("staff-profile");
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response,
                                     HttpSession session, StaffDAO dao) throws IOException {

        int staffId = Integer.parseInt(request.getParameter("staffId"));
        String fullName = request.getParameter("fullName") != null
                ? request.getParameter("fullName").trim() : "";
        String phone = request.getParameter("phone") != null
                ? request.getParameter("phone").trim() : "";
        String identityNumber = request.getParameter("identityNumber") != null
                ? request.getParameter("identityNumber").trim() : "";
        String address = request.getParameter("residenceAddress") != null
                ? request.getParameter("residenceAddress").trim() : "";
        String genderRaw = request.getParameter("gender");

        if (fullName.isEmpty()) {
            session.setAttribute("flash_error", "Full name is required.");
            response.sendRedirect("staff-profile");
            return;
        }

        if (!fullName.matches("^[\\p{L}\\s]+$")) {
            session.setAttribute("flash_error", "Full name must contain letters and spaces only.");
            response.sendRedirect("staff-profile");
            return;
        }

        if (!phone.isEmpty() && !phone.matches("^0\\d{9}$")) {
            session.setAttribute("flash_error", "Phone number must have 10 digits and start with 0.");
            response.sendRedirect("staff-profile");
            return;
        }

        if (identityNumber.isEmpty()) {
            session.setAttribute("flash_error", "Citizen ID is required.");
            response.sendRedirect("staff-profile");
            return;
        }

        if (!identityNumber.matches("^\\d{12}$")) {
            session.setAttribute("flash_error", "Citizen ID must contain exactly 12 digits.");
            response.sendRedirect("staff-profile");
            return;
        }

        int gender;
        try {
            gender = Integer.parseInt(genderRaw);
            if (gender != 1 && gender != 2 && gender != 3) {
                session.setAttribute("flash_error", "Invalid gender value.");
                response.sendRedirect("staff-profile");
                return;
            }
        } catch (NumberFormatException e) {
            session.setAttribute("flash_error", "Invalid gender value.");
            response.sendRedirect("staff-profile");
            return;
        }

        boolean updated = dao.updateStaffProfile(staffId, fullName, phone, gender, address, identityNumber);

        if (updated) {
            session.setAttribute("flash_success", "Profile updated successfully.");
        } else {
            session.setAttribute("flash_error", "Failed to update profile.");
        }

        response.sendRedirect("staff-profile");
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response,
                                      HttpSession session, User user, StaffDAO dao) throws IOException {

        String currentPassword = request.getParameter("currentPassword") != null
                ? request.getParameter("currentPassword").trim() : "";
        String newPassword = request.getParameter("newPassword") != null
                ? request.getParameter("newPassword").trim() : "";
        String confirmPassword = request.getParameter("confirmPassword") != null
                ? request.getParameter("confirmPassword").trim() : "";

        if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            session.setAttribute("flash_error", "Please fill in all password fields.");
            response.sendRedirect("staff-profile");
            return;
        }

        if (newPassword.length() < 8) {
            session.setAttribute("flash_error", "New password must be at least 8 characters long.");
            response.sendRedirect("staff-profile");
            return;
        }

        if (newPassword.contains(" ")) {
            session.setAttribute("flash_error", "New password must not contain spaces.");
            response.sendRedirect("staff-profile");
            return;
        }

        if (!newPassword.matches(".*[A-Z].*")) {
            session.setAttribute("flash_error", "New password must include at least one uppercase letter.");
            response.sendRedirect("staff-profile");
            return;
        }

        if (!newPassword.matches(".*\\d.*")) {
            session.setAttribute("flash_error", "New password must include at least one number.");
            response.sendRedirect("staff-profile");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("flash_error", "Confirm password does not match the new password.");
            response.sendRedirect("staff-profile");
            return;
        }

        if (currentPassword.equals(newPassword)) {
            session.setAttribute("flash_error", "New password must be different from your current password.");
            response.sendRedirect("staff-profile");
            return;
        }

        String currentPasswordHashInDb = dao.getPasswordHashByUserId(user.getUserId());

        if (currentPasswordHashInDb == null || !BCrypt.checkpw(currentPassword, currentPasswordHashInDb)) {
            session.setAttribute("flash_error", "Current password is incorrect.");
            response.sendRedirect("staff-profile");
            return;
        }

        String newPasswordHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        boolean updated = dao.updatePasswordByUserId(user.getUserId(), newPasswordHash);

        if (updated) {
            session.setAttribute("flash_success", "Password changed successfully.");
        } else {
            session.setAttribute("flash_error", "Failed to change password.");
        }

        response.sendRedirect("staff-profile");
    }
}