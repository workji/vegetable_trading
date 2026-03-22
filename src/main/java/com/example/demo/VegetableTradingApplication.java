package com.example.demo;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 青果仲卸管理系统 - 应用程序启动类（入口点）
 * * 【架构解读】
 * @SpringBootApplication 是一个复合注解，包含了三个核心功能：
 * 1. @Configuration: 标记当前类为配置类，Spring容器会将其作为Bean定义的来源。
 * 2. @EnableAutoConfiguration: 开启自动配置，Spring Boot会根据引入的依赖（如MySQL驱动）自动推测并配置系统。
 * 3. @ComponentScan: 自动扫描当前包及其子包下的所有 @Controller, @Service, @Component 组件。
 */
@SpringBootApplication
/*
 * @MapperScan: 告诉 MyBatis 去哪个包下寻找 Mapper 接口。
 * 如果没有这个注解，MyBatis 无法为接口生成动态代理实现类，启动时会报错说找不到 Mapper Bean。
 */
@MapperScan("com.example.demo.feature.*")
public class VegetableTradingApplication {

    /**
     * Java程序的标准入口 main 方法。
     * 调用 SpringApplication.run() 启动内嵌的 Tomcat 服务器，并加载整个 Spring 上下文。
     * @param args 命令行启动参数
     */
    public static void main(String[] args) {
        SpringApplication.run(VegetableTradingApplication.class, args);
    }
}