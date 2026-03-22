package com.example.demo.feature.sale;

import org.apache.ibatis.annotations.*;
import java.util.List;

/**
 * 销售出库数据访问接口 (Repository / Mapper)
 */
@Mapper
public interface SaleMapper {

    /**
     * 查询销售明细（联合顾客表和品目表，解决 N+1 查询问题）
     */
    @Select("SELECT s.*, c.name as customerName, p.name as productName " +
            "FROM t_sales s " +
            "JOIN m_customers c ON s.customer_id = c.id " +
            "JOIN m_products p ON s.product_id = p.id " +
            "ORDER BY s.sale_date DESC")
    List<Sale> findAll();

    @Insert("INSERT INTO t_sales(sale_date, customer_id, product_id, quantity, unit_price, total_price, arrival_id) " +
            "VALUES(#{saleDate}, #{customerId}, #{productId}, #{quantity}, #{unitPrice}, #{totalPrice}, #{arrivalId})")
    void insert(Sale sale);

    @Update("UPDATE t_sales SET sale_date=#{saleDate}, customer_id=#{customerId}, product_id=#{productId}, " +
            "quantity=#{quantity}, unit_price=#{unitPrice}, total_price=#{totalPrice}, arrival_id=#{arrivalId} WHERE id=#{id}")
    void update(Sale sale);

    @Delete("DELETE FROM t_sales WHERE id=#{id}")
    void deleteById(Integer id);
}