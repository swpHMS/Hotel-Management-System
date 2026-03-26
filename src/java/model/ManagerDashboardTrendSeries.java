package model;

public class ManagerDashboardTrendSeries {

    private final String labelsJs;
    private final String valuesJs;
    private final double totalValue;

    public ManagerDashboardTrendSeries(String labelsJs, String valuesJs, double totalValue) {
        this.labelsJs = labelsJs;
        this.valuesJs = valuesJs;
        this.totalValue = totalValue;
    }

    public String getLabelsJs() {
        return labelsJs;
    }

    public String getValuesJs() {
        return valuesJs;
    }

    public double getTotalValue() {
        return totalValue;
    }
}
