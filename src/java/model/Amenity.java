
package model;


public class Amenity {
    private int amenityId;
    private String code;
    private String name;
    private String description;
    private int category;     
    private boolean isActive; 

    public int getAmenityId() { return amenityId; }
    public void setAmenityId(int amenityId) { this.amenityId = amenityId; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getCategory() { return category; }
    public void setCategory(int category) { this.category = category; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}

