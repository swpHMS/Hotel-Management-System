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

        boolean validRoomNoFormat = false;
        boolean validFloorFormat = false;

        Room room = new Room();

        try {
            roomId = Integer.parseInt(roomIdRaw);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/manager/room-registry");
            return;
        }

        // Validate roomNo
        if (roomNo == null || roomNo.trim().isEmpty()) {
            errorList.add("Room number is required.");
        } else {
            roomNo = roomNo.trim();

            if (!roomNo.matches("\\d{1,4}")) {
                errorList.add("Room number must contain only digits and have at most 4 digits.");
            } else {
                validRoomNoFormat = true;
            }
        }

        // Validate room type
        try {
            roomTypeId = Integer.parseInt(roomTypeIdRaw);
            if (!roomDAO.isRoomTypeExists(roomTypeId)) {
                errorList.add("Selected room type does not exist.");
            }
        } catch (Exception e) {
            errorList.add("Room type is invalid.");
        }

        // Validate floor
        if (floorRaw == null || floorRaw.trim().isEmpty()) {
            errorList.add("Floor is required.");
        } else {
            try {
                floor = Integer.parseInt(floorRaw.trim());
                if (floor <= 0 || floor >= 99) {
                    errorList.add("Floor must be greater than 0 and less than 99.");
                } else {
                    validFloorFormat = true;
                }
            } catch (Exception e) {
                errorList.add("Floor is invalid.");
            }
        }

        // Validate status
        try {
            status = Integer.parseInt(statusRaw);
            if (status < 1 || status > 4) {
                errorList.add("Status is invalid.");
            }
        } catch (Exception e) {
            errorList.add("Status is invalid.");
        }

        // Check roomNo matches floor only when both formats are valid
        if (validRoomNoFormat && validFloorFormat) {
            int expectedFloor = Integer.parseInt(roomNo.substring(0, 1));

            if (expectedFloor != floor) {
                errorList.add("Room number does not match floor. For example, room "
                        + roomNo + " must be on floor " + expectedFloor + ".");
            }
        }
        // Check duplicate only when roomNo format is valid
        if (validRoomNoFormat && roomDAO.isRoomNoExistsForOtherRoom(roomNo, roomId)) {
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
