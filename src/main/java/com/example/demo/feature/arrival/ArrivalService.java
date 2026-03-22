package com.example.demo.feature.arrival;

import com.example.demo.core.exception.BusinessException;
import com.example.demo.feature.farmer.FarmerMapper;
import com.example.demo.feature.product.ProductMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 入库业务逻辑层 (Service)
 * * 【架构职责】数据落库前的最后一次全面风控审查。
 */
@Service
public class ArrivalService {

    private static final Logger logger = LoggerFactory.getLogger(ArrivalService.class);

    private final ArrivalMapper arrivalMapper;
    // 跨域注入：需要验证外键的合法性，因此必须借用 Farmer 和 Product 的 Mapper
    private final FarmerMapper farmerMapper;
    private final ProductMapper productMapper;

    public ArrivalService(ArrivalMapper arrivalMapper, FarmerMapper farmerMapper, ProductMapper productMapper) {
        this.arrivalMapper = arrivalMapper;
        this.farmerMapper = farmerMapper;
        this.productMapper = productMapper;
    }

    public List<Arrival> getAllArrivals() {
        return arrivalMapper.findAll();
    }

    /**
     * 核心入库事务处理
     */
    @Transactional
    public void registerArrival(ArrivalForm form) {
        logger.info("入库事务开始: farmerId={}, productId={}, quantity={}",
                form.getFarmerId(), form.getProductId(), form.getQuantity());

        // 【防御式编程 (Defensive Programming)】
        // 既然我们没有配置物理外键，就必须在代码层兜底，防止黑客用爬虫提交一个不存在的 farmerId。
        if(farmerMapper.findById(form.getFarmerId()).isEmpty()) {
            logger.warn("非法入库请求：农家ID {} 不存在", form.getFarmerId());
            throw new BusinessException("安全拦截：所选农家在系统中不存在或已被删除！");
        }
        if(productMapper.findById(form.getProductId()).isEmpty()) {
            logger.warn("非法入库请求：品目ID {} 不存在", form.getProductId());
            throw new BusinessException("安全拦截：所选品目在系统中不存在！");
        }

        // 组装 Entity
        Arrival arr = new Arrival();
        arr.setArrivalDate(form.getArrivalDate());
        arr.setFarmerId(form.getFarmerId());
        arr.setProductId(form.getProductId());
        arr.setQuantity(form.getQuantity());
        arr.setUnitPrice(form.getUnitPrice());

        // 【核心财务铁律：服务端重算】
        // 绝对不能让前端把 totalPrice 传过来，必须在后端基于受信任的数据运算！
        arr.setTotalPrice(form.getQuantity().multiply(form.getUnitPrice()));

        arrivalMapper.insert(arr);

        // 此时 arr.getId() 已经被 MyBatis 填充
        logger.info("入库事务结束。成功生成记录，入库流水号: {}", arr.getId());
    }

    @Transactional
    public void updateArrival(Integer id, ArrivalForm form) {
        if(arrivalMapper.findById(id).isEmpty()) throw new BusinessException("要更新的入库记录不存在！");
        if(farmerMapper.findById(form.getFarmerId()).isEmpty()) throw new BusinessException("供货农家不存在！");
        if(productMapper.findById(form.getProductId()).isEmpty()) throw new BusinessException("品目不存在！");

        Arrival arr = new Arrival();
        arr.setId(id); arr.setArrivalDate(form.getArrivalDate()); arr.setFarmerId(form.getFarmerId());
        arr.setProductId(form.getProductId()); arr.setQuantity(form.getQuantity()); arr.setUnitPrice(form.getUnitPrice());
        arr.setTotalPrice(form.getQuantity().multiply(form.getUnitPrice())); // 重新计算总价
        arrivalMapper.update(arr);
    }

    @Transactional
    public void deleteArrival(Integer id) {
        arrivalMapper.deleteById(id);
    }
}