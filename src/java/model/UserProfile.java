package model;

import java.sql.Date;

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
    
    
    
    private int gender;
private java.sql.Date dateOfBirth;
private String identityNumber;
private String residenceAddress;

    public int getGender() {
        return gender;
    }

    public void setGender(int gender) {
        this.gender = gender;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getIdentityNumber() {
        return identityNumber;
    }

    public void setIdentityNumber(String identityNumber) {
        this.identityNumber = identityNumber;
    }

    public String getResidenceAddress() {
        return residenceAddress;
    }

    public void setResidenceAddress(String residenceAddress) {
        this.residenceAddress = residenceAddress;
    }

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
