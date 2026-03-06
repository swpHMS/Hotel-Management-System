package controller.manager;

import dal.ManagerDashboardDAO;
import dal.ManagerDashboardDAO.TrendPoint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

@WebServlet("/manager/dashboard")
public class ManagerDashboardServlet extends HttpServlet {

    private static String toJsStringArray(List<String> labels) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < labels.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(labels.get(i).replace("\"", "\\\"")).append("\"");
        }
        sb.append("]");
        return sb.toString();
    }

    private static String toJsNumberArray(List<Integer> values) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < values.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(values.get(i));
        }
        sb.append("]");
        return sb.toString();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        ManagerDashboardDAO dao = new ManagerDashboardDAO();

        // 1) KPI từ dbo.rooms
        Map<String, Integer> kpi = dao.getRoomStatusCounts();
        req.setAttribute("totalInventory", kpi.getOrDefault("totalInventory", 0));
        req.setAttribute("liveSuites",     kpi.getOrDefault("liveSuites", 0));
        req.setAttribute("guestStays",     kpi.getOrDefault("guestStays", 0));
        req.setAttribute("servicing",      kpi.getOrDefault("servicing", 0));
        req.setAttribute("outOfOrder",     kpi.getOrDefault("outOfOrder", 0));

        // 2) Trend từ dbo.room_type_inventory
        List<TrendPoint> daily = dao.getBookingVelocityDaily(7);
        List<TrendPoint> monthly = dao.getBookingVelocityMonthly(7); // hoặc 12

        List<String> dailyLabels = new ArrayList<>();
        List<Integer> dailyValues = new ArrayList<>();
        for (TrendPoint p : daily) { dailyLabels.add(p.label); dailyValues.add(p.value); }

        List<String> monthlyLabels = new ArrayList<>();
        List<Integer> monthlyValues = new ArrayList<>();
        for (TrendPoint p : monthly) { monthlyLabels.add(p.label); monthlyValues.add(p.value); }

        req.setAttribute("dailyLabelsJs", toJsStringArray(dailyLabels));
        req.setAttribute("dailyValuesJs", toJsNumberArray(dailyValues));
        req.setAttribute("monthlyLabelsJs", toJsStringArray(monthlyLabels));
        req.setAttribute("monthlyValuesJs", toJsNumberArray(monthlyValues));

        // 3) Layout
        req.setAttribute("active", "dashboard");
        req.setAttribute("pageTitle", "Dashboard");
        req.setAttribute("contentPage", "/view/manager/dashboard.jsp");
        req.getRequestDispatcher("/view/manager/layout.jsp").forward(req, resp);
    }
}