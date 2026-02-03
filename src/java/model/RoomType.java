package model;

import java.math.BigDecimal;

public class RoomType {

    private int roomTypeId;
    private String name;
    private String description;
    private int maxAdult;
    private int maxChildren;
    private String imageUrl;
    private int status; // 1: ACTIVE, 0: INACTIVE
    private BigDecimal priceToday;

    public RoomType() {
    }

    public int getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(int roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getMaxAdult() {
        return maxAdult;
    }

    public void setMaxAdult(int maxAdult) {
        this.maxAdult = maxAdult;
    }

    public int getMaxChildren() {
        return maxChildren;
    }

    public void setMaxChildren(int maxChildren) {
        this.maxChildren = maxChildren;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public BigDecimal getPriceToday() {
        return priceToday;
    }

    public void setPriceToday(BigDecimal priceToday) {
        this.priceToday = priceToday;
    }

    // Optional: debug nhanh khi cần in list ra console
    @Override
    public String toString() {
        return "RoomTypeCard{"
                + "roomTypeId=" + roomTypeId
                + ", name=" + name
                + ", maxAdult=" + maxAdult
                + ", maxChildren=" + maxChildren
                + ", status=" + status
                + ", priceToday=" + priceToday
                + '}';
    }
}
