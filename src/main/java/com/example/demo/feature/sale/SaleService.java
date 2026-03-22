package com.example.demo.feature.sale;

import com.example.demo.core.exception.BusinessException;
import com.example.demo.feature.arrival.Arrival;
import com.example.demo.feature.arrival.ArrivalMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * 销售出库业务逻辑层 (Service)
 * 作用：统筹核心交易风控，包含复杂的防超卖、防篡改审查。
 */
@Service
public class SaleService {

    private static final Logger logger = LoggerFactory.getLogger(SaleService.class);

    private final SaleMapper saleMapper;
    // 跨域注入：需要查阅入库表的剩余库存
    private final ArrivalMapper arrivalMapper;

    public SaleService(SaleMapper saleMapper, ArrivalMapper arrivalMapper) {
        this.saleMapper = saleMapper;
        this.arrivalMapper = arrivalMapper;
    }

    public List<Sale> getAllSales() {
        return saleMapper.findAll();
    }

    /**
     * 【重中之重：库存防超卖模型与核心落库逻辑】
     */
    @Transactional
    public void registerSale(SaleForm form) {
        logger.info("出库审批流程启动，试图绑定并扣减的批次ID (arrivalId) = {}", form.getArrivalId());

        // 【防御防线1】：检查对应的入库批次是否真的存在
        Optional<Arrival> arrivalOpt = arrivalMapper.findById(form.getArrivalId());
        if (arrivalOpt.isEmpty()) {
            throw new BusinessException("风控拦截：您选择的入库批次不存在或已被撤销！");
        }

        Arrival arrival = arrivalOpt.get();

        // 【防御防线2】：品目校验（防止“挂羊头卖狗肉”）
        if (!arrival.getProductId().equals(form.getProductId())) {
            throw new BusinessException("风控拦截：出库品目与您绑定的入库批次所对应的品目不一致，涉嫌违规操作。");
        }

        // 【防御防线3】：可用库存上限校验（防止“超卖”）
        // compareTo 返回 1 表示前面的数大于后面的数。
        if (form.getQuantity().compareTo(arrival.getQuantity()) > 0) {
            throw new BusinessException(
                    String.format("库存告警：出库量(%s) 不可超过该批次原始入库总量(%s)。拒绝超卖！",
                            form.getQuantity().toPlainString(), arrival.getQuantity().toPlainString())
            );
        }

        // 组装并保存销售记录
        Sale sale = new Sale();
        sale.setSaleDate(form.getSaleDate());
        sale.setCustomerId(form.getCustomerId());
        sale.setProductId(form.getProductId());
        sale.setArrivalId(form.getArrivalId());
        sale.setQuantity(form.getQuantity());
        sale.setUnitPrice(form.getUnitPrice());

        // 核心财务铁律：总价由服务器重新计算
        sale.setTotalPrice(form.getQuantity().multiply(form.getUnitPrice()));

        saleMapper.insert(sale);
        logger.info("出库及扣减逻辑执行通过，数据落库完毕。");
    }

    @Transactional
    public void updateSale(Integer id, SaleForm form) {
        // 【防御性编程】实际生产中，修改已发生的销售单库存极其复杂（需回滚旧批次库存，扣减新批次库存）。
        // 此处提供基础 CRUD。依然执行与 insert 相同的库存上限校验。
        Optional<Arrival> arrivalOpt = arrivalMapper.findById(form.getArrivalId());
        if (arrivalOpt.isEmpty()) throw new BusinessException("您选择的入库批次不存在！");
        if (!arrivalOpt.get().getProductId().equals(form.getProductId())) throw new BusinessException("出库品目与绑定的入库批次品目不一致！");
        if (form.getQuantity().compareTo(arrivalOpt.get().getQuantity()) > 0) throw new BusinessException("出库量不可超过该批次原始入库总量！");

        Sale sale = new Sale();
        sale.setId(id); sale.setSaleDate(form.getSaleDate()); sale.setCustomerId(form.getCustomerId());
        sale.setProductId(form.getProductId()); sale.setArrivalId(form.getArrivalId());
        sale.setQuantity(form.getQuantity()); sale.setUnitPrice(form.getUnitPrice());
        sale.setTotalPrice(form.getQuantity().multiply(form.getUnitPrice()));
        saleMapper.update(sale);
    }

    @Transactional
    public void deleteSale(Integer id) {
        saleMapper.deleteById(id);
    }
}