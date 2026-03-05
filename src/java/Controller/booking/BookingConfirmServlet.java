package controller.booking;

import dal.RoomTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.RoomType;
import dal.PolicyRuleDAO;
import model.PolicyRule;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet(name = "BookingConfirmServlet", urlPatterns = {"/booking/confirm"})
public class BookingConfirmServlet extends HttpServlet {

    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private LocalDate parseDate(String s) {
        try { return (s == null || s.isBlank()) ? null : LocalDate.parse(s.trim()); }
        catch (Exception e) { return null; }
    }
    
  @Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    // ✅ 0) Nếu quay lại từ payment: /booking/confirm?holdId=...
    String holdIdRaw = req.getParameter("holdId");
    if (holdIdRaw != null && !holdIdRaw.isBlank()) {
        int holdId;
        try {
            holdId = Integer.parseInt(holdIdRaw);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/booking?err=invalid");
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/booking?err=invalid");
            return;
        }

        String roomTypeIdS = (String) session.getAttribute("HOLD_" + holdId + "_roomTypeId");
        String checkInS    = (String) session.getAttribute("HOLD_" + holdId + "_checkIn");
        String checkOutS   = (String) session.getAttribute("HOLD_" + holdId + "_checkOut");
        String roomQtyS    = (String) session.getAttribute("HOLD_" + holdId + "_roomQty");
        String adultsS     = (String) session.getAttribute("HOLD_" + holdId + "_adults");
        String childrenS   = (String) session.getAttribute("HOLD_" + holdId + "_children");

        // thiếu dữ liệu hold -> về booking
        if (roomTypeIdS == null || checkInS == null || checkOutS == null
                || roomQtyS == null || adultsS == null || childrenS == null) {
            resp.sendRedirect(req.getContextPath() + "/booking?err=invalid");
            return;
        }

        // ✅ set lại thành request attribute để bên dưới dùng chung
        req.setAttribute("roomTypeId", roomTypeIdS);
        req.setAttribute("checkIn", checkInS);
        req.setAttribute("checkOut", checkOutS);
        req.setAttribute("roomQty", roomQtyS);
        req.setAttribute("adults", adultsS);
        req.setAttribute("children", childrenS);
        req.setAttribute("holdId", holdId); // để JSP dùng nếu cần
    }

    // ✅ 1) Lấy param: ưu tiên attribute (khi có holdId), không có thì lấy từ query
    String roomTypeIdRaw = (String) req.getAttribute("roomTypeId");
    if (roomTypeIdRaw == null) roomTypeIdRaw = req.getParameter("roomTypeId");

    String roomQtyRaw = (String) req.getAttribute("roomQty");
    if (roomQtyRaw == null) roomQtyRaw = req.getParameter("roomQty");

    String adultsRaw = (String) req.getAttribute("adults");
    if (adultsRaw == null) adultsRaw = req.getParameter("adults");

    String childrenRaw = (String) req.getAttribute("children");
    if (childrenRaw == null) childrenRaw = req.getParameter("children");

    String checkInRaw = (String) req.getAttribute("checkIn");
    if (checkInRaw == null) checkInRaw = req.getParameter("checkIn");

    String checkOutRaw = (String) req.getAttribute("checkOut");
    if (checkOutRaw == null) checkOutRaw = req.getParameter("checkOut");

    int roomTypeId = parseInt(roomTypeIdRaw, -1);
    int roomQty = parseInt(roomQtyRaw, 1);
    int adults = parseInt(adultsRaw, 2);
    int children = parseInt(childrenRaw, 0);

    LocalDate checkIn = parseDate(checkInRaw);
    LocalDate checkOut = parseDate(checkOutRaw);

    if (roomTypeId <= 0 || roomQty <= 0 || adults <= 0 || children < 0
            || checkIn == null || checkOut == null || !checkOut.isAfter(checkIn)) {
        resp.sendRedirect(req.getContextPath() + "/booking?err=invalid");
        return;
    }

