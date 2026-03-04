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
 * Servlet xử lý quy trình Check-in chi tiết: Gán phòng và khai báo khách lưu trú.
 * @author ASUS
 */
@WebServlet(name = "CheckInServlet", urlPatterns = {"/receptionist/assign-room", "/receptionist/finalize-checkin"})
public class CheckInServlet extends HttpServlet {

    /**
     * Phương thức GET: Hiển thị trang chi tiết Check-in
     */
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

            // 1. Lấy thông tin tóm tắt đơn đặt (Cột trái)
            BookingDashboard booking = dao.getBookingById(bookingId);

            // 2. Lấy danh sách yêu cầu gán phòng cho đơn đặt này (Cột phải)
            List<StayRoomAssignment> assignments = dao.getAssignmentsByBooking(bookingId);

            // 3. Lấy danh sách tất cả các số phòng thực tế đang trống (Available)
            List<Room> availableRooms = dao.getAvailableRooms();

            // Đẩy dữ liệu sang trang JSP
            request.setAttribute("booking", booking);
            request.setAttribute("assignments", assignments);
            request.setAttribute("availableRooms", availableRooms);

            request.getRequestDispatcher("/view/receptionist/checkin-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard");
        }
    }

    /**
     * Phương thức POST: Xử lý hoàn tất Check-in khi nhấn nút Finalize
     */
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

        // Lấy lại danh sách assignments để quét dữ liệu từ Form gửi về
        List<StayRoomAssignment> assignments = dao.getAssignmentsByBooking(bookingId);
        Map<Integer, Integer> roomAssignmentsMap = new HashMap<>();

        for (StayRoomAssignment asm : assignments) {
            // Lấy ID phòng đã được chọn từ input hidden "roomAssign_{id}" trong JSP
            String roomIdRaw = request.getParameter("roomAssign_" + asm.getAssignmentId());
            if (roomIdRaw != null && !roomIdRaw.isEmpty()) {
                roomAssignmentsMap.put(asm.getAssignmentId(), Integer.parseInt(roomIdRaw));
            }
        }

        // Gọi hàm Transaction trong DAO để cập nhật trạng thái đồng thời nhiều bảng
        boolean success = dao.finalizeCheckIn(bookingId, roomAssignmentsMap);

        if (success) {
            // Chuyển hướng về Dashboard kèm thông báo thành công
            response.sendRedirect("dashboard?status=checkin_success");
        } else {
            // Nếu lỗi, quay lại trang gán phòng và báo lỗi
            response.sendRedirect("assign-room?bookingId=" + bookingId + "&error=finalize_failed");
        }
    }

    @Override
    public String getServletInfo() {
        return "Check-in Detail Controller";
    }
}