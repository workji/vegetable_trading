package com.example.demo.feature.farmer;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

/**
 * 农家注册表单 (DTO: Data Transfer Object)
 * 作用：专门用于接收前端 HTML 表单提交的数据，并执行“单字段校验”。
 * * 【架构隔离原则】
 * 为什么要新建一个 Form 类，而不是直接用 Farmer Entity 接收数据？
 * 答：防范“过度提交攻击(Over-Posting)”。假如 Entity 里有个 `isAdmin` 字段，
 * 恶意用户如果在表单里伪造了这个字段提交，直接用 Entity 接收就会被黑客提权。
 * 使用专门的 Form，只接收我们允许接收的字段，是最安全的做法。
 */
public class FarmerForm {
    private Integer id; // 追加：用于编辑时的ID回传

    // @NotBlank: 校验规则 —— 不允许为 null，不允许为空字符串("")，也不允许全空格("   ")。
    @NotBlank(message = "农家名（屋号）为必填项")
    private String name;

    @NotBlank(message = "都道府县为必填项")
    private String prefecture;

    @NotBlank(message = "市区町村为必填项")
    private String city;

    // 非必填项，不加任何校验注解
    private String addressLine;

    @NotBlank(message = "必须选择交易评级")
    // @Pattern: 使用正则表达式进行严格校验。确保前端传来的值只能是单个大写字母 A、B 或 C。
    @Pattern(regexp = "^[ABC]$", message = "评级只能是 A、B、C 中的一种")
    private String rank;

    // --- Getter / Setter ---
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getName() { return name; } public void setName(String name) { this.name = name; }
    public String getPrefecture() { return prefecture; } public void setPrefecture(String prefecture) { this.prefecture = prefecture; }
    public String getCity() { return city; } public void setCity(String city) { this.city = city; }
    public String getAddressLine() { return addressLine; } public void setAddressLine(String addressLine) { this.addressLine = addressLine; }
    public String getRank() { return rank; } public void setRank(String rank) { this.rank = rank; }
}