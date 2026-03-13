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

    private boolean isStaticResource(String uri) {
        return uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png")
                || uri.endsWith(".jpg") || uri.endsWith(".jpeg") || uri.endsWith(".gif")
                || uri.endsWith(".svg") || uri.endsWith(".woff") || uri.endsWith(".woff2")
                || uri.endsWith(".ttf") || uri.endsWith(".ico");
    }

    private boolean mustLogin(String uri) {
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

    if (isStaticResource(uri)) {
        chain.doFilter(request, response);
        return;
    }
    
    HttpSession session = req.getSession(false);
    User user = (session == null) ? null : (User) session.getAttribute("userAccount");

    
    if (mustLogin(uri)) {
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        chain.doFilter(request, response);
        return;
    }

    if (uri.contains("/login") || uri.contains("/logout")
            || uri.contains("/register") || uri.contains("/reset-password")
            || uri.contains("/verify") || uri.contains("/home")
            || uri.contains("/policy") || uri.contains("view/auth")) {

        chain.doFilter(request, response);
        return;
    }
    
    if (user == null) {
        res.sendRedirect(contextPath + "/login");
        return;
    }
    
    
    if(user.getRoleId()==1){
        chain.doFilter(request, response);
        return;
    }
    
    if(user.getRoleId()==2){
        if(uri.contains("/manager")  || uri.contains("view/staff/profile.jsp") || uri.contains("staff-profile")
                ){
            chain.doFilter(request, response);
            return;
        }else{
            res.sendRedirect(req.getContextPath()+"/manager/dashboard");
            return;
        }
    }
    
    if(user.getRoleId()==3  ){
        if(uri.contains("/receptionist") || uri.contains("view/staff/profile.jsp") || uri.contains("staff-profile")
                ){
            chain.doFilter(request, response);
            return;
        }else{
            res.sendRedirect(req.getContextPath()+"/receptionist/dashboard");
            return;
        }
    }
    
    if(user.getRoleId()==4){
        if(uri.contains("/staff")  || uri.contains("view/staff/profile.jsp") || uri.contains("staff-profile")){
            chain.doFilter(request, response);
            return;
        }else{
            res.sendRedirect(req.getContextPath()+"/staff");
            return;
        }
    }
    
    if(user.getRoleId()==5){
        chain.doFilter(request, response);
        return;
    }
    
    
    chain.doFilter(request, response);
}

    @Override
    public void destroy() {
    }
}