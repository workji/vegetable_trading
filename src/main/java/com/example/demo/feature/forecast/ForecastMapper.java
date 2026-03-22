package com.example.demo.feature.forecast;

import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Optional;

/**
 * 预测数据访问接口 (Repository / Mapper)
 */
@Mapper
public interface ForecastMapper {

    /**
     * 获取历史与未来的全量预测记录，并 JOIN 品目表提取易读的品目名称。
     */
    @Select("SELECT f.*, p.name as productName " +
            "FROM t_forecasts f " +
            "JOIN m_products p ON f.product_id = p.id " +
            "ORDER BY f.target_date DESC")
    List<Forecast> findAll();

    /**
     * 主键查询，通过 Optional 包装防空指针。
     */
    @Select("SELECT * FROM t_forecasts WHERE id = #{id}")
    Optional<Forecast> findById(Integer id);

    @Insert("INSERT INTO t_forecasts(target_date, type, product_id, estimated_qty, manual_qty, note) " +
            "VALUES(#{targetDate}, #{type}, #{productId}, #{estimatedQty}, #{manualQty}, #{note})")
    void insert(Forecast forecast);

    @Update("UPDATE t_forecasts SET target_date=#{targetDate}, type=#{type}, product_id=#{productId}, " +
            "estimated_qty=#{estimatedQty}, manual_qty=#{manualQty}, note=#{note} WHERE id=#{id}")
    void update(Forecast forecast);

    @Delete("DELETE FROM t_forecasts WHERE id=#{id}")
    void deleteById(Integer id);
}