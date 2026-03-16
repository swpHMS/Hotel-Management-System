package controller.manager.service;

import dal.ManagerServiceDAO;
import model.HotelService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ServiceRegistryServlet", urlPatterns = {"/manager/services"})
public class ServiceRegistryServlet extends HttpServlet {
    
    private final ManagerServiceDAO dao = new ManagerServiceDAO();

     @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String serviceType = request.getParameter("serviceType");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");
        String sizeStr = request.getParameter("pageSize");

        // Logic phân trang mặc định (Trang 1, 10 record/trang)
        int pageIndex = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);
        int pageSize = (sizeStr == null || sizeStr.isEmpty()) ? 10 : Integer.parseInt(sizeStr);
        
        if (keyword == null) keyword = "";

        // Lấy KPI
        request.setAttribute("kpis", dao.getServiceKPIs());

        // Lấy danh sách & tính tổng số trang
        request.setAttribute("services", dao.searchServices(keyword, serviceType, status, pageIndex, pageSize));
        int totalServices = dao.getTotalServiceCount(keyword, serviceType, status);
        int totalPages = (int) Math.ceil((double) totalServices / pageSize);

        // Gửi tham số về lại giao diện để giữ trạng thái
        request.setAttribute("keyword", keyword);
        request.setAttribute("serviceType", serviceType);
        request.setAttribute("status", status);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        
        // Layout
        request.setAttribute("active", "services");
        request.setAttribute("pageTitle", "Service Performance Dashboard");
        request.setAttribute("contentPage", "/view/manager/service-registry.jsp");
        request.getRequestDispatcher("/view/manager/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        request.setCharacterEncoding("UTF-8");
        
        // Lấy các tham số từ Modal Form gửi lên
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String unitPriceStr = request.getParameter("unitPrice");
        String serviceTypeStr = request.getParameter("serviceType");
        String statusStr = request.getParameter("status");
        
        HotelService s = new HotelService();
        s.setName(name);
        
        try {
            s.setUnitPrice(Double.parseDouble(unitPriceStr));
            s.setServiceType(Integer.parseInt(serviceTypeStr));
            s.setStatus(Integer.parseInt(statusStr));
            
            if ("create".equals(action)) {
                dao.createService(s);
            } else if ("update".equals(action)) {
                String serviceIdStr = request.getParameter("serviceId");
                s.setServiceId(Integer.parseInt(serviceIdStr));
                dao.updateService(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Có thể forward lại trang kèm thông báo lỗi nếu cần thiết
        }
        
        // Redirect lại trang danh sách để tránh lỗi gửi lại form khi F5 (Post/Redirect/Get pattern)
        response.sendRedirect(request.getContextPath() + "/manager/services");
    }
}