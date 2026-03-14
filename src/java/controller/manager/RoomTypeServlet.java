package controller.manager;

import dal.RoomTypeDAO;
import model.RoomTypeForm;
import model.RoomTypeManagementView;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;

@WebServlet("/manager/room-types")
public class RoomTypeServlet extends HttpServlet {

    private RoomTypeDAO roomTypeDAO;

    @Override
    public void init() throws ServletException {
        roomTypeDAO = new RoomTypeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                request.getRequestDispatcher("/view/manager/create-room-type.jsp")
                        .forward(request, response);

            } else if ("edit".equals(action)) {
                int roomTypeId = Integer.parseInt(request.getParameter("id"));
                RoomTypeManagementView roomType = roomTypeDAO.getRoomTypeDetail(roomTypeId);
                request.setAttribute("roomType", roomType);
                request.getRequestDispatcher("/view/manager/edit-room-type.jsp")
                        .forward(request, response);

            } else if ("delete".equals(action)) {
                int roomTypeId = Integer.parseInt(request.getParameter("id"));
                roomTypeDAO.updateRoomTypeStatus(roomTypeId, 0);
                response.sendRedirect(request.getContextPath() + "/manager/room-types");

            } else {
                String keyword = request.getParameter("q");
                List<RoomTypeManagementView> roomTypes = roomTypeDAO.searchRoomTypes(keyword);
                request.setAttribute("roomTypes", roomTypes);
                request.setAttribute("totalTypes", roomTypes.size());
                request.getRequestDispatcher("/view/manager/room-types.jsp")
                        .forward(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                RoomTypeForm form = new RoomTypeForm();
                form.setName(request.getParameter("name"));
                form.setDescription(request.getParameter("description"));
                form.setMaxAdult(Integer.parseInt(request.getParameter("maxAdult")));
                form.setMaxChildren(Integer.parseInt(request.getParameter("maxChildren")));
                form.setStatus(Integer.parseInt(request.getParameter("status")));

                roomTypeDAO.insertRoomType(form);
                response.sendRedirect(request.getContextPath() + "/manager/room-types");

            } else if ("update".equals(action)) {
                RoomTypeForm form = new RoomTypeForm();
                form.setRoomTypeId(Integer.parseInt(request.getParameter("roomTypeId")));
                form.setName(request.getParameter("name"));
                form.setDescription(request.getParameter("description"));
                form.setMaxAdult(Integer.parseInt(request.getParameter("maxAdult")));
                form.setMaxChildren(Integer.parseInt(request.getParameter("maxChildren")));
                form.setStatus(Integer.parseInt(request.getParameter("status")));

                roomTypeDAO.updateRoomType(form);
                response.sendRedirect(request.getContextPath() + "/manager/room-types");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}