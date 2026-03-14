package model;

public class StaffRoomItem {
    private int roomId;
    private String roomNo;
    private String roomTypeName;
    private int floor;
    private int status;
    private String note;

    public StaffRoomItem() {
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

    public String getRoomTypeName() {
        return roomTypeName;
    }

    public void setRoomTypeName(String roomTypeName) {
        this.roomTypeName = roomTypeName;
    }

    public int getFloor() {
        return floor;
    }

    public void setFloor(int floor) {
        this.floor = floor;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getStatusText() {
        switch (status) {
            case 1: return "Available";
            case 2: return "Occupied";
            case 3: return "Under Maintenance";
            case 4: return "Needs Cleaning";
            default: return "Unknown";
        }
    }
}