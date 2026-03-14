package controller.receptionist;

import dal.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import model.BookingDashboard;
import model.DashboardStats;

@WebServlet(name = "ReceptionistDashboardServlet", urlPatterns = {"/receptionist/dashboard"})
public class ReceptionistDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LocalDate nowDate = LocalDate.now();
        String currentDate = nowDate.toString();

        String search = trimOrEmpty(request.getParameter("txtSearch"));
        String status = trimOrDefault(request.getParameter("filterStatus"), "0");
        String sort = trimOrDefault(request.getParameter("filterSort"), "Newest");

        int index = parseIntOrDefault(request.getParameter("index"), 1);
        int pageSize = parseIntOrDefault(request.getParameter("size"), 10);

        if (index < 1) {
            index = 1;
        }

        if (pageSize != 10 && pageSize != 20 && pageSize != 50) {
            pageSize = 10;
        }

        BookingDAO dao = new BookingDAO();

        int totalEntries = dao.getTotalTodayOperations(currentDate, search, status);
        int endPage = (int) Math.ceil((double) totalEntries / pageSize);

        if (endPage <= 0) {
            endPage = 1;
        }

        if (index > endPage) {
            index = endPage;
        }

        List<BookingDashboard> list = dao.getTodayOperations(currentDate, search, status, sort, index, pageSize);
        DashboardStats stats = dao.getDashboardStats(currentDate);

        request.setAttribute("listBookings", list);
        request.setAttribute("stats", stats);

        request.setAttribute("searchValue", search);
        request.setAttribute("statusValue", status);
        request.setAttribute("sortValue", sort);
        request.setAttribute("tag", index);
        request.setAttribute("endP", endPage);
        request.setAttribute("currentSize", pageSize);

        request.getRequestDispatcher("/view/receptionist/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String trimOrEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private String trimOrDefault(String value, String defaultValue) {
        return (value == null || value.trim().isEmpty()) ? defaultValue : value.trim();
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    @Override
    public String getServletInfo() {
        return "Receptionist Dashboard Servlet";
    }
}