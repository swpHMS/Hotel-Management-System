package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO extends DBContext {

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
