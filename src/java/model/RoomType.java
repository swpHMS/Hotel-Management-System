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
    
    private List<String> amenityNames = new ArrayList<>();

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
        return String.join("||", amenityNames);
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
                + '}';
    }
}
