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

        int pageIndex = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);
        int pageSize = (sizeStr == null || sizeStr.isEmpty()) ? 10 : Integer.parseInt(sizeStr);

        if (keyword == null) {
            keyword = "";
        }

        request.setAttribute("kpis", dao.getServiceKPIs());
        request.setAttribute("services", dao.searchServices(keyword, serviceType, status, pageIndex, pageSize));

        int totalServices = dao.getTotalServiceCount(keyword, serviceType, status);
        int totalPages = (int) Math.ceil((double) totalServices / pageSize);

        request.setAttribute("keyword", keyword);
        request.setAttribute("serviceType", serviceType);
        request.setAttribute("status", status);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);

        request.setAttribute("active", "services");
        request.setAttribute("pageTitle", "Service Performance Dashboard");
        request.setAttribute("contentPage", "/view/manager/service-registry.jsp");
        request.getRequestDispatcher("/view/manager/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String name = normalizeSpaces(request.getParameter("name"));
        String unitPriceStr = request.getParameter("unitPrice");
        String serviceTypeStr = request.getParameter("serviceType");
        String statusStr = request.getParameter("status");

        String error = validateServiceInput(name, unitPriceStr);

        if (error != null) {
            request.setAttribute("formError", error);
            request.setAttribute("inputAction", action);
            request.setAttribute("inputName", name);
            request.setAttribute("inputUnitPrice", unitPriceStr);
            request.setAttribute("inputServiceType", serviceTypeStr);
            request.setAttribute("inputStatus", statusStr);
            request.setAttribute("inputServiceId", request.getParameter("serviceId"));
            doGet(request, response);
            return;
        }

        try {
            HotelService s = new HotelService();
            s.setName(name);
            s.setUnitPrice(Integer.parseInt(unitPriceStr.trim()));
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
            request.setAttribute("formError", "Failed to save service.");
            request.setAttribute("inputAction", action);
            request.setAttribute("inputName", name);
            request.setAttribute("inputUnitPrice", unitPriceStr);
            request.setAttribute("inputServiceType", serviceTypeStr);
            request.setAttribute("inputStatus", statusStr);
            request.setAttribute("inputServiceId", request.getParameter("serviceId"));
            doGet(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/manager/services");
    }

    private String validateServiceInput(String name, String unitPriceStr) {
        if (name == null || name.trim().isEmpty()) {
            return "Service name is required.";
        }

        name = name.trim();

        if (name.length() < 2 || name.length() > 100) {
            return "Service name must be from 2 to 100 characters.";
        }

        if (!isValidServiceName(name)) {
            return "Service name contains invalid characters.";
        }

        if (unitPriceStr == null || unitPriceStr.trim().isEmpty()) {
            return "Unit price is required.";
        }

        unitPriceStr = unitPriceStr.trim();

        try {
            int price = Integer.parseInt(unitPriceStr);

            if (price < 1000) {
                return "Unit price must be at least 1000.";
            }

            if (price % 1000 != 0) {
                return "Unit price must be a multiple of 1000.";
            }

        } catch (NumberFormatException e) {
            return "Unit price must be a valid whole number.";
        }

        return null;
    }

    private boolean isValidServiceName(String name) {
        return name.matches("^[\\p{L}0-9 &\\-()/.,]+$");
    }

    private String normalizeSpaces(String value) {
        if (value == null) {
            return null;
        }
        return value.trim().replaceAll("\\s+", " ");
    }
}
