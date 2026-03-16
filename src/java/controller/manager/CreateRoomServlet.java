/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.manager;

import dal.RoomDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import model.Room;

/**
 *
 * @author ASUS
 */
@WebServlet(name = "CreateRoomServlet", urlPatterns = {"/manager/room-registry/create"})
public class CreateRoomServlet extends HttpServlet {

    private static final int MAX_BULK_ROOMS = 200;
    private final RoomDAO dao = new RoomDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CreateRoomServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateRoomServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadRoomTypes(request);
        request.getRequestDispatcher("/view/manager/create-room-entry.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String mode = request.getParameter("mode");
        if (mode == null || mode.trim().isEmpty()) {
            mode = "single";
        }

        if ("bulk".equals(mode)) {
            handleBulkCreate(request, response);
        } else {
            handleSingleCreate(request, response);
        }
    }

    private void handleSingleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();

        String roomNo = safeTrim(request.getParameter("roomNo"));
        String roomTypeIdRaw = safeTrim(request.getParameter("roomTypeId"));
        String floorRaw = safeTrim(request.getParameter("floor"));
        String statusRaw = safeTrim(request.getParameter("status"));

        if (roomNo.isEmpty()) {
            errors.add("Room number is required.");
        }

        if (!roomNo.isEmpty() && !roomNo.matches("^\\d{1,4}$")) {
            errors.add("Room number must contain only digits and have at most 4 digits.");
        }

        int floor = parseInt(floorRaw, -1);
        if (floor <= 0 || floor >= 99) {
            errors.add("Floor must be greater than 0 and less than 99.");
        }

        int roomTypeId = parseInt(roomTypeIdRaw, -1);
        if (roomTypeId <= 0) {
            errors.add("Please select a room type.");
        } else if (!dao.isRoomTypeExists(roomTypeId)) {
            errors.add("Selected room type does not exist.");
        }

        int status = parseInt(statusRaw, -1);
        if (!isValidStatus(status)) {
            errors.add("Invalid room status.");
        }

        if (floor > 0 && floor < 99 && roomNo.matches("^\\d{1,4}$")) {
            if (!roomNo.startsWith(String.valueOf(floor))) {
                errors.add("Room number must match the floor. Example: floor " + floor
                        + " should use room numbers starting with " + floor + ".");
            }
        }

        if (roomNo.matches("^\\d{1,4}$") && dao.isRoomNoExists(roomNo)) {
            errors.add("Room number already exists.");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errorList", errors);
            request.setAttribute("activeMode", "single");
            loadRoomTypes(request);
            request.getRequestDispatcher("/view/manager/create-room-entry.jsp").forward(request, response);
            return;
        }

        Room room = new Room();
        room.setRoomNo(roomNo);
        room.setRoomTypeId(roomTypeId);
        room.setFloor(floor);
        room.setStatus(status);

