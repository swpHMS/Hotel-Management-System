package controller.staff.room;

import dal.StaffRoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

@WebServlet(name = "UpdateRoomStatusServlet", urlPatterns = {"/staff/room-operations/update"})
public class UpdateRoomStatusServlet extends HttpServlet {

    private final StaffRoomDAO dao = new StaffRoomDAO();

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        int newStatus = Integer.parseInt(request.getParameter("newStatus"));

        boolean success = dao.updateRoomStatus(roomId, newStatus);
        if (!success) {
            throw new ServletException("Không thể cập nhật trạng thái phòng.");
        }

        HttpSession session = request.getSession();
        Set<Integer> cleaningRooms = (Set<Integer>) session.getAttribute("cleaningRooms");
        if (cleaningRooms != null) {
            cleaningRooms.remove(roomId);
            session.setAttribute("cleaningRooms", cleaningRooms);
        }

        response.sendRedirect(request.getContextPath() + "/staff/room-operations");
    } catch (Exception e) {
        throw new ServletException(e);
    }
}
}