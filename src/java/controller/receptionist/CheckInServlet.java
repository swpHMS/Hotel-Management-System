package controller.receptionist;

import dal.BookingDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.BookingDashboard;
import model.Room;
import model.StayRoomAssignment;

@WebServlet(name = "CheckInServlet", urlPatterns = {"/receptionist/assign-room", "/receptionist/finalize-checkin"})
public class CheckInServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingIdRaw = request.getParameter("bookingId");
        if (bookingIdRaw == null) {
            response.sendRedirect("dashboard");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdRaw);
            BookingDAO dao = new BookingDAO();

            BookingDashboard booking = dao.getBookingById(bookingId);
            List<StayRoomAssignment> assignments = dao.getAssignmentsToCheckIn(bookingId);
            List<Room> availableRooms = dao.getAvailableRooms();

            request.setAttribute("booking", booking);
            request.setAttribute("assignments", assignments);
            request.setAttribute("availableRooms", availableRooms);

            request.getRequestDispatcher("/view/receptionist/checkin-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookingIdRaw = request.getParameter("bookingId");
        if (bookingIdRaw == null) {
            response.sendRedirect("dashboard");
            return;
        }

        int bookingId = Integer.parseInt(bookingIdRaw);
        BookingDAO dao = new BookingDAO();
        List<StayRoomAssignment> assignments = dao.getAssignmentsToCheckIn(bookingId);
        
        Map<Integer, Integer> roomAssignmentsMap = new HashMap<>();
        Map<Integer, List<String[]>> occupantsMap = new HashMap<>();
        Map<Integer, Double> upgradeFeesMap = new HashMap<>();

        for (int i = 0; i < assignments.size(); i++) {
            String suffix = String.valueOf(i); 

          
            String roomIdRaw = request.getParameter("roomAssign_" + suffix);
            
            if (roomIdRaw == null || roomIdRaw.trim().isEmpty()) {
                response.sendRedirect("assign-room?bookingId=" + bookingId + "&error=missing_room_at_slot_" + i);
                return;
            }
            roomAssignmentsMap.put(i, Integer.parseInt(roomIdRaw));

            // 2. Lấy phí nâng cấp
            String upgradeFeeRaw = request.getParameter("upgradeFee_" + suffix);
            double fee = 0;
            try {
                if (upgradeFeeRaw != null) fee = Double.parseDouble(upgradeFeeRaw);
            } catch (Exception e) { fee = 0; }
            upgradeFeesMap.put(i, fee);

            // 3. Lấy thông tin khách
            String[] names = request.getParameterValues("occName_" + suffix);
            String[] ids = request.getParameterValues("occId_" + suffix);

            List<String[]> guestList = new ArrayList<>();
            if (names != null) {
                for (int j = 0; j < names.length; j++) {
                    if (names[j] != null && !names[j].trim().isEmpty()) {
                        String gId = (ids != null && ids.length > j) ? ids[j].trim() : "";
                        guestList.add(new String[]{names[j].trim(), gId});
                    }
                }
            }
            occupantsMap.put(i, guestList);
            System.out.println("Slot " + i + " - Number of guests: " + guestList.size());
        }

        // Thực thi Transaction lưu vào Database
        boolean success = dao.finalizeCheckIn(bookingId, roomAssignmentsMap, occupantsMap, upgradeFeesMap);

        if (success) {
           
            response.sendRedirect("dashboard?status=checkin_success");
        } else {
            response.sendRedirect("assign-room?bookingId=" + bookingId + "&error=finalize_failed");
        }
    }
}