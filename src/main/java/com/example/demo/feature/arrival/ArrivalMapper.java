package com.example.demo.feature.arrival;

import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Optional;

/**
 * 入库数据访问接口 (Repository / Mapper)
 */
@Mapper
public interface ArrivalMapper {

    /**
     * 查询入库流水明细
     * * 【N+1 查询解决方案】
     * 严禁只查出 farmer_id 后，在代码里写个 for 循环去一个个查农家名字（会把数据库查挂）。
     * 必须使用 JOIN 一次性把业务所需的关联名称带出来。
     */
    @Select("SELECT a.*, f.name as farmerName, p.name as productName, p.standard_unit as unit " +
            "FROM t_arrivals a " +
            "JOIN m_farmers f ON a.farmer_id = f.id " +
            "JOIN m_products p ON a.product_id = p.id " +
            "ORDER BY a.arrival_date DESC")
    List<Arrival> findAll();

    /**
     * 按 ID 检索入库记录（后续出库模块扣减库存时需要使用）
     */
    @Select("SELECT * FROM t_arrivals WHERE id = #{id}")
    Optional<Arrival> findById(Integer id);

    /**
     * 插入入库记录
     * * 【主键回填机制】
     * @Options: 告诉 MyBatis 使用 MySQL 的自增主键功能 (useGeneratedKeys)，
     * 并将插入后生成的新 ID 自动塞回到传入的 arrival 对象的 'id' 属性中。
     */
    @Insert("INSERT INTO t_arrivals(arrival_date, farmer_id, product_id, quantity, unit_price, total_price) " +
            "VALUES(#{arrivalDate}, #{farmerId}, #{productId}, #{quantity}, #{unitPrice}, #{totalPrice})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    void insert(Arrival arrival);

    @Update("UPDATE t_arrivals SET arrival_date=#{arrivalDate}, farmer_id=#{farmerId}, product_id=#{productId}, " +
            "quantity=#{quantity}, unit_price=#{unitPrice}, total_price=#{totalPrice} WHERE id=#{id}")
    void update(Arrival arrival);

    @Delete("DELETE FROM t_arrivals WHERE id=#{id}")
    void deleteById(Integer id);
}
