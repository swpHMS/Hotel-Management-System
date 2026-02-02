package dal;

import context.DBContext;
import model.User;
import java.sql.*;
import model.GoogleUserDTO;
import utils.PasswordUtils;

public class UserDAO extends DBContext {
    
    // 1. Kiểm tra Email tồn tại (Dùng để validate lúc đăng ký)
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

    // 2. Lấy User theo Email (Dùng cho đăng nhập)
   public User getUserByEmail(String email) {
    String sql = "SELECT * FROM users WHERE email = ?";
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setString(1, email);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            User u = new User();
            u.setUserId(rs.getInt("user_id"));
            u.setEmail(rs.getString("email"));
            u.setRoleId(rs.getInt("role_id"));
            u.setPasswordHash(rs.getString("password_hash"));
            // THÊM DÒNG NÀY ĐỂ LẤY TRẠNG THÁI TỪ DATABASE
            u.setStatus(rs.getInt("status")); 
            return u;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}

    // 3. Đăng ký tài khoản LOCAL (Có mã hóa mật khẩu)
        public boolean registerLocalUser(String email, String password, String fullName, String phone, String token) {
        String passwordHash = PasswordUtils.hashPassword(password);

        // Đảm bảo SQL có cột token và status = 0 (chưa kích hoạt)
        String sqlUser = "INSERT INTO users (email, password_hash, auth_provider, role_id, status, token) VALUES (?, ?, 1, 3, 0, ?)";
        String sqlCustomer = "INSERT INTO customers (user_id, full_name, phone) VALUES (?, ?, ?)";

        try {
            connection.setAutoCommit(false);
            PreparedStatement ps1 = connection.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, email);
            ps1.setString(2, passwordHash);
            ps1.setString(3, token); // Lưu token bạn vừa tạo vào DB
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
            try { connection.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
            return false;
        }
    }

    // 4. Đăng ký tài khoản GOOGLE
    public void registerGoogleUser(GoogleUserDTO googleUser) {
        String sqlUser = "INSERT INTO users (email, auth_provider, google_sub, portrait_url, role_id, status) VALUES (?, 2, ?, ?, 3, 1)";
        String sqlCustomer = "INSERT INTO customers (user_id, full_name) VALUES (?, ?)";

        try {
            connection.setAutoCommit(false); 

            PreparedStatement ps1 = connection.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, googleUser.getEmail());
            ps1.setString(2, googleUser.getId());
            ps1.setString(3, googleUser.getPicture());
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
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    
    public User checkLogin(String email, String password) {
    User user = getUserByEmail(email); // Hàm này bạn đã có
    if (user != null && user.getPasswordHash() != null) {
        // So sánh mật khẩu thuần với password_hash trong DB bằng BCrypt
        if (org.mindrot.jbcrypt.BCrypt.checkpw(password, user.getPasswordHash())) {
            return user;
        }
    }
    return null;
}
    
    public boolean verifyUser(String email, String token) {
    // Câu lệnh SQL: Cập nhật status thành 1 và xóa token nếu email và token khớp
    String sql = "UPDATE users SET status = 1, token = NULL WHERE email = ? AND token = ?";
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, email);
        ps.setString(2, token);
        
        int rowsAffected = ps.executeUpdate();
        // Nếu có ít nhất 1 dòng được cập nhật, trả về true
        return rowsAffected > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
    
    // 1. Lưu token khôi phục vào user dựa trên email
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
    // Thêm status = 1 vào câu lệnh SQL để kích hoạt tài khoản ngay khi đổi pass thành công
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

// delete account 
private String sql_email="DELETE FROM [dbo].[customers]\n" +
"      WHERE email like '?';";
public void deleteAccount(String email){
    try {
        PreparedStatement pre=connection.prepareStatement(sql_email);
        pre.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
}