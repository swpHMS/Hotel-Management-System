package controller.receptionist.booking;

import dal.ReceptBookingDAO;
import model.HoldSummary;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="ReceptionistBookingCustomerServlet", urlPatterns={"/receptionist/booking/customer"})
public class ReceptionistBookingCustomerServlet extends HttpServlet {

    private final ReceptBookingDAO dao = new ReceptBookingDAO();

    private Integer parseIntOrNull(String s) {
        try { return (s==null||s.trim().isEmpty()) ? null : Integer.parseInt(s.trim()); }
        catch (Exception e) { return null; }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "create_booking");

        Integer holdId = parseIntOrNull(req.getParameter("holdId"));
        if (holdId == null) {
            resp.sendRedirect(req.getContextPath() + "/receptionist/booking/create");
            return;
        }

        try {
            HoldSummary s = dao.getHoldSummary(holdId);
            if (s == null) {
                resp.sendRedirect(req.getContextPath() + "/receptionist/booking/create");
                return;
            }

            // pass to jsp
            req.setAttribute("holdId", s.holdId);
            req.setAttribute("checkIn", s.checkIn);
            req.setAttribute("checkOut", s.checkOut);
            req.setAttribute("rooms", s.qty);
            req.setAttribute("roomTypeId", s.roomTypeId);
            req.setAttribute("roomTypeName", s.roomTypeName);
            req.setAttribute("rate", s.ratePerNight);
            req.setAttribute("nights", s.nights);
            req.setAttribute("total", s.total);

            req.getRequestDispatcher("/view/receptionist/customer_info.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "create_booking");

        Integer holdId = parseIntOrNull(req.getParameter("holdId"));
        if (holdId == null) {
            resp.sendRedirect(req.getContextPath() + "/receptionist/booking/create");
            return; // CHỐT CHẶN 1
        }

        // ===== 1. Lấy dữ liệu từ Form =====
        String fullName = utils.Validation.trimToNull(req.getParameter("fullName"));
        String phone    = utils.Validation.trimToNull(req.getParameter("phone"));
        String email    = utils.Validation.trimToNull(req.getParameter("email"));
        String identity = utils.Validation.trimToNull(req.getParameter("identity"));
        String address  = utils.Validation.trimToNull(req.getParameter("address"));

        java.util.List<String> errors = new java.util.ArrayList<>();

        // ===== 2. Kiểm tra lỗi (Validate) =====
        if (fullName == null) errors.add("Full Name is required.");
        else if (!utils.Validation.isValidFullNameNoNumber(fullName)) errors.add("Full Name is invalid (no numbers).");

        if (phone == null) errors.add("Phone is required.");
        else if (!utils.Validation.isPhoneVN(phone)) errors.add("Phone number is invalid (VN format: 0xxxxxxxxx).");

        if (email != null && !utils.Validation.isEmail(email)) errors.add("Email is invalid.");
        if (identity != null && !utils.Validation.isCCCD(identity)) errors.add("Identity/CCCD must be 12 digits.");

        if (address == null) errors.add("Address is required.");
        else if (!utils.Validation.minLen(address, 5)) errors.add("Address is too short.");

        // ===== 3. NẾU CÓ LỖI -> Hiển thị lỗi và DỪNG LẠI =====
        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            // Giữ lại dữ liệu cũ để lễ tân không phải nhập lại từ đầu
            req.setAttribute("fullName", fullName);
            req.setAttribute("phone", phone);
            req.setAttribute("email", email);
            req.setAttribute("identity", identity);
            req.setAttribute("address", address);

            try {
                model.HoldSummary s = dao.getHoldSummary(holdId);
                if (s != null) {
                    req.setAttribute("holdId", s.holdId);
                    req.setAttribute("checkIn", s.checkIn);
                    req.setAttribute("checkOut", s.checkOut);
                    req.setAttribute("rooms", s.qty);
                    req.setAttribute("roomTypeId", s.roomTypeId);
                    req.setAttribute("roomTypeName", s.roomTypeName);
                    req.setAttribute("rate", s.ratePerNight);
                    req.setAttribute("nights", s.nights);
                    req.setAttribute("total", s.total);
                }
            } catch (Exception ignore) {}

            req.getRequestDispatcher("/view/receptionist/customer_info.jsp").forward(req, resp);
            return; // CHỐT CHẶN 2: Bắt buộc phải có để code không chạy xuống dưới
        }

        // ===== 4. NẾU HỢP LỆ -> Lưu vào Session và chuyển sang Thanh toán =====
        HttpSession session = req.getSession();
        session.setAttribute("cus_fullName", fullName);
        session.setAttribute("cus_phone", phone);
        session.setAttribute("cus_email", email);
        session.setAttribute("cus_identity", identity);
        session.setAttribute("cus_address", address);

        resp.sendRedirect(req.getContextPath() + "/receptionist/booking/deposit?holdId=" + holdId);
        return; // CHỐT CHẶN CUỐI CÙNG
    }
}