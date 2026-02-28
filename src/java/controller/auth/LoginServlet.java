package controller.auth;

import context.GoogleUtils;
import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.GoogleUserDTO;
import model.User;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        String contextPath = request.getContextPath();

        if (code != null && !code.isEmpty()) {
            try {
                String accessToken = GoogleUtils.getToken(code);
                GoogleUserDTO googleUser = GoogleUtils.getUserInfo(accessToken);
                UserDAO dao = new UserDAO();
                User user = dao.getUserByEmail(googleUser.getEmail());

                if (user == null) {
                    dao.registerGoogleUser(googleUser);
                    user = dao.getUserByEmail(googleUser.getEmail());
                }

                if (user != null && user.getStatus() == 1) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userAccount", user);

                    session.setMaxInactiveInterval(24 * 60 * 60);

                    redirectUser(user, response, contextPath);
                } else {
                    response.sendRedirect(contextPath + "/view/auth/login.jsp?error=account_locked");
                }
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(contextPath + "/view/auth/login.jsp?error=google_failed");
                return;
            }
        }

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("cookEmail")) {
                    request.setAttribute("email", c.getValue());
                }
                if (c.getName().equals("cookRem")) {
                    request.setAttribute("remember", c.getValue());
                }
            }
        }
        request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");
        String contextPath = request.getContextPath();

        try {
            UserDAO dao = new UserDAO();
            User user = dao.checkLogin(email, password);
            if (user != null) {
                if (user.getStatus() == 0) {
                    request.setAttribute("error", "Your account has not been verified with an email address.!");
                    request.setAttribute("email", email);
                    request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
                    return;
                }

                HttpSession session = request.getSession(true);
                session.setAttribute("userAccount", user);

                session.setMaxInactiveInterval(24 * 60 * 60);

                Cookie cEmail = new Cookie("cookEmail", email);
                Cookie cRem = new Cookie("cookRem", "checked");

                cEmail.setPath("/");
                cRem.setPath("/");

                if (remember != null) {
                    int age = 60 * 60 * 24 * 7; // Lưu 7 ngày
                    cEmail.setMaxAge(age);
                    cRem.setMaxAge(age);
                } else {
                    cEmail.setMaxAge(0); 
                    cRem.setMaxAge(0);
                }

                response.addCookie(cEmail);
                response.addCookie(cRem);

                redirectUser(user, response, contextPath);
            } else {
                    request.setAttribute("error", "Incorrect email or password!");
                    request.setAttribute("email", email);
                    request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
                
            }
        } catch (Exception e) {
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
        }
    }

    private void redirectUser(User user, HttpServletResponse response, String contextPath) throws IOException {
        int role = user.getRoleId();

        if (role == 1) {
            response.sendRedirect(contextPath + "/admin/dashboard");
        }else if(role==5) { 
            response.sendRedirect(contextPath + "/home");
        }else{
            response.sendRedirect(contextPath + "/home");
        }
    }
}
