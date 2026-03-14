package controller.staff.serviceorder;

import dal.Staff_ServiceOrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
@WebServlet(name="StaffServiceOrderStatusServlet", urlPatterns={"/staff/service-orders/status"})
public class StaffServiceOrderStatusServlet extends HttpServlet {

    private final Staff_ServiceOrderDAO dao = new Staff_ServiceOrderDAO();

    private int parseInt(String s, int def){
        try { return Integer.parseInt(s); } catch(Exception e){ return def; }
    }
    private long parseLong(String s, long def){
        try { return Long.parseLong(s); } catch(Exception e){ return def; }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        int orderId = parseInt(req.getParameter("orderId"), -1);

        if ("qty".equals(action)) {
            long itemId = parseLong(req.getParameter("itemId"), -1);
            int delta = parseInt(req.getParameter("delta"), 0);

            // lấy order hiện tại để biết qty cũ
            var order = dao.getOrderWithItems(orderId);
            if (order != null && order.getStatus() == 0) {
                order.getItems().stream()
                    .filter(i -> i.getServiceOrderItemId() == itemId)
                    .findFirst()
                    .ifPresent(i -> {
                        int newQty = i.getQuantity() + delta;
                        if (newQty < 1) newQty = 1;
                        dao.updateItemQuantityDraft(itemId, newQty);
                    });
            }

        } else if ("remove".equals(action)) {
            long itemId = parseLong(req.getParameter("itemId"), -1);
            dao.removeItemDraft(itemId);

        } else if ("post".equals(action)) {
            dao.markPosted(orderId);

        } else if ("cancel".equals(action)) {
            dao.cancelDraft(orderId);
        }

        resp.sendRedirect(req.getContextPath() + "/staff/service-orders?id=" + orderId);
    }
}