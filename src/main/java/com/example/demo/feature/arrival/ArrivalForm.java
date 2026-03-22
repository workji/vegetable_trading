package com.example.demo.feature.arrival;

import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 入库登记表单 (DTO / Form)
 * * 【架构防线】
 * 该类负责抵御一切不合法的格式数据。通过强类型的校验，减轻 Service 层的防御压力。
 */
public class ArrivalForm {
    private Integer id;

    @NotNull(message = "入库日不可为空")
    private LocalDate arrivalDate;

    @NotNull(message = "请选择供货农家")
    private Integer farmerId;

    @NotNull(message = "请选择入库品目")
    private Integer productId;

    @NotNull(message = "入库数量不可为空")
    @DecimalMin(value = "0.01", message = "入库数量必须大于 0")
    private BigDecimal quantity;

    @NotNull(message = "进货单价不可为空")
    @DecimalMin(value = "0.00", message = "进货单价不能为负数")
    private BigDecimal unitPrice;

    /**
     * 【相干校验 (Cross-field/Custom Validation)】
     * @AssertTrue: 强制要求该方法的返回值为 true，否则抛出 message 的错误。
     * 业务防线：防止员工误填导致出现“明天才发生的入库记录”。
     */
    @AssertTrue(message = "入库日期不能是未来的日期（明天及以后）")
    public boolean isArrivalDateValid() {
        // 如果前面日期都没填，这里直接放行，把报错的责任交给上面的 @NotNull
        if (arrivalDate == null) {
            return true;
        }
        // 不能在当前日期之后
        return !arrivalDate.isAfter(LocalDate.now());
    }

    // --- Getter / Setter ---
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
}
