package com.example.demo.feature.product;

/**
 * 品目实体类 (Entity)
 * * 【架构规范】
 * 1. 纯净性：它只代表数据库 `m_products` 表的一行数据，绝对不包含任何诸如“校验”、“计算”的业务逻辑。
 * 2. 命名规约：Java 的驼峰命名（standardUnit）将由 MyBatis 自动映射为数据库的下划线命名（standard_unit）。
 */
public class Product {
    private Integer id;             // 品目主键ID
    private String name;            // 蔬菜大类名称（如：番茄、白菜）
    private String variety;         // 品种/细分（如：桃太郎番茄。允许为空）
    private String standardUnit;    // 基本计量单位（如：箱、kg、把）。作为后续入库出库的计算基准。

    // 默认空构造函数（MyBatis 框架在反射实例化对象时强依赖此构造器）
    public Product() {}

    // --- 严格的 Getter / Setter (禁用 Lombok) ---
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getVariety() { return variety; }
    public void setVariety(String variety) { this.variety = variety; }

    public String getStandardUnit() { return standardUnit; }
    public void setStandardUnit(String standardUnit) { this.standardUnit = standardUnit; }
}
