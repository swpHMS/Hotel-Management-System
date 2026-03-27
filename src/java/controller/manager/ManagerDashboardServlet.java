package controller.manager;

import dal.ManagerDashboardDAO;
import dal.ManagerDashboardDAO.TrendPoint;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import model.ManagerDashboardKpi;
import model.ManagerDashboardTrendSeries;

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

    private static ManagerDashboardTrendSeries toTrendSeries(List<TrendPoint> points) {
        List<String> labels = new ArrayList<>();
        List<Double> values = new ArrayList<>();
        double totalValue = 0;

        for (TrendPoint point : points) {
            labels.add(point.label);
            values.add(point.value);
            totalValue += point.value;
        }

        return new ManagerDashboardTrendSeries(
                toJsStringArray(labels),
                toJsNumberArray(values),
                totalValue
        );
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ManagerDashboardDAO dao = new ManagerDashboardDAO();
        ManagerDashboardKpi kpi = dao.getRoomStatusCounts();
        ManagerDashboardTrendSeries dailyTrend = toTrendSeries(dao.getBookingVelocityDaily(7));
        ManagerDashboardTrendSeries monthlyTrend = toTrendSeries(dao.getBookingVelocityMonthly(7));
        boolean useDailyByDefault = dailyTrend.getTotalValue() >= monthlyTrend.getTotalValue();
        DecimalFormat percentFormat = new DecimalFormat("0.00");

        req.setAttribute("kpi", kpi);
        req.setAttribute("dailyTrend", dailyTrend);
        req.setAttribute("monthlyTrend", monthlyTrend);
        req.setAttribute("initialTrendMode", useDailyByDefault ? "daily" : "monthly");
        req.setAttribute("fullHousePercentText", percentFormat.format(kpi.getOccupancyPercent()) + "%");

        req.setAttribute("active", "dashboard");
        req.setAttribute("pageTitle", "Dashboard");
        req.setAttribute("contentPage", "/view/manager/dashboard.jsp");
        req.getRequestDispatcher("/view/manager/layout.jsp").forward(req, resp);
    }
}
