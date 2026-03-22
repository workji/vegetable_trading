package com.example.demo.feature.forecast;

import com.example.demo.core.exception.BusinessException;
import com.example.demo.feature.product.ProductMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 预测业务逻辑层 (Service)
 */
@Service
public class ForecastService {

    private static final Logger logger = LoggerFactory.getLogger(ForecastService.class);

    private final ForecastMapper forecastMapper;
    // 跨域注入：防止外键失效引发的幽灵数据
    private final ProductMapper productMapper;

    public ForecastService(ForecastMapper forecastMapper, ProductMapper productMapper) {
        this.forecastMapper = forecastMapper;
        this.productMapper = productMapper;
    }

    public List<Forecast> getAllForecasts() {
        return forecastMapper.findAll();
    }

    @Transactional
    public void registerForecast(ForecastForm form) {
        logger.info("新增预测数据: 目标日期={}, 类型={}, 品目={}",
                form.getTargetDate(), form.getType(), form.getProductId());

        // 【防卫式编程】校验品目是否存在，兜底数据库外键缺失
        if (productMapper.findById(form.getProductId()).isEmpty()) {
            throw new BusinessException("风控拦截：您尝试预测的品目在系统中不存在！");
        }

        // Entity 转换落库
        Forecast f = new Forecast();
        f.setTargetDate(form.getTargetDate());
        f.setType(form.getType());
        f.setProductId(form.getProductId());
        f.setEstimatedQty(form.getEstimatedQty());
        f.setManualQty(form.getManualQty());
        f.setNote(form.getNote());

        forecastMapper.insert(f);
        logger.info("预测数据已入库生效。");
    }

    @Transactional
    public void updateForecast(Integer id, ForecastForm form) {
        if (forecastMapper.findById(id).isEmpty()) {
            throw new BusinessException("要更新的预测数据不存在或已被删除！");
        }
        if (productMapper.findById(form.getProductId()).isEmpty()) {
            throw new BusinessException("风控拦截：您尝试预测的品目在系统中不存在！");
        }

        Forecast f = new Forecast();
        f.setId(id);
        f.setTargetDate(form.getTargetDate());
        f.setType(form.getType());
        f.setProductId(form.getProductId());
        f.setEstimatedQty(form.getEstimatedQty());
        f.setManualQty(form.getManualQty());
        f.setNote(form.getNote());

        forecastMapper.update(f);
        logger.info("预测数据已成功更新。ID: {}", id);
    }

    @Transactional
    public void deleteForecast(Integer id) {
        forecastMapper.deleteById(id);
        logger.info("预测数据已成功删除。ID: {}", id);
    }
}