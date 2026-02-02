/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ASUS
 */
public class User {
    private int userId;
    private String email;
    private String passwordHash;     // null nếu GOOGLE
    private int authProvider;        // 1 LOCAL, 2 GOOGLE
    private String googleSub;        // null nếu LOCAL
    private String portraitUrl;      // có thể null
    private int status;              // 1 active, 0 inactive
    private int roleId;              // 1 admin, 2 staff, 3 customer

    public User() {
    }

    public User(int userId, String email, String passwordHash, int authProvider,
            String googleSub, String portraitUrl, int status, int roleId) {
        this.userId = userId;
        this.email = email;
        this.passwordHash = passwordHash;
        this.authProvider = authProvider;
        this.googleSub = googleSub;
        this.portraitUrl = portraitUrl;
        this.status = status;
        this.roleId = roleId;
    }

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

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
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

    public String getPortraitUrl() {
        return portraitUrl;
    }

    public void setPortraitUrl(String portraitUrl) {
        this.portraitUrl = portraitUrl;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }
}
