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

@WebServlet(name="LoginServlet", urlPatterns={"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String code = request.getParameter("code");
        String contextPath = request.getContextPath();

        // 1. Xử lý đăng nhập Google
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

                HttpSession session = request.getSession();
                session.setAttribute("userAccount", user);
                // Giữ session Google lâu hơn (ví dụ 1 ngày)
                session.setMaxInactiveInterval(24 * 60 * 60); 
                
                redirectUser(user, response, contextPath);
                return;
            } catch (Exception e) {
                response.sendRedirect(contextPath + "/view/auth/login.jsp?error=google_auth_failed");
                return;
            }
        }

        // 2. Đọc Cookie để tự động điền form (Remember Me)
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("cookEmail")) request.setAttribute("email", c.getValue());
                if (c.getName().equals("cookPass")) request.setAttribute("password", c.getValue());
                if (c.getName().equals("cookRem")) request.setAttribute("remember", c.getValue());
            }
        }
        request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember"); // Ô tích "Remember me"
        String contextPath = request.getContextPath();

        try {
            UserDAO dao = new UserDAO();
            User user = dao.checkLogin(email, password);

            if (user != null) {
                if (user.getStatus() == 0) {
                    request.setAttribute("error", "Tài khoản chưa được kích hoạt!");
                    request.setAttribute("email", email);
                    request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
                    return;
                }

                // 3. THIẾT LẬP DÙNG LÂU (COOKIE & SESSION)
                HttpSession session = request.getSession();
                session.setAttribute("userAccount", user);

                // Tạo Cookie
                Cookie cEmail = new Cookie("cookEmail", email);
                Cookie cPass = new Cookie("cookPass", password);
                Cookie cRem = new Cookie("cookRem", "checked");

                if (remember != null) {
                    // LƯU LÂU: 30 ngày (tính bằng giây)
                    int age = 60 * 60 * 24 * 30; 
                    cEmail.setMaxAge(age);
                    cPass.setMaxAge(age);
                    cRem.setMaxAge(age);
                    // Tăng thời gian Session chờ trên server (ví dụ 1 ngày)
                    session.setMaxInactiveInterval(24 * 60 * 60);
                } else {
                    // Xóa cookie nếu không tích chọn
                    cEmail.setMaxAge(0);
                    cPass.setMaxAge(0);
                    cRem.setMaxAge(0);
                }
                
                // Quan trọng: Đặt Path="/" để cookie có tác dụng toàn trang web
                cEmail.setPath("/");
                cPass.setPath("/");
                cRem.setPath("/");
                
                response.addCookie(cEmail);
                response.addCookie(cPass);
                response.addCookie(cRem);

                redirectUser(user, response, contextPath);
            } else {
                request.setAttribute("error", "Email hoặc mật khẩu không chính xác!");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
        }
    }

    private void redirectUser(User user, HttpServletResponse response, String contextPath) throws IOException {
        if (user.getRoleId() == 1) {
            response.sendRedirect(contextPath + "/admin/dashboard");
        } else if (user.getRoleId() == 2) {
            response.sendRedirect(contextPath + "/staff/management");
        } else {
            response.sendRedirect(contextPath + "/view/home.jsp");
        }
    }
}