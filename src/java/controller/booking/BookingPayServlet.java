package controller.booking;

import context.DBContext;
import dal.HoldDAO;
import dal.RoomTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.RoomType;

import java.io.IOException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/booking/pay")
public class BookingPayServlet extends HttpServlet {

    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private LocalDate parseDate(String s) {
        try { return (s == null || s.isBlank()) ? null : LocalDate.parse(s.trim()); }
        catch (Exception e) { return null; }
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    private Integer extractUserIdFromUserAccount(Object ua) {
        if (ua == null) return null;
        try {
            Method m = ua.getClass().getMethod("getUserId");
            Object v = m.invoke(ua);
            if (v == null) return null;
            int id = Integer.parseInt(String.valueOf(v));
            return (id > 0) ? id : null;
        } catch (Exception ignored) {}
        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1) bắt buộc tick agree
        if (request.getParameter("agree") == null) {
            response.sendRedirect(request.getContextPath() + "/booking/confirm?err=agree");
            return;
        }

        HttpSession session = request.getSession();

        // 2) holdId (nếu có thì dùng lại)
        String holdIdRaw = request.getParameter("holdId");
        Integer holdId = null;
        if (!isBlank(holdIdRaw)) {
            try { holdId = Integer.parseInt(holdIdRaw.trim()); } catch (Exception ignored) {}
        }

        String roomTypeIdS = request.getParameter("roomTypeId");
        String checkInS    = request.getParameter("checkIn");
        String checkOutS   = request.getParameter("checkOut");
        String roomQtyS    = request.getParameter("roomQty");
        String adultsS     = request.getParameter("adults");
        String childrenS   = request.getParameter("children");

        // ✅ email từ form
        String customerEmail = request.getParameter("customerEmail");
        if (isBlank(customerEmail)) customerEmail = request.getParameter("email");
        if (isBlank(customerEmail)) customerEmail = request.getParameter("guestEmail");

        // fallback: lấy từ session TMP
        if (isBlank(customerEmail)) {
            Object tmp = session.getAttribute("TMP_CUSTOMER_EMAIL");
            if (tmp != null) customerEmail = String.valueOf(tmp);
        }
        if (!isBlank(customerEmail)) customerEmail = customerEmail.trim();

        // validate tối thiểu
        int roomTypeId = parseInt(roomTypeIdS, -1);
        int roomQty = parseInt(roomQtyS, 1);
        LocalDate checkIn = parseDate(checkInS);
        LocalDate checkOut = parseDate(checkOutS);

        if (roomTypeId <= 0 || roomQty <= 0 || checkIn == null || checkOut == null || !checkOut.isAfter(checkIn)) {
            response.sendRedirect(request.getContextPath() + "/booking?err=invalid");
            return;
        }

        // ✅ Nếu chưa có holdId => TẠO HOLD THẬT TRONG DB
        if (holdId == null || holdId <= 0) {

            Integer userId = null;
            Object ua = session.getAttribute("userAccount"); // đúng theo header.jsp bạn gửi
            userId = extractUserIdFromUserAccount(ua);       // có thể null nếu guest

            HoldDAO holdDAO = new HoldDAO();

            try (Connection conn = new DBContext().getConnection()) {
                // holdMinutes = 15
                holdId = holdDAO.createHold(
                        conn,
                        checkIn,
                        checkOut,
                        userId,          // nullable
                        roomTypeId,
                        roomQty,
                        15
                );
            } catch (Exception ex) {
                ex.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/booking/confirm?err=hold_create");
                return;
            }

            // lưu info hold vào session để VNPayReturn / success đọc nhanh
            session.setAttribute("HOLD_" + holdId + "_roomTypeId", roomTypeIdS);
            session.setAttribute("HOLD_" + holdId + "_checkIn", checkInS);
            session.setAttribute("HOLD_" + holdId + "_checkOut", checkOutS);
            session.setAttribute("HOLD_" + holdId + "_roomQty", roomQtyS);
            session.setAttribute("HOLD_" + holdId + "_adults", adultsS);
            session.setAttribute("HOLD_" + holdId + "_children", childrenS);
        }

        // ✅ LƯU EMAIL THEO HOLD
        if (!isBlank(customerEmail) && customerEmail.contains("@")) {
            session.setAttribute("HOLD_" + holdId + "_email", customerEmail);
        }

        System.out.println("PAY HOLD_ID=" + holdId + " | SAVE_EMAIL=" + customerEmail);

        // 3) đánh dấu đã qua step confirm
        session.setAttribute("CHECKOUT_OK_" + holdId, true);

        // 4) Tính tiền thật: deposit 50%
        long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
        if (nights <= 0) {
            response.sendRedirect(request.getContextPath() + "/booking?err=invalid_date");
            return;
        }

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

        // lưu lại để return/success dùng
        session.setAttribute("HOLD_" + holdId + "_total", total.toPlainString());
        session.setAttribute("HOLD_" + holdId + "_deposit", deposit.toPlainString());

        long amount = deposit.longValue();

        // 5) Redirect sang VNPay (kèm holdId)
        response.sendRedirect(request.getContextPath()
                + "/vnpay-create?amount=" + amount
                + "&holdId=" + holdId);
    }
}