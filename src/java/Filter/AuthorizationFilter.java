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
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    private boolean isStaticResource(String path) {
        return path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png")
                || path.endsWith(".jpg") || path.endsWith(".jpeg") || path.endsWith(".gif")
                || path.endsWith(".svg") || path.endsWith(".woff") || path.endsWith(".woff2")
                || path.endsWith(".ttf") || path.endsWith(".ico");
    }

    private boolean mustLogin(String path) {
        return path.contains("/booking")
                || path.contains("/search")
                || path.contains("/rooms/filter")
                || path.contains("/room/filter")
                || path.contains("/room/search")
                || path.contains("/rooms/search");
    }

    private boolean isPublicPath(String path) {
        return path.startsWith("/login")
                || path.startsWith("/logout")
                || path.startsWith("/register")
                || path.startsWith("/reset-password")
                || path.startsWith("/verify")
                || path.startsWith("/home")
                || path.startsWith("/policy")
                || path.contains("view/auth");
                
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("userAccount");

        
        if (mustLogin(path)) {
            if (user == null) {
                res.sendRedirect(contextPath + "/login");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        
        if (user == null) {
            res.sendRedirect(contextPath + "/login");
            return;
        }

        int roleId = user.getRoleId();

        // Admin
        if (roleId == 1) {
            chain.doFilter(request, response);
            return;
        }

        // Manager
        if (roleId == 2) {
            if (path.startsWith("/manager")
                    || path.contains("view/staff/profile.jsp")
                    || path.contains("staff-profile")) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(contextPath + "/manager/dashboard");
            }
            return;
        }

        // Receptionist
        if (roleId == 3) {
            if (path.startsWith("/receptionist")
                    || path.contains("view/staff/profile.jsp")
                    || path.contains("staff-profile")) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(contextPath + "/receptionist/dashboard");
            }
            return;
        }

        // Staff
        if (roleId == 4) {
            if (path.startsWith("/staff")
                    || path.contains("view/staff/profile.jsp")
                    || path.contains("staff-profile")) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(contextPath + "/staff");
            }
            return;
        }

        // Customer
        if (roleId == 5) {
            boolean customerAllowed = isPublicPath(path)
                    || mustLogin(path);

            if (customerAllowed) {
                chain.doFilter(request, response);
            } else {
                res.sendRedirect(contextPath + "/home");
            }
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}