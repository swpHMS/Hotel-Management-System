package controller.auth;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="VerifyServlet", urlPatterns={"/verify"})
public class VerifyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String email = request.getParameter("email");
        String token = request.getParameter("token");

        try {
            UserDAO dao = new UserDAO();
            // Call verifyUser to update status = 1 in the database
            boolean isVerified = dao.verifyUser(email, token);

            if (isVerified) {
                // If verification is successful, redirect to login with a success message
                response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp?verify=success");
            } else {
                // If failed (wrong token or email), report an error
                request.setAttribute("error", "The verification link is invalid or has expired!");
                request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Redirect to login with a system error notification
            response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp?error=system_error");
        }
    }
    
}