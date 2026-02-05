package Filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {"/*"})
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // 1) ALLOW static resources
        if (path.startsWith("/assets/")
                || path.startsWith("/img/")
                || path.contains("/img/")
                || path.endsWith(".css")
                || path.endsWith(".js")
                || path.endsWith(".jpg")
                || path.endsWith(".jpeg")
                || path.endsWith(".png")
                || path.endsWith(".gif")
                || path.endsWith(".webp")
                || path.endsWith(".svg")
                || path.endsWith(".ico")) {
            chain.doFilter(request, response);
            return;
        }

        // 2) Public pages (no login required)
        boolean isPublicPage =
                path.equals("/") ||
                path.equals("/home") ||
                path.equals("/login") ||
                path.equals("/register") ||
                path.startsWith("/view/auth/") ||
                path.contains("/verify") ||
                path.contains("/forgot-password") ||
                path.contains("/reset-password");

        if (isPublicPage) {
            chain.doFilter(request, response);
            return;
        }

        // 3) Require login for non-public pages
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("userAccount") : null;

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int roleId = user.getRoleId();

        // 4) Authorization rules

        // 4.1) Admin/Staff area: only roles 1..4
        if (path.startsWith("/admin") || path.startsWith("/staff") || path.startsWith("/management")) {
            if (roleId >= 1 && roleId <= 4) {
                chain.doFilter(request, response);
            } else {
                // customer -> kick to home (or customer dashboard if you want)
                res.sendRedirect(req.getContextPath() + "/home");
            }
            return;
        }

        // 4.2) Customer area: only role 5
        if (path.startsWith("/customer")) {
            if (roleId == 5) {
                chain.doFilter(request, response);
            } else {
                // staff/admin -> kick to home (or admin dashboard)
                res.sendRedirect(req.getContextPath() + "/home");
            }
            return;
        }

        // 5) Other paths: allow by default (already logged in)
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
