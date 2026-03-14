package model;

public class RoomTypeForm {

    private Integer roomTypeId;
    private String name;
    private String description;
    private int maxAdult;
    private int maxChildren;
    private int status;
    private String imageUrl;

    public Integer getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(Integer roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getMaxAdult() { return maxAdult; }
    public void setMaxAdult(int maxAdult) { this.maxAdult = maxAdult; }

    public int getMaxChildren() { return maxChildren; }
    public void setMaxChildren(int maxChildren) { this.maxChildren = maxChildren; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}