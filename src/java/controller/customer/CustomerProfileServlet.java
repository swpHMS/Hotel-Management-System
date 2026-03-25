package controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CustomerProfileServlet", urlPatterns = {"/customer/profile"})
public class CustomerProfileServlet extends HttpServlet {

    private final CustomerPageSupport pageSupport = new CustomerPageSupport();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = pageSupport.requireUserId(request, response);
        if (userId == null) {
            return;
        }

        pageSupport.prepareViewProfile(request, userId);
        pageSupport.forwardLayout(request, response);
    }
}
