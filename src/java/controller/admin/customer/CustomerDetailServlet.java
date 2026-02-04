package controller.admin.customer;

import dal.AdminCustomerDAO;
import model.CustomerProfile;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet(name = "CustomerDetailServlet", urlPatterns = {"/admin/customer-detail"})
public class CustomerDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.isBlank()) {
                resp.sendRedirect(req.getContextPath() + "/admin/customers");
                return;
            }

            int id = Integer.parseInt(idStr);

            AdminCustomerDAO dao = new AdminCustomerDAO();
            CustomerProfile customer = dao.getCustomerById(id);

            if (customer == null) {
                req.setAttribute("error", "Customer not found");
                req.getRequestDispatcher("/view/admin/customer_detail.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("c", customer);
            req.getRequestDispatcher("/view/admin/customer_detail.jsp").forward(req, resp);

        } catch (NumberFormatException nfe) {
            resp.sendRedirect(req.getContextPath() + "/admin/customers");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
