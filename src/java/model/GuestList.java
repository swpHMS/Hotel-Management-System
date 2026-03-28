package model;

import java.sql.Date;

public class GuestList {
    private String fullName;
    private String identityNumber;
    private String roomNo;
    private Date checkInDate;
    private Date checkOutDate;
    private int status;

    public GuestList() {
    }

    public GuestList(String fullName, String identityNumber, String roomNo, Date checkInDate, Date checkOutDate, int status) {
        this.fullName = fullName;
        this.identityNumber = identityNumber;
        this.roomNo = roomNo;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.status = status;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getIdentityNumber() {
        return identityNumber;
    }

    public void setIdentityNumber(String identityNumber) {
        this.identityNumber = identityNumber;
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
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

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getStatusText() {
        switch (status) {
            case 0:
                return "Cancelled";
            case 1:
                return "Assigned";
            case 2:
                return "In-house";
            case 3:
                return "Ended";
            default:
                return "Unknown";
        }
    }
}