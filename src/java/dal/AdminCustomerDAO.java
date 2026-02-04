package dal;

import context.DBContext;
import model.CustomerProfile;

import java.sql.*;
import java.util.*;

public class AdminCustomerDAO {

    // Helper: SQL đoạn CASE dùng chung (u.status là INT)
    private static final String ACCOUNT_STATUS_CASE = """
        CASE
            WHEN c.user_id IS NULL THEN 'NO_ACCOUNT'
            WHEN u.status = 1 THEN 'ACTIVE'
            ELSE 'INACTIVE'
        END
    """;

    public List<CustomerProfile> searchCustomers(String keyword, Integer gender, String accountStatus,
                                          int page, int pageSize) throws Exception {
        int offset = (page - 1) * pageSize;

        StringBuilder sql = new StringBuilder();
        sql.append("""
            SELECT
                c.customer_id,
                c.user_id,
                c.full_name,
                c.gender,
                c.date_of_birth,
                c.identity_number,
                c.phone,
                c.residence_address,
                u.email,
        """);

        sql.append(ACCOUNT_STATUS_CASE).append(" AS account_status \n");

        sql.append("""
            FROM dbo.customers c
            LEFT JOIN dbo.users u ON u.user_id = c.user_id
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("""
                AND (
                    c.full_name LIKE ?
                    OR c.phone LIKE ?
                    OR c.identity_number LIKE ?
                    OR u.email LIKE ?
                )
            """);
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
        }

        if (gender != null && gender > 0) {
            sql.append(" AND c.gender = ? ");
            params.add(gender);
        }

        // accountStatus: all | ACTIVE | INACTIVE | NO_ACCOUNT
        if (accountStatus != null && !accountStatus.isBlank() && !accountStatus.equalsIgnoreCase("all")) {
            sql.append(" AND ").append(ACCOUNT_STATUS_CASE).append(" = ? ");
            params.add(accountStatus.trim().toUpperCase());
        }

        sql.append("""
            ORDER BY c.customer_id
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """);
        params.add(offset);
        params.add(pageSize);

        List<CustomerProfile> list = new ArrayList<>();

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CustomerProfile c = new CustomerProfile();
                    c.setCustomerId(rs.getInt("customer_id"));

                    int uid = rs.getInt("user_id");
                    c.setUserId(rs.wasNull() ? null : uid);

                    c.setFullName(rs.getString("full_name"));

                    int g = rs.getInt("gender");
                    c.setGender(rs.wasNull() ? null : g);

                    c.setDateOfBirth(rs.getDate("date_of_birth"));
                    c.setIdentityNumber(rs.getString("identity_number"));
                    c.setPhone(rs.getString("phone"));
                    c.setResidenceAddress(rs.getString("residence_address"));

                    c.setEmail(rs.getString("email"));
                    c.setAccountStatus(rs.getString("account_status"));

                    list.add(c);
                }
            }
        }
        return list;
    }

    public int countCustomers(String keyword, Integer gender, String accountStatus) throws Exception {
        StringBuilder sql = new StringBuilder();
        sql.append("""
            SELECT COUNT(*) AS total
            FROM dbo.customers c
            LEFT JOIN dbo.users u ON u.user_id = c.user_id
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("""
                AND (
                    c.full_name LIKE ?
                    OR c.phone LIKE ?
                    OR c.identity_number LIKE ?
                    OR u.email LIKE ?
                )
            """);
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
        }

        if (gender != null && gender > 0) {
            sql.append(" AND c.gender = ? ");
            params.add(gender);
        }

        if (accountStatus != null && !accountStatus.isBlank() && !accountStatus.equalsIgnoreCase("all")) {
            sql.append(" AND ").append(ACCOUNT_STATUS_CASE).append(" = ? ");
            params.add(accountStatus.trim().toUpperCase());
        }

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        }
        return 0;
    }

    public CustomerProfile getCustomerById(int customerId) throws Exception {
        String sql = """
            SELECT
                c.customer_id,
                c.user_id,
                c.full_name,
                c.gender,
                c.date_of_birth,
                c.identity_number,
                c.phone,
                c.residence_address,
                u.email,
        """ + ACCOUNT_STATUS_CASE + """
                AS account_status
            FROM dbo.customers c
            LEFT JOIN dbo.users u ON u.user_id = c.user_id
            WHERE c.customer_id = ?
        """;

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CustomerProfile c = new CustomerProfile();
                    c.setCustomerId(rs.getInt("customer_id"));

                    int uid = rs.getInt("user_id");
                    c.setUserId(rs.wasNull() ? null : uid);

                    c.setFullName(rs.getString("full_name"));

                    int g = rs.getInt("gender");
                    c.setGender(rs.wasNull() ? null : g);

                    c.setDateOfBirth(rs.getDate("date_of_birth"));
                    c.setIdentityNumber(rs.getString("identity_number"));
                    c.setPhone(rs.getString("phone"));
                    c.setResidenceAddress(rs.getString("residence_address"));

                    c.setEmail(rs.getString("email"));
                    c.setAccountStatus(rs.getString("account_status"));
                    return c;
                }
            }
        }
        return null;
    }

    public boolean updateUserStatusByCustomerId(int customerId, int newStatus) throws Exception {
        // newStatus: 1 ACTIVE, 0 INACTIVE
        String sql = """
            UPDATE u
            SET u.status = ?
            FROM dbo.users u
            INNER JOIN dbo.customers c ON c.user_id = u.user_id
            WHERE c.customer_id = ? AND c.user_id IS NOT NULL
        """;

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, newStatus);
            ps.setInt(2, customerId);
            return ps.executeUpdate() > 0;
        }
    }
}
