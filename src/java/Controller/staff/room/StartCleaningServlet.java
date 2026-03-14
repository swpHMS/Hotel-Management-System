package controller.staff.room;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

@WebServlet(name = "StartCleaningServlet", urlPatterns = {"/staff/room-operations/start"})
public class StartCleaningServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int roomId = Integer.parseInt(request.getParameter("roomId"));

        HttpSession session = request.getSession();
        Set<Integer> cleaningRooms = (Set<Integer>) session.getAttribute("cleaningRooms");
        if (cleaningRooms == null) {
            cleaningRooms = new HashSet<>();
        }

        cleaningRooms.add(roomId);
        session.setAttribute("cleaningRooms", cleaningRooms);

        response.sendRedirect(request.getContextPath() + "/room/staff/room-operations");
    }
}