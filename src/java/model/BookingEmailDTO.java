package model;

import java.util.HashMap;
import java.util.Map;

/**
 * Data Transfer Object (DTO) dùng để chứa dữ liệu gửi Email đặt phòng.
 * Đã bao gồm logic tính cọc 50% và định dạng số.
 */
public class BookingEmailDTO {
    private String fullName;
    private String email;
    private String phone;
    private String bookingId;
    private String checkInDate;
    private String checkOutDate;
    private String roomName;
    private double totalAmount;
    private double depositAmount;

    // --- Constructors ---
    public BookingEmailDTO() {
    }

    public BookingEmailDTO(String fullName, String email, String phone, String bookingId, 
                           String checkInDate, String checkOutDate, String roomName, 
                           double totalAmount, double depositAmount) {
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.bookingId = bookingId;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.roomName = roomName;
        this.totalAmount = totalAmount;
        this.depositAmount = depositAmount;
    }

    // --- Getters and Setters ---
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getBookingId() { return bookingId; }
    public void setBookingId(String bookingId) { this.bookingId = bookingId; }

    public String getCheckInDate() { return checkInDate; }
    public void setCheckInDate(String checkInDate) { this.checkInDate = checkInDate; }

    public String getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(String checkOutDate) { this.checkOutDate = checkOutDate; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public double getDepositAmount() { return depositAmount; }
    public void setDepositAmount(double depositAmount) { this.depositAmount = depositAmount; }

    /**
     * Chuyển đổi đối tượng sang Map để dùng với EmailUtils.replacePlaceholders.
     * Tự động tính toán số tiền còn lại (Remain) và định dạng 1,000,000.
     */
    public Map<String, String> toMap() {
        Map<String, String> map = new HashMap<>();
        map.put("full_name", fullName);
        map.put("email", email);
        map.put("phone", phone);
        map.put("booking_id", bookingId);
        map.put("check_in_date", checkInDate);
        map.put("check_out_date", checkOutDate);
        map.put("room_name", roomName);
        
        // Định dạng số có dấu phẩy ngăn cách hàng nghìn
        map.put("total_amount", String.format("%,.0f", totalAmount));
        map.put("deposit_amount", String.format("%,.0f", depositAmount));
        
        // Tính toán 50% còn lại để hiển thị trong email
        double remain = totalAmount - depositAmount;
        map.put("remain_amount", String.format("%,.0f", remain));
        
        return map;
    }
}