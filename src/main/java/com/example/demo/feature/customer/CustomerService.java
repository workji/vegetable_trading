package com.example.demo.feature.customer;

import com.example.demo.core.exception.BusinessException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

/**
 * 顾客业务逻辑层 (Service)
 * * 【事务控制】
 * 虽然当前 registerCustomer 只有单条 Insert 操作，但为了未来扩展（如：同时写入日志表、发邮件等），
 * 加上 @Transactional 可以将这些行为绑定为同一个原子操作。
 */
@Service
public class CustomerService {

    private static final Logger logger = LoggerFactory.getLogger(CustomerService.class);

    // final 声明确保不可变，通过构造器完成注入
    private final CustomerMapper customerMapper;

    public CustomerService(CustomerMapper customerMapper) {
        this.customerMapper = customerMapper;
    }

    public List<Customer> getAllCustomers() {
        return customerMapper.findAll();
    }

    /**
     * 注册新顾客核心流程
     * @param form 已通过表单层 @Validated 校验的数据对象
     */
    @Transactional
    public void registerCustomer(CustomerForm form) {
        logger.info("启动顾客注册业务逻辑, 商户名: {}", form.getName());

        // 组装 Entity 对象，准备落库
        Customer customer = new Customer();
        customer.setName(form.getName());
        customer.setPrefecture(form.getPrefecture());
        customer.setCity(form.getCity());
        customer.setAddressLine(form.getAddressLine());

        customerMapper.insert(customer);
        logger.info("顾客注册业务流转完毕并已成功落库");
    }

    @Transactional
    public void updateCustomer(Integer id, CustomerForm form) {
        if (customerMapper.findById(id).isEmpty()) throw new BusinessException("该顾客不存在或已被删除！");
        Customer c = new Customer();
        c.setId(id); c.setName(form.getName()); c.setPrefecture(form.getPrefecture());
        c.setCity(form.getCity()); c.setAddressLine(form.getAddressLine());
        customerMapper.update(c);
    }

    @Transactional
    public void deleteCustomer(Integer id) {
        customerMapper.deleteById(id);
    }
}