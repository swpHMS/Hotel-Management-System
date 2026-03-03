package controller.staff.serviceorder;

import dal.Staff_ServiceOrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author DieuBHHE191686
 */
@WebServlet(name="StaffServiceOrderLookupBookingServlet", urlPatterns={"/staff/service-orders/lookup-booking"})
public class StaffServiceOrderLookupBookingServlet extends HttpServlet {

    private final Staff_ServiceOrderDAO dao = new Staff_ServiceOrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        String roomNo = req.getParameter("roomNo");
        if (roomNo == null || roomNo.trim().isEmpty()) {
            resp.getWriter().write("{\"ok\":false,\"message\":\"Room number is required\"}");
            return;
        }

        var found = dao.findActiveBookingByRoomNo(roomNo.trim());
        if (found == null) {
            resp.getWriter().write("{\"ok\":false,\"message\":\"No IN_HOUSE booking (status=3) for this room\"}");
            return;
        }

        resp.getWriter().write(
            "{\"ok\":true,\"bookingId\":" + found.bookingId() +
            ",\"roomId\":" + found.roomId() +
            ",\"assignmentId\":" + found.assignmentId() + "}"
        );
    }
}