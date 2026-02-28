package dal;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class AdminDashboardDAO {

    public int countUsers() throws Exception {
        String sql = "SELECT COUNT(*) FROM dbo.users";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int countUsersByStatus(int status) throws Exception {
        String sql = "SELECT COUNT(*) FROM dbo.users WHERE status = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public int countCustomers() throws Exception {
        String sql = "SELECT COUNT(*) FROM dbo.customers";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    public Map<String, Integer> getUserStatusCounts() {
    Map<String, Integer> map = new HashMap<>();
    String sql =
        "SELECT " +
        "  SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS activeCount, " +
        "  SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS inactiveCount " +
        "FROM dbo.users;";

    try (Connection con = new DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

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
