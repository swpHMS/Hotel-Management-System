package controller.auth;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;
import utils.EmailUtils;

@WebServlet(name="ForgotPasswordServlet", urlPatterns={"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Chuyển hướng người dùng đến trang nhập email
        request.getRequestDispatcher("/view/auth/forgot.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO dao = new UserDAO();
        User user = dao.getUserByEmail(email);

        if (user != null) {
            // KIỂM TRA TRẠNG THÁI: Nếu chưa kích hoạt (status = 0) thì không cho reset
            if (user.getStatus() == 0) {
                request.setAttribute("error", "Tài khoản này chưa được kích hoạt. Vui lòng kiểm tra email để xác thực trước!");
            } else {
                // Chỉ xử lý cho tài khoản đã kích hoạt (status = 1)
                String token = UUID.randomUUID().toString();
                dao.updateToken(email, token);

                // Gửi email chứa link dẫn tới ResetPasswordServlet
                String resetLink = request.getScheme() + "://" + request.getServerName() + ":" 
                                 + request.getServerPort() + request.getContextPath() 
                                 + "/reset-password?token=" + token;
                
                String content = "Bạn đã yêu cầu đặt lại mật khẩu tại Regal Quintet Hotel.\n"
                               + "Vui lòng nhấn vào đường dẫn sau để thực hiện: " + resetLink;
                
                EmailUtils.sendEmail(email, "Regal Quintet - Đặt lại mật khẩu", content);

                request.setAttribute("message", "Yêu cầu đã được gửi! Vui lòng kiểm tra email của bạn.");
            }
        } else {
            request.setAttribute("error", "Email không tồn tại trong hệ thống!");
        }
        
        request.getRequestDispatcher("/view/auth/forgot.jsp").forward(request, response);
    }
}