package com.example.demo.feature.arrival;

import com.example.demo.core.exception.BusinessException;
import com.example.demo.feature.farmer.FarmerMapper;
import com.example.demo.feature.product.ProductMapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 入库管理控制层 (Controller)
 * * 【架构职责】负责页面与数据的粘合，尤其是错误发生时的页面“状态恢复”。
 */
@Controller
@RequestMapping("/arrivals")
public class ArrivalController {

    private final ArrivalService arrivalService;
    // 需要注入字典表 Mapper 以供下拉列表展示
    private final FarmerMapper farmerMapper;
    private final ProductMapper productMapper;

    public ArrivalController(ArrivalService arrivalService, FarmerMapper farmerMapper, ProductMapper productMapper) {
        this.arrivalService = arrivalService;
        this.farmerMapper = farmerMapper;
        this.productMapper = productMapper;
    }

    /**
     * 渲染入库主界面（包含上方的注册表单，以及下方的历史记录）
     */
    @GetMapping
    public String list(Model model) {
        // 1. 注入下方的历史流水表数据
        model.addAttribute("list", arrivalService.getAllArrivals());

        // 2. 注入上方表单中 <select> 标签所需的字典数据
        model.addAttribute("farmers", farmerMapper.findAll());
        model.addAttribute("products", productMapper.findAll());

        // 3. 注入防空指针的空表单
        if (!model.containsAttribute("arrivalForm")) {
            model.addAttribute("arrivalForm", new ArrivalForm());
        }
        return "arrival/arrivals";
    }

    /**
     * 接收表单提交并处理
     */
    @PostMapping
    public String add(@Validated @ModelAttribute("arrivalForm") ArrivalForm form,
                      BindingResult result,
                      Model model) {

        // 【经典踩坑点防御：回显状态丢失】
        // 当发生校验错误（如：忘记填数量）被打回原页面时，HTTP 请求并不会走上面的 @GetMapping。
        // 所以我们必须在这里“手工把所有下拉框和列表的数据再查一遍”，否则页面直接白屏报错。
        if (result.hasErrors()) {
            model.addAttribute("list", arrivalService.getAllArrivals());
            model.addAttribute("farmers", farmerMapper.findAll());
            model.addAttribute("products", productMapper.findAll());
            return "arrival/arrivals";
        }

        try {
            arrivalService.registerArrival(form);
        } catch (BusinessException e) {
            // 捕获“农家不存在”之类的自定义业务异常，并以红字显示在表单上方
            model.addAttribute("businessError", e.getMessage());
            // 同样的，报错返回时必须复原页面数据
            model.addAttribute("list", arrivalService.getAllArrivals());
            model.addAttribute("farmers", farmerMapper.findAll());
            model.addAttribute("products", productMapper.findAll());
            return "arrival/arrivals";
        }

        // 【PRG 模式】
        // 保存成功，强行跳转（Redirect）。彻底掐断二次刷新的隐患。
        return "redirect:/arrivals";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model) {
        Arrival a = arrivalService.getAllArrivals().stream().filter(item -> item.getId().equals(id)).findFirst()
                .orElseThrow(() -> new BusinessException("该入库数据不存在"));
        ArrivalForm form = new ArrivalForm();
        form.setId(a.getId()); form.setArrivalDate(a.getArrivalDate()); form.setFarmerId(a.getFarmerId());
        form.setProductId(a.getProductId()); form.setQuantity(a.getQuantity()); form.setUnitPrice(a.getUnitPrice());

        model.addAttribute("arrivalForm", form);
        model.addAttribute("list", arrivalService.getAllArrivals());
        model.addAttribute("farmers", farmerMapper.findAll());
        model.addAttribute("products", productMapper.findAll());
        return "arrival/arrivals";
    }

    @PostMapping("/edit/{id}")
    public String update(@PathVariable Integer id, @Validated @ModelAttribute("arrivalForm") ArrivalForm form, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("list", arrivalService.getAllArrivals());
            model.addAttribute("farmers", farmerMapper.findAll());
            model.addAttribute("products", productMapper.findAll());
            return "arrival/arrivals";
        }
        try {
            arrivalService.updateArrival(id, form);
        } catch (BusinessException e) {
            model.addAttribute("businessError", e.getMessage());
            model.addAttribute("list", arrivalService.getAllArrivals());
            model.addAttribute("farmers", farmerMapper.findAll());
            model.addAttribute("products", productMapper.findAll());
            return "arrival/arrivals";
        }
        return "redirect:/arrivals";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id) {
        arrivalService.deleteArrival(id);
        return "redirect:/arrivals";
    }
}