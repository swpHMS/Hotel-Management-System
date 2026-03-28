package model;

public class ManagerDashboardKpi {

    private int totalInventory;
    private int available;
    private int occupied;
    private int dirty;
    private int maintenance;

    public int getTotalInventory() {
        return totalInventory;
    }

    public void setTotalInventory(int totalInventory) {
        this.totalInventory = totalInventory;
    }

    public int getAvailable() {
        return available;
    }

    public void setAvailable(int available) {
        this.available = available;
    }

    public int getOccupied() {
        return occupied;
    }

    public void setOccupied(int occupied) {
        this.occupied = occupied;
    }

    public int getDirty() {
        return dirty;
    }

    public void setDirty(int dirty) {
        this.dirty = dirty;
    }

    public int getMaintenance() {
        return maintenance;
    }

    public void setMaintenance(int maintenance) {
        this.maintenance = maintenance;
    }

    public double getOccupancyPercent() {
        if (totalInventory <= 0) {
            return 0;
        }
        return occupied * 100.0 / totalInventory;
    }
}
