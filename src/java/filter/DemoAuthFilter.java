package filter;

import dal.CustomerDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.CustomerProfile;
import utils.NameUtils;
import utils.SessionKeys;

@WebFilter(filterName = "DemoAuthFilter", urlPatterns = {"/*"})
public class DemoAuthFilter implements Filter {

    private static final int DEMO_USER_ID = 31; // user giả lập
    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession(true);

        // Chỉ giả lập login 1 lần
        if (session.getAttribute(SessionKeys.SESSION_USER_ID) == null) {

            session.setAttribute(SessionKeys.SESSION_USER_ID, DEMO_USER_ID);

            // Lấy thông tin user từ DB
            CustomerProfile profile = customerDAO.getProfileByUserId(DEMO_USER_ID);

            String fullName = (profile != null && profile.getFullName() != null)
                    ? profile.getFullName()
                    : "USER";

            // Set cho header dùng
            session.setAttribute("userName", fullName);
            session.setAttribute("userInitials", NameUtils.initials(fullName));
        }

        chain.doFilter(request, response);
    }
}
