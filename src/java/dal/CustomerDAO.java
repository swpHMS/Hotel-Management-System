package dal;

import context.DBContext;
import model.CustomerProfile;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

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

    // ✅ NEW: lấy customer_id theo user_id (nhanh)
    public Integer getCustomerIdByUserId(int userId) {
        String sql = "SELECT customer_id FROM dbo.customers WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    // ✅ NEW: tạo customer nếu chưa có (dùng khi finalize)
    public int createCustomerForUser(int userId, String fullName) {
        String sql = "INSERT INTO dbo.customers(user_id, full_name) VALUES(?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, (fullName == null || fullName.isBlank()) ? "Customer" : fullName.trim());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        throw new RuntimeException("Cannot create customer for user_id=" + userId);
    }

    // (OPTION 1) nếu bạn muốn support guest không login
    public int createGuestCustomer(String fullName) {
        String sql = "INSERT INTO dbo.customers(user_id, full_name) VALUES(NULL, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, (fullName == null || fullName.isBlank()) ? "Guest" : fullName.trim());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        throw new RuntimeException("Cannot create guest customer");
    }
}
