package dal;

import context.DBContext;
import model.CustomerProfile;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CustomerDAO extends DBContext {

    public CustomerProfile getProfileByUserId(int userId) {
        String sql = """
            SELECT u.user_id, u.email, c.customer_id, c.full_name, c.residence_address
            FROM dbo.users u
            JOIN dbo.customers c ON c.user_id = u.user_id
            WHERE u.user_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CustomerProfile p = new CustomerProfile();
                    p.setUserId(rs.getInt("user_id"));
                    p.setEmail(rs.getString("email"));
                    p.setCustomerId(rs.getInt("customer_id"));
                    p.setFullName(rs.getString("full_name"));
                    p.setResidenceAddress(rs.getString("residence_address"));
                    return p;
                }
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }
}
