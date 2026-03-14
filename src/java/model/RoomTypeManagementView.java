package model;

import java.math.BigDecimal;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeManagementView {

    private int roomTypeId;
    private String name;
    private String description;
    private int maxAdult;
    private int maxChildren;
    private String imageUrl;
    private String thumbnailUrl;
    private int status;
    private BigDecimal price;
    private int roomCount;

    private List<String> amenityNames = new ArrayList<>();

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

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getRoomCount() {
        return roomCount;
    }

    public void setRoomCount(int roomCount) {
        this.roomCount = roomCount;
    }

    public List<String> getAmenityNames() {
        return amenityNames;
    }

    public void setAmenityNames(List<String> amenityNames) {
        this.amenityNames = amenityNames == null ? new ArrayList<>() : amenityNames;
    }
}