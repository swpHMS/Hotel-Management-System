package controller.manager;

import dal.ManagerDashboardDAO;
import dal.ManagerDashboardDAO.TrendPoint;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@WebServlet("/manager/dashboard")
public class ManagerDashboardServlet extends HttpServlet {

    private static String toJsStringArray(List<String> labels) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < labels.size(); i++) {
            if (i > 0) {
                sb.append(",");
            }
            sb.append("\"").append(labels.get(i).replace("\"", "\\\"")).append("\"");
        }
        sb.append("]");
        return sb.toString();
    }

    private static String toJsNumberArray(List<Double> values) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < values.size(); i++) {
            if (i > 0) {
                sb.append(",");
            }
            sb.append(String.format(Locale.US, "%.2f", values.get(i)));
        }
        sb.append("]");
        return sb.toString();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Map<String, Integer> kpi = new ManagerDashboardDAO().getRoomStatusCounts();
        req.setAttribute("totalInventory", kpi.getOrDefault("totalInventory", 0));
        req.setAttribute("liveSuites", kpi.getOrDefault("liveSuites", 0));
        req.setAttribute("guestStays", kpi.getOrDefault("guestStays", 0));
        req.setAttribute("servicing", kpi.getOrDefault("servicing", 0));
        req.setAttribute("outOfOrder", kpi.getOrDefault("outOfOrder", 0));

        List<TrendPoint> daily = new ManagerDashboardDAO().getBookingVelocityDaily(7);
        List<TrendPoint> monthly = new ManagerDashboardDAO().getBookingVelocityMonthly(7);

        List<String> dailyLabels = new ArrayList<>();
        List<Double> dailyValues = new ArrayList<>();
        for (TrendPoint p : daily) {
            dailyLabels.add(p.label);
            dailyValues.add(p.value);
        }

        List<String> monthlyLabels = new ArrayList<>();
        List<Double> monthlyValues = new ArrayList<>();
        for (TrendPoint p : monthly) {
            monthlyLabels.add(p.label);
            monthlyValues.add(p.value);
        }

        req.setAttribute("dailyLabelsJs", toJsStringArray(dailyLabels));
        req.setAttribute("dailyValuesJs", toJsNumberArray(dailyValues));
        req.setAttribute("monthlyLabelsJs", toJsStringArray(monthlyLabels));
        req.setAttribute("monthlyValuesJs", toJsNumberArray(monthlyValues));

        req.setAttribute("active", "dashboard");
        req.setAttribute("pageTitle", "Dashboard");
        req.setAttribute("contentPage", "/view/manager/dashboard.jsp");
        req.getRequestDispatcher("/view/manager/layout.jsp").forward(req, resp);
    }
}
