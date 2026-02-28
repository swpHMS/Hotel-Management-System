package dal;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.PolicyRule;

public class Admin_PolicyRuleDAO {

    public PolicyRule getByName(String name) {
        String sql = "SELECT policy_id, name, content FROM dbo.policy_rules WHERE name = ?";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

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
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, content);
            ps.setInt(2, policyId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
