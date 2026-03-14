package controller.staff.room;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;
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

        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");

        if (status == null || status.isEmpty()) {
            status = "all";
        }
        if (keyword == null) {
            keyword = "";
        }
        if (page == null || page.isEmpty()) {
            page = "1";
        }
        if (pageSize == null || pageSize.isEmpty()) {
            pageSize = "10";
        }

        response.sendRedirect(
                request.getContextPath()
                + "/staff/room-operations?status=" + status
                + "&keyword=" + URLEncoder.encode(keyword, "UTF-8")
                + "&page=" + page
                + "&pageSize=" + pageSize
        );
    }
}