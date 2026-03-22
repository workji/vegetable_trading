-- =================================================================================
-- 青果仲卸管理系统 - 数据库初始化脚本 (DDL & DML)
-- 修复了 MySQL 8.x 中 RANK 窗口函数保留字冲突的问题
-- =================================================================================

CREATE DATABASE IF NOT EXISTS vegetable_trading DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE vegetable_trading;

DROP TABLE IF EXISTS t_sales;
DROP TABLE IF EXISTS t_arrivals;
DROP TABLE IF EXISTS t_forecasts;
DROP TABLE IF EXISTS m_farmers;
DROP TABLE IF EXISTS m_customers;
DROP TABLE IF EXISTS m_products;

-- 1. 农家主数据表 (m_farmers)
CREATE TABLE m_farmers (
                           id INT AUTO_INCREMENT PRIMARY KEY COMMENT '农家固有ID',
                           name VARCHAR(100) NOT NULL COMMENT '农家名或屋号',
                           prefecture VARCHAR(20) NOT NULL COMMENT '所属都道府县',
                           city VARCHAR(50) NOT NULL COMMENT '市区町村',
                           address_line VARCHAR(200) COMMENT '详细地址',
    -- 【修复核心】RANK 是 MySQL 8.0 的保留字，必须使用反引号包裹
                           `rank` CHAR(1) COMMENT '信任评级（A:非常稳定, B:标准, C:散单临时合作）',
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='农家名册表';

-- 2. 顾客主数据表 (m_customers)
CREATE TABLE m_customers (
                             id INT AUTO_INCREMENT PRIMARY KEY COMMENT '顾客固有ID',
                             name VARCHAR(100) NOT NULL COMMENT '商超或零售店企业名称',
                             prefecture VARCHAR(20) NOT NULL COMMENT '所属都道府县',
                             city VARCHAR(50) NOT NULL COMMENT '市区町村',
                             address_line VARCHAR(200) COMMENT '详细地址',
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='顾客名册表';

-- 3. 蔬菜品目主数据表 (m_products)
CREATE TABLE m_products (
                            id INT AUTO_INCREMENT PRIMARY KEY COMMENT '品目固有ID',
                            name VARCHAR(50) NOT NULL COMMENT '蔬菜种类大类',
                            variety VARCHAR(50) COMMENT '细分品种或品牌',
                            standard_unit VARCHAR(10) COMMENT '基准计量单位',
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='品目字典表';

-- 4. 入库交易表 (t_arrivals)
CREATE TABLE t_arrivals (
                            id INT AUTO_INCREMENT PRIMARY KEY COMMENT '入库流水ID',
                            arrival_date DATE NOT NULL COMMENT '入库日期',
                            farmer_id INT NOT NULL COMMENT '供货农家ID',
                            product_id INT NOT NULL COMMENT '入库品目ID',
                            quantity DECIMAL(10, 2) NOT NULL COMMENT '入库数量',
                            unit_price DECIMAL(10, 2) NOT NULL COMMENT '进货单价',
                            total_price DECIMAL(15, 2) NOT NULL COMMENT '进货总金额',
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='入库流水表';

-- 5. 出库交易表 (t_sales)
CREATE TABLE t_sales (
                         id INT AUTO_INCREMENT PRIMARY KEY COMMENT '出库流水ID',
                         sale_date DATE NOT NULL COMMENT '出库日期',
                         customer_id INT NOT NULL COMMENT '接收顾客ID',
                         product_id INT NOT NULL COMMENT '销售品目ID',
                         quantity DECIMAL(10, 2) NOT NULL COMMENT '出库数量',
                         unit_price DECIMAL(10, 2) NOT NULL COMMENT '销售单价',
                         total_price DECIMAL(15, 2) NOT NULL COMMENT '销售总金额',
                         arrival_id INT NOT NULL COMMENT '关联的入库批次ID',
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='出库流水表';

-- 6. 供需预测表 (t_forecasts)
CREATE TABLE t_forecasts (
                             id INT AUTO_INCREMENT PRIMARY KEY COMMENT '预测记录ID',
                             target_date DATE NOT NULL COMMENT '预测目标日期',
    -- TYPE 也是敏感词汇（虽不是强保留字，但建议包裹）
                             `type` ENUM('SUPPLY', 'DEMAND') NOT NULL COMMENT '预测维度',
                             product_id INT NOT NULL COMMENT '被预测的品目ID',
                             estimated_qty DECIMAL(10, 2) COMMENT '算法预估数量',
                             manual_qty DECIMAL(10, 2) COMMENT '人工核定数量',
                             note TEXT COMMENT '研判依据',
                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商业预测表';


-- ==========================================
-- 初始测试数据
-- ==========================================

-- 注意：这里的 rank 字段同样需要加反引号
INSERT INTO m_farmers (name, prefecture, city, address_line, `rank`) VALUES
                                                                         ('田中农园', '东京都', '葛饰区', '柴又1-2-3', 'A'),
                                                                         ('铃木有机农场', '千叶县', '成田市', '大山大棚 B区', 'A'),
                                                                         ('佐藤果蔬合作社', '埼玉县', '川口市', '西口农场', 'B');

INSERT INTO m_customers (name, prefecture, city, address_line) VALUES
                                                                   ('永旺生鲜(葛饰店)', '东京都', '葛饰区', '青户4-5-6'),
                                                                   ('7-11便利(成田站前)', '千叶县', '成田市', '东町11-1'),
                                                                   ('伊藤洋华堂(川口店)', '埼玉县', '川口市', '荣町3丁目');

INSERT INTO m_products (name, variety, standard_unit) VALUES
                                                          ('卷心菜 (高丽菜)', '爱知早生', '箱'),
                                                          ('番茄', '桃太郎', 'kg'),
                                                          ('白萝卜', '千叶特产', '箱');

INSERT INTO t_arrivals (arrival_date, farmer_id, product_id, quantity, unit_price, total_price) VALUES
                                                                                                    (CURDATE(), 1, 1, 50.00, 1500.00, 75000.00),
                                                                                                    (CURDATE(), 2, 2, 100.00, 350.00, 35000.00);

INSERT INTO t_sales (sale_date, customer_id, product_id, quantity, unit_price, total_price, arrival_id) VALUES
    (CURDATE(), 1, 1, 20.00, 2000.00, 40000.00, 1);

INSERT INTO t_forecasts (target_date, `type`, product_id, estimated_qty, manual_qty, note) VALUES
                                                                                               (DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'SUPPLY', 1, 60.00, 50.00, '台风导致微调'),
                                                                                               (DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'DEMAND', 1, NULL, 80.00, '永旺超市下周特卖');