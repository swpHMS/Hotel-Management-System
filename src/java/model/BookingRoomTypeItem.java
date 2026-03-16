package model;

public class BookingRoomTypeItem {
    private int bookingRoomId;
    private int roomTypeId;
    private String roomTypeName;
    private int quantity;
    private long priceAtBooking;
    private long lineTotal;

    public int getBookingRoomId() {
        return bookingRoomId;
    }

    public void setBookingRoomId(int bookingRoomId) {
        this.bookingRoomId = bookingRoomId;
    }

    public int getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(int roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public String getRoomTypeName() {
        return roomTypeName;
    }

    public void setRoomTypeName(String roomTypeName) {
        this.roomTypeName = roomTypeName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public long getPriceAtBooking() {
        return priceAtBooking;
    }

    public void setPriceAtBooking(long priceAtBooking) {
        this.priceAtBooking = priceAtBooking;
    }

    public long getLineTotal() {
        return lineTotal;
    }

    public void setLineTotal(long lineTotal) {
        this.lineTotal = lineTotal;
    }
}