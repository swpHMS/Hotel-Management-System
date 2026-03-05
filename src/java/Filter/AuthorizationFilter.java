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

    private boolean isStaticResource(String uri) {
        return uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png")
                || uri.endsWith(".jpg") || uri.endsWith(".jpeg") || uri.endsWith(".gif")
                || uri.endsWith(".svg") || uri.endsWith(".woff") || uri.endsWith(".woff2")
                || uri.endsWith(".ttf") || uri.endsWith(".ico");
    }

    private boolean mustLogin(String uri) {
        // ✅ CHỈNH Ở ĐÂY: các url mà khách muốn filter/booking thì phải login
        return uri.contains("/booking")
                || uri.contains("/search")
                || uri.contains("/rooms/filter")
                || uri.contains("/room/filter")
                || uri.contains("/room/search")
                || uri.contains("/rooms/search");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        // lấy user từ session (đúng key bạn đang dùng)
        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("userAccount");

        // 1) static files -> cho qua
        if (isStaticResource(uri)) {
            chain.doFilter(request, response);
            return;
        }

        // 2) admin -> chỉ role admin (roleId = 1)
        if (uri.contains("/admin/")) {
            if (user == null || user.getRoleId() != 1) {
                res.sendRedirect(contextPath + "/home");
                return;
            }
        }

        // 3) ✅ booking / filter -> bắt login
        if (mustLogin(uri)) {
            if (user == null) {
                // lưu url để login xong quay lại trang đang filter/booking
                String redirect = req.getRequestURI();
                String qs = req.getQueryString();
                if (qs != null) redirect += "?" + qs;

                req.getSession(true).setAttribute("redirectAfterLogin", redirect);

                res.sendRedirect(contextPath + "/login"); // hoặc /register nếu bạn muốn
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}