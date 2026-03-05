/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;

/**
 *
 * @author DieuBHHE191686
 */
public class ServiceOrderItem {
    private long serviceOrderItemId;      // BIGINT
    private int serviceOrderId;           // INT
    private int serviceId;                // INT
    private int quantity;                 // INT
    private BigDecimal unitPriceSnapshot; // decimal(18,2)

    // join fields for UI (không lưu DB)
    private String serviceCode;

    public String getServiceCode() {
        return serviceCode;
    }

    public void setServiceCode(String serviceCode) {
        this.serviceCode = serviceCode;
    }
    private String serviceName;
    private int serviceType;

    public ServiceOrderItem() {
    }

    public ServiceOrderItem(long serviceOrderItemId, int serviceOrderId, int serviceId, int quantity, BigDecimal unitPriceSnapshot, String serviceName, int serviceType) {
        this.serviceOrderItemId = serviceOrderItemId;
        this.serviceOrderId = serviceOrderId;
        this.serviceId = serviceId;
        this.quantity = quantity;
        this.unitPriceSnapshot = unitPriceSnapshot;
        this.serviceName = serviceName;
        this.serviceType = serviceType;
    }
    

    public long getServiceOrderItemId() {
        return serviceOrderItemId;
    }

    public void setServiceOrderItemId(long serviceOrderItemId) {
        this.serviceOrderItemId = serviceOrderItemId;
    }

    public int getServiceOrderId() {
        return serviceOrderId;
    }

    public void setServiceOrderId(int serviceOrderId) {
        this.serviceOrderId = serviceOrderId;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPriceSnapshot() {
        return unitPriceSnapshot;
    }

    public void setUnitPriceSnapshot(BigDecimal unitPriceSnapshot) {
        this.unitPriceSnapshot = unitPriceSnapshot;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public int getServiceType() {
        return serviceType;
    }

    public void setServiceType(int serviceType) {
        this.serviceType = serviceType;
    }
    
    
}
