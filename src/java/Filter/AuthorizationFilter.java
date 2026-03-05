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
    String uri = req.getRequestURI();
    String contextPath = req.getContextPath();
    User user = (User) req.getSession().getAttribute("userAccount");

    if (uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png") || 
        uri.endsWith(".jpg") || uri.endsWith(".jpeg") || uri.endsWith(".gif")) {
        chain.doFilter(request, response);
        return;
    }


    if (uri.contains("/admin/")) {
        if (user == null || user.getRoleId() != 1) {
            res.sendRedirect(contextPath + "/home");
            return;
        }
    }
    
    if (uri.contains("/manager/")) {
        if (user == null || user.getRoleId() != 2) {
            res.sendRedirect(contextPath + "/home");
            return;
        }
    }

    chain.doFilter(request, response);
    }
    @Override
    public void destroy() {}
}