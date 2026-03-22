package com.example.demo.core.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * 根路径调度控制器
 * 解决浏览器访问 "/" 时报 NoResourceFoundException 的问题
 */
@Controller
public class IndexController {

    @GetMapping("/")
    public String index() {
        // 用户访问首页时，默认重定向到“入库管理”画面
        return "redirect:/arrivals";
    }
}