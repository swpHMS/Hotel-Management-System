package model;

import java.sql.Timestamp;

public class FolioItemView {
    private int itemId;
    private int folioId;
    private Integer serviceOrderId;
    private Integer bookingChangeId;
    private String description;
    private long amount;
    private Timestamp createdAt;

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getFolioId() {
        return folioId;
    }

    public void setFolioId(int folioId) {
        this.folioId = folioId;
    }

    public Integer getServiceOrderId() {
        return serviceOrderId;
    }

    public void setServiceOrderId(Integer serviceOrderId) {
        this.serviceOrderId = serviceOrderId;
    }

    public Integer getBookingChangeId() {
        return bookingChangeId;
    }

    public void setBookingChangeId(Integer bookingChangeId) {
        this.bookingChangeId = bookingChangeId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public long getAmount() {
        return amount;
    }

    public void setAmount(long amount) {
        this.amount = amount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}