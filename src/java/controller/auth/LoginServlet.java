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

        // 1. Xử lý phản hồi từ Google OAuth (Login with Google)
        if (code != null && !code.isEmpty()) {
            try {
                String accessToken = GoogleUtils.getToken(code);
                GoogleUserDTO googleUser = GoogleUtils.getUserInfo(accessToken);
                UserDAO dao = new UserDAO();
                User user = dao.getUserByEmail(googleUser.getEmail());

                // Nếu Email Google chưa có trong DB -> Đăng ký tự động
                if (user == null) {
                    dao.registerGoogleUser(googleUser);
                    user = dao.getUserByEmail(googleUser.getEmail());
                }

                // Kiểm tra trạng thái tài khoản
                if (user != null && user.getStatus() == 1) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userAccount", user);
                    
                    // Duy trì session Google (ví dụ 1 ngày)
                    session.setMaxInactiveInterval(24 * 60 * 60); 
                    
                    redirectUser(user, response, contextPath);
                } else {
                    // Nếu tài khoản bị khóa (status = 0)
                    response.sendRedirect(contextPath + "/view/auth/login.jsp?error=account_locked");
                }
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(contextPath + "/view/auth/login.jsp?error=google_failed");
                return;
            }
        }

        // 2. Đọc Cookie để điền Email vào form (Remember Me)
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("cookEmail")) request.setAttribute("email", c.getValue());
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
        String remember = request.getParameter("remember");
        String contextPath = request.getContextPath();

        try {
            UserDAO dao = new UserDAO();
            // checkLogin xử lý so sánh BCrypt và trả về User nếu đúng
            User user = dao.checkLogin(email, password);

            if (user != null) {
                // KIỂM TRA TRẠNG THÁI (Nếu status = 0 thì không cho vào)
                if (user.getStatus() == 0) {
                    request.setAttribute("error", "Tài khoản của bạn chưa được xác thực email!");
                    request.setAttribute("email", email);
                    request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
                    return;
                }

                // 3. ĐĂNG NHẬP THÀNH CÔNG -> Tạo Session
                // 3. ĐĂNG NHẬP THÀNH CÔNG -> Tạo Session
HttpSession session = request.getSession(true);
session.setAttribute("userAccount", user);

// (khuyên) giữ session lâu hơn nếu muốn
session.setMaxInactiveInterval(24 * 60 * 60);


                // Xử lý Cookie "Remember Me" (Chỉ lưu Email, không lưu Password)
                Cookie cEmail = new Cookie("cookEmail", email);
                Cookie cRem = new Cookie("cookRem", "checked");
                
                cEmail.setPath("/");
                cRem.setPath("/");

                if (remember != null) {
                    int age = 60 * 60 * 24 * 7; // Lưu 7 ngày
                    cEmail.setMaxAge(age);
                    cRem.setMaxAge(age);
                } else {
                    cEmail.setMaxAge(0); // Xóa cookie nếu không tích
                    cRem.setMaxAge(0);
                }
                
                response.addCookie(cEmail);
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

    // Hàm điều hướng dựa trên Role ID thực tế từ Database của bạn
    private void redirectUser(User user, HttpServletResponse response, String contextPath) throws IOException {
        int role = user.getRoleId();
        
        if (role == 1) { // ADMIN
            response.sendRedirect(contextPath + "/admin/dashboard");
        } else if (role >= 2 && role <= 4) { // MANAGER, RECEPTIONIST, STAFF
            response.sendRedirect(contextPath + "/staff/management");
        } else { // CUSTOMER (Role 5)
            response.sendRedirect(contextPath + "/home");
        }
    }
}