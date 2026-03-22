package com.example.demo.feature.customer;

/**
 * 顾客（零售商/超市）实体类 (Entity)
 * 作用：映射数据库 `m_customers` 表。承载销售终端的物理和业务信息。
 * 规范：与 Farmer 一致，保持绝对的纯净性（POJO）。
 */
public class Customer {
    private Integer id;           // 顾客主键ID
    private String name;          // 门店名称/企业名（如：XX生鲜超市）
    private String prefecture;    // 都道府县（用于判断地带属性及物流分拣）
    private String city;          // 市区町村
    private String addressLine;   // 详细地址（门牌、大厦楼层）

    public Customer() {}

    // --- 严谨的 Getter/Setter 声明 ---
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