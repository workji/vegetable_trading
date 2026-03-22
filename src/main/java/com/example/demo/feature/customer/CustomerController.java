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
 */
@Controller
@RequestMapping("/customers")
public class CustomerController {

    private final CustomerService customerService;

    public CustomerController(CustomerService customerService) {
        this.customerService = customerService;
    }

    /**
     * 呈现列表页与空表单
     */
    @GetMapping
    public String list(Model model) {
        // 注入数据集合供页面使用
        model.addAttribute("list", customerService.getAllCustomers());

        // 防空指针兜底：初始化一个空表单供 FreeMarker 的 spring 标签绑定
        if (!model.containsAttribute("customerForm")) {
            model.addAttribute("customerForm", new CustomerForm());
        }
        return "customer/customers";
    }

    /**
     * 接收表单 POST 提交
     */
    @PostMapping
    public String add(@Validated @ModelAttribute("customerForm") CustomerForm form,
                      BindingResult bindingResult,
                      Model model) {

        // 【回显设计】如果填错，必须带着刚填的数据和全量列表返回原页面，给用户改正的机会
        if (bindingResult.hasErrors()) {
            model.addAttribute("list", customerService.getAllCustomers());
            return "customer/customers";
        }

        customerService.registerCustomer(form);

        // 【PRG模式】重定向到 GET 请求的路由，清空表单提交状态
        return "redirect:/customers";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model) {
        Customer c = customerService.getAllCustomers().stream().filter(item -> item.getId().equals(id)).findFirst()
                .orElseThrow(() -> new BusinessException("该数据不存在"));
        CustomerForm form = new CustomerForm();
        form.setId(c.getId()); form.setName(c.getName()); form.setPrefecture(c.getPrefecture());
        form.setCity(c.getCity()); form.setAddressLine(c.getAddressLine());
        model.addAttribute("customerForm", form);
        model.addAttribute("list", customerService.getAllCustomers());
        return "customer/customers";
    }

    @PostMapping("/edit/{id}")
    public String update(@PathVariable Integer id, @Validated @ModelAttribute("customerForm") CustomerForm form, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("list", customerService.getAllCustomers());
            return "customer/customers";
        }
        customerService.updateCustomer(id, form);
        return "redirect:/customers";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id) {
        customerService.deleteCustomer(id);
        return "redirect:/customers";
    }
}