package controller.payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import vnpay.VNPayConfig;
import vnpay.VNPayHash;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/vnpay-create")
public class VNPayCreateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        long amount = 100000;
        try { amount = Long.parseLong(request.getParameter("amount")); }
        catch (Exception ignored) {}

        // ✅ nhận holdId để nhét vào txnRef (để return lấy lại đúng roomType)
        String holdId = request.getParameter("holdId");
        if (holdId == null || holdId.isBlank()) holdId = "0";

        // ✅ txnRef = holdId_timestamp
        String txnRef = holdId + "_" + System.currentTimeMillis();

        TimeZone tz = TimeZone.getTimeZone("Asia/Ho_Chi_Minh");
        Calendar cld = Calendar.getInstance(tz);
        SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMddHHmmss");
        fmt.setTimeZone(tz);

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", "2.1.0");
        vnp_Params.put("vnp_Command", "pay");
        vnp_Params.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);

        // VNPay yêu cầu amount * 100
        vnp_Params.put("vnp_Amount", String.valueOf(amount * 100));
        vnp_Params.put("vnp_CurrCode", "VND");

        vnp_Params.put("vnp_TxnRef", txnRef);

        // ✅ orderInfo có holdId để debug dễ
        vnp_Params.put("vnp_OrderInfo", "Booking holdId=" + holdId);

        vnp_Params.put("vnp_OrderType", "other");
        vnp_Params.put("vnp_Locale", "vn");
        vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);

        // dùng X-Forwarded-For nếu có (khi deploy qua proxy/ngrok)
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isBlank()) ip = request.getRemoteAddr();
        vnp_Params.put("vnp_IpAddr", ip);

        vnp_Params.put("vnp_CreateDate", fmt.format(cld.getTime()));
        cld.add(Calendar.MINUTE, 15);
        vnp_Params.put("vnp_ExpireDate", fmt.format(cld.getTime()));

        // sort keys
        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        int added = 0;
        for (String fieldName : fieldNames) {
            String fieldValue = vnp_Params.get(fieldName);
            if (fieldValue == null || fieldValue.isEmpty()) continue;

            // ✅ encode 1 lần, dùng chung cho hashData + query
            String encodedName = URLEncoder.encode(fieldName, StandardCharsets.UTF_8.toString());
            String encodedValue = URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString());

            if (added > 0) {
                hashData.append("&");
                query.append("&");
            }

            // ✅ HASH theo value ENCODED (đúng với sandbox VNPay)
            hashData.append(fieldName).append("=").append(encodedValue);

            query.append(encodedName).append("=").append(encodedValue);

            added++;
        }

        String secureHash = VNPayHash.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
        String payUrl = VNPayConfig.vnp_PayUrl + "?" + query + "&vnp_SecureHash=" + secureHash;

        // log debug
        System.out.println("TMN=" + VNPayConfig.vnp_TmnCode);
        System.out.println("PAYURL=" + VNPayConfig.vnp_PayUrl);
        System.out.println("HASH_DATA=" + hashData);
        System.out.println("SECUREHASH=" + secureHash);
        System.out.println("PAY_URL=" + payUrl);

        response.sendRedirect(payUrl);
    }
}