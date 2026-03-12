package model;

public class RoomTypeCard {
    private int roomTypeId;
    private String roomTypeName;
    private long ratePerNight;
    private int availableRooms;
    private String uiStatus; // ok / limited / soldout

    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }

    public long getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(long ratePerNight) { this.ratePerNight = ratePerNight; }

    public int getAvailableRooms() { return availableRooms; }
    public void setAvailableRooms(int availableRooms) { this.availableRooms = availableRooms; }

    public String getUiStatus() { return uiStatus; }
    public void setUiStatus(String uiStatus) { this.uiStatus = uiStatus; }
}
