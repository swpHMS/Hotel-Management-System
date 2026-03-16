package controller.receptionist.checkout;

import dal.ReceptCheckoutDAO;
import model.CheckoutSummary;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name="ReceptionistCheckoutListServlet", urlPatterns={"/receptionist/checkout"})
public class ReceptionistCheckoutListServlet extends HttpServlet {

    private final ReceptCheckoutDAO dao = new ReceptCheckoutDAO();

    private int parseInt(String s, int defaultValue) {
        try {
            return (s == null || s.trim().isEmpty()) ? defaultValue : Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("active", "checkout"); // Đánh dấu active cho sidebar

        // 1. Lấy parameters từ request (Bộ lọc & Phân trang)
        String keyword = req.getParameter("keyword");
        String statusFilter = req.getParameter("status"); // 3: In-House, 4: Departing Today
        String sortFilter = req.getParameter("sort");     // Newest / Oldest
        
        int page = parseInt(req.getParameter("page"), 1);
        int size = parseInt(req.getParameter("size"), 10);
        
        if (page < 1) page = 1;
        if (size != 5 && size != 10 && size != 20) size = 10;

        // 2. Tính toán phân trang
        int totalRecords = dao.countInHouseBookings(keyword, statusFilter);
        int totalPages = (int) Math.ceil(totalRecords * 1.0 / size);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        // 3. Lấy dữ liệu danh sách
        List<CheckoutSummary> checkoutList = dao.getInHouseBookings(keyword, statusFilter, sortFilter, page, size);

        // 4. Gắn dữ liệu trả về View
        req.setAttribute("checkoutList", checkoutList);
        req.setAttribute("page", page);
        req.setAttribute("size", size);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalRecords", totalRecords);
        
        // Giữ lại trạng thái bộ lọc trên UI
        req.setAttribute("param.keyword", keyword);
        req.setAttribute("param.status", statusFilter);
        req.setAttribute("param.sort", sortFilter);

        // 5. Chuyển tiếp tới JSP (File checkout_list.jsp đã code lúc trước)
        req.getRequestDispatcher("/view/receptionist/checkout_list.jsp").forward(req, resp);
    }
}
