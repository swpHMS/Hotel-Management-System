package controller.auth;

import dal.UserDAO;
import model.User;
import utils.EmailUtils;
import java.io.IOException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="RegisterServlet", urlPatterns={"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Luôn dùng forward để hiển thị trang đăng ký
        request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Lấy thông tin từ form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 1. Validate số điện thoại (Định dạng Việt Nam)
        if (phone == null || !phone.matches("^(0[3|5|7|8|9])[0-9]{8}$")) {
            request.setAttribute("error", "Định dạng số điện thoại không hợp lệ!");
            keepFormData(request, fullName, email, phone);
            request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
            return;
        }

        // 2. Kiểm tra mật khẩu xác nhận
        if (password == null || password.isEmpty() || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            keepFormData(request, fullName, email, phone);
            request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            User existingUser = dao.getUserByEmail(email);
            String token = UUID.randomUUID().toString();

            // 3. XỬ LÝ KHI EMAIL ĐÃ TỒN TẠI TRONG HỆ THỐNG
            if (existingUser != null) {
                if (existingUser.getStatus() == 1) {
                    // Tài khoản đã hoạt động -> Yêu cầu đăng nhập
                    request.setAttribute("error", "Email này đã được sử dụng. Vui lòng đăng nhập!");
                    keepFormData(request, fullName, email, phone);
                } else {
                    // Tài khoản chờ xác thực (Status = 0) -> Gửi lại mã kích hoạt
                    dao.updateToken(email, token); 
                    EmailUtils.sendVerifyEmail(email, token);
                    
                    // Thông báo màu xanh (biến message trong JSP)
                    request.setAttribute("message", "Email này đang chờ xác thực. Chúng tôi đã gửi lại link kích hoạt mới vào hộp thư của bạn!");
                    keepFormData(request, fullName, email, phone);
                }
                request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
                return;
            }

            // 4. THỰC HIỆN ĐĂNG KÝ MỚI (Mặc định RoleID = 5 cho Customer)
            // Lưu ý: Đảm bảo trong UserDAO.registerLocalUser bạn truyền roleId = 5 vào câu SQL
            boolean success = dao.registerLocalUser(email, password, fullName, phone, token);

            if (success) {
                // Gửi mail kích hoạt lần đầu
                EmailUtils.sendVerifyEmail(email, token);
                
                // Redirect sang trang thông báo thành công để tránh lỗi F5 (Duplicate POST)
                response.sendRedirect(request.getContextPath() + "/view/auth/check-mail.jsp");
            } else {
                request.setAttribute("error", "Lỗi lưu dữ liệu. Vui lòng thử lại sau!");
                keepFormData(request, fullName, email, phone);
                request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
        }
    }

    // Hàm giữ lại dữ liệu đã nhập nếu có lỗi xảy ra
    private void keepFormData(HttpServletRequest request, String fullName, String email, String phone) {
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
    }
}