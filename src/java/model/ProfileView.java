package model;

import java.sql.Date;

public class ProfileView {
    private int userId;
    private String email;
    private int userStatus;      // users.status (0/1)
    private String roleName;     // roles.role_name

    private int customerId;
    private String fullName;
    private Integer gender;      // 1/2/3
    private Date dateOfBirth;
    private String identityNumber;
    private String phone;
    private String residenceAddress;

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public int getUserStatus() { return userStatus; }
    public void setUserStatus(int userStatus) { this.userStatus = userStatus; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public Integer getGender() { return gender; }
    public void setGender(Integer gender) { this.gender = gender; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getIdentityNumber() { return identityNumber; }
    public void setIdentityNumber(String identityNumber) { this.identityNumber = identityNumber; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getResidenceAddress() { return residenceAddress; }
    public void setResidenceAddress(String residenceAddress) { this.residenceAddress = residenceAddress; }
}
