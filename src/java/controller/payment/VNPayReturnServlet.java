package controller.payment;

import dal.BookingFinalizeDAO;
import dal.RoomTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.RoomType;
import vnpay.VNPayConfig;
import vnpay.VNPayHash;

import java.io.IOException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.*;

@WebServlet("/vnpay-return")
public class VNPayReturnServlet extends HttpServlet {

    private static String enc(String s) throws IOException {
        if (s == null) return "";
        return URLEncoder.encode(s, StandardCharsets.UTF_8.toString());
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    // ✅ lấy email từ object (getEmail/getMail/getUsername) bằng reflection
    private static String extractEmailFromObject(Object obj) {
        if (obj == null) return null;

        String[] getters = {"getEmail", "getMail", "getUsername"};
        for (String g : getters) {
            try {
                Method m = obj.getClass().getMethod(g);
                Object v = m.invoke(obj);
                if (v != null) {
                    String s = String.valueOf(v).trim();
                    if (!s.isEmpty() && s.contains("@")) return s;
                }
            } catch (Exception ignored) {}
        }
        return null;
    }

    private static Integer tryGetIntGetter(Object obj, String getter) {
        if (obj == null) return null;
        try {
            Object v = obj.getClass().getMethod(getter).invoke(obj);
            if (v == null) return null;
            int n = Integer.parseInt(String.valueOf(v));
            return n > 0 ? n : null;
        } catch (Exception e) {
            return null;
        }
    }

    private static String tryGetStringGetter(Object obj, String getter) {
        if (obj == null) return null;
        try {
            Object v = obj.getClass().getMethod(getter).invoke(obj);
            if (v == null) return null;
            String s = String.valueOf(v).trim();
            return s.isEmpty() ? null : s;
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1) Lấy tất cả params trả về (trừ vnp_SecureHash, vnp_SecureHashType)
        Map<String, String> params = new HashMap<>();
        Enumeration<String> names = request.getParameterNames();
        while (names.hasMoreElements()) {
            String name = names.nextElement();
            if ("vnp_SecureHash".equals(name) || "vnp_SecureHashType".equals(name)) continue;
            params.put(name, request.getParameter(name));
        }

        // 2) Sort keys
        List<String> keys = new ArrayList<>(params.keySet());
        Collections.sort(keys);

        // 3) Build hashData: key=URLEncoded(value)
        StringBuilder hashData = new StringBuilder();
        int added = 0;
        for (String k : keys) {
            String v = params.get(k);
            if (v == null || v.isEmpty()) continue;

            if (added > 0) hashData.append("&");
            // ✅ giữ key raw, encode value (đúng kiểu bạn đang làm ở create)
            hashData.append(k).append("=").append(enc(v));
            added++;
        }

        // 4) Tính lại chữ ký và so sánh
        String expected = VNPayHash.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
        String received = request.getParameter("vnp_SecureHash");
        boolean validHash = expected != null && received != null && expected.equalsIgnoreCase(received);

        // 5) Kết quả VNPay
        String responseCode = request.getParameter("vnp_ResponseCode"); // 00 = success
        boolean isOk = validHash && "00".equals(responseCode);

        // 6) Lấy holdId từ vnp_TxnRef: holdId_timestamp (hoặc chỉ holdId)
        String txnRef = request.getParameter("vnp_TxnRef");
        int holdId = 0;
        try {
            if (txnRef != null && txnRef.contains("_")) {
                holdId = Integer.parseInt(txnRef.split("_")[0]);
            } else if (txnRef != null && txnRef.matches("\\d+")) {
                holdId = Integer.parseInt(txnRef);
            }
        } catch (Exception ignored) {}

        // 7) Amount trả về là x100 -> chia 100 để hiển thị
        long amountVnp = 0;
        try { amountVnp = Long.parseLong(request.getParameter("vnp_Amount")); } catch (Exception ignored) {}
        long amountDisplay = amountVnp / 100;

        // ✅ FIX: lấy session kiểu "true" để không bị null (nếu browser vẫn giữ cookie sẽ là session cũ)
        // (Nếu cookie mất thì nó tạo session mới, nhưng finalize vẫn chạy nhờ hold DB + amount fallback)
        HttpSession session = request.getSession(true);

        // 8) Load dữ liệu để hiển thị (ưu tiên session, không có thì thôi)
        String roomTypeIdS = (holdId <= 0) ? null : (String) session.getAttribute("HOLD_" + holdId + "_roomTypeId");
        String checkInS    = (holdId <= 0) ? null : (String) session.getAttribute("HOLD_" + holdId + "_checkIn");

        String roomName = "N/A";
        String checkInDate = (checkInS != null ? checkInS : "N/A");

        if (!isBlank(roomTypeIdS) && !isBlank(checkInS)) {
            try {
                int roomTypeId = Integer.parseInt(roomTypeIdS);
                LocalDate checkIn = LocalDate.parse(checkInS);

                RoomTypeDAO dao = new RoomTypeDAO();
                RoomType rt = dao.getRoomTypeByIdWithRate(roomTypeId, checkIn);
                if (rt != null && rt.getName() != null) {
                    roomName = rt.getName();
                }
            } catch (Exception ignored) {}
        }

        // 9) Customer email: ưu tiên theo HOLD trong session
        String customerEmail = null;

        if (holdId > 0) {
            customerEmail = (String) session.getAttribute("HOLD_" + holdId + "_email");
        }

        // fallback: session userEmail
        if (isBlank(customerEmail)) {
            Object ue = session.getAttribute("userEmail");
            if (ue != null && !isBlank(String.valueOf(ue))) customerEmail = String.valueOf(ue).trim();
        }

        // fallback: object user/account/profile...
        if (isBlank(customerEmail)) {
            Object acc = session.getAttribute("user");
            if (acc == null) acc = session.getAttribute("userProfile");
            if (acc == null) acc = session.getAttribute("profile");
            if (acc == null) acc = session.getAttribute("account");
            if (acc == null) acc = session.getAttribute("currentUser");

            String em = extractEmailFromObject(acc);
            if (!isBlank(em)) customerEmail = em.trim();
        }

        if (isBlank(customerEmail)) customerEmail = "(không xác định)";

        if (holdId > 0 && !isBlank(customerEmail) && customerEmail.contains("@")) {
            session.setAttribute("HOLD_" + holdId + "_email", customerEmail.trim());
        }

        // =====================================================
        // ✅ FINALIZE: nếu thanh toán OK -> tạo BOOKING thật + insert DB
        // =====================================================
        BookingFinalizeDAO.FinalizeResult fr = null;

        if (isOk && holdId > 0) {
            try {
                // total/deposit ưu tiên session, không có thì fallback:
                String totalS = (String) session.getAttribute("HOLD_" + holdId + "_total");
                String depS   = (String) session.getAttribute("HOLD_" + holdId + "_deposit");

                BigDecimal paid  = (!isBlank(depS))
                        ? new BigDecimal(depS)
                        : BigDecimal.valueOf(amountDisplay);

                BigDecimal total = (!isBlank(totalS))
                        ? new BigDecimal(totalS)
                        : paid.multiply(new BigDecimal("2")); // ✅ deposit 50% => total = paid*2

                // userId/fullName (nếu có login)
                Integer userId = null;
                String fullName = null;

                Object ua = session.getAttribute("userAccount"); // key theo header home.jsp của bạn
                if (ua != null) {
                    userId = tryGetIntGetter(ua, "getUserId");
                    fullName = tryGetStringGetter(ua, "getFullName");
                }

                if (isBlank(fullName) || fullName == null) fullName = customerEmail;

                BookingFinalizeDAO fdao = new BookingFinalizeDAO();
                fr = fdao.finalizeAfterVnpaySuccess(holdId, userId, fullName, total, paid);

                // ✅ lưu để hiển thị BK
                session.setAttribute("HOLD_" + holdId + "_bookingCode", "#" + fr.bookingCode);

                System.out.println("FINALIZE_OK bookingId=" + fr.bookingId + " code=" + fr.bookingCode);

            } catch (Exception ex) {
                ex.printStackTrace();
                System.out.println("FINALIZE_FAIL: " + ex.getMessage());
                request.setAttribute("finalizeErr", ex.getMessage());
            }
        }

        // 10) Booking code: ưu tiên BK nếu đã finalize
        String bookingCode = "#N/A";
        if (holdId > 0) bookingCode = "#HOLD-" + holdId;

        if (fr != null && fr.bookingCode != null && !fr.bookingCode.isBlank()) {
            bookingCode = "#" + fr.bookingCode;
        } else if (holdId > 0) {
            String bc = (String) session.getAttribute("HOLD_" + holdId + "_bookingCode");
            if (bc != null && !bc.isBlank()) bookingCode = bc;
        }

        // 11) Set data cho JSP
        request.setAttribute("isOk", isOk);
        request.setAttribute("holdId", holdId);
        request.setAttribute("bookingCode", bookingCode);
        request.setAttribute("customerEmail", customerEmail);
        request.setAttribute("roomName", roomName);

        request.setAttribute("checkInDate", checkInDate);
        request.setAttribute("checkIn", checkInDate);
        request.setAttribute("amount", amountDisplay);

        // debug
        System.out.println("RETURN_VALID_HASH=" + validHash);
        System.out.println("RETURN_CODE=" + responseCode);
        System.out.println("HOLD_ID=" + holdId);
        System.out.println("BOOKING_CODE=" + bookingCode);
        System.out.println("EMAIL_FROM_HOLD=" + session.getAttribute("HOLD_" + holdId + "_email"));
        System.out.println("EMAIL_DISPLAY=" + customerEmail);

        // ✅ Forward sang success.jsp
        request.getRequestDispatcher("/view/booking/success.jsp")
                .forward(request, response);
    }
}