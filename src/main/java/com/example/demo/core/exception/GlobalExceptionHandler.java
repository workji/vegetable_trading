package com.example.demo.core.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.resource.NoResourceFoundException;

/**
 * 全局异常处理器（系统的最后一道防波堤）
 * * 【AOP思想体现】
 * @ControllerAdvice: 这是一个切面（Aspect），它会拦截所有 @Controller 抛出的异常。
 * 这样就无需在每个 Controller 的每个方法里写丑陋的 try-catch 代码块，实现了“关注点分离”。
 */
@ControllerAdvice
public class GlobalExceptionHandler {
    // 引入 SLF4J 日志组件，这是排查生产环境故障的唯一线索。
    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * 【新增】：专门拦截 404 资源未找到异常 (如 favicon.ico 缺失)
     * 将错误级别降为 WARN，且不打印详细堆栈，避免日志污染
     */
    @ExceptionHandler(NoResourceFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND) // 返回 404 状态码
    public String handleNotFoundException(NoResourceFoundException e, Model model) {
        // 仅记录一行警告日志
        logger.warn("请求的静态资源或路径不存在: {}", e.getResourcePath());

        model.addAttribute("errorMessage", "抱歉，您访问的页面或资源不存在 (HTTP 404)。");
        return "error";
    }

    /**
     * 捕获所有未被程序显式处理的 Exception（即系统级崩溃、空指针等）
     * * @param e 捕获到的异常对象
     * @param model 用于向前端页面传递数据的容器
     * @return 错误页面的视图名称（指向 templates/error.ftlh）
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR) // 返回 500 状态码
    public String handleException(Exception e, Model model) {
        // 1. 在服务器后台打印完整的错误堆栈（Stack Trace），供研发排查
        logger.error("系统发生未捕获的严重异常", e);

        // 2. 向前台传递一条模糊的错误信息，绝对不能把 SQL 错误或代码细节抛给前端（防止黑客攻击）
        model.addAttribute("errorMessage", "系统内部错误，请联系管理员。错误详情: " + e.getMessage());

        // 3. 引导用户进入统一的错误展示页面
        return "error";
    }
}