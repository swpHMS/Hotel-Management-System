package model;

import java.sql.Date;

public class CustomerProfile {
    private int customerId;
    private Integer userId;

    private String fullName;
    private Integer gender; // 1,2,3
    private Date dateOfBirth;

    private String identityNumber;
    private String phone;
    private String residenceAddress;

    // join users
    private String email;

    // computed for UI
    private String accountStatus; // ACTIVE | INACTIVE | NO_ACCOUNT

    public CustomerProfile() {
    }

    public CustomerProfile(int customerId, Integer userId, String fullName, Integer gender, Date dateOfBirth, String identityNumber, String phone, String residenceAddress, String email, String accountStatus) {
        this.customerId = customerId;
        this.userId = userId;
        this.fullName = fullName;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.identityNumber = identityNumber;
        this.phone = phone;
        this.residenceAddress = residenceAddress;
        this.email = email;
        this.accountStatus = accountStatus;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Integer getGender() {
        return gender;
    }

    public void setGender(Integer gender) {
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getResidenceAddress() {
        return residenceAddress;
    }

    public void setResidenceAddress(String residenceAddress) {
        this.residenceAddress = residenceAddress;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAccountStatus() {
        return accountStatus;
    }

    public void setAccountStatus(String accountStatus) {
        this.accountStatus = accountStatus;
    }

    
}
