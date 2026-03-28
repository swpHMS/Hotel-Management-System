package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CustomerPastStaysServlet", urlPatterns = {"/customer/bookings/past"})
public class CustomerPastStaysServlet extends HttpServlet {

    private final CustomerPageSupport pageSupport = new CustomerPageSupport();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = pageSupport.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        pageSupport.preparePastStays(request, userId);
        pageSupport.forwardLayout(request, response);
    }
}
