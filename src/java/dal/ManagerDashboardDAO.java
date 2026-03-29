package dal;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.ManagerDashboardKpi;

public class ManagerDashboardDAO extends DBContext {

    public static class TrendPoint {
        public final String label;
        public final double value;

        public TrendPoint(String label, double value) {
            this.label = label;
            this.value = value;
        }
    }

    public ManagerDashboardKpi getRoomStatusCounts() {
        String bookingDateExpr = getBookingCreatedDateExpression();
        String sql = """
            SELECT
              COUNT(*) AS total,
              SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS available,
              SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) AS occupied,
              SUM(CASE WHEN status = 3 THEN 1 ELSE 0 END) AS maintenance,
              SUM(CASE WHEN status = 4 THEN 1 ELSE 0 END) AS dirty,
              (
                  SELECT COALESCE(SUM(b.total_amount), 0)
                  FROM dbo.bookings b
                  WHERE b.status IN (2, 3, 4)
              ) AS total_revenue,
              (
                  SELECT COALESCE(SUM(b.total_amount), 0)
                  FROM dbo.bookings b
                  WHERE b.status IN (2, 3, 4)
                    AND YEAR(%s) = YEAR(GETDATE())
                    AND MONTH(%s) = MONTH(GETDATE())
              ) AS month_revenue
            FROM dbo.rooms
        """.formatted(
                bookingDateExpr,
                bookingDateExpr
        );

        ManagerDashboardKpi kpi = new ManagerDashboardKpi();
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                kpi.setTotalInventory(rs.getInt("total"));
                kpi.setAvailable(rs.getInt("available"));
                kpi.setOccupied(rs.getInt("occupied"));
                kpi.setDirty(rs.getInt("dirty"));
                kpi.setMaintenance(rs.getInt("maintenance"));
                kpi.setTotalRevenue(rs.getDouble("total_revenue"));
                kpi.setCurrentMonthRevenue(rs.getDouble("month_revenue"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return kpi;
    }

    public List<TrendPoint> getDailyOccupancyTrend(int daysBack) {
        String sql = """
            WITH Days AS (
                SELECT CAST(DATEADD(DAY, 1 - ?, CAST(GETDATE() AS date)) AS date) AS d
                UNION ALL
                SELECT DATEADD(DAY, 1, d)
                FROM Days
                WHERE d < CAST(GETDATE() AS date)
            ),
            TotalRooms AS (
                SELECT COUNT(*) AS total_rooms
                FROM dbo.rooms
            )
            SELECT
                CONVERT(varchar(10), d.d, 120) AS d,
                CAST(
                    COALESCE(COUNT(DISTINCT sra.room_id), 0) * 100.0 / NULLIF(tr.total_rooms, 0)
                    AS decimal(10, 2)
                ) AS v
            FROM Days d
            CROSS JOIN TotalRooms tr
            LEFT JOIN dbo.stay_room_assignments sra
                ON sra.actual_check_in < DATEADD(DAY, 1, d.d)
               AND (sra.actual_check_out IS NULL OR sra.actual_check_out > d.d)
            GROUP BY d.d, tr.total_rooms
            ORDER BY d.d
            OPTION (MAXRECURSION 400)
        """;

        List<TrendPoint> list = new ArrayList<>();
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, daysBack);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new TrendPoint(rs.getString("d"), rs.getDouble("v")));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<TrendPoint> getMonthlyOccupancyTrend(int monthsBack) {
        String sql = """
            WITH Days AS (
                SELECT DATEFROMPARTS(
                           YEAR(DATEADD(MONTH, 1 - ?, CAST(GETDATE() AS date))),
                           MONTH(DATEADD(MONTH, 1 - ?, CAST(GETDATE() AS date))),
                           1
                       ) AS d
                UNION ALL
                SELECT DATEADD(DAY, 1, d)
                FROM Days
                WHERE d < CAST(GETDATE() AS date)
            ),
            TotalRooms AS (
                SELECT COUNT(*) AS total_rooms
                FROM dbo.rooms
            ),
            DailyOccupancy AS (
                SELECT
                    d.d AS occupancy_date,
                    CAST(
                        COALESCE(COUNT(DISTINCT sra.room_id), 0) * 100.0 / NULLIF(tr.total_rooms, 0)
                        AS decimal(10, 2)
                    ) AS daily_rate
                FROM Days d
                CROSS JOIN TotalRooms tr
                LEFT JOIN dbo.stay_room_assignments sra
                    ON sra.actual_check_in < DATEADD(DAY, 1, d.d)
                   AND (sra.actual_check_out IS NULL OR sra.actual_check_out > d.d)
                GROUP BY d.d, tr.total_rooms
            )
            SELECT
                FORMAT(occupancy_date, 'yyyy-MM') AS ym,
                CAST(AVG(daily_rate) AS decimal(10, 2)) AS v
            FROM DailyOccupancy
            GROUP BY FORMAT(occupancy_date, 'yyyy-MM')
            ORDER BY ym
            OPTION (MAXRECURSION 400)
        """;

        List<TrendPoint> list = new ArrayList<>();
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, monthsBack);
            ps.setInt(2, monthsBack);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new TrendPoint(rs.getString("ym"), rs.getDouble("v")));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private String getBookingCreatedDateExpression() {
        if (hasColumn("dbo", "bookings", "created_at")) {
            return "b.created_at";
        }
        if (hasColumn("dbo", "bookings", "created_date")) {
            return "b.created_date";
        }
        if (hasColumn("dbo", "bookings", "booking_date")) {
            return "b.booking_date";
        }
        if (hasColumn("dbo", "bookings", "created_on")) {
            return "b.created_on";
        }
        return "b.check_in_date";
    }

    private boolean hasColumn(String schema, String table, String column) {
        String sql = """
            SELECT 1
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = ?
              AND TABLE_NAME = ?
              AND COLUMN_NAME = ?
        """;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, schema);
            ps.setString(2, table);
            ps.setString(3, column);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

}
