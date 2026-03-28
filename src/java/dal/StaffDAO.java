package dal;

import context.DBContext;
import model.StaffProfile;
import java.sql.*;

public class StaffDAO extends DBContext {

    public StaffProfile getStaffByUserId(int userId) {
        String sql = "SELECT s.*, u.email, r.role_name "
                + "FROM staff s "
                + "JOIN users u ON s.user_id = u.user_id "
                + "JOIN roles r ON u.role_id = r.role_id "
                + "WHERE s.user_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return new StaffProfile(
                        rs.getInt("staff_id"),
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getInt("gender"),
                        rs.getDate("date_of_birth"),
                        rs.getString("identity_number"),
                        rs.getString("phone"),
                        rs.getString("residence_address"),
                        rs.getString("email"),
                        rs.getString("role_name")
                );
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return null;
    }

    public boolean updateStaffProfile(int staffId, String fullName, String phone,
                                      int gender, String address, String identityNumber) {
        String sql = "UPDATE staff "
                + "SET full_name = ?, phone = ?, gender = ?, residence_address = ?, identity_number = ? "
                + "WHERE staff_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, fullName);
            st.setString(2, phone);
            st.setInt(3, gender);
            st.setString(4, address);
            st.setString(5, identityNumber);
            st.setInt(6, staffId);

            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return false;
    }

    public int getTotalServiceOrdersByStaffId(int staffId) {
        String sql = "SELECT COUNT(*) FROM service_orders WHERE created_by_staff_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, staffId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return 0;
    }

    public String getPasswordHashByUserId(int userId) {
        String sql = "SELECT password_hash FROM users WHERE user_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getString("password_hash");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return null;
    }

    public boolean updatePasswordByUserId(int userId, String newPasswordHash) {
        String sql = "UPDATE users SET password_hash = ? WHERE user_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newPasswordHash);
            st.setInt(2, userId);

            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return false;
    }
}