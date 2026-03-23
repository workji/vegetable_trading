package com.example.demo.feature.customer;

import com.example.demo.core.exception.BusinessException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 顾客业务逻辑层 (Service)
 * * 【事务控制】
 * 虽然当前 registerCustomer 只有单条 Insert 操作，但为了未来扩展（如：同时写入日志表、发邮件等），
 * 加上 @Transactional 可以将这些行为绑定为同一个原子操作。
 */
@Service
public class CustomerService {

    private static final Logger logger = LoggerFactory.getLogger(CustomerService.class);
    // --- 追加：防止 SQL 注入的安全白名单 ---
    private static final List<String> VALID_COLUMNS = Arrays.asList("id", "name", "prefecture");

    // final 声明确保不可变，通过构造器完成注入
    private final CustomerMapper customerMapper;

    public CustomerService(CustomerMapper customerMapper) {
        this.customerMapper = customerMapper;
    }

    public List<Customer> getAllCustomers() {
        return customerMapper.findAll();
    }

    public Map<String, Object> getCustomersPage(int page, int size, String sortColumn, String sortDir) {
        // 1. 绝对安全防线：拦截所有非法的列名和排序关键字
        if (!VALID_COLUMNS.contains(sortColumn)) sortColumn = "id";
        if (!"asc".equalsIgnoreCase(sortDir) && !"desc".equalsIgnoreCase(sortDir)) sortDir = "desc";
        if (page < 1) page = 1;

        // 2. 计算物理分页参数
        int offset = (page - 1) * size;
        List<Customer> list = customerMapper.findPage(sortColumn, sortDir, offset, size);
        long total = customerMapper.countAll();

        // 3. 计算总页数 (向上取整)
        int totalPages = (int) Math.ceil((double) total / size);
        if (totalPages == 0) totalPages = 1;

        // 4. 打包返回给前端的上下文
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);               // 当前页的数据列表
        result.put("total", total);             // 总记录数
        result.put("currentPage", page);        // 当前页码
        result.put("totalPages", totalPages);   // 总页数
        result.put("sortColumn", sortColumn);   // 当前排序的列
        result.put("sortDir", sortDir);         // 当前排序的方向 (asc/desc)
        return result;
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