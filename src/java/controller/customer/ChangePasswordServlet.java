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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = AuthUtils.getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/customer/dashboard?tab=changePassword");
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

        if (isBlank(currentPassword) || isBlank(newPassword) || isBlank(confirmPassword)) {
            session.setAttribute("flash_error", "Please fill in all fields.");
            redirectTab(response, request, "changePassword");
            return;
        }

        if (containsWhitespace(newPassword) || containsWhitespace(confirmPassword)) {
            session.setAttribute("flash_error", "Password must not contain spaces.");
            redirectTab(response, request, "changePassword");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            session.setAttribute("flash_error", "Confirm password does not match.");
            redirectTab(response, request, "changePassword");
            return;
        }

        if (newPassword.equals(currentPassword)) {
            session.setAttribute("flash_error", "New password must be different from current password.");
            redirectTab(response, request, "changePassword");
            return;
        }

        if (newPassword.length() < 8) {
            session.setAttribute("flash_error", "New password must be at least 8 characters.");
            redirectTab(response, request, "changePassword");
            return;
        }

        if (!newPassword.matches(".*\\d.*")) {
            session.setAttribute("flash_error", "Include at least one number.");
            redirectTab(response, request, "changePassword");
            return;
        }

        if (!newPassword.matches(".*[A-Z].*")) {
            session.setAttribute("flash_error", "Include at least one uppercase letter.");
            redirectTab(response, request, "changePassword");
            return;
        }

        String storedHash = userDAO.getPasswordHashByUserId(userId);
        if (storedHash == null || storedHash.isBlank()) {
            session.setAttribute("flash_error", "Your account cannot change password.");
            redirectTab(response, request, "changePassword");
            return;
        }

        if (!PasswordUtils.verify(currentPassword, storedHash)) {
            session.setAttribute("flash_error", "Current password is incorrect.");
            redirectTab(response, request, "changePassword");
            return;
        }

        String newHash = PasswordUtils.hash(newPassword);
        boolean updated = userDAO.updatePasswordHash(userId, newHash);

        if (!updated) {
            session.setAttribute("flash_error", "Failed to update password. Please try again.");
            redirectTab(response, request, "changePassword");
            return;
        }

        session.setAttribute("flash_success", "Password changed successfully.");
        redirectTab(response, request, "changePassword");
    }

    private void redirectTab(HttpServletResponse res, HttpServletRequest req, String tab)
            throws IOException {
        res.sendRedirect(req.getContextPath() + "/customer/dashboard?tab=" + tab);
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private boolean containsWhitespace(String s) {
        return s != null && s.matches(".*\\s+.*");
    }
}
