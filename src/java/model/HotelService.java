package model;

public class HotelService {
    private int serviceId;
    private String code;
    private String name;
    private int serviceType; // 0:SURCHARGE, 1:MINIBAR, 2:LAUNDRY, 3:CLEANING
    private double unitPrice; // Đã đổi sang kiểu double
    private int status; // 1: ACTIVE, 0: INACTIVE

    public HotelService() {
    }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getServiceType() { return serviceType; }
    public void setServiceType(int serviceType) { this.serviceType = serviceType; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    // Helper methods hiển thị ra view
    public String getCategoryName() {
        switch (serviceType) {
            case 1: return "Food";
            case 2: return "Laundry";
            case 3: return "Transport"; 
            default: return "Other";
        }
    }

    public String getStatusText() {
        return status == 1 ? "ACTIVE" : "INACTIVE";
    }

    // Vẫn định dạng 2 chữ số thập phân khi hiển thị ra giao diện
    public String getFormattedPrice() {
        java.text.DecimalFormat df = new java.text.DecimalFormat("#,##0.00");
        return "$" + df.format(unitPrice);
    }
}