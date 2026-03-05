package model;

import java.sql.Date;

/**
 * Class đại diện cho dữ liệu hiển thị trên Dashboard và Check-in
 * @author Minh Đức
 */
public class BookingDashboard {
    private int bookingId;
    private String guestName;
    private String roomTypeName;
    private Date checkInDate;
    private Date checkOutDate;
    private int numRooms;
    private String roomNo;
    private int numPersons;
    private int bookingStatus; 
    private int assignmentStatus; 
    private double totalAmount; 
    // ✅ BỔ SUNG: Tiền đặt cọc để hết lỗi PropertyNotFoundException
    private double deposit; 

    public BookingDashboard() {
    }

    // Constructor đầy đủ
    public BookingDashboard(int bookingId, String guestName, String roomTypeName, Date checkInDate, 
                            Date checkOutDate, int numRooms, String roomNo, int numPersons, 
                            int bookingStatus, int assignmentStatus, double totalAmount, double deposit) {
        this.bookingId = bookingId;
        this.guestName = guestName;
        this.roomTypeName = roomTypeName;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.numRooms = numRooms;
        this.roomNo = roomNo;
        this.numPersons = numPersons;
        this.bookingStatus = bookingStatus;
        this.assignmentStatus = assignmentStatus;
        this.totalAmount = totalAmount;
        this.deposit = deposit;
    }

    // ✅ GETTER VÀ SETTER CHO DEPOSIT (BẮT BUỘC CÓ)
    public double getDeposit() {
        return deposit;
    }

    public void setDeposit(double deposit) {
        this.deposit = deposit;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }

    public Date getCheckInDate() { return checkInDate; }
    public void setCheckInDate(Date checkInDate) { this.checkInDate = checkInDate; }

    public Date getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(Date checkOutDate) { this.checkOutDate = checkOutDate; }

    public int getNumRooms() { return numRooms; }
    public void setNumRooms(int numRooms) { this.numRooms = numRooms; }

    public String getRoomNo() { return roomNo; }
    public void setRoomNo(String roomNo) { this.roomNo = roomNo; }

    public int getNumPersons() { return numPersons; }
    public void setNumPersons(int numPersons) { this.numPersons = numPersons; }

    public int getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(int bookingStatus) { this.bookingStatus = bookingStatus; }

    public int getAssignmentStatus() { return assignmentStatus; }
    public void setAssignmentStatus(int assignmentStatus) { this.assignmentStatus = assignmentStatus; }
}