    long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
    if (nights <= 0) {
        resp.sendRedirect(req.getContextPath() + "/booking?err=invalid_date");
        return;
    }

    RoomTypeDAO dao = new RoomTypeDAO();
    RoomType rt = dao.getRoomTypeByIdWithRate(roomTypeId, checkIn);

    if (rt == null) {
        resp.sendRedirect(req.getContextPath() + "/booking?err=notfound");
        return;
    }

    int maxAdult = rt.getMaxAdult();
    int maxChildren = rt.getMaxChildren();

    int capAdultTotal = maxAdult * roomQty;
    int capChildrenTotal = maxChildren * roomQty;

    if (adults > capAdultTotal || children > capChildrenTotal) {
        resp.sendRedirect(req.getContextPath() + "/booking?err=capacity"
                + "&maxA=" + capAdultTotal
                + "&maxC=" + capChildrenTotal);
        return;
    }

    BigDecimal pricePerNight = rt.getPriceToday();
    if (pricePerNight == null) pricePerNight = BigDecimal.ZERO;

    BigDecimal total = pricePerNight
            .multiply(BigDecimal.valueOf(nights))
            .multiply(BigDecimal.valueOf(roomQty));

    BigDecimal depositRate = new BigDecimal("0.50");
    BigDecimal deposit = total.multiply(depositRate).setScale(0, RoundingMode.HALF_UP);

    req.setAttribute("rt", rt);
    req.setAttribute("checkIn", checkIn);
    req.setAttribute("checkOut", checkOut);
    req.setAttribute("nights", nights);
    req.setAttribute("roomQty", roomQty);
    req.setAttribute("adults", adults);
    req.setAttribute("children", children);

    req.setAttribute("pricePerNight", pricePerNight);
    req.setAttribute("total", total);
    req.setAttribute("deposit", deposit);

    req.setAttribute("holdMs", 15 * 60 * 1000);

    try {
        PolicyRuleDAO prDao = new PolicyRuleDAO();
        PolicyRule paymentPolicy = prDao.getPolicyByName("PAYMENT");
        req.setAttribute("paymentPolicy", paymentPolicy);
    } catch (Exception e) {
        e.printStackTrace();
    }

    req.getRequestDispatcher("/view/booking/confirm.jsp").forward(req, resp);
}
    @Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    boolean agreed = "1".equals(req.getParameter("agree"));
    if (!agreed) {
        resp.sendRedirect(req.getContextPath() + "/booking/confirm"
                + "?roomTypeId=" + req.getParameter("roomTypeId")
                + "&checkIn=" + req.getParameter("checkIn")
                + "&checkOut=" + req.getParameter("checkOut")
                + "&roomQty=" + req.getParameter("roomQty")
                + "&adults=" + req.getParameter("adults")
                + "&children=" + req.getParameter("children")
                + "&err=agree");
        return;
    }

    // ✅ tạo holdId (demo). Sau này thay bằng DB identity của availability_holds
    int holdId = (int)(System.currentTimeMillis() % 100000);

    HttpSession session = req.getSession();

    // ✅ lưu lại các param cần để quay lại confirm
    session.setAttribute("HOLD_" + holdId + "_roomTypeId", req.getParameter("roomTypeId"));
    session.setAttribute("HOLD_" + holdId + "_checkIn", req.getParameter("checkIn"));
    session.setAttribute("HOLD_" + holdId + "_checkOut", req.getParameter("checkOut"));
    session.setAttribute("HOLD_" + holdId + "_roomQty", req.getParameter("roomQty"));
    session.setAttribute("HOLD_" + holdId + "_adults", req.getParameter("adults"));
    session.setAttribute("HOLD_" + holdId + "_children", req.getParameter("children"));

    // ✅ đánh dấu đã qua step confirm
    session.setAttribute("CHECKOUT_OK_" + holdId, true);

    // ✅ đi sang payment bằng holdId
    resp.sendRedirect(req.getContextPath() + "/booking/payment?holdId=" + holdId);
}
}