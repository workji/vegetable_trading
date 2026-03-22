package com.example.demo.feature.arrival;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 入库明细实体类 (Entity)
 * * 【架构规范】
 * 1. 财务严谨性：涉及到数量和金额的字段，强制使用 BigDecimal。绝对禁止使用 float 或 double，防止精度丢失。
 * 2. 冗余设计：除了关联的 ID 外，增加了 farmerName、productName 等字段，用于接收 JOIN 查询的结果，方便前端展示。
 */
public class Arrival {
    private Integer id;             // 入库流水号
    private LocalDate arrivalDate;  // 实际入库日期
    private Integer farmerId;       // 关联的农家（供货商）ID
    private Integer productId;      // 关联的品目ID

    private BigDecimal quantity;    // 入库数量
    private BigDecimal unitPrice;   // 进货单价
    private BigDecimal totalPrice;  // 进货总金额

    // --- 下列为 JOIN 查询时的扩展展示字段（非数据库物理列） ---
    private String farmerName;      // 农家名称
    private String productName;     // 品目名称
    private String unit;            // 计量单位

    public Arrival() {}

    // --- 严格的 Getter / Setter (禁用 Lombok) ---
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public LocalDate getArrivalDate() { return arrivalDate; }
    public void setArrivalDate(LocalDate arrivalDate) { this.arrivalDate = arrivalDate; }

    public Integer getFarmerId() { return farmerId; }
    public void setFarmerId(Integer farmerId) { this.farmerId = farmerId; }

    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }

    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public String getFarmerName() { return farmerName; }
    public void setFarmerName(String farmerName) { this.farmerName = farmerName; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
}
