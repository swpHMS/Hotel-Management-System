package model;

import java.sql.Date;

/**
 * Class đại diện cho dữ liệu hiển thị trên Dashboard, Check-in, Checkout
 * và Detail Drawer của Receptionist
 * 
 * @author Minh Đức
 */
public class BookingDashboard {

    private int bookingId;
    private String guestName;
    private String roomTypeName;
    private Date checkInDate;
    private Date checkOutDate;
    private int numRooms;

    // Field cũ
    private String roomNo;
    private int numPersons;
    private int bookingStatus;
    private int assignmentStatus;
    private double totalAmount;
    private double deposit;

    // Field mới cho detail drawer
    private String assignedRoomNos;
    private String assignedRoomDetails;
    private String phone;
    private String email;
    private String note;

    public BookingDashboard() {
    }

    // Constructor mở rộng
    public BookingDashboard(int bookingId, String guestName, String roomTypeName, Date checkInDate,
                            Date checkOutDate, int numRooms, String roomNo, int numPersons,
                            int bookingStatus, int assignmentStatus, double totalAmount, double deposit,
                            String assignedRoomNos, String assignedRoomDetails,
                            String phone, String email, String note) {
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
        this.assignedRoomNos = assignedRoomNos;
        this.assignedRoomDetails = assignedRoomDetails;
        this.phone = phone;
        this.email = email;
        this.note = note;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public String getRoomTypeName() {
        return roomTypeName;
    }

    public void setRoomTypeName(String roomTypeName) {
        this.roomTypeName = roomTypeName;
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

    public int getNumRooms() {
        return numRooms;
    }

    public void setNumRooms(int numRooms) {
        this.numRooms = numRooms;
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }

    public int getNumPersons() {
        return numPersons;
    }

    public void setNumPersons(int numPersons) {
        this.numPersons = numPersons;
    }

    public int getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(int bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public int getAssignmentStatus() {
        return assignmentStatus;
    }

    public void setAssignmentStatus(int assignmentStatus) {
        this.assignmentStatus = assignmentStatus;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getDeposit() {
        return deposit;
    }

    public void setDeposit(double deposit) {
        this.deposit = deposit;
    }

    public String getAssignedRoomNos() {
        return assignedRoomNos;
    }

    public void setAssignedRoomNos(String assignedRoomNos) {
        this.assignedRoomNos = assignedRoomNos;
    }

    public String getAssignedRoomDetails() {
        return assignedRoomDetails;
    }

    public void setAssignedRoomDetails(String assignedRoomDetails) {
        this.assignedRoomDetails = assignedRoomDetails;
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

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    /**
     * Alias để tương thích với code cũ:
     * nếu assignedRoomNos có dữ liệu thì ưu tiên trả về assignedRoomNos,
     * còn không thì trả về roomNo cũ.
     */
    public String getDisplayRoomNo() {
        if (assignedRoomNos != null && !assignedRoomNos.trim().isEmpty()) {
            return assignedRoomNos;
        }
        return roomNo;
    }
}