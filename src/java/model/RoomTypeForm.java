package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeForm {

    private String name;
    private String bedType;
    private String viewType;
    private Integer roomSize;
    private String description;
    private Integer maxAdult;
    private Integer maxChildren;
    private Integer status;

    private BigDecimal price;
    private LocalDate validFrom;
    private LocalDate validTo;

    private List<Integer> amenityIds = new ArrayList<>();

    public List<String> validate(boolean creating) {
        List<String> errors = new ArrayList<>();

        if (name == null || name.trim().isEmpty()) {
            errors.add("Room type name is required.");
        } else if (name.trim().length() > 100) {
            errors.add("Room type name must be <= 100 characters.");
        }

        if (bedType == null || bedType.trim().isEmpty()) {
            errors.add("Bed type is required.");
        }

        if (viewType == null || viewType.trim().isEmpty()) {
            errors.add("View type is required.");
        }

        if (roomSize == null || roomSize <= 0) {
            errors.add("Room size must be greater than 0.");
        }

        if (maxAdult == null || maxAdult <= 0) {
            errors.add("Max adults must be greater than 0.");
        }

        if (maxChildren == null || maxChildren < 0) {
            errors.add("Max children must be >= 0.");
        }

        if (status == null || (status != 0 && status != 1)) {
            errors.add("Status is invalid.");
        }

        if (price == null) {
            errors.add("Base price is required.");
        }

        if (price != null && price.compareTo(BigDecimal.ZERO) <= 0) {
            errors.add("Price must be greater than 0.");
        }

        if (amenityIds == null) {
            amenityIds = new ArrayList<>();
        }

        return errors;
    }

    public String toStoredDescription() {
        StringBuilder sb = new StringBuilder();
        sb.append("[BED:").append(nullToEmpty(bedType)).append("]");
        sb.append("[VIEW:").append(nullToEmpty(viewType)).append("]");
        sb.append("[SIZE:").append(roomSize == null ? "" : roomSize).append("]");
        return sb.toString();
    }

    private String nullToEmpty(String s) {
        return s == null ? "" : s.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public Integer getRoomSize() {
        return roomSize;
    }

    public void setRoomSize(Integer roomSize) {
        this.roomSize = roomSize;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getMaxAdult() {
        return maxAdult;
    }

    public void setMaxAdult(Integer maxAdult) {
        this.maxAdult = maxAdult;
    }

    public Integer getMaxChildren() {
        return maxChildren;
    }

    public void setMaxChildren(Integer maxChildren) {
        this.maxChildren = maxChildren;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
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
}
