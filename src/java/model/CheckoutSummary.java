package model;

import java.sql.Date;

public class CheckoutSummary {
    private int bookingId;
    private String customerName;
    private String phone;
    private Date checkInDate;
    private Date checkOutDate;
    private String roomNo;
    private long depositPaid;

    public CheckoutSummary() {
    }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Date getCheckInDate() { return checkInDate; }
    public void setCheckInDate(Date checkInDate) { this.checkInDate = checkInDate; }

    public Date getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(Date checkOutDate) { this.checkOutDate = checkOutDate; }

    public String getRoomNo() { return roomNo; }
    public void setRoomNo(String roomNo) { this.roomNo = roomNo; }

    public long getDepositPaid() { return depositPaid; }
    public void setDepositPaid(long depositPaid) { this.depositPaid = depositPaid; }
}