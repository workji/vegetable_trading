package com.example.demo.feature.sale;

import com.example.demo.core.exception.BusinessException;
import com.example.demo.feature.arrival.ArrivalMapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 销售出库控制层 (Controller)
 */
@Controller
@RequestMapping("/sales")
public class SaleController {

    private final SaleService saleService;
    // 注入 ArrivalMapper 用于给前端下拉框提供入库批次选择
    private final ArrivalMapper arrivalMapper;

    public SaleController(SaleService saleService, ArrivalMapper arrivalMapper) {
        this.saleService = saleService;
        this.arrivalMapper = arrivalMapper;
    }

    @GetMapping
    public String list(Model model) {
        model.addAttribute("list", saleService.getAllSales());
        model.addAttribute("arrivals", arrivalMapper.findAll());

        if (!model.containsAttribute("saleForm")) {
            model.addAttribute("saleForm", new SaleForm());
        }
        return "sale/sales";
    }

    @PostMapping
    public String add(@Validated @ModelAttribute("saleForm") SaleForm form,
                      BindingResult result,
                      Model model) {

        // 【回显防白屏处理】如果输入格式错误，必须重新灌入下拉框字典数据
        if (result.hasErrors()) {
            model.addAttribute("list", saleService.getAllSales());
            model.addAttribute("arrivals", arrivalMapper.findAll());
            return "sale/sales";
        }

        try {
            saleService.registerSale(form);
        } catch (BusinessException e) {
            // 捕获业务逻辑风控异常（如库存不足），将错误信息塞入 Model 用于前端警示
            model.addAttribute("businessError", e.getMessage());
            model.addAttribute("list", saleService.getAllSales());
            model.addAttribute("arrivals", arrivalMapper.findAll());
            return "sale/sales";
        }

        // PRG 模式：成功后重定向
        return "redirect:/sales";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model) {
        Sale s = saleService.getAllSales().stream().filter(item -> item.getId().equals(id)).findFirst()
                .orElseThrow(() -> new BusinessException("该出库记录不存在"));
        SaleForm form = new SaleForm();
        form.setId(s.getId()); form.setSaleDate(s.getSaleDate()); form.setCustomerId(s.getCustomerId());
        form.setProductId(s.getProductId()); form.setArrivalId(s.getArrivalId());
        form.setQuantity(s.getQuantity()); form.setUnitPrice(s.getUnitPrice());

        model.addAttribute("saleForm", form);
        model.addAttribute("list", saleService.getAllSales());
        model.addAttribute("arrivals", arrivalMapper.findAll());
        return "sale/sales";
    }

    @PostMapping("/edit/{id}")
    public String update(@PathVariable Integer id, @Validated @ModelAttribute("saleForm") SaleForm form, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("list", saleService.getAllSales());
            model.addAttribute("arrivals", arrivalMapper.findAll());
            return "sale/sales";
        }
        try {
            saleService.updateSale(id, form);
        } catch (BusinessException e) {
            model.addAttribute("businessError", e.getMessage());
            model.addAttribute("list", saleService.getAllSales());
            model.addAttribute("arrivals", arrivalMapper.findAll());
            return "sale/sales";
        }
        return "redirect:/sales";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id) {
        saleService.deleteSale(id);
        return "redirect:/sales";
    }
}