        boolean ok = dao.createRoom(room);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/manager/room-registry?success=created");
        } else {
            errors.add("Failed to create room.");
            request.setAttribute("errorList", errors);
            request.setAttribute("activeMode", "single");
            loadRoomTypes(request);
            request.getRequestDispatcher("/view/manager/create-room-entry.jsp").forward(request, response);
        }
    }

    private void handleBulkCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();

        String roomTypeIdRaw = safeTrim(request.getParameter("bulkRoomTypeId"));
        String floorRaw = safeTrim(request.getParameter("bulkFloor"));
        String statusRaw = safeTrim(request.getParameter("bulkStatus"));
        String startRoomNoRaw = safeTrim(request.getParameter("startRoomNo"));
        String endRoomNoRaw = safeTrim(request.getParameter("endRoomNo"));

        int floor = parseInt(floorRaw, -1);
        if (floor <= 0 || floor >= 99) {
            errors.add("Floor must be greater than 0 and less than 99.");
        }

        int roomTypeId = parseInt(roomTypeIdRaw, -1);
        if (roomTypeId <= 0) {
            errors.add("Please select a room type.");
        } else if (!dao.isRoomTypeExists(roomTypeId)) {
            errors.add("Selected room type does not exist.");
        }

        int status = parseInt(statusRaw, -1);
        if (!isValidStatus(status)) {
            errors.add("Invalid room status.");
        }

        if (startRoomNoRaw.isEmpty()) {
            errors.add("Start room number is required.");
        }
        if (endRoomNoRaw.isEmpty()) {
            errors.add("End room number is required.");
        }

        if (!startRoomNoRaw.isEmpty() && !startRoomNoRaw.matches("^\\d{1,4}$")) {
            errors.add("Start room number must contain only digits and have at most 4 digits.");
        }
        if (!endRoomNoRaw.isEmpty() && !endRoomNoRaw.matches("^\\d{1,4}$")) {
            errors.add("End room number must contain only digits and have at most 4 digits.");
        }

        int startRoomNo = -1;
        int endRoomNo = -1;

        if (errors.isEmpty()) {
            startRoomNo = Integer.parseInt(startRoomNoRaw);
            endRoomNo = Integer.parseInt(endRoomNoRaw);

            if (startRoomNo > endRoomNo) {
                errors.add("Start room number must be less than or equal to end room number.");
            }

            int totalRooms = endRoomNo - startRoomNo + 1;
            if (totalRooms > MAX_BULK_ROOMS) {
                errors.add("You can create at most " + MAX_BULK_ROOMS + " rooms at one time.");
            }

            String floorPrefix = String.valueOf(floor);
            if (!startRoomNoRaw.startsWith(floorPrefix) || !endRoomNoRaw.startsWith(floorPrefix)) {
                errors.add("Start room number and end room number must match the selected floor.");
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errorList", errors);
            request.setAttribute("activeMode", "bulk");
            loadRoomTypes(request);
            request.getRequestDispatcher("/view/manager/create-room-entry.jsp").forward(request, response);
            return;
        }

        List<String> createdRooms = new ArrayList<>();
        List<String> skippedRooms = new ArrayList<>();

        for (int i = startRoomNo; i <= endRoomNo; i++) {
            String roomNo = String.valueOf(i);

            if (!roomNo.startsWith(String.valueOf(floor))) {
                skippedRooms.add(roomNo);
                continue;
            }

            if (dao.isRoomNoExists(roomNo)) {
                skippedRooms.add(roomNo);
                continue;
            }

            Room room = new Room();
            room.setRoomNo(roomNo);
            room.setRoomTypeId(roomTypeId);
            room.setFloor(floor);
            room.setStatus(status);

            boolean ok = dao.createRoom(room);
            if (ok) {
                createdRooms.add(roomNo);
            } else {
                skippedRooms.add(roomNo);
            }
        }

        // Sync lại 1 lần nữa cho chắc theo COUNT(*) thực tế
        if (!createdRooms.isEmpty()) {
            dao.syncInventoryTotalRoomsByRoomType(roomTypeId);
        }

        request.setAttribute("activeMode", "bulk");
        request.setAttribute("successMessage", "Created " + createdRooms.size() + " room(s) successfully.");
        request.setAttribute("createdRooms", createdRooms);
        request.setAttribute("skippedRooms", skippedRooms);

        loadRoomTypes(request);
        request.getRequestDispatcher("/view/manager/create-room-entry.jsp").forward(request, response);
    }

    private void loadRoomTypes(HttpServletRequest request) {
        List<Room> roomTypeList = dao.getAllRoomTypes();
        request.setAttribute("roomTypeList", roomTypeList);
    }

    private String safeTrim(String s) {
        return s == null ? "" : s.trim();
    }

    private int parseInt(String s, int defaultValue) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private boolean isValidStatus(int status) {
        return status == 1 || status == 2 || status == 3 || status == 4;
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}