package com.example.demo.feature.farmer;

/**
 * 农家实体类 (Entity)
 * 作用：它是数据库 `m_farmers` 表在 Java 世界的 1:1 投影。
 * 规范：它是一个纯粹的数据载体（POJO），绝对不能包含任何业务计算逻辑。
 */
public class Farmer {
    private Integer id;           // 主键ID（数据库自动递增）
    private String name;          // 农家名・屋号
    private String prefecture;    // 都道府县（用于地狱匹配和运费计算）
    private String city;          // 市区町村
    private String addressLine;   // 详细地址（门牌号、大棚编号等）
    private String rank;          // 信任评级 (A, B, C等)

    // 默认空构造函数（MyBatis 从数据库查出数据后，通过反射创建对象时必须依赖此构造函数）
    public Farmer() {}

    // --- 下列为严格符合 JavaBeans 规范的 Getter / Setter ---
    // （为了不让代码显得臃肿，这里采用单行紧凑格式）
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
    public String getRank() { return rank; }
    public void setRank(String rank) { this.rank = rank; }
}