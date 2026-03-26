package controller.receptionist.checkout;

import dal.ReceptCheckoutDAO;
import model.CheckoutBill;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="ReceptionistCheckoutServlet", urlPatterns={"/receptionist/checkout-process"})
public class ReceptionistCheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "checkout"); 
        String bookingIdRaw = req.getParameter("bookingId");
        if (bookingIdRaw == null || bookingIdRaw.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/receptionist/dashboard");
            return;
        }
        
        // ĐÃ SỬA: Khởi tạo DAO bên trong hàm để luôn lấy Connection mới
        ReceptCheckoutDAO dao = new ReceptCheckoutDAO();
        try {
            int bookingId = Integer.parseInt(bookingIdRaw);
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
        ReceptCheckoutDAO dao = new ReceptCheckoutDAO();
        try {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            long balanceDue = Long.parseLong(req.getParameter("balanceDue"));
            String method = req.getParameter("method"); 

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
        
        // ĐÃ SỬA: Redirect về danh sách Check-out thay vì Dashboard
        resp.sendRedirect(req.getContextPath() + "/receptionist/checkout");
    }
}