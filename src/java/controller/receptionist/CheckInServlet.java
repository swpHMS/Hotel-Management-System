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

/**
 * Servlet xử lý quy trình Check-in chi tiết: Gán phòng, Upgrade và khai báo khách.
 * @author Minh Đức
 */
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
            List<StayRoomAssignment> assignments = dao.getAssignmentsByBooking(bookingId);
            // Phương thức này giờ đã JOIN lấy giá và tên loại phòng
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
        List<StayRoomAssignment> assignments = dao.getAssignmentsByBooking(bookingId);
        
        Map<Integer, Integer> roomAssignmentsMap = new HashMap<>();
        Map<Integer, List<String[]>> occupantsMap = new HashMap<>();
        Map<Integer, Double> upgradeFeesMap = new HashMap<>(); // THÊM MAP PHÍ NÂNG CẤP

        for (StayRoomAssignment asm : assignments) {
            int asmId = asm.getAssignmentId();

            // 1. Lấy ID phòng thực tế gán (Bắt buộc)
            String roomIdRaw = request.getParameter("roomAssign_" + asmId);
            if (roomIdRaw == null || roomIdRaw.isEmpty()) {
                response.sendRedirect("assign-room?bookingId=" + bookingId + "&error=missing_room");
                return;
            }
            roomAssignmentsMap.put(asmId, Integer.parseInt(roomIdRaw));

            // 2. Lấy phí nâng cấp (Nếu khách sạn tặng thì bằng 0, nếu khách yêu cầu thì > 0)
            String upgradeFeeRaw = request.getParameter("upgradeFee_" + asmId);
            double fee = 0;
            try {
                if (upgradeFeeRaw != null) fee = Double.parseDouble(upgradeFeeRaw);
            } catch (NumberFormatException e) { fee = 0; }
            upgradeFeesMap.put(asmId, fee);

            // 3. Lấy danh sách khách lưu trú (Occupants)
            String[] names = request.getParameterValues("occName_" + asmId);
            String[] ids = request.getParameterValues("occId_" + asmId);

            if (names != null && ids != null) {
                List<String[]> guestList = new ArrayList<>();
                for (int i = 0; i < names.length; i++) {
                    if (names[i] != null && !names[i].trim().isEmpty()) {
                        guestList.add(new String[]{names[i].trim(), ids[i].trim()});
                    }
                }
                // Ràng buộc: Mỗi phòng ít nhất 1 khách
                if (guestList.isEmpty()) {
                    response.sendRedirect("assign-room?bookingId=" + bookingId + "&error=missing_occupant");
                    return;
                }
                occupantsMap.put(asmId, guestList);
            } else {
                response.sendRedirect("assign-room?bookingId=" + bookingId + "&error=missing_occupant");
                return;
            }
        }

        // Gọi hàm DAO đã sửa để thực hiện Transaction cộng phí nâng cấp vào hóa đơn
        boolean success = dao.finalizeCheckIn(bookingId, roomAssignmentsMap, occupantsMap, upgradeFeesMap);

        if (success) {
            response.sendRedirect("dashboard?status=checkin_success");
        } else {
            response.sendRedirect("assign-room?bookingId=" + bookingId + "&error=finalize_failed");
        }
    }
}