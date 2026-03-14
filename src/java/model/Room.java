/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ASUS
 */
public class Room {
    private int roomId;
    private String roomNo;
    private int roomTypeId;
    private int status;
    private int floor;
    private double price;
    private String roomTypeName;

    public Room() {
    }

    public Room(int roomId, String roomNo, int roomTypeId, int status, int floor, double price, String roomTypeName) {
        this.roomId = roomId;
        this.roomNo = roomNo;
        this.roomTypeId = roomTypeId;
        this.status = status;
        this.floor = floor;
        this.price = price;
        this.roomTypeName = roomTypeName;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }

    public int getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(int roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getFloor() {
        return floor;
    }

    public void setFloor(int floor) {
        this.floor = floor;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getRoomTypeName() {
        return roomTypeName;
    }

    public void setRoomTypeName(String roomTypeName) {
        this.roomTypeName = roomTypeName;
    }

    public String getStatusClass() {
        if (status == 1) return "available";
        if (status == 2) return "occupied";
        if (status == 3) return "maintenance";
        if (status == 4) return "dirty";
        return "available";
    }

    public String getStatusText() {
        if (status == 1) return "Available";
        if (status == 2) return "Occupied";
        if (status == 3) return "Maintenance";
        if (status == 4) return "Dirty";
        return "Available";
    }

    public String getFormattedPrice() {
        java.text.DecimalFormat df = new java.text.DecimalFormat("#,###");
        return df.format(price) + " VND";
    }
    
    
}
