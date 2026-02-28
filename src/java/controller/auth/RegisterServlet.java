package controller.auth;

import dal.UserDAO;
import model.User;
import utils.EmailUtils;
import java.io.IOException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String error = null;


        if (fullName == null || fullName.trim().isEmpty() || 
            email == null || email.trim().isEmpty() || 
            phone == null || phone.trim().isEmpty() || 
            password == null || password.isEmpty() || 
            confirmPassword == null || confirmPassword.isEmpty()) {
            error = "All fields are required!";
        } 
        // Validate Full Name: No numbers, no special characters
        else if (!fullName.matches("^[\\p{L}\\s]+$")) {
            error = "Full name must not contain numbers or special characters!";
        } 
        // Validate Email format
        else if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[a-z]{2,}$")) {
            error = "Invalid email format (e.g., example@mail.com)!";
        } 
        // Validate Phone: Starts with 0 and exactly 10 digits
        else if (!phone.matches("^0[0-9]{9}$")) {
            error = "Phone number must start with 0 and contain exactly 10 digits!";
        } 
        // Validate Password: length >= 8, at least 1 uppercase, 1 digit, no spaces
        else if (!password.matches("^(?=.*[A-Z])(?=.*\\d)\\S{8,}$")) {
            error = "Password must be at least 8 characters long, including at least one uppercase letter, one number, and no spaces!";
        } 
        // Validate Confirm Password: 100% match
        else if (!password.equals(confirmPassword)) {
            error = "Confirm password does not match!";
        }

        // Return to register page if there's a validation error
        if (error != null) {
            request.setAttribute("error", error);
            keepFormData(request, fullName, email, phone);
            request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            User existingUser = dao.getUserByEmail(email);
            String token = UUID.randomUUID().toString();

            if (existingUser != null) {
                if (existingUser.getStatus() == 1) {
                    request.setAttribute("error", "This email is already in use. Please sign in!");
                } else {
                    dao.updateToken(email, token);
                    EmailUtils.sendVerifyEmail(email, token);
                    request.setAttribute("message", "This email is pending verification. A new activation link has been sent to your inbox!");
                }
                keepFormData(request, fullName, email, phone);
                request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
                return;
            }

            boolean success = dao.registerLocalUser(email, password, fullName, phone, token);

            if (success) {
                EmailUtils.sendVerifyEmail(email, token);
                response.sendRedirect(request.getContextPath() + "/view/auth/check-mail.jsp");
            } else {
                request.setAttribute("error", "Data saving error. Please try again later!");
                keepFormData(request, fullName, email, phone);
                request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
        }
    }

    private void keepFormData(HttpServletRequest request, String fullName, String email, String phone) {
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
    }
}