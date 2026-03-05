package controller.auth;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;
import utils.EmailUtils;

@WebServlet(name="ForgotPasswordServlet", urlPatterns={"/forgot-password"})
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
                request.setAttribute("error", "This account is not yet activated. Please check your email for confirmation first!");
            } else {
                String token = UUID.randomUUID().toString();
                dao.updateToken(email, token);

                String resetLink = request.getScheme() + "://" + request.getServerName() + ":" 
                                 + request.getServerPort() + request.getContextPath() 
                                 + "/reset-password?token=" + token;
                
                String content = "You have requested a password reset at the Regal Quintet Hotel..\n"
                               + "Please click on the following link to proceed: " + resetLink;
                
                EmailUtils.sendEmail(email, "Regal Quintet - Reset Password", content);

                request.setAttribute("message", "Your request has been submitted! Please check your email.");
            }
        } else {
            request.setAttribute("error", "The email address does not exist in the system.!");
        }
        
        request.getRequestDispatcher("/view/auth/forgot.jsp").forward(request, response);
    }
}