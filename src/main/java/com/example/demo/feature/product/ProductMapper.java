package com.example.demo.feature.product;

import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Optional;

/**
 * 品目数据访问接口 (Repository / Mapper)
 * * 【架构解读】
 * @Mapper 注解告诉 Spring 和 MyBatis：请在启动时为这个接口动态生成一个实现类，并放进 Spring 容器中。
 */
@Mapper
public interface ProductMapper {

    /**
     * 查询所有品目，按 ID 倒序排列（后添加的蔬菜种类在最前面）
     */
    @Select("SELECT * FROM m_products ORDER BY id DESC")
    List<Product> findAll();

    /**
     * 根据 ID 查询单个品目
     * * 【防卫式编程】
     * 强制返回 Optional<Product> 而不是直接返回 Product。
     * 这在后续 SaleService 这种需要检查品目是否存在的场景中，能优雅地避免 NullPointerException。
     */
    @Select("SELECT * FROM m_products WHERE id = #{id}")
    Optional<Product> findById(Integer id);

    /**
     * 插入新品目数据
     * * #{参数名}：MyBatis 会将其编译为 JDBC 的 PreparedStatement 占位符(?)，从根本上杜绝 SQL 注入。
     */
    @Insert("INSERT INTO m_products(name, variety, standard_unit) VALUES(#{name}, #{variety}, #{standardUnit})")
    void insert(Product product);

    @Update("UPDATE m_products SET name=#{name}, variety=#{variety}, standard_unit=#{standardUnit} WHERE id=#{id}")
    void update(Product product);

    @Delete("DELETE FROM m_products WHERE id=#{id}")
    void deleteById(Integer id);
}
