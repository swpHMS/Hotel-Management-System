package vnpay;

public class VNPayConfig {

    // ✅ TMN Code từ email
    public static final String vnp_TmnCode = "55CZ637J";

    // ✅ Secret mới nhất bạn nhận (ảnh bạn gửi)
    public static final String vnp_HashSecret = "G4Y1D0MMAO66LHWZAZP1Y2X0JQQBCG1P";

    // ✅ PayUrl sandbox chuẩn
    public static final String vnp_PayUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";

    // ✅ ReturnUrl: trỏ về servlet xử lý kết quả
    public static final String vnp_ReturnUrl =
            "http://localhost:9999/SWP391_HMS_GR2_booking/vnpay-return";
}