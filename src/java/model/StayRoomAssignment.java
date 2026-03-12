/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ASUS
 */
public class StayRoomAssignment {
    private int assignmentId;
    private int bookingId;
    private int roomId;
    private String roomTypeName; // Dùng để hiển thị tên loại phòng
    private int roomTypeId;
    private int numPersons; // Sức chứa của loại phòng đó
    private int status;

    public StayRoomAssignment() {
    }

    public StayRoomAssignment(int assignmentId, int bookingId, int roomId, String roomTypeName, int roomTypeId, int numPersons, int status) {
        this.assignmentId = assignmentId;
        this.bookingId = bookingId;
        this.roomId = roomId;
        this.roomTypeName = roomTypeName;
        this.roomTypeId = roomTypeId;
        this.numPersons = numPersons;
        this.status = status;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getRoomTypeName() {
        return roomTypeName;
    }

    public void setRoomTypeName(String roomTypeName) {
        this.roomTypeName = roomTypeName;
    }

    public int getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(int roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public int getNumPersons() {
        return numPersons;
    }

    public void setNumPersons(int numPersons) {
        this.numPersons = numPersons;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    
}
