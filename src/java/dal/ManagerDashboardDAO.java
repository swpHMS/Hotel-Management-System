package dal;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ManagerDashboardDAO extends DBContext {

    public static class TrendPoint {
        public final String label;
        public final double value;

        public TrendPoint(String label, double value) {
            this.label = label;
            this.value = value;
        }
    }

    public Map<String, Integer> getRoomStatusCounts() {
        String sql = """
            SELECT
              COUNT(*) AS total,
              SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS available,
              SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) AS occupied,
              SUM(CASE WHEN status = 3 THEN 1 ELSE 0 END) AS maintenance,
              SUM(CASE WHEN status = 4 THEN 1 ELSE 0 END) AS dirty
            FROM dbo.rooms
        """;

        Map<String, Integer> m = new HashMap<>();
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                m.put("totalInventory", rs.getInt("total"));
                m.put("liveSuites", rs.getInt("available"));
                m.put("guestStays", rs.getInt("occupied"));
                m.put("servicing", rs.getInt("dirty"));
                m.put("outOfOrder", rs.getInt("maintenance"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return m;
    }

    public List<TrendPoint> getBookingVelocityDaily(int daysBack) {
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
               AND (sra.actual_check_out IS NULL OR sra.actual_check_out >= d.d)
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

    public List<TrendPoint> getBookingVelocityMonthly(int monthsBack) {
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
                   AND (sra.actual_check_out IS NULL OR sra.actual_check_out >= d.d)
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
}
