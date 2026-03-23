package com.example.demo.feature.farmer;

import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Optional;

/**
 * 农家数据访问接口 (Data Access Layer)
 * 作用：定义与 MySQL 数据库交互的 SQL 语句。
 * 依靠 @Mapper 注解，MyBatis 会在运行时自动生成这个接口的实现类。
 */
@Mapper
public interface FarmerMapper {

    /**
     * 获取所有农家列表，按 ID 倒序排列（最新注册的在最前面）
     */
    @Select("SELECT * FROM m_farmers ORDER BY id DESC")
    List<Farmer> findAll();

    /**
     * 根据 ID 查找指定的农家
     * * 【高级防御技巧：Optional】
     * 以前的写法是返回 Farmer，如果数据库没查到就返回 null，很容易引发 NullPointerException。
     * 包装成 Optional<Farmer> 后，强迫调用者显式处理“查不到数据”的情况，极大地提升了系统的健壮性。
     */
    @Select("SELECT * FROM m_farmers WHERE id = #{id}")
    Optional<Farmer> findById(Integer id);

    /**
     * 插入新的农家数据
     * 注意：#{属性名} 这种写法是安全的预编译参数（PreparedStatement），能100%防止 SQL 注入攻击。
     * 绝对不要用 ${属性名} 进行字符串拼接。
     * 必须将列名 `rank` 用反引号（ESC键下方的波浪号键）包裹起来。
     * 否则 MySQL 8.0 会将其误认为是 RANK() 窗口函数，抛出 SQLSyntaxErrorException。
     */
    @Insert("INSERT INTO m_farmers(name, prefecture, city, address_line, `rank`) VALUES(#{name}, #{prefecture}, #{city}, #{addressLine}, #{rank})")
    void insert(Farmer farmer);

    @Update("UPDATE m_farmers SET name=#{name}, prefecture=#{prefecture}, city=#{city}, address_line=#{addressLine}, `rank`=#{rank} WHERE id=#{id}")
    void update(Farmer farmer);

    @Delete("DELETE FROM m_farmers WHERE id=#{id}")
    void deleteById(Integer id);

    // 追加：带有动态搜索、排序、分页的终极查询
    @Select("<script>" +
            "SELECT * FROM m_farmers WHERE 1=1 " +
            "<if test='searchName != null and searchName != \"\"'> AND name LIKE CONCAT('%', #{searchName}, '%') </if>" +
            "<if test='searchRank != null and searchRank != \"\"'> AND `rank` = #{searchRank} </if>" +
            "ORDER BY ${sortColumn} ${sortDir} LIMIT #{offset}, #{size}" +
            "</script>")
    List<Farmer> findPage(@Param("searchName") String searchName, @Param("searchRank") String searchRank,
                          @Param("sortColumn") String sortColumn, @Param("sortDir") String sortDir,
                          @Param("offset") int offset, @Param("size") int size);

    @Select("<script>" +
            "SELECT COUNT(id) FROM m_farmers WHERE 1=1 " +
            "<if test='searchName != null and searchName != \"\"'> AND name LIKE CONCAT('%', #{searchName}, '%') </if>" +
            "<if test='searchRank != null and searchRank != \"\"'> AND `rank` = #{searchRank} </if>" +
            "</script>")
    long countAll(@Param("searchName") String searchName, @Param("searchRank") String searchRank);
}