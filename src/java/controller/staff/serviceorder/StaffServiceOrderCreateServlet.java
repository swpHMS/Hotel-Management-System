package controller.staff.serviceorder;

import dal.Staff_ServiceOrderDAO;
import dal.Staff_ServiceOrderDAO.ItemReq;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name="StaffServiceOrderCreateServlet", urlPatterns={"/staff/service-orders/create"})
public class StaffServiceOrderCreateServlet extends HttpServlet {

    private final Staff_ServiceOrderDAO dao = new Staff_ServiceOrderDAO();

    private Integer parseIntOrNull(String s) {
        try {
            if (s == null || s.trim().isEmpty()) return null;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private void loadServiceDropdown(HttpServletRequest req) {
        // service_type: 1 MINIBAR, 2 LAUNDRY, 3 CLEANING, 0 SURCHARGE (theo bạn đang dùng)
        req.setAttribute("svMinibar", dao.listServicesByType(1));
        req.setAttribute("svLaundry", dao.listServicesByType(2));
        req.setAttribute("svCleaning", dao.listServicesByType(3));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        loadServiceDropdown(req);
        req.getRequestDispatcher("/view/staff/serviceorder/createdraft.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        req.setCharacterEncoding("UTF-8");

        Integer bookingId = parseIntOrNull(req.getParameter("bookingId"));
        Integer roomId = parseIntOrNull(req.getParameter("roomId"));

        // staffId từ session
        HttpSession session = req.getSession(false);
        Integer staffId = (session != null) ? (Integer) session.getAttribute("staffId") : null;
        if (staffId == null) staffId = 1;

        // items arrays
        String[] serviceIdsRaw = req.getParameterValues("serviceId");
        String[] qtyRaw = req.getParameterValues("quantity");

        // giữ lại input để JSP refill
        req.setAttribute("bookingIdVal", bookingId);
        req.setAttribute("roomIdVal", roomId);

        if (bookingId == null) {
            loadServiceDropdown(req);
            req.setAttribute("err", "booking_required");
            req.getRequestDispatcher("/view/staff/serviceorder/createdraft.jsp").forward(req, resp);
            return;
        }

        List<ItemReq> items = new ArrayList<>();
        if (serviceIdsRaw != null && qtyRaw != null && serviceIdsRaw.length == qtyRaw.length) {
            for (int i = 0; i < serviceIdsRaw.length; i++) {
                Integer sid = parseIntOrNull(serviceIdsRaw[i]);
                Integer qty = parseIntOrNull(qtyRaw[i]);
                if (sid != null && qty != null && qty > 0) {
                    items.add(new ItemReq(sid, qty));
                }
            }
        }

        if (items.isEmpty()) {
            loadServiceDropdown(req);
            req.setAttribute("err", "items_required");
            req.getRequestDispatcher("/view/staff/serviceorder/createdraft.jsp").forward(req, resp);
            return;
        }

        int newId = dao.createDraftWithItems(bookingId, roomId, staffId, items);
        if (newId <= 0) {
            loadServiceDropdown(req);
            req.setAttribute("err", "create_failed");
            req.getRequestDispatcher("/view/staff/serviceorder/createdraft.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/staff/service-orders?id=" + newId + "&msg=created");
    }
}