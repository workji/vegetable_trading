package com.example.demo.feature.customer;

import com.example.demo.core.exception.BusinessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 顾客管理控制层 (Controller)
 * 职责：拦截 "/customers" 下的 HTTP 流量，将模型数据交由 FreeMarker 渲染视图。
 * 特性：已集成企业级分页、动态安全排序及编辑状态保持功能。
 */
@Controller
@RequestMapping("/customers")
public class CustomerController {

    private final CustomerService customerService;

    public CustomerController(CustomerService customerService) {
        this.customerService = customerService;
    }

    /**
     * 1. 呈现列表页与新增空表单（支持分页和排序）
     */
    @GetMapping
    public String list(Model model,
                       @RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "id") String sort,
                       @RequestParam(defaultValue = "desc") String dir) {

        // 注入分页和排序后的数据集合供页面使用 (每页设定为 5 条以便测试)
        model.addAllAttributes(customerService.getCustomersPage(page, 10, sort, dir));
        // 防空指针兜底：初始化一个空表单供 FreeMarker 的 spring 标签绑定
        if (!model.containsAttribute("customerForm")) {
            model.addAttribute("customerForm", new CustomerForm());
        }
        return "customer/customers";
    }

    /**
     * 2. 接收新增表单 POST 提交
     */
    @PostMapping
    public String add(@Validated @ModelAttribute("customerForm") CustomerForm form,
                      BindingResult bindingResult,
                      Model model) {

        // 【回显设计】如果填错，必须带着刚填的数据和全量列表返回原页面
        if (bindingResult.hasErrors()) {
            // 发生校验错误时，默认展示第一页的列表数据，防止下方表格白屏
            model.addAllAttributes(customerService.getCustomersPage(1, 10, "id", "desc"));
            return "customer/customers";
        }

        customerService.registerCustomer(form);

        // 【PRG模式】重定向到 GET 请求的路由，清空表单提交状态
        return "redirect:/customers";
    }

    /**
     * 3. 渲染编辑表单（携带分页状态）
     */
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model,
                           @RequestParam(defaultValue = "1") int page,
                           @RequestParam(defaultValue = "id") String sort,
                           @RequestParam(defaultValue = "desc") String dir) {

        // 查找对应数据（生产环境中建议直接使用 customerService.findById 去数据库查）
        Customer c = customerService.getAllCustomers().stream()
                .filter(item -> item.getId().equals(id)).findFirst()
                .orElseThrow(() -> new BusinessException("该数据不存在或已被删除"));

        CustomerForm form = new CustomerForm();
        form.setId(c.getId());
        form.setName(c.getName());
        form.setPrefecture(c.getPrefecture());
        form.setCity(c.getCity());
        form.setAddressLine(c.getAddressLine());

        model.addAttribute("customerForm", form);

        // 核心：保持当前的分页和排序状态，灌入 Model
        model.addAllAttributes(customerService.getCustomersPage(page, 10, sort, dir));
        return "customer/customers";
    }

    /**
     * 4. 保存编辑修改，并精准返回原页面
     */
    @PostMapping("/edit/{id}")
    public String update(@PathVariable Integer id,
                         @Validated @ModelAttribute("customerForm") CustomerForm form,
                         BindingResult result,
                         Model model,
                         @RequestParam(defaultValue = "1") int page,
                         @RequestParam(defaultValue = "id") String sort,
                         @RequestParam(defaultValue = "desc") String dir) {

        if (result.hasErrors()) {
            model.addAllAttributes(customerService.getCustomersPage(page, 10, sort, dir));
            return "customer/customers";
        }

        customerService.updateCustomer(id, form);

        // 【高级架构处理】：修改完成后，拼接参数，精准重定向回用户刚才所在的分页和排序位置
        return String.format("redirect:/customers?page=%d&sort=%s&dir=%s", page, sort, dir);
    }

    /**
     * 5. 物理删除指定数据
     */
    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id) {
        customerService.deleteCustomer(id);
        // 删除后默认返回列表首页
        return "redirect:/customers";
    }
}