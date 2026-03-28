package model;

import java.time.LocalDateTime;
import java.util.List;

/**
 *
 * @author Admin
 */
public class ServiceOrder {

    private int serviceOrderId;
    private int bookingId;
    private Integer roomId;
    private String roomNo;

    private int createdByStaffId;
    private String createdByStaffName;

    private int status; // 0 = Unfinished, 1 = Finished, 2 = Cancelled

    private LocalDateTime createdAt;
    private LocalDateTime completedAt;
    private Integer completedByStaffId;
    private String completedByStaffName;

    private LocalDateTime cancelledAt;
    private Integer cancelledByStaffId;
    private String cancelledByStaffName;

    private String note;
    private Double total;

    // UI fields
    private String staffName;
    private List<ServiceOrderItem> items;

    public ServiceOrder() {
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

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }

    public int getCreatedByStaffId() {
        return createdByStaffId;
    }

    public void setCreatedByStaffId(int createdByStaffId) {
        this.createdByStaffId = createdByStaffId;
    }

    public String getCreatedByStaffName() {
        return createdByStaffName;
    }

    public void setCreatedByStaffName(String createdByStaffName) {
        this.createdByStaffName = createdByStaffName;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public Integer getCompletedByStaffId() {
        return completedByStaffId;
    }

    public void setCompletedByStaffId(Integer completedByStaffId) {
        this.completedByStaffId = completedByStaffId;
    }

    public String getCompletedByStaffName() {
        return completedByStaffName;
    }

    public void setCompletedByStaffName(String completedByStaffName) {
        this.completedByStaffName = completedByStaffName;
    }

    public LocalDateTime getCancelledAt() {
        return cancelledAt;
    }

    public void setCancelledAt(LocalDateTime cancelledAt) {
        this.cancelledAt = cancelledAt;
    }

    public Integer getCancelledByStaffId() {
        return cancelledByStaffId;
    }

    public void setCancelledByStaffId(Integer cancelledByStaffId) {
        this.cancelledByStaffId = cancelledByStaffId;
    }

    public String getCancelledByStaffName() {
        return cancelledByStaffName;
    }

    public void setCancelledByStaffName(String cancelledByStaffName) {
        this.cancelledByStaffName = cancelledByStaffName;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Double getTotal() {
        return total;
    }

    public void setTotal(Double total) {
        this.total = total;
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