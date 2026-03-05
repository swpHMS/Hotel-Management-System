package model;

import java.sql.Timestamp;

public class RoomTypeImage {
    private int imageId;
    private int roomTypeId;
    private String imageUrl;
    private boolean thumbnail;
    private int sortOrder;
    private Timestamp createdAt;

    public int getImageId() { return imageId; }
    public void setImageId(int imageId) { this.imageId = imageId; }

    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public boolean isThumbnail() { return thumbnail; }
    public void setThumbnail(boolean thumbnail) { this.thumbnail = thumbnail; }

    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
