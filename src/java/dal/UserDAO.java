package dal;

import context.DBContext;
import model.User;
import java.sql.*;
import model.GoogleUserDTO;
import utils.PasswordUtils;

public class UserDAO extends DBContext {

    // 1. Kiểm tra Email tồn tại
    public boolean checkEmailExist(String email) {
        String sql = "SELECT 1 FROM users WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Lấy User theo Email (JOIN để lấy thêm tên từ bảng Profile)
    public User getUserByEmail(String email) {
        // Dùng LEFT JOIN để lấy full_name từ bảng customers hoặc staff nếu có
        String sql = "SELECT u.*, c.full_name FROM users u "
                + "LEFT JOIN customers c ON u.user_id = c.user_id "
                + "WHERE u.email = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setRoleId(rs.getInt("role_id"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setStatus(rs.getInt("status"));
                // Giả sử bạn có trường fullName trong Model User để hiển thị lên Header
                // u.setFullName(rs.getString("full_name")); 
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 3. Đăng ký tài khoản LOCAL (Transaction 2 bảng)
    public boolean registerLocalUser(String email, String password, String fullName, String phone, String token) {
        String passwordHash = PasswordUtils.hashPassword(password);
        String sqlUser = "INSERT INTO users (email, password_hash, auth_provider, role_id, status, token) VALUES (?, ?, 1, 5, 0, ?)";
        String sqlCustomer = "INSERT INTO customers (user_id, full_name, phone) VALUES (?, ?, ?)";

        try {
            connection.setAutoCommit(false); // Bắt đầu giao dịch

            PreparedStatement ps1 = connection.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, email);
            ps1.setString(2, passwordHash);
            ps1.setString(3, token);
            ps1.executeUpdate();

            ResultSet rs = ps1.getGeneratedKeys();
            if (rs.next()) {
                int newUserId = rs.getInt(1);
                PreparedStatement ps2 = connection.prepareStatement(sqlCustomer);
                ps2.setInt(1, newUserId);
                ps2.setString(2, fullName);
                ps2.setString(3, phone);
                ps2.executeUpdate();
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
            }
        }
    }

    // 4. Đăng ký tài khoản GOOGLE (Sửa lỗi thiếu tham số ảnh đại diện)
    public void registerGoogleUser(GoogleUserDTO googleUser) {
        // Lưu ý: Database của bạn cần cột 'avatar' trong bảng users hoặc customers
        String sqlUser = "INSERT INTO users (email, auth_provider, google_sub, role_id, status) VALUES (?, 2, ?, 5, 1)";
        String sqlCustomer = "INSERT INTO customers (user_id, full_name) VALUES (?, ?)";

        try {
            connection.setAutoCommit(false);
            PreparedStatement ps1 = connection.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, googleUser.getEmail());
            ps1.setString(2, googleUser.getId());
            ps1.executeUpdate();

            ResultSet rs = ps1.getGeneratedKeys();
            if (rs.next()) {
                int newUserId = rs.getInt(1);
                PreparedStatement ps2 = connection.prepareStatement(sqlCustomer);
                ps2.setInt(1, newUserId);
                ps2.setString(2, googleUser.getName());
                ps2.executeUpdate();
            }
            connection.commit();
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
            }
        }
    }

    // 5. Kiểm tra đăng nhập
    public User checkLogin(String email, String password) {
        User user = getUserByEmail(email);
        if (user != null && user.getPasswordHash() != null) {
            if (org.mindrot.jbcrypt.BCrypt.checkpw(password, user.getPasswordHash())) {
                return user;
            }
        }
        return null;
    }

    // 6. Xóa tài khoản rác (Sửa lỗi khóa ngoại)
    public void deleteAccount(String email) {
        // Quy tắc: Xóa ở bảng con (customers) trước, bảng mẹ (users) sau
        String sqlGetId = "SELECT user_id FROM users WHERE email = ?";
        String sqlDelCust = "DELETE FROM customers WHERE user_id = ?";
        String sqlDelUser = "DELETE FROM users WHERE user_id = ?";

        try {
            connection.setAutoCommit(false);
            PreparedStatement psGet = connection.prepareStatement(sqlGetId);
            psGet.setString(1, email);
            ResultSet rs = psGet.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("user_id");

                PreparedStatement ps1 = connection.prepareStatement(sqlDelCust);
                ps1.setInt(1, id);
                ps1.executeUpdate();

                PreparedStatement ps2 = connection.prepareStatement(sqlDelUser);
                ps2.setInt(1, id);
                ps2.executeUpdate();
            }
            connection.commit();
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
            }
        }
    }

    // --- Các hàm hỗ trợ Token (Verify, Reset) giữ nguyên logic cũ ---
    public boolean verifyUser(String email, String token) {
        String sql = "UPDATE users SET status = 1, token = NULL WHERE email = ? AND token = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, token);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateToken(String email, String token) {
        String sql = "UPDATE users SET token = ? WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean resetPassword(String token, String newPassword) {
        String sql = "UPDATE users SET password_hash = ?, token = NULL, status = 1 WHERE token = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, PasswordUtils.hashPassword(newPassword));
            ps.setString(2, token);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy hash mật khẩu (chỉ dùng cho LOCAL user)
    public String getPasswordHashByUserId(int userId) {
        String sql = """
            SELECT password_hash
            FROM dbo.users
            WHERE user_id = ?
              AND auth_provider = 1
              AND status = 1
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("password_hash");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update mật khẩu mới
    public boolean updatePasswordHash(int userId, String newHash) {
        String sql = """
            UPDATE dbo.users
            SET password_hash = ?
            WHERE user_id = ?
              AND auth_provider = 1
              AND status = 1
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
