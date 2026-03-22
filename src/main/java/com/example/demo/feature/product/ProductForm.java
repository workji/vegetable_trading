package com.example.demo.feature.product;

import jakarta.validation.constraints.NotBlank;

/**
 * 品目注册表单 (DTO / Form)
 * * 【架构防线】
 * 为什么不直接用 Product 接收前端参数？
 * 答：防止“过度提交(Over-Posting)”。假设以后我们在 Product 表里加了 `is_deleted` 字段，
 * 如果黑客在提交表单时自己加上 `<input name="is_deleted" value="true">`，
 * 直接用 Entity 接收就会引发严重的安全事故。用 Form 隔离是企业级标配。
 */
public class ProductForm {
    private Integer id; // 追加：用于编辑时的ID回传

    // @NotBlank 会同时拦截 null、""（空串）以及 "   "（纯空格串）。
    @NotBlank(message = "品目名称不可为空，请明确输入（如：番茄）")
    private String name;

    // 品种允许为空（如一般的胡萝卜可能不细分品种），因此不加校验注解
    private String variety;

    @NotBlank(message = "基本计量单位不可为空（如：箱、kg）")
    private String standardUnit;

    // --- 严格的 Getter / Setter ---
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getVariety() { return variety; }
    public void setVariety(String variety) { this.variety = variety; }

    public String getStandardUnit() { return standardUnit; }
    public void setStandardUnit(String standardUnit) { this.standardUnit = standardUnit; }
}