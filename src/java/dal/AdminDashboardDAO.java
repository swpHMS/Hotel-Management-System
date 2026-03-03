package dal;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class AdminDashboardDAO {


    public int countStaff() throws Exception {
        String sql = "SELECT COUNT(*) FROM dbo.staff";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    public Map<String, Integer> countStaffStatus() throws Exception {

    String sql = """
        SELECT 
            COUNT(*) AS total_staff,
            SUM(CASE WHEN u.status = 1 THEN 1 ELSE 0 END) AS active_count,
            SUM(CASE WHEN u.status = 0 THEN 1 ELSE 0 END) AS inactive_count
        FROM dbo.staff s
        JOIN dbo.users u ON s.user_id = u.user_id
    """;

    Map<String, Integer> result = new HashMap<>();

    try (Connection con = new DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            result.put("total", rs.getInt("total_staff"));
            result.put("active", rs.getInt("active_count"));
            result.put("inactive", rs.getInt("inactive_count"));
        }
    }

    return result;
}

    public Map<String, Integer> countCustomerStatus() throws Exception {

        String sql = """
        SELECT 
            SUM(CASE WHEN u.status = 1 THEN 1 ELSE 0 END) AS active_count,
            SUM(CASE WHEN u.status = 0 THEN 1 ELSE 0 END) AS inactive_count
        FROM dbo.customers c
        JOIN dbo.users u ON c.user_id = u.user_id
    """;

        Map<String, Integer> result = new HashMap<>();

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                result.put("active", rs.getInt("active_count"));
                result.put("inactive", rs.getInt("inactive_count"));
            }
        }

        return result;
    }

    public int countRoles() throws Exception {
        String sql = "SELECT COUNT(*) FROM dbo.roles";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public Map<String, Integer> getRoleDistribution() throws Exception {
        String sql = """
        SELECT r.role_name, COUNT(u.user_id) AS total
        FROM dbo.roles r
        LEFT JOIN dbo.users u ON r.role_id = u.role_id
        GROUP BY r.role_name
    """;

        Map<String, Integer> map = new LinkedHashMap<>();

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                map.put(rs.getString("role_name"),
                        rs.getInt("total"));
            }
        }
        return map;
    }

    public int countCustomers() throws Exception {
        String sql = "SELECT COUNT(*) FROM dbo.customers";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public Map<String, Integer> getUserStatusCounts() {
        Map<String, Integer> map = new HashMap<>();
        String sql
                = "SELECT "
                + "  SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS activeCount, "
                + "  SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS inactiveCount "
                + "FROM dbo.users;";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                map.put("active", rs.getInt("activeCount"));
                map.put("inactive", rs.getInt("inactiveCount"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            map.put("active", 0);
            map.put("inactive", 0);
        }
        return map;
    }

}
