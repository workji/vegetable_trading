package com.example.demo.feature.forecast;

import com.example.demo.core.exception.BusinessException;
import com.example.demo.feature.product.ProductMapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 预测管理控制层 (Controller)
 */
@Controller
@RequestMapping("/forecasts")
public class ForecastController {

    private final ForecastService forecastService;
    // 用于给前端表单提供品目下拉菜单
    private final ProductMapper productMapper;

    public ForecastController(ForecastService forecastService, ProductMapper productMapper) {
        this.forecastService = forecastService;
        this.productMapper = productMapper;
    }

    @GetMapping
    public String list(Model model) {
        // 装载列表记录
        model.addAttribute("list", forecastService.getAllForecasts());
        // 装载下拉框字典
        model.addAttribute("products", productMapper.findAll());

        // 装载空表单，防空指针
        if (!model.containsAttribute("forecastForm")) {
            model.addAttribute("forecastForm", new ForecastForm());
        }
        return "forecast/forecasts";
    }

    @PostMapping
    public String add(@Validated @ModelAttribute("forecastForm") ForecastForm form,
                      BindingResult result,
                      Model model) {

        // 【回显防白屏】校验失败时，务必将字典列表重新塞回，否则前端下拉框将崩溃
        if (result.hasErrors()) {
            model.addAttribute("list", forecastService.getAllForecasts());
            model.addAttribute("products", productMapper.findAll());
            return "forecast/forecasts";
        }

        try {
            forecastService.registerForecast(form);
        } catch (BusinessException e) {
            // 拦截业务异常（如品目突然被删）
            model.addAttribute("businessError", e.getMessage());
            model.addAttribute("list", forecastService.getAllForecasts());
            model.addAttribute("products", productMapper.findAll());
            return "forecast/forecasts";
        }

        // PRG 模式防复刷
        return "redirect:/forecasts";
    }

    // --- 追加：编辑数据时的表单回显逻辑 ---
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model) {
        Forecast f = forecastService.getAllForecasts().stream()
                .filter(item -> item.getId().equals(id)).findFirst()
                .orElseThrow(() -> new BusinessException("该数据不存在"));

        ForecastForm form = new ForecastForm();
        form.setId(f.getId());
        form.setTargetDate(f.getTargetDate());
        form.setType(f.getType());
        form.setProductId(f.getProductId());
        form.setEstimatedQty(f.getEstimatedQty());
        form.setManualQty(f.getManualQty());
        form.setNote(f.getNote());

        model.addAttribute("forecastForm", form);
        model.addAttribute("list", forecastService.getAllForecasts());
        model.addAttribute("products", productMapper.findAll());
        return "forecast/forecasts";
    }

    // --- 追加：保存编辑后的数据 ---
    @PostMapping("/edit/{id}")
    public String update(@PathVariable Integer id, @Validated @ModelAttribute("forecastForm") ForecastForm form,
                         BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("list", forecastService.getAllForecasts());
            model.addAttribute("products", productMapper.findAll());
            return "forecast/forecasts";
        }
        try {
            forecastService.updateForecast(id, form);
        } catch (BusinessException e) {
            model.addAttribute("businessError", e.getMessage());
            model.addAttribute("list", forecastService.getAllForecasts());
            model.addAttribute("products", productMapper.findAll());
            return "forecast/forecasts";
        }
        return "redirect:/forecasts";
    }

    // --- 追加：删除数据 ---
    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id) {
        forecastService.deleteForecast(id);
        return "redirect:/forecasts";
    }
}