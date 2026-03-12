package controller.booking;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import dal.RoomTypeDAO;
import model.RoomType;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
@WebServlet(name = "PaymentServlet", urlPatterns = {"/booking/payment"})
public class PaymentServlet extends HttpServlet {

   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException {

    String holdIdRaw = request.getParameter("holdId");
    if (holdIdRaw == null || holdIdRaw.isBlank()) {
        response.sendRedirect(request.getContextPath() + "/booking");
        return;
    }

    int holdId;
    try {
        holdId = Integer.parseInt(holdIdRaw);
    } catch (Exception e) {
        response.sendRedirect(request.getContextPath() + "/booking?err=invalid");
        return;
    }

    // ✅ chặn nhảy bước
    HttpSession session = request.getSession(false);
    boolean ok = session != null && Boolean.TRUE.equals(session.getAttribute("CHECKOUT_OK_" + holdId));
    if (!ok) {
        response.sendRedirect(request.getContextPath() + "/booking/confirm?err=step");
        return;
    }

    // ✅ lấy dữ liệu hold từ session (đã lưu ở BookingConfirmServlet#doPost)
    String roomTypeIdS = (String) session.getAttribute("HOLD_" + holdId + "_roomTypeId");
    String checkInS    = (String) session.getAttribute("HOLD_" + holdId + "_checkIn");
    String checkOutS   = (String) session.getAttribute("HOLD_" + holdId + "_checkOut");
    String roomQtyS    = (String) session.getAttribute("HOLD_" + holdId + "_roomQty");
    String adultsS     = (String) session.getAttribute("HOLD_" + holdId + "_adults");
    String childrenS   = (String) session.getAttribute("HOLD_" + holdId + "_children");

    if (roomTypeIdS == null || checkInS == null || checkOutS == null
            || roomQtyS == null || adultsS == null || childrenS == null) {
        response.sendRedirect(request.getContextPath() + "/booking?err=invalid");
        return;
    }

    int roomTypeId = Integer.parseInt(roomTypeIdS);
    int roomQty = Integer.parseInt(roomQtyS);
    int adults = Integer.parseInt(adultsS);
    int children = Integer.parseInt(childrenS);

    LocalDate checkIn = LocalDate.parse(checkInS);
    LocalDate checkOut = LocalDate.parse(checkOutS);

    long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
    if (nights <= 0) {
        response.sendRedirect(request.getContextPath() + "/booking?err=invalid_date");
        return;
    }

    // ✅ load RoomType thật để lấy tên + giá theo ngày (giống confirm)
    RoomTypeDAO dao = new RoomTypeDAO();
    RoomType rt = dao.getRoomTypeByIdWithRate(roomTypeId, checkIn);
    if (rt == null) {
        response.sendRedirect(request.getContextPath() + "/booking?err=notfound");
        return;
    }

    BigDecimal pricePerNight = rt.getPriceToday();
    if (pricePerNight == null) pricePerNight = BigDecimal.ZERO;

    BigDecimal total = pricePerNight
            .multiply(BigDecimal.valueOf(nights))
            .multiply(BigDecimal.valueOf(roomQty));

    BigDecimal deposit = total.multiply(new BigDecimal("0.50"))
            .setScale(0, RoundingMode.HALF_UP);

    // ✅ set attributes cho payment.jsp
    request.setAttribute("holdId", holdId);

    request.setAttribute("rt", rt);               // để bạn dùng block cf-card nếu muốn
    request.setAttribute("roomTypeName", rt.getName()); // nếu payment.jsp đang dùng roomTypeName
    request.setAttribute("checkIn", checkIn);
    request.setAttribute("checkOut", checkOut);

    request.setAttribute("roomQty", roomQty);
    request.setAttribute("adults", adults);
    request.setAttribute("children", children);

    request.setAttribute("nights", nights);
    request.setAttribute("guests", adults); // payment.jsp đang hiển thị "adults" là đủ

    request.setAttribute("pricePerNight", pricePerNight);
    request.setAttribute("total", total);
    request.setAttribute("deposit", deposit);

    // timer cho trang payment
    request.setAttribute("expiresAtMillis", System.currentTimeMillis() + 15 * 60 * 1000);

    request.getRequestDispatcher("/view/booking/payment.jsp").forward(request, response);
}

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException {

    String holdIdRaw = request.getParameter("holdId");
    if (holdIdRaw == null || holdIdRaw.isBlank()) {
        response.sendRedirect(request.getContextPath() + "/booking");
        return;
    }
    int holdId = Integer.parseInt(holdIdRaw);

    // TODO: update DB: mark payment pending/paid (tuỳ bạn)
    // holdDAO.markPaidPending(holdId);

    response.sendRedirect(request.getContextPath() + "/booking/success?holdId=" + holdId);
}
}