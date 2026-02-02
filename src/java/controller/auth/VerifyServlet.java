package controller.auth;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="VerifyServlet", urlPatterns={"/verify"})
public class VerifyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String email = request.getParameter("email");
        String token = request.getParameter("token");

        try {
            UserDAO dao = new UserDAO();
            // Gọi hàm verifyUser để update status = 1 trong database
            boolean isVerified = dao.verifyUser(email, token);

            if (isVerified) {
                // Nếu xác thực thành công, chuyển hướng về login với thông báo
                response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp?verify=success");
            } else {
                // Nếu thất bại (sai token hoặc email), báo lỗi
                request.setAttribute("error", "Link xác thực không hợp lệ hoặc đã hết hạn!");
                request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp?error=system_error");
        }
    }
    
}