package controller.manager;

import dal.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Room;

@WebServlet(name = "UpdateRoomServlet", urlPatterns = {"/manager/room-registry/update"})
public class UpdateRoomServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomIdRaw = request.getParameter("id");

        try {
            int roomId = Integer.parseInt(roomIdRaw);

            Room room = roomDAO.getRoomById(roomId);
            if (room == null) {
                response.sendRedirect(request.getContextPath() + "/manager/room-registry");
                return;
            }

            request.setAttribute("room", room);
            request.setAttribute("roomTypeList", roomDAO.getAllRoomTypes());

            request.getRequestDispatcher("/view/manager/update-room.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/manager/room-registry");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        List<String> errorList = new ArrayList<>();

        String roomIdRaw = request.getParameter("roomId");
        String roomNo = request.getParameter("roomNo");
        String roomTypeIdRaw = request.getParameter("roomTypeId");
        String floorRaw = request.getParameter("floor");
        String statusRaw = request.getParameter("status");

        int roomId = 0;
        int roomTypeId = 0;
        int floor = 0;
        int status = 0;

        Room room = new Room();

        try {
            roomId = Integer.parseInt(roomIdRaw);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/manager/room-registry");
            return;
        }

        if (roomNo == null || roomNo.trim().isEmpty()) {
            errorList.add("Room number is required.");
        } else {
            roomNo = roomNo.trim();
        }

        try {
            roomTypeId = Integer.parseInt(roomTypeIdRaw);
            if (!roomDAO.isRoomTypeExists(roomTypeId)) {
                errorList.add("Selected room type does not exist.");
            }
        } catch (Exception e) {
            errorList.add("Room type is invalid.");
        }

        try {
            floor = Integer.parseInt(floorRaw);
            if (floor < 1) {
                errorList.add("Floor must be greater than or equal to 1.");
            }
        } catch (Exception e) {
            errorList.add("Floor is invalid.");
        }

        try {
            status = Integer.parseInt(statusRaw);
            if (status < 1 || status > 4) {
                errorList.add("Status is invalid.");
            }
        } catch (Exception e) {
            errorList.add("Status is invalid.");
        }

        if (roomNo != null && !roomNo.isEmpty() && roomDAO.isRoomNoExistsForOtherRoom(roomNo, roomId)) {
            errorList.add("Room number already exists.");
        }

        room.setRoomId(roomId);
        room.setRoomNo(roomNo);
        room.setRoomTypeId(roomTypeId);
        room.setFloor(floor);
        room.setStatus(status);

        if (!errorList.isEmpty()) {
            request.setAttribute("errorList", errorList);
            request.setAttribute("room", room);
            request.setAttribute("roomTypeList", roomDAO.getAllRoomTypes());
            request.getRequestDispatcher("/view/manager/update-room.jsp").forward(request, response);
            return;
        }

        boolean updated = roomDAO.updateRoom(room);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/manager/room-registry");
        } else {
            errorList.add("Update room failed. Please try again.");
            request.setAttribute("errorList", errorList);
            request.setAttribute("room", room);
            request.setAttribute("roomTypeList", roomDAO.getAllRoomTypes());
            request.getRequestDispatcher("/view/manager/update-room.jsp").forward(request, response);
        }
    }
}