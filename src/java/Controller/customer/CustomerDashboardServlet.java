package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CustomerDashboardServlet", urlPatterns = {"/customer/dashboard"})
public class CustomerDashboardServlet extends HttpServlet {

    private final CustomerPageSupport pageSupport = new CustomerPageSupport();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = pageSupport.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        String tab = request.getParameter("tab");
        String target = switch (tab == null ? "" : tab) {
            case CustomerPageSupport.PAGE_PAST -> "/customer/bookings/past";
            case CustomerPageSupport.PAGE_VIEW_PROFILE -> "/customer/profile";
            case CustomerPageSupport.PAGE_EDIT_PROFILE -> "/customer/profile/edit";
            case CustomerPageSupport.PAGE_CHANGE_PASSWORD -> "/customer/change-password";
            case CustomerPageSupport.PAGE_CURRENT, "" -> "/customer/bookings/current";
            default -> "/customer/bookings/current";
        };

        String queryString = request.getQueryString();
        if (queryString != null && !queryString.isBlank()) {
            queryString = queryString.replaceFirst("(^|&)tab=[^&]*&?", "$1").replaceAll("&$", "");
            if (!queryString.isBlank()) {
                target += "?" + queryString;
            }
        }

        response.sendRedirect(request.getContextPath() + target);
    }
}
