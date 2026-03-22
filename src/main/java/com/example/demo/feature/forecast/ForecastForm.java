package com.example.demo.feature.forecast;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 预测录入表单 (DTO / Form)
 * * 【架构防线】终结“魔法数字”。通过严格的枚举正则，将脏数据隔离在 Controller 边缘。
 */
public class ForecastForm {
    private Integer id; // 追加：用于编辑时的ID回传

    @NotNull(message="预测的目标日期必须填写")
    private LocalDate targetDate;

    /**
     * 【禁止魔法数字(Magic Number)】
     * 坚决抵制使用 "01" 代表供货，"02" 代表需求。
     * 直接采用语义化的全拼英语，并通过 RegExp 阻止任何恶意篡改。
     */
    @NotBlank(message="必须选择预测的维度")
    @Pattern(regexp="^(SUPPLY|DEMAND)$", message="非法的业务枚举值！系统仅允许 SUPPLY(供应预测) 或 DEMAND(需求预测)")
    private String type;

    @NotNull(message="被预测的品目必须指定")
    private Integer productId;

    private BigDecimal estimatedQty; // 系统预测值（此版本暂留空，供后续 AI 模块接入）
    private BigDecimal manualQty;    // 业务人员最终核定的预测数量
    private String note;             // 备注说明

    // --- Getter / Setter ---
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public LocalDate getTargetDate() { return targetDate; }
    public void setTargetDate(LocalDate targetDate) { this.targetDate = targetDate; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }

    public BigDecimal getEstimatedQty() { return estimatedQty; }
    public void setEstimatedQty(BigDecimal estimatedQty) { this.estimatedQty = estimatedQty; }

    public BigDecimal getManualQty() { return manualQty; }
    public void setManualQty(BigDecimal manualQty) { this.manualQty = manualQty; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}