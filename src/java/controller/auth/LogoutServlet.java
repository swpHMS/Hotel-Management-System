package controller.auth;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="LogoutServlet", urlPatterns={"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
     
        handleLogout(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        handleLogout(request, response);
    }

    
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
    throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        Cookie cEmail = new Cookie("cookEmail", "");
        Cookie cPass = new Cookie("cookPass", "");
        Cookie cRem = new Cookie("cookRem", "");

        cEmail.setMaxAge(0);
        cPass.setMaxAge(0);
        cRem.setMaxAge(0);
        
        cEmail.setPath("/");
        cPass.setPath("/");
        cRem.setPath("/");

        response.addCookie(cEmail);
        response.addCookie(cPass);
        response.addCookie(cRem);

        response.sendRedirect(request.getContextPath() + "/home");
    }

    @Override
    public String getServletInfo() {
        return "Logout Servlet handling session invalidation and cookie clearing";
    }
}