package model;

/**
 * Model đại diện cho bảng users và thông tin Profile cơ bản
 * @author ASUS
 */
public class User {
    private int userId;
    private String email;
    private String passwordHash;     // null nếu GOOGLE
    private int authProvider;        // 1 LOCAL, 2 GOOGLE
    private String googleSub;        // null nếu LOCAL
    private int status;              // 1 active, 0 inactive
    private int roleId;              // 1 admin, 2 receptionist, 3 staff, 4 customer
    private String token;            // Dùng cho verify email và reset password

    // --- Bổ sung thêm các trường từ bảng Profile (customers/staff) ---
    private String fullName;         
    private String phone;

    public User() {
    }

    public User(int userId, String email, String passwordHash, int authProvider,
                String googleSub, int status, int roleId, String token) {
        this.userId = userId;
        this.email = email;
        this.passwordHash = passwordHash;
        this.authProvider = authProvider;
        this.googleSub = googleSub;
        this.status = status;
        this.roleId = roleId;
        this.token = token;
    }

    // Getter và Setter cho các trường cơ bản
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public int getAuthProvider() { return authProvider; }
    public void setAuthProvider(int authProvider) { this.authProvider = authProvider; }

    public String getGoogleSub() { return googleSub; }
    public void setGoogleSub(String googleSub) { this.googleSub = googleSub; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    // Getter và Setter cho thông tin bổ sung
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
}