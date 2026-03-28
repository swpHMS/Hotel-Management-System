package controller.auth;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.EmailUtils;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/view/auth/forgot.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        UserDAO dao = new UserDAO();
        User user = dao.getUserByEmail(email);

        if (user != null) {
            if (user.getStatus() == 0) {
                request.setAttribute("error",
                        "This account is not yet activated. Please check your email for confirmation first!");
            } else {
                String token = UUID.randomUUID().toString();
                dao.updateToken(email, token);

                try {
                    EmailUtils.sendForgotPasswordEmail(email, token);
                    request.setAttribute("message",
                            "Your request has been submitted! Please check your email.");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error",
                            "Failed to send reset password email. Please try again later.");
                }
            }
        } else {
            request.setAttribute("error", "The email address does not exist in the system!");
        }

        request.getRequestDispatcher("/view/auth/forgot.jsp").forward(request, response);
    }
}