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

        // Đọc cookie để tự động điền form login
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
            
            // 1. Kiểm tra email tồn tại
            User user = dao.getUserByEmail(email);

            if (user == null) {
                request.setAttribute("error", "Account does not exist!");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
                return;
            }

            // 2. Kiểm tra mật khẩu (Sử dụng BCrypt)
            if (user.getPasswordHash() != null && org.mindrot.jbcrypt.BCrypt.checkpw(password, user.getPasswordHash())) {
                
                // 3. Kiểm tra trạng thái verify
                if (user.getStatus() == 0) {
                    request.setAttribute("error", "Your account is inactive!");
                    request.setAttribute("email", email);
                    request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
                    return;
                }

                // ĐĂNG NHẬP THÀNH CÔNG
                HttpSession session = request.getSession(true);
                session.setAttribute("userAccount", user);
                session.setMaxInactiveInterval(24 * 60 * 60);

                // Gọi hàm xử lý Cookie (Đã thêm bên dưới)
                handleCookies(email, remember, response);

                redirectUser(user, response, contextPath);

            } else {
                // Sai mật khẩu
                request.setAttribute("error", "Incorrect password!");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
        }
    }


    private void handleCookies(String email, String remember, HttpServletResponse response) {
        Cookie cEmail = new Cookie("cookEmail", email);
        Cookie cRem = new Cookie("cookRem", "checked");
        cEmail.setPath("/");
        cRem.setPath("/");

        if (remember != null) {
            int age = 60 * 60 * 24 * 7; // 7 ngày
            cEmail.setMaxAge(age);
            cRem.setMaxAge(age);
        } else {
            cEmail.setMaxAge(0);
            cRem.setMaxAge(0);
        }
        response.addCookie(cEmail);
        response.addCookie(cRem);
    }

    private void redirectUser(User user, HttpServletResponse response, String contextPath) throws IOException {
        int role = user.getRoleId();
        if (role == 1) {
            response.sendRedirect(contextPath + "/admin/dashboard");
        } else if (role == 3) {
            response.sendRedirect(contextPath + "/receptionist/dashboard");
        } else if (role == 4) {
            response.sendRedirect(contextPath + "/view/staff/dashboard.jsp");
        } else {
            response.sendRedirect(contextPath + "/home");
        }
    }
}