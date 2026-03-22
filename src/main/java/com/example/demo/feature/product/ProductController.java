package com.example.demo.feature.product;

import com.example.demo.core.exception.BusinessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 品目管理控制层 (Controller)
 * 作用：接收 HTTP 请求，调度 Service 进行处理，并决定向用户展示哪个页面（或重定向）。
 */
@Controller
@RequestMapping("/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    /**
     * HTTP GET: 渲染列表页面和注册表单
     */
    @GetMapping
    public String list(Model model) {
        // 查询数据库中的数据列表，放入 Model 供 FreeMarker 渲染
        model.addAttribute("list", productService.getAllProducts());

        // 【关键防错】：如果不塞入一个空的 ProductForm，前端 FreeMarker 访问表单字段时会报 Null 错误。
        if (!model.containsAttribute("productForm")) {
            model.addAttribute("productForm", new ProductForm());
        }

        // 寻找 src/main/resources/templates/product/products.ftlh 模板
        return "product/products";
    }

    /**
     * HTTP POST: 处理表单提交
     * * @Validated: 触发 Form 中的校验规则。
     * * BindingResult: 存放校验失败的错误信息。它必须【紧挨着】在 @Validated 参数的后面！
     */
    @PostMapping
    public String add(@Validated @ModelAttribute("productForm") ProductForm form,
                      BindingResult bindingResult,
                      Model model) {

        // 【单字段校验失败分支】
        if (bindingResult.hasErrors()) {
            // 注意：因为要打回原来的页面显示红字错误，原来的页面下方还有一个数据列表。
            // 此时必须重新查一次数据库把列表塞回去，否则页面下半截会变成空白或报错。
            model.addAttribute("list", productService.getAllProducts());
            return "product/products";
        }

        // 校验通过，移交核心业务逻辑层
        productService.registerProduct(form);

        // 【PRG 架构模式】: Post - Redirect - Get
        // 成功后强制浏览器发起一次新的 GET 请求跳转到 /products。
        // 这样可以防止用户手欠按 F5 刷新页面导致表单被重复提交两次。
        return "redirect:/products";
    }

    // --- 追加：编辑与删除 ---
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Integer id, Model model) {
        Product p = productService.getAllProducts().stream().filter(item -> item.getId().equals(id)).findFirst()
                .orElseThrow(() -> new BusinessException("该数据不存在"));
        ProductForm form = new ProductForm();
        form.setId(p.getId());
        form.setName(p.getName());
        form.setVariety(p.getVariety());
        form.setStandardUnit(p.getStandardUnit());

        model.addAttribute("productForm", form);
        model.addAttribute("list", productService.getAllProducts());
        return "product/products";
    }

    @PostMapping("/edit/{id}")
    public String update(@PathVariable Integer id, @Validated @ModelAttribute("productForm") ProductForm form, BindingResult result, Model model) {
        if (result.hasErrors()) {
            model.addAttribute("list", productService.getAllProducts());
            return "product/products";
        }
        productService.updateProduct(id, form);
        return "redirect:/products";
    }

    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Integer id) {
        productService.deleteProduct(id);
        return "redirect:/products";
    }
}
