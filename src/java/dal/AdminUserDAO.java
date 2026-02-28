package dal;

import context.DBContext;
import java.sql.*;
import java.util.*;
import model.Role;
import model.UserProfile;

public class AdminUserDAO {

    public int countAllUsers() throws Exception {
        String sql = "SELECT COUNT(*) FROM dbo.users";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public List<UserProfile> getUsersPaged(int page, int pageSize) throws Exception {
        int offset = (page - 1) * pageSize;

        String sql = """
        SELECT u.user_id, u.email, u.status,
               u.auth_provider, u.google_sub,
               u.role_id, r.role_name
        FROM dbo.users u
        LEFT JOIN dbo.roles r ON r.role_id = u.role_id
        ORDER BY u.user_id DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

        List<UserProfile> list = new ArrayList<>();

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserProfile u = new UserProfile();
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

    //lấy role để đổ vào dropdown "Role"
    public List<Role> getAllRoles() throws Exception {
        List<Role> list = new ArrayList<>();
        String sql = """
        SELECT role_id, role_name
        FROM roles
        ORDER BY role_name
    """;

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Role r = new Role();
                r.setRoleId(rs.getInt("role_id"));
                r.setRoleName(rs.getString("role_name"));
                list.add(r);
            }
        }
        return list;
    }

    public List<UserProfile> getStaffList(Integer roleId, Integer status, String keyword, int page, int pageSize) throws Exception {
        List<UserProfile> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        StringBuilder sql = new StringBuilder();
        sql.append("""
        SELECT 
            s.staff_id,
            u.user_id,
            s.full_name,
            u.email,
            u.status,
            r.role_name
        FROM users u
        JOIN roles r ON r.role_id = u.role_id
        LEFT JOIN staff s ON s.user_id = u.user_id
        WHERE r.role_name IN ('ADMIN','MANAGER','RECEPTIONIST','STAFF')
    """);

        if (roleId != null) {
            sql.append("\n AND u.role_id = ? ");
        }
        if (status != null) {
            sql.append("\n AND u.status = ? ");
        }

        // search theo NAME 
        if (hasKeyword) {
            sql.append("\n AND s.full_name COLLATE Vietnamese_100_CI_AI LIKE ? ");
        }

        sql.append("\n ORDER BY u.user_id DESC ");
        sql.append("\n OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int idx = 1;
            if (roleId != null) {
                ps.setInt(idx++, roleId);
            }
            if (status != null) {
                ps.setInt(idx++, status);
            }
            if (hasKeyword) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }

            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserProfile u = new UserProfile();
                    Object staffIdObj = rs.getObject("staff_id");
                    u.setStaffId(staffIdObj == null ? 0 : ((Number) staffIdObj).intValue());
                    u.setUserId(rs.getInt("user_id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setEmail(rs.getString("email"));
                    u.setStatus(rs.getInt("status"));
                    u.setRoleName(rs.getString("role_name"));
                    list.add(u);
                }
            }
        }
        return list;
    }

    public int countStaff(Integer roleId, Integer status, String keyword) throws Exception {
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();

        StringBuilder sql = new StringBuilder();
        sql.append("""
        SELECT COUNT(*)
        FROM users u
        JOIN roles r ON u.role_id = r.role_id
        LEFT JOIN staff s ON s.user_id = u.user_id
        WHERE r.role_name IN ('MANAGER','RECEPTIONIST','STAFF')
    """);

        if (roleId != null) {
            sql.append("\n AND u.role_id = ? ");
        }
        if (status != null) {
            sql.append("\n AND u.status = ? ");
        }
        if (hasKeyword) {
            sql.append("\n AND s.full_name COLLATE Vietnamese_100_CI_AI LIKE ? ");
        }

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int idx = 1;
            if (roleId != null) {
                ps.setInt(idx++, roleId);
            }
            if (status != null) {
                ps.setInt(idx++, status);
            }
            if (hasKeyword) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    //detail staff
    public UserProfile getStaffByUserId(int userId) throws Exception {
        String sql = """
        SELECT
            s.staff_id,            
            u.user_id,
            u.email,
            u.status,
            u.role_id,
            r.role_name,
            s.full_name,
            s.phone,
            s.gender,
            s.date_of_birth,
            s.identity_number,
            s.residence_address
        FROM users u
        JOIN roles r ON r.role_id = u.role_id
        LEFT JOIN staff s ON s.user_id = u.user_id
        WHERE u.user_id = ?
          AND r.role_name IN ('ADMIN','MANAGER','RECEPTIONIST','STAFF')
    """;

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                UserProfile p = new UserProfile();

                // ✅ staff_id có thể NULL nếu không có row staff
                Object staffIdObj = rs.getObject("staff_id");
                p.setStaffId(staffIdObj == null ? 0 : ((Number) staffIdObj).intValue());

                p.setUserId(rs.getInt("user_id"));
                p.setEmail(rs.getString("email"));
                p.setStatus(rs.getInt("status"));
                p.setRoleId(rs.getInt("role_id"));
                p.setRoleName(rs.getString("role_name"));

                p.setFullName(rs.getString("full_name"));
                p.setPhone(rs.getString("phone"));
                p.setGender(rs.getInt("gender"));
                p.setDateOfBirth(rs.getDate("date_of_birth"));
                p.setIdentityNumber(rs.getString("identity_number"));
                p.setResidenceAddress(rs.getString("residence_address"));

                return p;
            }
        }
    }

    //dùng cho crateStaff+ Staff Edit
    //lấy role ko phải Customer
    public boolean updateUserRoleStatus(int userId, int roleId, int status) throws Exception {
        String sql = """
        UPDATE users
        SET role_id = ?, status = ?
        WHERE user_id = ?
    """;

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ps.setInt(2, status);
            ps.setInt(3, userId);

            return ps.executeUpdate() > 0;
        }
    }

    // ======================
// CHECK DUPLICATE STAFF
// ======================
    public boolean emailExists(String email) throws Exception {
        String sql = "SELECT 1 FROM dbo.users WHERE email = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean identityExists(String identityNumber) throws Exception {
        String sql = "SELECT 1 FROM dbo.staff WHERE identity_number = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, identityNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean phoneExistsInStaff(String phone) throws Exception {
        String sql = "SELECT 1 FROM staff WHERE phone = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean cccdExistsInStaff(String identityNumber) throws Exception {
        String sql = "SELECT 1 FROM staff WHERE identity_number = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, identityNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Role> getAllNonCustomerRoles() throws Exception {
        List<Role> list = new ArrayList<>();
        String sql = """
        SELECT role_id, role_name
        FROM roles
        WHERE role_name IN ('MANAGER', 'RECEPTIONIST', 'STAFF','ADMIN')
        ORDER BY role_name
    """;

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Role r = new Role();
                r.setRoleId(rs.getInt("role_id"));
                r.setRoleName(rs.getString("role_name"));
                list.add(r);
            }
        }
        return list;
    }

    public int createStaffAccount(
            String email,
            String passwordHash,
            int roleId,
            int status,
            String fullName,
            int gender,
            java.sql.Date dob,
            String identityNumber,
            String phone,
            String address
    ) throws Exception {

        // auth_provider: 1 = LOCAL (theo DB bạn đang dùng)
        String sqlUser = """
        INSERT INTO users (email, password_hash, auth_provider, google_sub, status, role_id)
        VALUES (?, ?, 1, NULL, ?, ?)
    """;

        String sqlStaff = """
        INSERT INTO staff (user_id, full_name, gender, date_of_birth, identity_number, phone, residence_address)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """;

        try (Connection con = new DBContext().getConnection()) {
            con.setAutoCommit(false);

            try (PreparedStatement psUser = con.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
                psUser.setString(1, email);
                psUser.setString(2, passwordHash);
                psUser.setInt(3, status);
                psUser.setInt(4, roleId);

                int affected = psUser.executeUpdate();
                if (affected == 0) {
                    throw new SQLException("Insert users failed");
                }

                int userId;
                try (ResultSet keys = psUser.getGeneratedKeys()) {
                    if (!keys.next()) {
                        throw new SQLException("No generated user_id");
                    }
                    userId = keys.getInt(1);
                }

                try (PreparedStatement psStaff = con.prepareStatement(sqlStaff)) {
                    psStaff.setInt(1, userId);
                    psStaff.setString(2, fullName);
                    psStaff.setInt(3, gender);
                    psStaff.setDate(4, dob);
                    psStaff.setString(5, identityNumber);
                    psStaff.setString(6, phone);
                    psStaff.setString(7, address);

                    psStaff.executeUpdate();
                }

                con.commit();
                return userId;

            } catch (Exception ex) {
                con.rollback();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    //CỦA EDIT PROFILE
    public boolean emailExistsExceptUserId(String email, int userId) throws Exception {
        String sql = "SELECT 1 FROM dbo.users WHERE email = ? AND user_id <> ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void updateStaffProfile(UserProfile s) throws Exception {

        // 1) update email trong users
        String sqlUser = "UPDATE dbo.users SET email = ? WHERE user_id = ?";

        // 2) update profile 
        String sqlStaff
                = "UPDATE st "
                + "SET st.full_name = ?, st.gender = ?, st.date_of_birth = ?, st.phone = ?, st.residence_address = ? "
                + "FROM dbo.staff st "
                + "JOIN dbo.users u ON u.user_id = st.user_id "
                + "WHERE st.user_id = ? AND u.role_id IN (1,2,3,4)";

        Connection con = null;
        try {
            con = new DBContext().getConnection();
            con.setAutoCommit(false);

            // update users.email
            try (PreparedStatement ps = con.prepareStatement(sqlUser)) {
                ps.setString(1, s.getEmail());
                ps.setInt(2, s.getUserId());
                ps.executeUpdate();
            }

            // update staff profile
            try (PreparedStatement ps = con.prepareStatement(sqlStaff)) {
                ps.setString(1, s.getFullName());
                ps.setInt(2, s.getGender());           // int 1/2/3
                ps.setDate(3, s.getDateOfBirth());     // java.sql.Date (nullable ok)
                ps.setString(4, s.getPhone());
                ps.setString(5, s.getResidenceAddress());
                ps.setInt(6, s.getUserId());

                int updated = ps.executeUpdate();

                // nếu không update được 
                if (updated == 0) {
                    throw new Exception("No staff profile found in dbo.staff for user_id=" + s.getUserId());
                }
            }

            con.commit();
        } catch (Exception ex) {
            if (con != null) {
                con.rollback();
            }
            throw ex;
        } finally {
            if (con != null) {
                con.close();
            }
        }
    }

}
