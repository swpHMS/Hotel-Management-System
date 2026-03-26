package model;


public class StayGuestView {
    private int guestId;
    private String fullName;
    private String identityNumber;

    public StayGuestView(int guestId, String fullName, String identityNumber) {
        this.guestId = guestId;
        this.fullName = fullName;
        this.identityNumber = identityNumber;
    }

    public StayGuestView() {
    }

    public int getGuestId() {
        return guestId;
    }

    public void setGuestId(int guestId) {
        this.guestId = guestId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getIdentityNumber() {
        return identityNumber;
    }

    public void setIdentityNumber(String identityNumber) {
        this.identityNumber = identityNumber;
    }
    
    
}