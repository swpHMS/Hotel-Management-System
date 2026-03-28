package controller.staff.serviceorder;

import dal.Staff_ServiceOrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ServiceOrder;
import model.User;

@WebServlet(name="StaffServiceOrderStatusServlet", urlPatterns={"/staff/service-orders/status"})
public class StaffServiceOrderStatusServlet extends HttpServlet {

    private final Staff_ServiceOrderDAO dao = new Staff_ServiceOrderDAO();

    private int parseInt(String s, int def){
        try { return Integer.parseInt(s); } catch(Exception e){ return def; }
    }

    private long parseLong(String s, long def){
        try { return Long.parseLong(s); } catch(Exception e){ return def; }
    }

    private Integer getLoginStaffId(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return null;
        }

        User user = (User) session.getAttribute("userAccount");
        if (user == null) {
            return null;
        }

        return dao.getStaffIdByUserId(user.getUserId());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        int orderId = parseInt(req.getParameter("orderId"), -1);

        if (orderId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/staff/service-orders");
            return;
        }

        if ("qty".equals(action)) {
            long itemId = parseLong(req.getParameter("itemId"), -1);
            int delta = parseInt(req.getParameter("delta"), 0);

            ServiceOrder order = dao.getOrderWithItems(orderId);
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

        } else if ("finish".equals(action)) {
            Integer staffId = getLoginStaffId(req);
            if (staffId != null) {
                dao.markFinished(orderId, staffId);
            }

        } else if ("cancel".equals(action)) {
            Integer staffId = getLoginStaffId(req);
            if (staffId != null) {
                dao.cancelDraft(orderId, staffId);
            }
        }

        resp.sendRedirect(req.getContextPath() + "/staff/service-orders?id=" + orderId);
    }
}