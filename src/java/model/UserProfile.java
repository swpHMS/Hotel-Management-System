package model;

public class UserProfile {

    private int userId;
    private String email;
    private int status;        // 1 = ACTIVE, 0 = INACTIVE
    private int authProvider;  // 1 = LOCAL, 2 = GOOGLE 
    private String googleSub;  // nullable
    private int roleId;
    private String roleName;   // lấy từ bảng roles nếu JOIN

    // Optional (nếu JOIN sang staff)
    private String fullName;
    private String phone;
    
    public UserProfile() {
    }

    // getters/setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getAuthProvider() {
        return authProvider;
    }

    public void setAuthProvider(int authProvider) {
        this.authProvider = authProvider;
    }

    public String getGoogleSub() {
        return googleSub;
    }

    public void setGoogleSub(String googleSub) {
        this.googleSub = googleSub;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

   
    public String getStatusText() {
        return status == 1 ? "ACTIVE" : "INACTIVE";
    }

    public String getAuthProviderText() {
        return authProvider == 2 ? "GOOGLE" : "LOCAL";
    }
}
