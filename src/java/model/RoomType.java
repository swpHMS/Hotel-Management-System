package model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class RoomType {

    private int roomTypeId;
    private String name;
    private String description;
    private int maxAdult;
    private int maxChildren;
    private String imageUrl;
    private int status;
    private BigDecimal priceToday;

    // ✅ Amenities (đang dùng)
    private List<String> amenityNames = new ArrayList<>();

    // ✅ NEW: List ảnh lấy từ bảng room_type_images
    private List<RoomTypeImage> images = new ArrayList<>();

    public RoomType() {}

    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getMaxAdult() { return maxAdult; }
    public void setMaxAdult(int maxAdult) { this.maxAdult = maxAdult; }

    public int getMaxChildren() { return maxChildren; }
    public void setMaxChildren(int maxChildren) { this.maxChildren = maxChildren; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public BigDecimal getPriceToday() { return priceToday; }
    public void setPriceToday(BigDecimal priceToday) { this.priceToday = priceToday; }

    public List<String> getAmenityNames() { return amenityNames; }
    public void setAmenityNames(List<String> amenityNames) {
        this.amenityNames = (amenityNames == null) ? new ArrayList<>() : amenityNames;
    }

    // ✅ dùng thẳng trong JSP: data-amenities="${rt.amenityPipe}"
    public String getAmenityPipe() {
        if (amenityNames == null || amenityNames.isEmpty()) return "";
        return String.join("|", amenityNames);
    }

    // =========================================================
    // ✅ NEW: Images
    // =========================================================
    public List<RoomTypeImage> getImages() {
        return images;
    }

    public void setImages(List<RoomTypeImage> images) {
        this.images = (images == null) ? new ArrayList<>() : images;
    }

    /**
     * ✅ Tiện dùng nếu bạn muốn lấy nhanh URL ảnh thumbnail:
     * - Ưu tiên is_thumbnail = true
     * - Nếu không có, lấy ảnh đầu tiên
     * - Nếu không có ảnh, trả null
     */
    public String getThumbnailUrl() {
        if (images == null || images.isEmpty()) return null;
        for (RoomTypeImage img : images) {
            if (img != null && img.isThumbnail()) {
                return img.getImageUrl();
            }
        }
        return images.get(0) != null ? images.get(0).getImageUrl() : null;
    }

    @Override
    public String toString() {
        return "RoomType{"
                + "roomTypeId=" + roomTypeId
                + ", name=" + name
                + ", maxAdult=" + maxAdult
                + ", maxChildren=" + maxChildren
                + ", status=" + status
                + ", priceToday=" + priceToday
                + ", amenityNames=" + amenityNames
                + ", images=" + (images == null ? 0 : images.size())
                + '}';
    }
}