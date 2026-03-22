package com.example.demo.core.exception;

/**
 * 业务逻辑异常（表示违反了业务规则的自定义异常类）
 * * 【架构深层原因】
 * 为什么要继承 RuntimeException（非受检异常）而不是 Exception（受检异常）？
 * 答：Spring 的 @Transactional 事务管理，默认情况下**只有在遇到 RuntimeException 时才会触发数据库回滚**。
 * 如果继承 Exception，抛出异常时数据依然会被提交到数据库，造成脏数据。
 */
public class BusinessException extends RuntimeException {

    /**
     * 构造函数
     * @param message 传递给前端展示的、用户友好的错误提示（如："库存不足，无法出库！"）
     */
    public BusinessException(String message) {
        super(message);
    }
}