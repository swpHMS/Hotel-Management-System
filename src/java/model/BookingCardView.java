package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

public class BookingCardView {

    private int bookingId;
    private int bookingStatus;

    private Date checkInDate;
    private Date checkOutDate;
    private BigDecimal totalAmount;

    private int roomTypeId;
    private String roomTypeName;
    private String roomMeta;

    private int maxAdult;
    private int maxChildren;

    private int quantity;
    private BigDecimal priceAtBooking;

    private List<String> imageUrls;

    // Amenities
    private String amenitiesText;

    public BookingCardView() {
    }

    // ===== CANCEL LOGIC (CHUẨN) =====
    public boolean isCanCancel() {

        // chỉ cho huỷ nếu status = PENDING (1) hoặc CONFIRMED (2)
        if (bookingStatus != 1 && bookingStatus != 2) {
            return false;
        }

        if (checkInDate == null) {
            return false;
        }

        LocalDate today = LocalDate.now();
        LocalDate checkIn = checkInDate.toLocalDate();
        LocalDate deadline = checkIn.minusDays(1);

        // chỉ cho huỷ nếu hôm nay <= deadline
        return !today.isAfter(deadline);
    }

    // ===== BASIC INFO =====
    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(int bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public Date getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(Date checkInDate) {
        this.checkInDate = checkInDate;
    }

    public Date getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(Date checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    // ===== ROOM INFO =====
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

    public String getRoomMeta() {
        return roomMeta;
    }

    public void setRoomMeta(String roomMeta) {
        this.roomMeta = roomMeta;
    }

    public int getMaxAdult() {
        return maxAdult;
    }

    public void setMaxAdult(int maxAdult) {
        this.maxAdult = maxAdult;
    }

    public int getMaxChildren() {
        return maxChildren;
    }

    public void setMaxChildren(int maxChildren) {
        this.maxChildren = maxChildren;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPriceAtBooking() {
        return priceAtBooking;
    }

    public void setPriceAtBooking(BigDecimal priceAtBooking) {
        this.priceAtBooking = priceAtBooking;
    }

    public List<String> getImageUrls() {
        return imageUrls;
    }

    public void setImageUrls(List<String> imageUrls) {
        this.imageUrls = imageUrls;
    }

    public String getAmenitiesText() {
        return amenitiesText;
    }

    public void setAmenitiesText(String amenitiesText) {
        this.amenitiesText = amenitiesText;
    }

    // ===== STATUS TEXT =====
    public String getStatusText() {
        return switch (bookingStatus) {
            case 1 ->
                "PENDING";
            case 2 ->
                "CONFIRMED";
            case 3 ->
                "CHECKED_IN";
            case 4 ->
                "CHECKED_OUT";
            case 5 ->
                "CANCELLED";
            case 6 ->
                "NO_SHOW";
            default ->
                "UNKNOWN";
        };
    }

    public String getStatusUiType() {
        return switch (bookingStatus) {
            case 1 ->
                "pending";
            case 2 ->
                "confirmed";
            case 3 ->
                "inhouse";
            case 4 ->
                "completed";
            case 5 ->
                "cancelled";
            case 6 ->
                "no-show";
            default ->
                "pending";
        };
    }
}
