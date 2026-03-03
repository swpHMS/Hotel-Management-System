/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ASUS
 */
public class DashboardStats {
    private int totalGuests;    // Tổng số khách (Người lớn + Trẻ em) đang/sẽ ở
    private int roomsBooked;    // Số phòng có trạng thái Reserved (Status 1)
    private int checkInToday;   // Số khách thực tế đã làm thủ tục vào phòng (Status 2, 3)
    private int checkOutToday;  // Số khách cần/đã trả phòng trong ngày (Status 2, 3)
    private int noShowToday;    // Số đơn đặt phòng bị quá hạn không đến (Status 4)

    public DashboardStats() {
    }

    public DashboardStats(int totalGuests, int roomsBooked, int checkInToday, int checkOutToday, int noShowToday) {
        this.totalGuests = totalGuests;
        this.roomsBooked = roomsBooked;
        this.checkInToday = checkInToday;
        this.checkOutToday = checkOutToday;
        this.noShowToday = noShowToday;
    }

    // Getters and Setters
    public int getTotalGuests() {
        return totalGuests;
    }

    public void setTotalGuests(int totalGuests) {
        this.totalGuests = totalGuests;
    }

    public int getRoomsBooked() {
        return roomsBooked;
    }

    public void setRoomsBooked(int roomsBooked) {
        this.roomsBooked = roomsBooked;
    }

    public int getCheckInToday() {
        return checkInToday;
    }

    public void setCheckInToday(int checkInToday) {
        this.checkInToday = checkInToday;
    }

    public int getCheckOutToday() {
        return checkOutToday;
    }

    public void setCheckOutToday(int checkOutToday) {
        this.checkOutToday = checkOutToday;
    }

    public int getNoShowToday() {
        return noShowToday;
    }

    public void setNoShowToday(int noShowToday) {
        this.noShowToday = noShowToday;
    }

    @Override
    public String toString() {
        return "DashboardStats{" + "totalGuests=" + totalGuests + ", roomsBooked=" + roomsBooked + 
               ", checkInToday=" + checkInToday + ", checkOutToday=" + checkOutToday + 
               ", noShowToday=" + noShowToday + '}';
    }
}
