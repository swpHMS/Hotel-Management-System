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

        request.getRequestDispatcher("/view/customer/change_password.jsp")
                .forward(request, response);
    }

    // ====== BƯỚC NÀY ======
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = AuthUtils.getUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        /* ---------- 1. Validate input (ordered) ---------- */
// 1) Required fields
        if (isBlank(currentPassword) || isBlank(newPassword) || isBlank(confirmPassword)) {
            request.setAttribute("error", "Please fill in all fields.");
            forward(request, response);
            return;
        }

// 2) Confirm match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Confirm password does not match.");
            forward(request, response);
            return;
        }

// 3) Basic rules: length first
        if (newPassword.length() < 8) {
            request.setAttribute("error", "New password must be at least 8 characters.");
            forward(request, response);
            return;
        }

// 4) Strength rules
        if (!newPassword.matches(".*\\d.*")) {
            request.setAttribute("error", "Include at least one number.");
            forward(request, response);
            return;
        }

        if (!newPassword.matches(".*[A-Z].*")) {
            request.setAttribute("error", "Include at least one uppercase letter.");
            forward(request, response);
            return;
        }

// 5) New != current
        if (newPassword.equals(currentPassword)) {
            request.setAttribute("error", "New password must be different from current password.");
            forward(request, response);
            return;
        }

        /* ---------- 2. Verify current password (BCrypt) ---------- */
        String storedHash = userDAO.getPasswordHashByUserId(userId);
        if (storedHash == null) {
            request.setAttribute("error", "Your account cannot change password.");
            forward(request, response);
            return;
        }

        if (!PasswordUtils.verify(currentPassword, storedHash)) {
            request.setAttribute("error", "Current password is incorrect.");
            forward(request, response);
            return;
        }

        /* ---------- 3. Update new password ---------- */
        String newHash = PasswordUtils.hash(newPassword);
        boolean updated = userDAO.updatePasswordHash(userId, newHash);

        if (!updated) {
            request.setAttribute("error", "Failed to update password. Please try again.");
            forward(request, response);
            return;
        }

        /* ---------- 4. Logout for security ---------- */
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect(request.getContextPath() + "/login?changed=1");
    }

    /* ====== helpers ====== */
    private void forward(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/view/customer/change_password.jsp").forward(req, res);
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
