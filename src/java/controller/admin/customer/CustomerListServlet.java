package controller.admin.customer;

import dal.AdminCustomerDAO;
import model.CustomerProfile;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerListServlet", urlPatterns = {"/admin/customers"})
public class CustomerListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String q = req.getParameter("q");
            q = (q == null) ? null : q.trim();

            String genderStr = req.getParameter("gender");  // all|1|2|3
            String status = req.getParameter("status");     // all|ACTIVE|INACTIVE|NO_ACCOUNT

            int page = parseInt(req.getParameter("page"), 1);
            int size = parseInt(req.getParameter("size"), 10);

            Integer gender = null;
            if (genderStr != null && !genderStr.equalsIgnoreCase("all") && !genderStr.isBlank()) {
                gender = Integer.parseInt(genderStr);
            }

            AdminCustomerDAO dao = new AdminCustomerDAO();
            List<CustomerProfile> customers = dao.searchCustomers(q, gender, status, page, size);
            int total = dao.countCustomers(q, gender, status);
            int totalPages = (int) Math.ceil((double) total / size);

            req.setAttribute("customers", customers);
            req.setAttribute("total", total);
            req.setAttribute("page", page);
            req.setAttribute("size", size);
            req.setAttribute("totalPages", totalPages);

            req.setAttribute("q", q);
            req.setAttribute("gender", genderStr == null ? "all" : genderStr);
            req.setAttribute("status", status == null ? "all" : status);

            req.getRequestDispatcher("/view/admin/customer_list.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }
}
