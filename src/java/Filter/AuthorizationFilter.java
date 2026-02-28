package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.util.Set;

@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {"/*"})
public class AuthorizationFilter implements Filter {

    // Các route public (không cần login)
    private static final Set<String> PUBLIC_PREFIX = Set.of(
            "/home", "/login", "/register", "/logout",
            "/rooms", "/contact"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length()); // path tương đối trong app

        // 1) Bypass static/resources
        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 2) Cho phép public routes
        if (isPublic(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 3) Lấy userAccount từ session (login hoàn chỉnh sẽ set cái này)
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("userAccount") : null;

        boolean isAdminArea = path.startsWith("/admin/");
        boolean isCustomerArea = path.startsWith("/customer/");

        // 4) Chặn khu vực cần login
        if ((isAdminArea || isCustomerArea) && user == null) {
            res.sendRedirect(contextPath + "/login");
            return;
        }

        // 5) Chặn admin nếu không phải role admin (roleId = 1)
        if (isAdminArea) {
            if (user == null || user.getRoleId() != 1) {
                res.sendRedirect(contextPath + "/home");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private boolean isPublic(String path) {
        if (path == null || path.isEmpty() || "/".equals(path)) return true;

        for (String p : PUBLIC_PREFIX) {
            if (path.equals(p) || path.startsWith(p + "/")) return true;
        }
        return false;
    }

    private boolean isStaticResource(String path) {
        if (path == null) return false;
        String u = path.toLowerCase();

        return u.startsWith("/assets/") || u.startsWith("/static/")
                || u.endsWith(".css") || u.endsWith(".js")
                || u.endsWith(".png") || u.endsWith(".jpg") || u.endsWith(".jpeg") || u.endsWith(".gif")
                || u.endsWith(".svg") || u.endsWith(".ico")
                || u.endsWith(".woff") || u.endsWith(".woff2") || u.endsWith(".ttf")
                || u.endsWith(".map");
    }

    @Override
    public void destroy() {}
}
