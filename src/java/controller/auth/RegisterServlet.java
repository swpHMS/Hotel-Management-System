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
        request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 1. Validate Phone (Regex Việt Nam)
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
            
            // TẠO TOKEN MỚI (Dùng cho cả đăng ký mới và gửi lại)
            String token = UUID.randomUUID().toString();

            // 3. XỬ LÝ KHI EMAIL ĐÃ TỒN TẠI
            if (existingUser != null) {
                if (existingUser.getStatus() == 1) {
                    // Trường hợp đã kích hoạt -> Báo lỗi trùng email
                    request.setAttribute("error", "Email này đã được sử dụng. Vui lòng đăng nhập!");
                    keepFormData(request, fullName, email, phone);
                } else {
                    // TRƯỜNG HỢP ĐĂNG KÝ LẠI (Status = 0) -> Cập nhật Token mới và gửi lại mail
                    dao.updateToken(email, token); // Cập nhật token mới vào bản ghi cũ
                    EmailUtils.sendVerifyEmail(email, token);
                    
                    // NỘI DUNG THÔNG BÁO THEO YÊU CẦU CỦA BẠN
                    request.setAttribute("message", "Email này đang chờ xác thực. Chúng tôi đã gửi lại link kích hoạt mới vào hộp thư của bạn!");
                    keepFormData(request, fullName, email, phone);
                }
                // Dùng forward để hiển thị thông báo ngay tại trang register
                request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
                return;
            }

            // 4. THỰC HIỆN ĐĂNG KÝ MỚI (Nếu email chưa tồn tại)
            boolean success = dao.registerLocalUser(email, password, fullName, phone, token);

            if (success) {
                EmailUtils.sendVerifyEmail(email, token);
                // Dùng Redirect sang trang check-mail để tránh F5 trùng dữ liệu
                response.sendRedirect(request.getContextPath() + "/view/auth/check-mail.jsp");
            } else {
                request.setAttribute("error", "Lỗi lưu dữ liệu. Vui lòng thử lại!");
                keepFormData(request, fullName, email, phone);
                request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/view/auth/register-customer.jsp").forward(request, response);
        }
    }

    private void keepFormData(HttpServletRequest request, String fullName, String email, String phone) {
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
    }
}