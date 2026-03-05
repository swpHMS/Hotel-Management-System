/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;


/**
 *
 * @author DieuBHHE191686
 */
public class Service {

    private int serviceId;
    private String code;
    private String name;
    private int serviceType;           // 0 surcharge, 1 minibar, 2 laundry, 3 cleaning
    private double unitPrice;

    public Service() {
    }

    public Service(int serviceId, String code, String name, int serviceType, double unitPrice) {
        this.serviceId = serviceId;
        this.code = code;
        this.name = name;
        this.serviceType = serviceType;
        this.unitPrice = unitPrice;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getServiceType() {
        return serviceType;
    }

    public void setServiceType(int serviceType) {
        this.serviceType = serviceType;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }
    
}
