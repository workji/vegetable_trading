package com.example.demo.feature.sale;

import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 销售出库表单 (DTO / Form)
 * 作用：接收前端请求，执行基础的单字段与跨字段参数校验，防止脏数据污染业务层。
 */
public class SaleForm {
    private Integer id;

    @NotNull(message="出库日期是必须的")
    private LocalDate saleDate;

    @NotNull(message="必须指定销售对象的顾客/超市")
    private Integer customerId;

    @NotNull(message="请选择出库品目")
    private Integer productId;

    @NotNull(message="请关联要扣减库存的入库批次(入库ID)")
    private Integer arrivalId;

    @NotNull(message="出库数量必须填写")
    @DecimalMin(value="0.01", message="出库数必须 > 0")
    private BigDecimal quantity;

    @NotNull(message="销售单价必须填写")
    @DecimalMin(value="0.00", message="价格不可为负")
    private BigDecimal unitPrice;

    /**
     * 【相干校验 (Cross-field Validation)】
     * 业务场景：出库日期不能是未来的时间。
     */
    @AssertTrue(message="出库日不能是未来时间")
    public boolean isSaleDateValid() {
        return saleDate == null || !saleDate.isAfter(LocalDate.now());
    }

    // --- Getter / Setter ---
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public LocalDate getSaleDate() { return saleDate; }
    public void setSaleDate(LocalDate saleDate) { this.saleDate = saleDate; }

    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }

    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }

    public Integer getArrivalId() { return arrivalId; }
    public void setArrivalId(Integer arrivalId) { this.arrivalId = arrivalId; }

    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
}