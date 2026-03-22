package com.example.demo.feature.customer;

import jakarta.validation.constraints.NotBlank;

/**
 * 顾客注册表单 (DTO / Form)
 * * 【安全边界防护】
 * 该类是前端请求数据进入后端系统的“第一道安检门”。
 * 利用 Bean Validation (JSR-380) 进行脏数据的初步拦截，避免 Controller 层堆积大量 if-else。
 */
public class CustomerForm {
    private Integer id;

    @NotBlank(message = "商超店铺名称为必填项，不可为空")
    private String name;

    @NotBlank(message = "都道府县为必填项，以便匹配物流路线")
    private String prefecture;

    @NotBlank(message = "市区町村为必填项")
    private String city;

    // 详细地址可能在某些乡村地带不需要，因此不加 @NotBlank 校验
    private String addressLine;

    // --- Getter/Setter ---
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPrefecture() { return prefecture; }
    public void setPrefecture(String prefecture) { this.prefecture = prefecture; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getAddressLine() { return addressLine; }
    public void setAddressLine(String addressLine) { this.addressLine = addressLine; }
}