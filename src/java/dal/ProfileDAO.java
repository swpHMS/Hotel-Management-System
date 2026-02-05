package dal;

import context.DBContext;
import model.ProfileView;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ProfileDAO extends DBContext {

    public ProfileView getCustomerProfileByUserId(int userId) {
        String sql = """
            SELECT
                u.user_id,
                u.email,
                u.status AS user_status,
                r.role_name,
                c.customer_id,
                c.full_name,
                c.gender,
                c.date_of_birth,
                c.identity_number,
                c.phone,
                c.residence_address
            FROM dbo.users u
            JOIN dbo.roles r ON r.role_id = u.role_id
            JOIN dbo.customers c ON c.user_id = u.user_id
            WHERE u.user_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProfileView p = new ProfileView();
                    p.setUserId(rs.getInt("user_id"));
                    p.setEmail(rs.getString("email"));
                    p.setUserStatus(rs.getInt("user_status"));
                    p.setRoleName(rs.getString("role_name"));

                    p.setCustomerId(rs.getInt("customer_id"));
                    p.setFullName(rs.getString("full_name"));

                    int g = rs.getInt("gender");
                    p.setGender(rs.wasNull() ? null : g);

                    p.setDateOfBirth(rs.getDate("date_of_birth"));
                    p.setIdentityNumber(rs.getString("identity_number"));
                    p.setPhone(rs.getString("phone"));
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
