package model;

import java.util.ArrayList;
import java.util.List;

public class AssignedRoomView {
    private int assignmentId;
    private String roomNo;
    private String roomTypeName;
    private List<StayGuestView> guests = new ArrayList<>();

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }

    public String getRoomTypeName() {
        return roomTypeName;
    }

    public void setRoomTypeName(String roomTypeName) {
        this.roomTypeName = roomTypeName;
    }

    public List<StayGuestView> getGuests() {
        return guests;
    }

    public void setGuests(List<StayGuestView> guests) {
        this.guests = guests;
    }
}