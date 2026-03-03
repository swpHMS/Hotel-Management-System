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

    public Room() {
    }

    // Getters và Setters tương ứng để Servlet có thể gọi
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public String getRoomNo() { return roomNo; }
    public void setRoomNo(String roomNo) { this.roomNo = roomNo; }

    public int getFloor() { return floor; }
    public void setFloor(int floor) { this.floor = floor; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
}
