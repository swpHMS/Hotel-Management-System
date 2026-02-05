package dal;

import context.DBContext;
import model.ProfileView;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CustomerProfileDAO extends DBContext {

    // Lấy profile (giống ProfileDAO) - để edit page hiển thị data
    public ProfileView getCustomerProfileByUserId(int userId) {
        String sql = """
            SELECT
                u.user_id, u.email, u.status AS user_status, r.role_name,
                c.customer_id, c.full_name, c.gender, c.date_of_birth,
                c.identity_number, c.phone, c.residence_address
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

    // ✅ Update các field cho customer dựa trên user_id (có identity_number)
    public boolean updateCustomerProfileByUserId(int userId,
            String fullName,
            Integer gender,
            java.sql.Date dateOfBirth,
            String identityNumber,
            String phone,
            String residenceAddress) {

        String sql = """
        UPDATE dbo.customers
        SET full_name = ?,
            gender = ?,
            date_of_birth = ?,
            identity_number = ?,
            phone = ?,
            residence_address = ?
        WHERE user_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, fullName);

            if (gender == null) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, gender);
            }

            if (dateOfBirth == null) {
                ps.setNull(3, java.sql.Types.DATE);
            } else {
                ps.setDate(3, dateOfBirth);
            }

            // identity_number: nullable/blank => NULL
            if (identityNumber == null || identityNumber.isBlank()) {
                ps.setNull(4, java.sql.Types.VARCHAR);
            } else {
                ps.setString(4, identityNumber);
            }

            // phone: nullable/blank => NULL
            if (phone == null || phone.isBlank()) {
                ps.setNull(5, java.sql.Types.VARCHAR);
            } else {
                ps.setString(5, phone);
            }

            // address: nullable/blank => NULL
            if (residenceAddress == null || residenceAddress.isBlank()) {
                ps.setNull(6, java.sql.Types.NVARCHAR);
            } else {
                ps.setString(6, residenceAddress);
            }

            ps.setInt(7, userId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("updateCustomerProfileByUserId: " + e.getMessage());
        }
        return false;
    }

}
