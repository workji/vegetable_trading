package com.example.demo.feature.farmer;

import com.example.demo.core.exception.BusinessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 农家管理控制层 (UI Routing)
 * 作用：处理浏览器发起的 HTTP 请求，调用 Service，并将结果返回给 FreeMarker 模板引擎渲染。
 * * @RequestMapping("/farmers"): 统一设置该类下所有路由的 URL 前缀为 /farmers
 */
@Controller
@RequestMapping("/farmers")
public class FarmerController {

    private final FarmerService farmerService;

    public FarmerController(FarmerService farmerService) {
        this.farmerService = farmerService;
    }

    /**
     * 处理 GET 请求：展示农家列表及注册表单
     */
    @GetMapping
    public String list(Model model) {
        // 将数据库查出的列表塞入 Model，前端模板可以用 ${list} 取出
        model.addAttribute("list", farmerService.getAllFarmers());

        // 为了让前端的表单有一个绑定的初始空对象（如果不传，前端访问 form.name 会报错）
        if (!model.containsAttribute("farmerForm")) {
            model.addAttribute("farmerForm", new FarmerForm());
        }
        return "farmer/farmers"; // 渲染 src/main/resources/templates/farmer/farmers.ftlh 页面
    }

    /**
     * 处理 POST 请求：提交表单并保存
     * * @Validated: 触发 FarmerForm 内的 @NotBlank 等校验规则。
     * BindingResult: 存放校验的错题本。
     * 【致命陷阱】：BindingResult 参数必须、必须、必须紧跟在 @Validated 参数的后面！否则 Spring 会直接抛异常中断程序。
     */
    @PostMapping
    public String add(@Validated @ModelAttribute("farmerForm") FarmerForm form,
                      BindingResult bindingResult,
                      Model model) {

        // 1. 如果有输入校验不通过（例如名字没填）
        if (bindingResult.hasErrors()) {
            // 必须重新查询列表塞回 Model，否则带着红字错误回到当前页面时，下方的列表会因为没数据而报错消失。
            model.addAttribute("list", farmerService.getAllFarmers());
            return "farmer/farmers"; // 停留在当前页，前端利用 Spring 标签展示红字错误
        }

        // 2. 校验通过，移交 Service 执行保存
        farmerService.registerFarmer(form);

        // 3. PRG (Post-Redirect-Get) 模式：
        // 保存成功后，强行让浏览器“重定向”到一个新的 GET 请求地址。
        // 如果不这么做，用户按键盘 F5 刷新页面时，会弹出“确认重新提交表单”的提示，导致数据被重复保存两遍。
        return "redirect:/farmers";
    }

    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model) {
        Farmer f = farmerService.getAllFarmers().stream().filter(item -> item.getId().equals(id)).findFirst()
                .orElseThrow(() -> new BusinessException("该数据不存在"));
        FarmerForm form = new FarmerForm();
        form.setId(f.getId()); form.setName(f.getName()); form.setPrefecture(f.getPrefecture());
        form.setCity(f.getCity()); form.setAddressLine(f.getAddressLine()); form.setRank(f.getRank());
        model.addAttribute("farmerForm", form);
        model.addAttribute("list", farmerService.getAllFarmers());
        return "farmer/farmers";
    }

    @PostMapping("/edit/{id}")
    public String update(@PathVariable Integer id, @Validated @ModelAttribute("farmerForm") FarmerForm form, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("list", farmerService.getAllFarmers());
            return "farmer/farmers";
        }
        farmerService.updateFarmer(id, form);
        return "redirect:/farmers";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id) {
        farmerService.deleteFarmer(id);
        return "redirect:/farmers";
    }
}