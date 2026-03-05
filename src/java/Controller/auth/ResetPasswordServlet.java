package controller.auth;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * ResetPasswordServlet handles the password recovery process.
 * Author: ASUS
 */
@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String token = request.getParameter("token");
        request.setAttribute("token", token);
        request.getRequestDispatcher("/view/auth/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPass = request.getParameter("password");
        String confirmPass = request.getParameter("confirmPassword");
        
        String errorMsg = null;

        // --- PASSWORD VALIDATION LOGIC ---
        
        //Check for empty fields
        if (newPass == null || newPass.isEmpty() || confirmPass == null || confirmPass.isEmpty()) {
            errorMsg = "Please enter all password fields!";
        }
        //Complexity check: >= 8 chars, 1 Uppercase, 1 Digit, No Spaces
        else if (!newPass.matches("^(?=.*[A-Z])(?=.*\\d)\\S{8,}$")) {
            errorMsg = "Password must be at least 8 characters long, including at least one uppercase letter, one number, and no spaces!";
        }
        //Confirm password check
        else if (!newPass.equals(confirmPass)) {
            errorMsg = "Confirm password does not match!";
        }

        // If there is a validation error, return to the reset page
        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);
            request.setAttribute("token", token);
            request.getRequestDispatcher("/view/auth/reset-password.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            // Update the new password and invalidate the token for security
            if (dao.resetPassword(token, newPass)) {
                // Use session to persist message across redirect
                request.getSession().setAttribute("successMsg", "Password reset successfully! Please log in with your new password.");
                response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp?message=reset_success");
            } else {
                request.setAttribute("error", "The reset link is invalid or has expired!");
                request.setAttribute("token", token);
                request.getRequestDispatcher("/view/auth/reset-password.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "System error: " + e.getMessage());
            request.setAttribute("token", token);
            request.getRequestDispatcher("/view/auth/reset-password.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles password reset requests and validates new password credentials.";
    }
}