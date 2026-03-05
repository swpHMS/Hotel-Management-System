package model;

import java.time.LocalDateTime;
import java.util.List;

/**
 *
 * @author Admin
 */
public class ServiceOrder {

    private int serviceOrderId;
    private int bookingId;               // INT
    private Integer roomId;              // nullable
    private String roomNo;
    private int createdByStaffId;
    private int status;                  // 0 draft, 1 posted, 2 cancelled
    private LocalDateTime postedAt;      // datetime2 NULL
    private Double total;

    // UI fields (join, không lưu DB)
    private String staffName;
    private List<ServiceOrderItem> items;

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }

    public Double getTotal() {
        return total;
    }

    public void setTotal(Double total) {
        this.total = total;
    }

    public int getServiceOrderId() {
        return serviceOrderId;
    }

    public void setServiceOrderId(int serviceOrderId) {
        this.serviceOrderId = serviceOrderId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public int getCreatedByStaffId() {
        return createdByStaffId;
    }

    public void setCreatedByStaffId(int createdByStaffId) {
        this.createdByStaffId = createdByStaffId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public LocalDateTime getPostedAt() {
        return postedAt;
    }

    public void setPostedAt(LocalDateTime postedAt) {
        this.postedAt = postedAt;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public List<ServiceOrderItem> getItems() {
        return items;
    }

    public void setItems(List<ServiceOrderItem> items) {
        this.items = items;
    }

}
