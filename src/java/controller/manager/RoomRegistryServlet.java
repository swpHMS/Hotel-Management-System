package controller.manager;

import dal.RoomDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Room;

@WebServlet(name = "RoomRegistryServlet", urlPatterns = {"/manager/room-registry"})
public class RoomRegistryServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RoomRegistryServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RoomRegistryServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String roomType = request.getParameter("roomType");

        String pageStr = request.getParameter("page");
        int pageIndex = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);

        String sizeStr = request.getParameter("pageSize");
        int pageSize = (sizeStr == null || sizeStr.isEmpty()) ? 10 : Integer.parseInt(sizeStr);

        RoomDAO dao = new RoomDAO();

        List<Room> list = dao.searchRoom(keyword, status, roomType, pageIndex, pageSize);
        int totalRooms = dao.getTotalRoomCount(keyword, status, roomType);
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

        // NEW: load room type dropdown từ database
        List<Room> roomTypeList = dao.getAllRoomTypes();

        request.setAttribute("listR", list);
        request.setAttribute("roomTypeList", roomTypeList);

        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);

        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("roomType", roomType);
        request.setAttribute("active", "roomRegistry");

        request.getRequestDispatcher("/view/manager/room-registry.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}