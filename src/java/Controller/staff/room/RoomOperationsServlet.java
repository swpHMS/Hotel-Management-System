package controller.staff.room;

import dal.StaffRoomDAO;
import model.StaffRoomItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "RoomOperationsServlet", urlPatterns = {"/staff/room-operations"})
public class RoomOperationsServlet extends HttpServlet {

    private final StaffRoomDAO dao = new StaffRoomDAO();

    private Integer parseStatus(String s) {
        try {
            if (s == null || s.trim().isEmpty() || "all".equalsIgnoreCase(s)) {
                return null;
            }
            return Integer.parseInt(s);
        } catch (Exception e) {
            return null;
        }
    }

    private int parsePositiveInt(String s, int defaultValue) {
        try {
            int value = Integer.parseInt(s);
            return value > 0 ? value : defaultValue;
        } catch (Exception e) {
            return defaultValue;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");
            Integer status = parseStatus(request.getParameter("status"));

            int page = parsePositiveInt(request.getParameter("page"), 1);
            int pageSize = parsePositiveInt(request.getParameter("pageSize"), 10);

            if (pageSize != 10 && pageSize != 20 && pageSize != 50) {
                pageSize = 10;
            }

            int totalRooms = dao.countRooms(keyword, status);
            int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

            if (totalPages == 0) {
                totalPages = 1;
            }

            if (page > totalPages) {
                page = totalPages;
            }

            List<StaffRoomItem> rooms = dao.getRooms(keyword, status, page, pageSize);

            HttpSession session = request.getSession();
            Set<Integer> cleaningRooms = (Set<Integer>) session.getAttribute("cleaningRooms");
            if (cleaningRooms == null) {
                cleaningRooms = new HashSet<>();
                session.setAttribute("cleaningRooms", cleaningRooms);
            }

            request.setAttribute("rooms", rooms);
            request.setAttribute("keyword", keyword);
            request.setAttribute("selectedStatus", request.getParameter("status"));

            request.setAttribute("dirtyCount", dao.countByStatus(4));
            request.setAttribute("availableCount", dao.countByStatus(1));
            request.setAttribute("occupiedCount", dao.countByStatus(2));
            request.setAttribute("maintenanceCount", dao.countByStatus(3));
            request.setAttribute("inProgressCount", cleaningRooms.size());

            request.setAttribute("cleaningRooms", cleaningRooms);

            request.setAttribute("page", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/view/staff/room/room-operations.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}