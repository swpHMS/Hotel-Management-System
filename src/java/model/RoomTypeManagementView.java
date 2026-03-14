package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeManagementView {

    private int roomTypeId;
    private String name;
    private String imageUrl;
    private String descriptionRaw;
    private String descriptionPlain;

    private String bedType;
    private String viewType;
    private int roomSize;

    private int maxAdult;
    private int maxChildren;
    private int status;

    private BigDecimal currentPrice;
    private LocalDate validFrom;
    private LocalDate validTo;

    private List<Integer> amenityIds = new ArrayList<>();
    private List<String> amenityNames = new ArrayList<>();
    private List<RoomTypeImage> images = new ArrayList<>();

    public String getStatusText() {
        return status == 1 ? "ACTIVE" : "INACTIVE";
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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getDescriptionRaw() {
        return descriptionRaw;
    }

    public void setDescriptionRaw(String descriptionRaw) {
        this.descriptionRaw = descriptionRaw;
    }

    public String getDescriptionPlain() {
        return descriptionPlain;
    }

    public void setDescriptionPlain(String descriptionPlain) {
        this.descriptionPlain = descriptionPlain;
    }

    public String getBedType() {
        return bedType;
    }

    public void setBedType(String bedType) {
        this.bedType = bedType;
    }

    public String getViewType() {
        return viewType;
    }

    public void setViewType(String viewType) {
        this.viewType = viewType;
    }

    public int getRoomSize() {
        return roomSize;
    }

    public void setRoomSize(int roomSize) {
        this.roomSize = roomSize;
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

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public BigDecimal getCurrentPrice() {
        return currentPrice;
    }

    public void setCurrentPrice(BigDecimal currentPrice) {
        this.currentPrice = currentPrice;
    }

    public LocalDate getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(LocalDate validFrom) {
        this.validFrom = validFrom;
    }

    public LocalDate getValidTo() {
        return validTo;
    }

    public void setValidTo(LocalDate validTo) {
        this.validTo = validTo;
    }

    public List<Integer> getAmenityIds() {
        return amenityIds;
    }

    public void setAmenityIds(List<Integer> amenityIds) {
        this.amenityIds = amenityIds;
    }

    public List<String> getAmenityNames() {
        return amenityNames;
    }

    public void setAmenityNames(List<String> amenityNames) {
        this.amenityNames = amenityNames;
    }

    public List<RoomTypeImage> getImages() {
        return images;
    }

    public void setImages(List<RoomTypeImage> images) {
        this.images = images == null ? new ArrayList<>() : images;
    }

    public RoomTypeImage getThumbnailImage() {
        if (images == null || images.isEmpty()) {
            return null;
        }
        for (RoomTypeImage image : images) {
            if (image != null && image.isThumbnail()) {
                return image;
            }
        }
        return images.get(0);
    }

    public List<RoomTypeImage> getGalleryImages() {
        List<RoomTypeImage> gallery = new ArrayList<>();
        if (images == null) {
            return gallery;
        }
        RoomTypeImage thumbnail = getThumbnailImage();
        for (RoomTypeImage image : images) {
            if (image != null && !image.isThumbnail() && (thumbnail == null || image.getImageId() != thumbnail.getImageId())) {
                gallery.add(image);
            }
        }
        return gallery;
    }
}
