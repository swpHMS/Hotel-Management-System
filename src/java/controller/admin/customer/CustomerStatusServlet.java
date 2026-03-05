package controller.admin.customer;

import dal.AdminCustomerDAO;
import model.CustomerProfile;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet(name = "CustomerStatusServlet", urlPatterns = {"/admin/customer-status"})
public class CustomerStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(req.getParameter("id"));

            AdminCustomerDAO dao = new AdminCustomerDAO();
            CustomerProfile c = dao.getCustomerById(id);

            if (c == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/customers");
                return;
            }

            req.setAttribute("c", c);
            req.getRequestDispatcher("/view/admin/customer_status.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String status = req.getParameter("status"); // "ACTIVE" or "INACTIVE"

            int newStatusInt = "ACTIVE".equalsIgnoreCase(status) ? 1 : 0;

            AdminCustomerDAO dao = new AdminCustomerDAO();
            CustomerProfile c = dao.getCustomerById(id);

            if (c == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/customers");
                return;
            }

            // Không có account thì không cho đổi
            if (c.getUserId() == null) {
                req.setAttribute("c", c);
                req.setAttribute("error", "This customer has no account. Cannot change status.");
                req.getRequestDispatcher("/view/admin/customer_status.jsp").forward(req, resp);
                return;
            }

            dao.updateUserStatusByCustomerId(id, newStatusInt);

            // redirect về list
            resp.sendRedirect(req.getContextPath() + "/admin/customers");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
