package controller.staff.profile;

import dal.StaffDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.StaffProfile;
import model.User;

@WebServlet(name="StaffProfileServlet", urlPatterns={"/staff-profile"})
public class StaffProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        // Lấy User từ session (Minh Đức nhớ key "account" này phải khớp với lúc Login nhé)
        User user = (User) session.getAttribute("userAccount"); 

        if (user == null) {
            response.sendRedirect("login"); 
            return;
        }

        StaffDAO dao = new StaffDAO();
        StaffProfile staff = dao.getStaffByUserId(user.getUserId());

        if (staff != null) {
            int totalOrders = dao.getTotalServiceOrdersByStaffId(staff.getStaffId());
            
            // Đẩy dữ liệu sang JSP
            request.setAttribute("staff", staff);
            request.setAttribute("totalOrders", totalOrders);
            
            // Forward đến file JSP theo cấu trúc thư mục của bạn
            request.getRequestDispatcher("view/staff/profile.jsp").forward(request, response);
        } else {
            response.getWriter().println("Profile not found. Please contact Admin.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
    try {
        int staffId = Integer.parseInt(request.getParameter("staffId"));
        String fullName = request.getParameter("fullName").trim();
        String phone = request.getParameter("phone").trim();
        int gender = Integer.parseInt(request.getParameter("gender"));
        String address = request.getParameter("residenceAddress");

        // Validate Server-side
        boolean isValidName = fullName.matches("^[a-zA-Z\\s\\p{L}]+$"); // \\p{L} hỗ trợ mọi ngôn ngữ chữ cái
        boolean isValidPhone = phone.matches("^0\\d{9}$");

        if (!isValidName || !isValidPhone) {
            request.getSession().setAttribute("errorMsg", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại tên và số điện thoại!");
            response.sendRedirect("staff-profile");
            return;
        }

        StaffDAO dao = new StaffDAO();
        boolean isUpdated = dao.updateStaffProfile(staffId, fullName, phone, gender, address);

        if (isUpdated) {
            request.getSession().setAttribute("toastMsg", "success");
            response.sendRedirect("staff-profile");
        } else {
            // Xử lý lỗi
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("staff-profile");
    }
    }
}