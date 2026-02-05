package controller.auth;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="LogoutServlet", urlPatterns={"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Vì link <a> trên Header dùng GET, nên phải xử lý ở đây
        handleLogout(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Hỗ trợ cả trường hợp dùng form POST (nếu có)
        handleLogout(request, response);
    }

    /**
     * Logic dùng chung để hủy phiên làm việc và xóa cookie
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
    throws IOException {
        // 1. Hủy phiên làm việc (Session)
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // 2. Xóa sạch Cookie để trình duyệt không tự động điền form
        // Lưu ý: Tên cookie và Path phải khớp hoàn toàn với lúc tạo trong LoginServlet
        Cookie cEmail = new Cookie("cookEmail", "");
        Cookie cPass = new Cookie("cookPass", "");
        Cookie cRem = new Cookie("cookRem", "");

        // Đặt thời gian sống bằng 0 để trình duyệt xóa ngay lập tức
        cEmail.setMaxAge(0);
        cPass.setMaxAge(0);
        cRem.setMaxAge(0);
        
        cEmail.setPath("/");
        cPass.setPath("/");
        cRem.setPath("/");

        response.addCookie(cEmail);
        response.addCookie(cPass);
        response.addCookie(cRem);

        // 3. Chuyển hướng về trang chủ
        // Sau khi logout, trang chủ sẽ tự nhận biết session trống và hiện lại nút LOGIN
        response.sendRedirect(request.getContextPath() + "/home");
    }

    @Override
    public String getServletInfo() {
        return "Logout Servlet handling session invalidation and cookie clearing";
    }
}