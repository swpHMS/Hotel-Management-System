package controller.customer;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import utils.AuthUtils;
import utils.PasswordUtils;

import java.io.IOException;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/customer/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final CustomerPageSupport pageSupport = new CustomerPageSupport();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = pageSupport.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        pageSupport.prepareChangePassword(request, userId);
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
        HttpSession session = request.getSession(true);

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // ✅ KHÔNG lưu password vào session (security)
        // session.setAttribute("cp_current", currentPassword);
        // session.setAttribute("cp_new", newPassword);
        // session.setAttribute("cp_confirm", confirmPassword);

        if (isBlank(currentPassword) || isBlank(newPassword) || isBlank(confirmPassword)) {
            session.setAttribute("flash_error", "Please fill in all fields.");
            redirectChangePassword(response, request);
            return;
        }

        if (containsWhitespace(newPassword) || containsWhitespace(confirmPassword)) {
            session.setAttribute("flash_error", "Password must not contain spaces.");
            redirectChangePassword(response, request);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("flash_error", "Confirm password does not match.");
            redirectChangePassword(response, request);
            return;
        }

        if (newPassword.equals(currentPassword)) {
            session.setAttribute("flash_error", "New password must be different from current password.");
            redirectChangePassword(response, request);
            return;
        }

        if (newPassword.length() < 8) {
            session.setAttribute("flash_error", "New password must be at least 8 characters.");
            redirectChangePassword(response, request);
            return;
        }

        if (!newPassword.matches(".*\\d.*")) {
            session.setAttribute("flash_error", "Include at least one number.");
            redirectChangePassword(response, request);
            return;
        }

        if (!newPassword.matches(".*[A-Z].*")) {
            session.setAttribute("flash_error", "Include at least one uppercase letter.");
            redirectChangePassword(response, request);
            return;
        }

        String storedHash = userDAO.getPasswordHashByUserId(userId);
        if (storedHash == null || storedHash.isBlank()) {
            session.setAttribute("flash_error", "Your account cannot change password.");
            redirectChangePassword(response, request);
            return;
        }

        if (!PasswordUtils.verify(currentPassword, storedHash)) {
            session.setAttribute("flash_error", "Current password is incorrect.");
            redirectChangePassword(response, request);
            return;
        }

        String newHash = PasswordUtils.hash(newPassword);
        boolean updated = userDAO.updatePasswordHash(userId, newHash);

        if (!updated) {
            session.setAttribute("flash_error", "Failed to update password. Please try again.");
            redirectChangePassword(response, request);
            return;
        }

        // ===== SUCCESS: logout -> new session for login page message =====
        session.invalidate();

        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("successMsg", "Password changed successfully. Please login again.");

        response.sendRedirect(request.getContextPath() + "/login");
    }

    private void redirectChangePassword(HttpServletResponse res, HttpServletRequest req)
            throws IOException {
        res.sendRedirect(req.getContextPath() + "/customer/change-password");
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private boolean containsWhitespace(String s) {
        return s != null && s.matches(".*\\s+.*");
    }
}
