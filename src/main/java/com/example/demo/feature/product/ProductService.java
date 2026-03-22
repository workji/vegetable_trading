package com.example.demo.feature.product;

import com.example.demo.core.exception.BusinessException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 品目业务逻辑层 (Service)
 * 作用：统筹协调，处理业务规则，并管理事务。
 */
@Service
public class ProductService {

    // 引入 SLF4J 接口进行日志记录。这是排查生产环境故障的重要手段。
    private static final Logger logger = LoggerFactory.getLogger(ProductService.class);

    // 声明为 final，确保依赖在初始化后不可被篡改（线程安全）。
    private final ProductMapper productMapper;

    /**
     * 构造器注入（Constructor Injection）
     * 推荐使用这种方式替代 @Autowired，因为它在编写单元测试时（不启动 Spring 容器）可以通过 new 关键字直接注入 Mock 对象。
     */
    public ProductService(ProductMapper productMapper) {
        this.productMapper = productMapper;
    }

    /**
     * 获取全量品目列表
     */
    public List<Product> getAllProducts() {
        return productMapper.findAll();
    }

    /**
     * 注册新的品目
     * * @Transactional：如果在此方法内发生任何 RuntimeException（如数据库断开、SQL语法错误），
     * 将触发自动回滚，确保数据库不会残留半截脏数据。
     */
    @Transactional
    public void registerProduct(ProductForm form) {
        // 记录业务执行轨迹，包含关键参数
        logger.info("开始注册新品目业务: 品目名称={}, 单位={}", form.getName(), form.getStandardUnit());

        // 1. 将安全的 DTO 数据转移到 Entity 实体中
        Product product = new Product();
        product.setName(form.getName());
        product.setVariety(form.getVariety());
        product.setStandardUnit(form.getStandardUnit());

        // 2. 持久化到数据库
        productMapper.insert(product);

        logger.info("新品目注册业务完成，数据已落盘");
    }

    @Transactional
    public void updateProduct(Integer id, ProductForm form) {
        if (productMapper.findById(id).isEmpty()) throw new BusinessException("要更新的品目不存在或已被删除！");

        Product product = new Product();
        product.setId(id);
        product.setName(form.getName());
        product.setVariety(form.getVariety());
        product.setStandardUnit(form.getStandardUnit());

        productMapper.update(product);
        logger.info("品目数据已成功更新。ID: {}", id);
    }

    @Transactional
    public void deleteProduct(Integer id) {
        // 在企业级系统中，由于缺少外键级联，删除前应检查是否有交易记录引用了该品目。此处保持物理直删。
        productMapper.deleteById(id);
        logger.info("品目数据已成功删除。ID: {}", id);
    }
}