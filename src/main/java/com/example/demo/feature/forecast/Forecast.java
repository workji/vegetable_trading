package com.example.demo.feature.forecast;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * 预测实体类 (Entity)
 * 作用：映射数据库 `t_forecasts` 表。承载老板或系统对未来农产品走势的评估数据。
 */
public class Forecast {
    private Integer id;
    private LocalDate targetDate;     // 预测指向的未来日期

    // DB列设计为 ENUM('SUPPLY', 'DEMAND')。
    // 在 Java 中，实体类用纯 String 接收，安全校验由 Form 层的正则表达式接管。
    private String type;

    private Integer productId;        // 预测关联的品目
    private BigDecimal estimatedQty;  // 系统算法预测的数量
    private BigDecimal manualQty;     // 人工(老板)微调的最终参考数量
    private String note;              // 预测依据（如：台风预警）

    // JOIN用展示字段
    private String productName;

    // --- 严格的 Getter / Setter ---
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

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
}