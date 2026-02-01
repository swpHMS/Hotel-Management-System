package dal;

import context.DBContext;
import java.sql.*;
import java.util.*;
import model.Role;
import model.User;

public class AdminUserDAO {

    public int countAllUsers() throws Exception {
        String sql = "SELECT COUNT(*) FROM dbo.users";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public List<User> getUsersPaged(int page, int pageSize) throws Exception {
    int offset = (page - 1) * pageSize;

    String sql = """
        SELECT u.user_id, u.email, u.status,
               u.auth_provider, u.google_sub,
               u.role_id, r.role_name
        FROM dbo.users u
        LEFT JOIN dbo.roles r ON r.role_id = u.role_id
        ORDER BY u.user_id
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

    List<User> list = new ArrayList<>();

    try (Connection con = new DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, offset);
        ps.setInt(2, pageSize);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setStatus(rs.getInt("status"));
                u.setAuthProvider(rs.getInt("auth_provider")); // ✅ INT
                u.setGoogleSub(rs.getString("google_sub"));
                u.setRoleId(rs.getInt("role_id"));
                u.setRoleName(rs.getString("role_name"));
                list.add(u);
            }
        }
    }
    return list;
}

    public List<Role> getAllStaffRoles() throws Exception {
    List<Role> list = new ArrayList<>();
    String sql = """
        SELECT role_id, role_name
        FROM roles
        WHERE role_name <> 'CUSTOMER'
        ORDER BY role_name
    """;

    try (Connection con = new DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Role r = new Role();
            r.setRoleId(rs.getInt("role_id"));
            r.setRoleName(rs.getString("role_name"));
            list.add(r);
        }
    }
    return list;
}

  public List<User> getStaffList(Integer roleId, Integer status, int page, int pageSize) throws Exception {
    List<User> list = new ArrayList<>();
    int offset = (page - 1) * pageSize;

    String sql = """
        SELECT 
            u.user_id,
            s.full_name,
            u.email,
            u.status,
            r.role_name
        FROM users u
        JOIN roles r ON r.role_id = u.role_id
        LEFT JOIN staff s ON s.user_id = u.user_id
        WHERE r.role_name <> 'CUSTOMER'
    """;

    if (roleId != null) sql += " AND u.role_id = ?";
    if (status != null) sql += " AND u.status = ?";

    sql += " ORDER BY u.user_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (Connection con = new DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        int idx = 1;
        if (roleId != null) ps.setInt(idx++, roleId);
        if (status != null) ps.setInt(idx++, status);

        ps.setInt(idx++, offset);
        ps.setInt(idx, pageSize);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name")); // ✅ QUAN TRỌNG
                u.setEmail(rs.getString("email"));
                u.setStatus(rs.getInt("status"));
                u.setRoleName(rs.getString("role_name"));
                list.add(u);
            }
        }
    }
    return list;
}

    public int countStaff(Integer roleId, Integer status) throws Exception {
    String sql = """
        SELECT COUNT(*)
        FROM users u
        JOIN roles r ON u.role_id = r.role_id
        WHERE r.role_name <> 'CUSTOMER'
    """;

    if (roleId != null) sql += " AND u.role_id = ?";
    if (status != null) sql += " AND u.status = ?";

    try (Connection con = new DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        int idx = 1;
        if (roleId != null) ps.setInt(idx++, roleId);
        if (status != null) ps.setInt(idx++, status);

        try (ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}

}
