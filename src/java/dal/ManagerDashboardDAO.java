package dal;

import context.DBContext;

import java.sql.*;
import java.util.*;

public class ManagerDashboardDAO extends DBContext {

    public static class TrendPoint {
        public final String label;
        public final int value;
        public TrendPoint(String label, int value) {
            this.label = label;
            this.value = value;
        }
    }

    /**
     * KPI theo dbo.rooms.status:
     * 1:AVAILABLE, 2:OCCUPIED, 3:MAINTENANCE, 4:DIRTY
     */
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
                m.put("liveSuites", rs.getInt("available"));     // Available
                m.put("guestStays", rs.getInt("occupied"));      // Occupied
                m.put("servicing", rs.getInt("dirty"));          // DIRTY ≈ servicing/housekeeping
                m.put("outOfOrder", rs.getInt("maintenance"));   // MAINTENANCE ≈ out-of-order
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return m;
    }

    /**
     * Booking Velocity DAILY: lấy từ dbo.room_type_inventory
     * SUM(booked_rooms) theo inventory_date trong N ngày gần nhất
     */
    public List<TrendPoint> getBookingVelocityDaily(int daysBack) {
        String sql = """
            SELECT
              CONVERT(varchar(10), inventory_date, 120) AS d,
              SUM(booked_rooms) AS v
            FROM dbo.room_type_inventory
            WHERE inventory_date >= DATEADD(DAY, 1 - ?, CAST(GETDATE() AS date))
              AND inventory_date <= CAST(GETDATE() AS date)
            GROUP BY CONVERT(varchar(10), inventory_date, 120)
            ORDER BY d
        """;

        List<TrendPoint> list = new ArrayList<>();
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, daysBack);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new TrendPoint(rs.getString("d"), rs.getInt("v")));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Booking Velocity MONTHLY: lấy từ dbo.room_type_inventory
     * SUM(booked_rooms) theo tháng trong N tháng gần nhất
     */
    public List<TrendPoint> getBookingVelocityMonthly(int monthsBack) {
        String sql = """
            SELECT
              FORMAT(inventory_date, 'yyyy-MM') AS ym,
              SUM(booked_rooms) AS v
            FROM dbo.room_type_inventory
            WHERE inventory_date >= DATEFROMPARTS(
                    YEAR(DATEADD(MONTH, 1 - ?, CAST(GETDATE() AS date))),
                    MONTH(DATEADD(MONTH, 1 - ?, CAST(GETDATE() AS date))),
                    1
                  )
              AND inventory_date <= CAST(GETDATE() AS date)
            GROUP BY FORMAT(inventory_date, 'yyyy-MM')
            ORDER BY ym
        """;

        List<TrendPoint> list = new ArrayList<>();
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, monthsBack);
            ps.setInt(2, monthsBack);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new TrendPoint(rs.getString("ym"), rs.getInt("v")));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
