package controller.receptionist.checkout;

import dal.ReceptCheckoutDAO;
import model.CheckoutBill;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="ReceptionistCheckoutServlet", urlPatterns={"/receptionist/checkout-process"})
public class ReceptionistCheckoutServlet extends HttpServlet {

    private final ReceptCheckoutDAO dao = new ReceptCheckoutDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "checkout"); // Giữ active sidebar
        
        String bookingIdRaw = req.getParameter("bookingId");
        if (bookingIdRaw == null || bookingIdRaw.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/receptionist/dashboard");
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdRaw);
            // Kéo dữ liệu bill từ database (đã bao gồm các Service Order mà Staff đẩy lên)
            CheckoutBill bill = dao.getCheckoutBill(bookingId);
            
            if (bill == null) {
                req.getSession().setAttribute("errorMsg", "Không tìm thấy thông tin Booking!");
                resp.sendRedirect(req.getContextPath() + "/receptionist/dashboard");
                return;
            }

            req.setAttribute("bill", bill);
            req.getRequestDispatcher("/view/receptionist/checkout.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/receptionist/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            long balanceDue = Long.parseLong(req.getParameter("balanceDue"));
            String method = req.getParameter("method"); // CASH hoặc QR

            // Gọi Transaction Checkout
            boolean isSuccess = dao.processCheckout(bookingId, balanceDue, method);

            if (isSuccess) {
                req.getSession().setAttribute("successMsg", "Check-out thành công cho Booking #" + bookingId);
            } else {
                req.getSession().setAttribute("errorMsg", "Có lỗi xảy ra trong quá trình Check-out!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMsg", "Lỗi hệ thống: " + e.getMessage());
        }

        // Sau khi checkout xong, quay về màn hình dashboard hoặc danh sách in-house
        resp.sendRedirect(req.getContextPath() + "/receptionist/dashboard");
    }
}
