package model;

import java.sql.Date;
import java.util.List;

public class CheckoutBill {
    // 1. Guest Information
    private int bookingId;
    private String customerName;
    private String phone;
    private String email;

    // 2. Stay Details
    private String roomTypeName;
    private int roomQuantity;
    private Date checkInDate;
    private Date checkOutDate;
    private long nights;

    // 3. Financial Summary
    private long roomCharges;       // Tiền phòng gốc
    private long serviceCharges;    // Tổng tiền dịch vụ (Staff post lên)
    private long totalAmount;       // Tổng cộng = Room + Service
    private long depositPaid;       // Tiền đã cọc
    private long balanceDue;        // Số tiền còn lại khách phải trả (Total - Deposit)

    // 4. Service List (Danh sách chi tiết dịch vụ để hiển thị trên UI)
    private List<CheckoutServiceItem> usedServices;

    public CheckoutBill() {
    }

    // --- Getters and Setters ---
    
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }

    public int getRoomQuantity() { return roomQuantity; }
    public void setRoomQuantity(int roomQuantity) { this.roomQuantity = roomQuantity; }

    public Date getCheckInDate() { return checkInDate; }
    public void setCheckInDate(Date checkInDate) { this.checkInDate = checkInDate; }

    public Date getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(Date checkOutDate) { this.checkOutDate = checkOutDate; }

    public long getNights() { return nights; }
    public void setNights(long nights) { this.nights = nights; }

    public long getRoomCharges() { return roomCharges; }
    public void setRoomCharges(long roomCharges) { this.roomCharges = roomCharges; }

    public long getServiceCharges() { return serviceCharges; }
    public void setServiceCharges(long serviceCharges) { this.serviceCharges = serviceCharges; }

    public long getTotalAmount() { return totalAmount; }
    public void setTotalAmount(long totalAmount) { this.totalAmount = totalAmount; }

    public long getDepositPaid() { return depositPaid; }
    public void setDepositPaid(long depositPaid) { this.depositPaid = depositPaid; }

    public long getBalanceDue() { return balanceDue; }
    public void setBalanceDue(long balanceDue) { this.balanceDue = balanceDue; }

    public List<CheckoutServiceItem> getUsedServices() { return usedServices; }
    public void setUsedServices(List<CheckoutServiceItem> usedServices) { this.usedServices = usedServices; }
}