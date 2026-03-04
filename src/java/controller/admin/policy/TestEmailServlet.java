/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.admin.policy;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author ASUS
 */
@WebServlet(name="TestEmailServlet", urlPatterns={"/test-email"})
public class TestEmailServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet TestEmailServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TestEmailServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // 1. Giả lập ID booking có sẵn trong DB của bạn để test lấy dữ liệu
        int testBookingId = 2; // Thay bằng một ID có thật trong bảng bookings của bạn

        // 2. Khởi tạo DAO và lấy dữ liệu
        dal.AdminTemplateDAO dao = new dal.AdminTemplateDAO();
        java.util.Map<String, String> data = dao.getEmailDataByBookingId(testBookingId);
        
        // 3. Lấy Template từ DB (Cái bạn vừa lưu ở Bước 1)
        model.EmailTemplate template = dao.getByCode("BOOKING_CONFIRM");

        if (template != null && !data.isEmpty()) {
            String content = template.getContent();
            
            // 4. Thay thế các biến {{...}}
            for (java.util.Map.Entry<String, String> entry : data.entrySet()) {
                content = content.replace("{{" + entry.getKey() + "}}", entry.getValue());
            }

            // 5. Gửi mail (Gửi tới email cá nhân của bạn để check)
            String myEmail = "minhducypbn@gmail.com"; 
            utils.EmailUtils.sendEmail(myEmail, template.getSubject(), content);

            response.getWriter().print("Da gui mail test thanh cong! Hay kiem tra Hop thu den.");
        } else {
            response.getWriter().print("Loi: Khong tim thay Template hoac Booking ID.");
        }
    }
     

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
