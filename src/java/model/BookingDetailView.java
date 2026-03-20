package model;

import java.sql.Date;
import java.sql.Timestamp;

public class BookingDetailView {
    private int bookingId;
    private String bookingCode;

    private String customerName;
    private String phone;
    private String email;
    private Integer gender;
    private Date dateOfBirth;
    private String identityNumber;
    private String residenceAddress;

    private int status;
    private Date checkInDate;
    private Date checkOutDate;
    private int nights;

    private long totalAmount;
    private long depositPaid;
    private long balanceDue;

    private Integer folioId;
    private long folioTotalAmount;
    private Integer folioStatus;
    private Timestamp folioCreatedAt;
    private Timestamp folioClosedAt;

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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

    public String getResidenceAddress() {
        return residenceAddress;
    }

    public void setResidenceAddress(String residenceAddress) {
        this.residenceAddress = residenceAddress;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Date getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(Date checkInDate) {
        this.checkInDate = checkInDate;
    }

    public Date getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(Date checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public int getNights() {
        return nights;
    }

    public void setNights(int nights) {
        this.nights = nights;
    }

    public long getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(long totalAmount) {
        this.totalAmount = totalAmount;
    }

    public long getDepositPaid() {
        return depositPaid;
    }

    public void setDepositPaid(long depositPaid) {
        this.depositPaid = depositPaid;
    }

    public long getBalanceDue() {
        return balanceDue;
    }

    public void setBalanceDue(long balanceDue) {
        this.balanceDue = balanceDue;
    }

    public Integer getFolioId() {
        return folioId;
    }

    public void setFolioId(Integer folioId) {
        this.folioId = folioId;
    }

    public long getFolioTotalAmount() {
        return folioTotalAmount;
    }

    public void setFolioTotalAmount(long folioTotalAmount) {
        this.folioTotalAmount = folioTotalAmount;
    }

    public Integer getFolioStatus() {
        return folioStatus;
    }

    public void setFolioStatus(Integer folioStatus) {
        this.folioStatus = folioStatus;
    }

    public Timestamp getFolioCreatedAt() {
        return folioCreatedAt;
    }

    public void setFolioCreatedAt(Timestamp folioCreatedAt) {
        this.folioCreatedAt = folioCreatedAt;
    }

    public Timestamp getFolioClosedAt() {
        return folioClosedAt;
    }

    public void setFolioClosedAt(Timestamp folioClosedAt) {
        this.folioClosedAt = folioClosedAt;
    }
}