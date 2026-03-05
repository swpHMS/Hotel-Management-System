package dal;

import context.DBContext;
import model.PolicyRule;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PolicyRuleDAO extends DBContext {

    public List<PolicyRule> getAllPolicyRules() throws Exception {
        String sql = """
            SELECT policy_id, name, content
            FROM dbo.policy_rules
            ORDER BY policy_id ASC
        """;

        List<PolicyRule> list = new ArrayList<>();

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                PolicyRule p = new PolicyRule();
                p.setPolicyId(rs.getInt("policy_id"));
                p.setName(rs.getString("name"));
                p.setContent(rs.getString("content"));
                list.add(p);
            }
        }
        return list;
    }
    
    public PolicyRule getPolicyByName(String name) throws Exception {
    String sql = """
        SELECT TOP 1 policy_id, name, content
        FROM dbo.policy_rules
        WHERE name = ?
    """;

    try (Connection con = getConnection();
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
    }
    return null;
}
}
