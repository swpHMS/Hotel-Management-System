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

    private int totalGuests;      // Tổng số khách đang ở
    private int pendingCheckIn;   // Số booking hôm nay chưa check-in
    private int checkInToday;     // Số phòng đã check-in hôm nay
    private int checkOutToday;    // Số booking/phòng checkout hôm nay
    private int arrivalToday;     // Tổng số booking có ngày check-in là hôm nay

    public DashboardStats() {
    }

    public DashboardStats(int totalGuests, int pendingCheckIn, int checkInToday, int checkOutToday, int arrivalToday) {
        this.totalGuests = totalGuests;
        this.pendingCheckIn = pendingCheckIn;
        this.checkInToday = checkInToday;
        this.checkOutToday = checkOutToday;
        this.arrivalToday = arrivalToday;
    }

    public int getTotalGuests() {
        return totalGuests;
    }

    public void setTotalGuests(int totalGuests) {
        this.totalGuests = totalGuests;
    }

    public int getPendingCheckIn() {
        return pendingCheckIn;
    }

    public void setPendingCheckIn(int pendingCheckIn) {
        this.pendingCheckIn = pendingCheckIn;
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

    public int getArrivalToday() {
        return arrivalToday;
    }

    public void setArrivalToday(int arrivalToday) {
        this.arrivalToday = arrivalToday;
    }

    @Override
    public String toString() {
        return "DashboardStats{"
                + "totalGuests=" + totalGuests
                + ", pendingCheckIn=" + pendingCheckIn
                + ", checkInToday=" + checkInToday
                + ", checkOutToday=" + checkOutToday
                + ", arrivalToday=" + arrivalToday
                + '}';
    }
}
