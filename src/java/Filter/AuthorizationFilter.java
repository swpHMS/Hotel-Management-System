package Filter;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {"/*"})
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter nếu cần
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        User user = (User) session.getAttribute("userAccount");

        // 1. Nếu chưa có Session, kiểm tra Cookie để tự động đăng nhập (Dùng lâu)
        if (user == null) {
            Cookie[] cookies = req.getCookies();
            String email = null;
            String pass = null;

            if (cookies != null) {
                for (Cookie c : cookies) {
                    if (c.getName().equals("cookEmail")) {
                        email = c.getValue();
                    }
                    if (c.getName().equals("cookPass")) {
                        pass = c.getValue();
                    }
                }
            }

            if (email != null && pass != null) {
                UserDAO dao = new UserDAO();
                user = dao.checkLogin(email, pass);
                if (user != null && user.getStatus() == 1) {
                    session.setAttribute("userAccount", user);
                    // Duy trì session lâu hơn nếu tự động đăng nhập từ cookie
                    session.setMaxInactiveInterval(24 * 60 * 60);
                }
            }
        }

        // 2. Kiểm tra phân quyền truy cập
        String requestURI = req.getRequestURI();
        String contextPath = req.getContextPath();

        // Cho phép truy cập tài nguyên tĩnh (css, js, img)
        if (requestURI.contains("/assets/")) {
            chain.doFilter(request, response);
            return;
        }

        // Cho phép truy cập các trang đăng nhập, đăng ký, quên mật khẩu
        if (requestURI.endsWith("/login")
                || requestURI.endsWith("/register")
                || requestURI.contains("login.jsp")
                || requestURI.contains("register-customer.jsp") // Thêm dòng này
                || requestURI.contains("forgot")
                || requestURI.contains("verify")) { // Thêm cả verify để click mail không bị chặn

            chain.doFilter(request, response);
            return;
        }

        // Kiểm tra quyền vào trang Admin (RoleId = 1)
        if (requestURI.contains("/admin/")) {
            if (user != null && user.getRoleId() == 1) {
                chain.doFilter(request, response);
            } else {
                // Không có quyền hoặc chưa đăng nhập -> Đá về Login
                res.sendRedirect(contextPath + "/login");
            }
            return;
        }

        // Mặc định cho phép các trang khác (như trang chủ) đi tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Giải phóng tài nguyên nếu cần
    }
}
