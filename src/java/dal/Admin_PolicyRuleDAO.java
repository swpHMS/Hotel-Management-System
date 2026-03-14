package dal;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.PolicyRule;

public class Admin_PolicyRuleDAO {

    //lấy cho sidebar
    public List<PolicyRule> getAllPolicies() {
        List<PolicyRule> list = new ArrayList<>();
        String sql = "SELECT policy_id, name, content FROM dbo.policy_rules ORDER BY policy_id";

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new PolicyRule(
                        rs.getInt("policy_id"),
                        rs.getString("name"),
                        rs.getString("content")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public PolicyRule getByName(String name) {
        String sql = "SELECT policy_id, name, content "
                + "FROM dbo.policy_rules "
                + "WHERE UPPER(name) = UPPER(?)";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PolicyRule p = new PolicyRule();
                    p.setPolicyId(rs.getInt("policy_id"));
                    p.setName(rs.getString("name"));
                    p.setContent(rs.getString("content"));
                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateContent(int policyId, String content) {
        String sql = "UPDATE dbo.policy_rules SET content = ? WHERE policy_id = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, content);
            ps.setInt(2, policyId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateName(int policyId, String newName) {
        String sql = "UPDATE dbo.policy_rules SET name = ? WHERE policy_id = ?";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newName);
            ps.setInt(2, policyId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
     public PolicyRule getById(int policyId) {
        String sql = "SELECT policy_id, name, content FROM dbo.policy_rules WHERE policy_id = ?";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, policyId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new PolicyRule(
                            rs.getInt("policy_id"),
                            rs.getString("name"),
                            rs.getString("content")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
     
      public boolean insertPolicy(String name, String content) {
        String sql = "INSERT INTO dbo.policy_rules(name, content) VALUES (?, ?)";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, content);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
      
      public boolean deletePolicy(int policyId) {
        String sql = "DELETE FROM dbo.policy_rules WHERE policy_id = ?";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, policyId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existsByName(String name) {
        String sql = "SELECT 1 FROM dbo.policy_rules WHERE UPPER(name) = UPPER(?)";

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
      
}
