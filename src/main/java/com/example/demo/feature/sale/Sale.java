package com.example.demo.feature.sale;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 销售出库实体类 (Entity)
 * 作用：映射数据库 `t_sales` 表。承载销售流水的物理记录。
 */
public class Sale {
    private Integer id;
    private LocalDate saleDate;
    private Integer customerId;
    private Integer productId;
    private BigDecimal quantity;
    private BigDecimal unitPrice;
    private BigDecimal totalPrice;

    // 溯源（Traceability）核心字段：
    // 指明“这批卖给超市的菜，到底是来源于哪一次入库批次”。实现了食品安全链路追踪。
    private Integer arrivalId;

    // JOIN用的展示字段（非数据库物理列）
    private String customerName;
    private String productName;

    // --- 严格的 Getter / Setter ---
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public LocalDate getSaleDate() { return saleDate; }
    public void setSaleDate(LocalDate saleDate) { this.saleDate = saleDate; }

    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }

    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }

    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public Integer getArrivalId() { return arrivalId; }
    public void setArrivalId(Integer arrivalId) { this.arrivalId = arrivalId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
}