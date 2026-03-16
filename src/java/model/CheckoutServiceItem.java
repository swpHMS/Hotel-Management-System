package model;

public class CheckoutServiceItem {
    private String serviceName;
    private int quantity;
    private long price;
    private long total;

    public CheckoutServiceItem() {
    }

    public CheckoutServiceItem(String serviceName, int quantity, long price, long total) {
        this.serviceName = serviceName;
        this.quantity = quantity;
        this.price = price;
        this.total = total;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public long getPrice() {
        return price;
    }

    public void setPrice(long price) {
        this.price = price;
    }

    public long getTotal() {
        return total;
    }

    public void setTotal(long total) {
        this.total = total;
    }
}
