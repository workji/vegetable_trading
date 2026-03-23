package com.example.demo.feature.farmer;

import com.example.demo.core.exception.BusinessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/farmers")
public class FarmerController {

    private final FarmerService farmerService;
    public FarmerController(FarmerService farmerService) { this.farmerService = farmerService; }

    // 1. 独立的一览页面 (带检索和分页，每页10条)
    @GetMapping
    public String list(Model model,
                       @RequestParam(required = false) String searchName,
                       @RequestParam(required = false) String searchRank,
                       @RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "id") String sort,
                       @RequestParam(defaultValue = "desc") String dir) {
        model.addAllAttributes(farmerService.getFarmersPage(searchName, searchRank, page, 10, sort, dir));
        return "farmer/farmers";
    }

    // 2. 独立的新增表单页
    @GetMapping("/add")
    public String addForm(Model model) {
        model.addAttribute("farmerForm", new FarmerForm());
        return "farmer/farmer_form";
    }

    @PostMapping("/add")
    public String add(@Validated @ModelAttribute("farmerForm") FarmerForm form, BindingResult result) {
        if (result.hasErrors()) return "farmer/farmer_form";
        farmerService.registerFarmer(form);
        return "redirect:/farmers";
    }

    // 3. 独立的编辑表单页 (携带列表状态)
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model,
                           @RequestParam(required = false) String searchName,
                           @RequestParam(required = false) String searchRank,
                           @RequestParam(defaultValue = "1") int page,
                           @RequestParam(defaultValue = "id") String sort,
                           @RequestParam(defaultValue = "desc") String dir) {
        Farmer f = farmerService.getAllFarmers().stream().filter(item -> item.getId().equals(id)).findFirst()
                .orElseThrow(() -> new BusinessException("数据不存在"));
        FarmerForm form = new FarmerForm();
        form.setId(f.getId()); form.setName(f.getName()); form.setPrefecture(f.getPrefecture());
        form.setCity(f.getCity()); form.setAddressLine(f.getAddressLine()); form.setRank(f.getRank());

        model.addAttribute("farmerForm", form);
        // 缓存列表状态用于页面返回
        model.addAttribute("page", page); model.addAttribute("sort", sort); model.addAttribute("dir", dir);
        model.addAttribute("searchName", searchName); model.addAttribute("searchRank", searchRank);
        return "farmer/farmer_form";
    }

    @PostMapping("/edit/{id}")
    public String update(@PathVariable Integer id, @Validated @ModelAttribute("farmerForm") FarmerForm form, BindingResult result, Model model,
                         @RequestParam(required = false) String searchName, @RequestParam(required = false) String searchRank,
                         @RequestParam(defaultValue = "1") int page, @RequestParam(defaultValue = "id") String sort, @RequestParam(defaultValue = "desc") String dir) {
        if (result.hasErrors()) {
            model.addAttribute("page", page); model.addAttribute("sort", sort); model.addAttribute("dir", dir);
            model.addAttribute("searchName", searchName); model.addAttribute("searchRank", searchRank);
            return "farmer/farmer_form";
        }
        farmerService.updateFarmer(id, form);

        // 动态构建包含 null 判断的重定向 URL
        StringBuilder redirectUrl = new StringBuilder(String.format("redirect:/farmers?page=%d&sort=%s&dir=%s", page, sort, dir));
        if (searchName != null && !searchName.isEmpty()) redirectUrl.append("&searchName=").append(searchName);
        if (searchRank != null && !searchRank.isEmpty()) redirectUrl.append("&searchRank=").append(searchRank);
        return redirectUrl.toString();
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id) {
        farmerService.deleteFarmer(id);
        return "redirect:/farmers";
    }
}