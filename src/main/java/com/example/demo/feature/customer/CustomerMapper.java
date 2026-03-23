package com.example.demo.feature.customer;

import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Optional;

/**
 * 顾客数据访问接口 (Repository / Mapper)
 * * 【设计哲学】
 * 仅封装最纯粹的 SQL 操作，绝不包含任何诸如“判断名字是否重复”的业务逻辑，保持 Mapper 的单一职责。
 */
@Mapper
public interface CustomerMapper {

    /**
     * 获取全量顾客列表，按添加时间（ID）倒序排列
     */
    @Select("SELECT * FROM m_customers ORDER BY id DESC")
    List<Customer> findAll();

    /**
     * 根据主键精准查询
     * 返回 Optional，防范脏数据导致的 NullPointerException。
     */
    @Select("SELECT * FROM m_customers WHERE id = #{id}")
    Optional<Customer> findById(Integer id);

    /**
     * 插入新数据。
     * 字段映射严格对应 Java 驼峰 -> 数据库下划线 (例：addressLine -> address_line)。
     */
    @Insert("INSERT INTO m_customers(name, prefecture, city, address_line) VALUES(#{name}, #{prefecture}, #{city}, #{addressLine})")
    void insert(Customer customer);

    @Update("UPDATE m_customers SET name=#{name}, prefecture=#{prefecture}, city=#{city}, address_line=#{addressLine} WHERE id=#{id}")
    void update(Customer customer);

    @Delete("DELETE FROM m_customers WHERE id=#{id}")
    void deleteById(Integer id);

    // --- 追加：分页与排序专属查询 ---
    // 注意：${} 用于直接拼接列名和ASC/DESC，存在SQL注入风险，必须在Service层严格拦截！
    @Select("SELECT * FROM m_customers ORDER BY ${sortColumn} ${sortDir} LIMIT #{offset}, #{size}")
    List<Customer> findPage(@Param("sortColumn") String sortColumn, @Param("sortDir") String sortDir,
                            @Param("offset") int offset, @Param("size") int size);

    @Select("SELECT COUNT(id) FROM m_customers")
    long countAll();
}