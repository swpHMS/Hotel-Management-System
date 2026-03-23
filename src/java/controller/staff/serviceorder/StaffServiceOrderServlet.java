package controller.staff.serviceorder;

import dal.Staff_ServiceOrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.ServiceOrder;

@WebServlet(name = "StaffServiceOrderServlet", urlPatterns = {"/staff/service-orders"})
public class StaffServiceOrderServlet extends HttpServlet {

    private final Staff_ServiceOrderDAO dao = new Staff_ServiceOrderDAO();

    private Integer parseIntNullable(String s) {
        try {
            if (s == null || s.trim().isEmpty()) {
                return null;
            }
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    //tránh trường hợp: URL chọn 1 order ko nằm tập DL filter
    private boolean containsId(List<ServiceOrder> orders, Integer id) {
        if (id == null) {
            return false;
        }
        for (ServiceOrder o : orders) {
            if (o.getServiceOrderId() == id) {
                return true;
            }
        }
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer status = parseIntNullable(req.getParameter("status")); // null = ALL
        String createdDate = req.getParameter("createdDate");
        
        String roomNo = req.getParameter("roomNo");
        if (roomNo != null) {
            roomNo = roomNo.trim();
            if (roomNo.isEmpty()) {
                roomNo = null;
            }
        }
        
        List<ServiceOrder> orders = dao.listOrders(status, roomNo,createdDate);
        req.setAttribute("orders", orders);

        Integer selectedId = parseIntNullable(req.getParameter("id"));
        if (!containsId(orders, selectedId)) {
            selectedId = orders.isEmpty() ? null : orders.get(0).getServiceOrderId();
        }

        ServiceOrder selected = null;
        if (selectedId != null) {
            selected = dao.getOrderWithItems(selectedId);
        }
        String modal = req.getParameter("modal"); // "addItems" or null
        Integer type = parseIntNullable(req.getParameter("type"));
        if (type == null) {
            type = 1;
        }
// chỉ load services khi mở modal
        if ("addItems".equals(modal) && selected != null) {
            req.setAttribute("type", type);

            req.setAttribute("svMinibar", dao.listServicesByType(1));
            req.setAttribute("svLaundry", dao.listServicesByType(2));
            req.setAttribute("svCleaning", dao.listServicesByType(3));
            req.setAttribute("svSurcharge", dao.listServicesByType(0)); // nếu bạn có type=0
        }
        req.setAttribute("modal", modal);
        req.setAttribute("selected", selected);
        req.getRequestDispatcher("/view/staff/serviceorder/list.jsp").forward(req, resp);
    }
}
