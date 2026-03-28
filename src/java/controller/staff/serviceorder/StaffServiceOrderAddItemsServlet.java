package controller.staff.serviceorder;

import dal.Staff_ServiceOrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/*
GET: mở additem_draft.jsp (có orderId)

POST: gọi addItemsToDraft
 */
@WebServlet(name = "StaffServiceOrderAddItemsServlet", urlPatterns = {"/staff/service-orders/add-items"})
public class StaffServiceOrderAddItemsServlet extends HttpServlet {

    private final Staff_ServiceOrderDAO dao = new Staff_ServiceOrderDAO();

    private int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {

        req.setCharacterEncoding("UTF-8");

        int orderId = parseInt(req.getParameter("orderId"), -1);
        int type = parseInt(req.getParameter("type"), 1);
        String note = req.getParameter("note");
        
        String[] serviceIdsRaw = req.getParameterValues("serviceId");
        String[] qtyRaw = req.getParameterValues("quantity");

        // validate
        if (orderId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/staff/service-orders?id=" + orderId + "&msg=invalid");
            return;
        }

        // add từng item (draft-only đã check trong SQL EXISTS status=0)
        // nếu có item thì mới add
        if (serviceIdsRaw != null && qtyRaw != null && serviceIdsRaw.length == qtyRaw.length) {
            for (int i = 0; i < serviceIdsRaw.length; i++) {
                int serviceId = parseInt(serviceIdsRaw[i], -1);
                int qty = parseInt(qtyRaw[i], 1);
                if (qty < 1) {
                    qty = 1;
                }
                if (serviceId > 0) {
                    dao.addItemToDraft2(orderId, serviceId, qty);
                }
            }
        }
// luôn update note (dù có item hay không)
    dao.appendNote(orderId, note);
        // quay lại detail và đóng modal
        resp.sendRedirect(req.getContextPath() + "/staff/service-orders?id=" + orderId + "&msg=items_saved");
    }
}
