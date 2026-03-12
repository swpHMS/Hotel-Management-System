package controller.receptionist.booking;

import dal.ReceptBookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import model.RoomTypeCard;

@WebServlet(name="ReceptionistBookingCreateServlet", urlPatterns={"/receptionist/booking/create"})
public class ReceptionistBookingCreateServlet extends HttpServlet {

    private final ReceptBookingDAO dao = new ReceptBookingDAO();

    private Integer parseIntOrNull(String s) {
        try { return (s==null||s.trim().isEmpty()) ? null : Integer.parseInt(s.trim()); }
        catch (Exception e) { return null; }
    }

    private Date parseSqlDateOrNull(String s) {
        try { return (s==null||s.trim().isEmpty()) ? null : Date.valueOf(s.trim()); }
        catch (Exception e) { return null; }
    }

    private int clamp(int n, int min, int max) {
        return Math.max(min, Math.min(max, n));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "create_booking");

        LocalDate today = LocalDate.now();
        Date checkIn = parseSqlDateOrNull(req.getParameter("checkIn"));
        Date checkOut = parseSqlDateOrNull(req.getParameter("checkOut"));
        if (checkIn == null) checkIn = Date.valueOf(today.plusDays(1));
        if (checkOut == null) checkOut = Date.valueOf(today.plusDays(2));
        if (!checkIn.before(checkOut)) checkOut = Date.valueOf(checkIn.toLocalDate().plusDays(1));

        int rooms = clamp(parseIntOrNull(req.getParameter("rooms")) == null ? 1 : parseIntOrNull(req.getParameter("rooms")), 1, 10);
        int adults = clamp(parseIntOrNull(req.getParameter("adults")) == null ? 1 : parseIntOrNull(req.getParameter("adults")), 1, 20);
        int children = clamp(parseIntOrNull(req.getParameter("children")) == null ? 0 : parseIntOrNull(req.getParameter("children")), 0, 20);
        Integer roomTypeId = parseIntOrNull(req.getParameter("roomTypeId"));

        // --- THÊM ĐOẠN CODE NÀY ĐỂ QUÉT VÀ NHẢ PHÒNG TRƯỚC KHI TẢI DANH SÁCH ---
        try {
            dao.expireHolds();
        } catch (Exception e) {
            System.out.println("Lỗi khi dọn dẹp Hold hết hạn: " + e.getMessage());
        }
        
        List<RoomTypeCard> cards = dao.getRoomTypeCards(checkIn, checkOut, rooms);

        RoomTypeCard selected = null;
        if (roomTypeId != null) {
            for (RoomTypeCard c : cards) if (c.getRoomTypeId() == roomTypeId) { selected = c; break; }
        }
        if (selected == null && !cards.isEmpty()) selected = cards.get(0);

        long nights = dao.calcNights(checkIn.toLocalDate(), checkOut.toLocalDate());
        long rate = selected != null ? selected.getRatePerNight() : 0;
long total = rate * nights * rooms;

        req.setAttribute("checkIn", checkIn);
        req.setAttribute("checkOut", checkOut);
        req.setAttribute("rooms", rooms);
        req.setAttribute("adults", adults);
        req.setAttribute("children", children);

        req.setAttribute("cards", cards);
        req.setAttribute("roomTypeId", selected != null ? selected.getRoomTypeId() : null);
        req.setAttribute("roomTypeName", selected != null ? selected.getRoomTypeName() : "");
        req.setAttribute("availableRooms", selected != null ? selected.getAvailableRooms() : 0);

        req.setAttribute("nights", nights);
        req.setAttribute("rate", rate);
        req.setAttribute("total", total);

        req.getRequestDispatcher("/view/receptionist/create_booking.jsp").forward(req, resp);
    }

    // POST: NEXT -> create hold
        @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "create_booking");
        
        // 1. Kiểm tra quyền và lấy thông tin người dùng từ Session
        HttpSession session = req.getSession();
        model.User loggedInUser = (model.User) session.getAttribute("userAccount");
        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login"); 
            return; // CHỐT CHẶN: Dừng code ngay lập tức nếu chưa đăng nhập
        }
        int userId = loggedInUser.getUserId(); // Hoặc getUserId() tuỳ theo Model User của bạn

        // 2. Lấy dữ liệu ngày tháng, số lượng từ Form gửi lên
        Date checkIn = parseSqlDateOrNull(req.getParameter("checkIn"));
        Date checkOut = parseSqlDateOrNull(req.getParameter("checkOut"));
        Integer roomsRaw = parseIntOrNull(req.getParameter("rooms"));
        Integer roomTypeId = parseIntOrNull(req.getParameter("roomTypeId"));

        LocalDate today = LocalDate.now();
        if (checkIn == null) checkIn = Date.valueOf(today.plusDays(1));
        if (checkOut == null) checkOut = Date.valueOf(today.plusDays(2));
        if (!checkIn.before(checkOut)) checkOut = Date.valueOf(checkIn.toLocalDate().plusDays(1));
        int rooms = clamp(roomsRaw == null ? 1 : roomsRaw, 1, 10);

        // 3. Kiểm tra Lễ tân đã chọn loại phòng chưa
        if (roomTypeId == null) {
            req.setAttribute("errors", java.util.List.of("Please select a room type."));
            doGet(req, resp);
            return; // CHỐT CHẶN: Tránh lỗi load lại trang 2 lần
        }

        // 4. Dọn các Hold cũ quá hạn để vớt phòng trống (bạn đã thêm ở bước trước)
        try {
            dao.expireHolds();
        } catch (Exception e) {
            System.out.println("Lỗi khi dọn dẹp Hold hết hạn: " + e.getMessage());
        }

        // 5. Tiến hành giữ phòng (Hold)
        try {
int holdId = dao.createHold(userId, roomTypeId, checkIn, checkOut, rooms, 15);
            
            // Chuyển hướng sang bước 2 (Điền thông tin khách)
            resp.sendRedirect(req.getContextPath() + "/receptionist/booking/customer?holdId=" + holdId);
            return; // CHỐT CHẶN CUỐI CÙNG
            
        } catch (Exception ex) {
            // Nếu khách khác vừa đặt mất hoặc lỗi Database
            req.setAttribute("errors", java.util.List.of(
                "Not enough rooms available for the selected dates. Please choose another room type."
            ));
            doGet(req, resp);
            return; 
        }
    }
}