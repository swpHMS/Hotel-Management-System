/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.receptionist;

import dal.BookingDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.BookingDashboard;
import model.DashboardStats;
import java.time.LocalDate;

/**
 *
 * @author ASUS
 */
@WebServlet(name="ReceptionistDashboardServlet", urlPatterns={"/receptionist/dashboard"})
public class ReceptionistDashboardServlet extends HttpServlet {
   
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
            out.println("<title>Servlet ReceptionistDashboardServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReceptionistDashboardServlet at " + request.getContextPath () + "</h1>");
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
        // 1. Lấy các tham số cơ bản từ Request
        LocalDate nowDate=LocalDate.now();
        String currentDate=nowDate.toString();
        String search = request.getParameter("txtSearch");
        String status = request.getParameter("filterStatus");
        String sort = request.getParameter("filterSort");

        // 2. Lấy tham số phân trang (Số trang và Kích thước trang)
        String indexPage = request.getParameter("index");
        if (indexPage == null) {
            indexPage = "1"; // Mặc định là trang 1
        }
        int index = Integer.parseInt(indexPage);

        String sizePage = request.getParameter("size");
        if (sizePage == null) {
            sizePage = "5"; // Mặc định hiển thị 5 dòng
        }
        int pageSize = Integer.parseInt(sizePage);

        BookingDAO dao = new BookingDAO();

        // 3. Thực thi nghiệp vụ Database
        // Cập nhật trạng thái No-show cho các đơn lỡ hẹn trước khi lấy số liệu
        dao.updateNoShowStatus(currentDate);

        // Tính toán tổng số trang dựa trên bộ lọc hiện tại và pageSize động
        int totalEntries = dao.getTotalTodayOperations(currentDate, search, status);
        int endPage = (int) Math.ceil((double) totalEntries / pageSize);

        // Lấy danh sách booking đã được phân trang và lọc
        List<BookingDashboard> list = dao.getTodayOperations(currentDate, search, status, sort, index, pageSize);

        // Lấy số liệu thống kê cho các thẻ Stats (không phụ thuộc phân trang)
        DashboardStats stats = dao.getDashboardStats(currentDate);

        // 4. Thiết lập thuộc tính để gửi sang JSP
        request.setAttribute("listBookings", list);
        request.setAttribute("stats", stats);

        // Giữ trạng thái các bộ lọc và phân trang trên giao diện
        request.setAttribute("searchValue", search);
        request.setAttribute("statusValue", status);
        request.setAttribute("sortValue", sort);
        request.setAttribute("tag", index);            // Trang hiện tại
        request.setAttribute("endP", endPage);         // Tổng số trang
        request.setAttribute("currentSize", pageSize); // Kích thước trang (5, 10, 20)

        request.getRequestDispatcher("/view/receptionist/dashboard.jsp").forward(request, response);
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
