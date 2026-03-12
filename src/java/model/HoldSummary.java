package model;

import java.sql.Date;
import java.sql.Timestamp;

public class HoldSummary {
    public int holdId;
    public int roomTypeId;
    public String roomTypeName;
    public int quantity;
    public Date checkIn;
    public Date checkOut;
    public Timestamp expiresAt;
    public int status;

    public long nights;
    public long ratePerNight;
    public long total;
    public int userId;
    public int qty;
    

    // getters/setters
    public int getHoldId() { return holdId; }
    public void setHoldId(int holdId) { this.holdId = holdId; }

    public int getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(int roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getRoomTypeName() { return roomTypeName; }
    public void setRoomTypeName(String roomTypeName) { this.roomTypeName = roomTypeName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Date getCheckIn() { return checkIn; }
    public void setCheckIn(Date checkIn) { this.checkIn = checkIn; }

    public Date getCheckOut() { return checkOut; }
    public void setCheckOut(Date checkOut) { this.checkOut = checkOut; }

    public Timestamp getExpiresAt() { return expiresAt; }
    public void setExpiresAt(Timestamp expiresAt) { this.expiresAt = expiresAt; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public long getNights() { return nights; }
    public void setNights(long nights) { this.nights = nights; }

    public long getRatePerNight() { return ratePerNight; }
    public void setRatePerNight(long ratePerNight) { this.ratePerNight = ratePerNight; }

    public long getTotal() { return total; }
    public void setTotal(long total) { this.total = total; }
}