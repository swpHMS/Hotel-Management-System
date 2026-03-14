package controller.manager;

import dal.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Room;

@WebServlet(name = "RoomDetailServlet", urlPatterns = {"/manager/room-registry/detail"})
public class RoomDetailServlet extends HttpServlet {

    private final RoomDAO dao = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");
        int id;

        try {
            id = Integer.parseInt(idRaw);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/manager/room-registry");
            return;
        }

        Room room = dao.getRoomById(id);
        request.setAttribute("roomDetail", room);
        request.getRequestDispatcher("/view/manager/room-detail.jsp").forward(request, response);
    }
}