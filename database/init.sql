-- 药品查询系统数据库初始化脚本
-- 数据库: medicine_system

-- 创建数据库
CREATE DATABASE IF NOT EXISTS medicine_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE medicine_system;

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码(加密存储)',
    email VARCHAR(100) UNIQUE COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    role ENUM('GUEST', 'USER', 'ADMIN', 'SUPER_ADMIN') DEFAULT 'USER' COMMENT '角色',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否激活',
    register_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    last_login_date DATETIME COMMENT '最后登录时间',
    real_name VARCHAR(50) COMMENT '真实姓名',
    age INT COMMENT '年龄',
    gender ENUM('MALE', 'FEMALE', 'OTHER') COMMENT '性别',
    medical_history TEXT COMMENT '病史',
    allergies TEXT COMMENT '过敏史',
    address VARCHAR(255) COMMENT '地址',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_username (username),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 药品表
CREATE TABLE IF NOT EXISTS medicines (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '药品ID',
    name VARCHAR(100) NOT NULL COMMENT '药品名称',
    generic_name VARCHAR(100) COMMENT '通用名称',
    english_name VARCHAR(100) COMMENT '英文名',
    manufacturer VARCHAR(200) COMMENT '生产厂家',
    manufacturer_qualification VARCHAR(500) COMMENT '厂家资质',
    description TEXT COMMENT '药品描述',
    indications TEXT COMMENT '适应症',
    usage_method TEXT COMMENT '用法',
    dosage TEXT COMMENT '用量',
    precautions TEXT COMMENT '注意事项',
    side_effects TEXT COMMENT '副作用',
    contraindications TEXT COMMENT '禁忌症',
    allergic_reactions TEXT COMMENT '过敏反应',
    batch_number VARCHAR(50) COMMENT '批号',
    expiry_date DATE COMMENT '有效期',
    specifications VARCHAR(100) COMMENT '规格',
    category VARCHAR(50) COMMENT '类别',
    drug_type VARCHAR(50) COMMENT '药品类型',
    storage_condition VARCHAR(100) COMMENT '储存条件',
    is_prescription TINYINT(1) DEFAULT 0 COMMENT '是否处方药',
    price DECIMAL(10,2) DEFAULT 0.00 COMMENT '价格',
    stock INT DEFAULT 0 COMMENT '库存',
    sales INT DEFAULT 0 COMMENT '销量',
    rating DECIMAL(2,1) DEFAULT 5.0 COMMENT '评分',
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_manufacturer (manufacturer),
    INDEX idx_price (price)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='药品表';

-- 症状映射表
CREATE TABLE IF NOT EXISTS symptom_mappings (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    symptom VARCHAR(100) NOT NULL COMMENT '症状',
    medicine_id BIGINT NOT NULL COMMENT '药品ID',
    recommendation_level INT DEFAULT 1 COMMENT '推荐等级(1-5)',
    description TEXT COMMENT '描述',
    severity ENUM('MILD', 'MODERATE', 'SEVERE') DEFAULT 'MILD' COMMENT '严重程度',
    advice TEXT COMMENT '建议',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE CASCADE,
    INDEX idx_symptom (symptom)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='症状映射表';

-- 用户搜索历史表
CREATE TABLE IF NOT EXISTS search_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    keyword VARCHAR(200) COMMENT '搜索关键词',
    search_type VARCHAR(50) COMMENT '搜索类型',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '搜索时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='搜索历史表';

-- 用户收藏表
CREATE TABLE IF NOT EXISTS user_favorites (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    medicine_id BIGINT NOT NULL COMMENT '药品ID',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_medicine (user_id, medicine_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户收藏表';

-- 药品评价表
CREATE TABLE IF NOT EXISTS reviews (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    medicine_id BIGINT NOT NULL COMMENT '药品ID',
    rating INT NOT NULL COMMENT '评分(1-5)',
    content TEXT COMMENT '评价内容',
    is_anonymous TINYINT(1) DEFAULT 0 COMMENT '是否匿名',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE CASCADE,
    INDEX idx_medicine_id (medicine_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='药品评价表';

-- 药品价格历史表
CREATE TABLE IF NOT EXISTS price_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    medicine_id BIGINT NOT NULL COMMENT '药品ID',
    price DECIMAL(10,2) NOT NULL COMMENT '价格',
    price_change DECIMAL(10,2) DEFAULT 0.00 COMMENT '价格变动',
    change_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '变动日期',
    reason VARCHAR(255) COMMENT '变动原因',
    FOREIGN KEY (medicine_id) REFERENCES medicines(id) ON DELETE CASCADE,
    INDEX idx_medicine_id (medicine_id),
    INDEX idx_change_date (change_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='药品价格历史表';

-- 系统配置表
CREATE TABLE IF NOT EXISTS system_config (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    config_key VARCHAR(100) NOT NULL UNIQUE COMMENT '配置键',
    config_value TEXT COMMENT '配置值',
    description VARCHAR(255) COMMENT '描述',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

-- 插入默认管理员账号 (密码: admin123)
INSERT INTO users (username, password, email, role, is_active, real_name) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', 'admin@medicine.com', 'ADMIN', 1, '系统管理员'),
('user1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', 'user1@medicine.com', 'USER', 1, '测试用户');

-- 插入示例药品数据
INSERT INTO medicines (name, generic_name, english_name, manufacturer, description, indications, usage_method, dosage, precautions, side_effects, contraindications, specifications, category, price, stock, sales, rating) VALUES
('感冒灵颗粒', '感冒灵', 'Ganmaoling Granules', '华润三九医药股份有限公司', '解热镇痛药', '用于感冒引起的头痛、发热、鼻塞、流涕、咽痛等', '口服', '一次1袋，一日3次', '忌烟、酒及辛辣、生冷、油腻食物', '偶见皮疹、荨麻疹、药热及粒细胞减少', '严重肝肾功能不全者禁用', '10g*9袋/盒', '感冒药', 15.50, 500, 1200, 4.5),
('连花清瘟胶囊', '连花清瘟', 'Lianhua Qingwen Capsule', '石家庄以岭药业股份有限公司', '清瘟解毒，宣肺泄热', '用于治疗流行性感冒属热毒袭肺证', '口服', '一次4粒，一日3次', '忌烟、酒及辛辣、生冷、油腻食物', '恶心、呕吐、腹痛、腹泻、腹胀、反胃', '对本品过敏者禁用', '0.35g*24粒/盒', '感冒药', 28.00, 300, 800, 4.3),
('布洛芬缓释胶囊', '布洛芬', 'Ibuprofen Sustained-release Capsules', '中美天津史克制药有限公司', '非甾体抗炎药', '用于缓解轻至中度疼痛如头痛、关节痛、偏头痛、牙痛、肌肉痛、神经痛、痛经', '口服', '一次1粒，一日2次', '本品为对症治疗药，不宜长期或大量使用', '恶心、呕吐、胃烧灼感或轻度消化不良', '对其他非甾体抗炎药过敏者禁用', '0.3g*20粒/盒', '止痛药', 22.80, 400, 1500, 4.6),
('阿莫西林胶囊', '阿莫西林', 'Amoxicillin Capsules', '华北制药股份有限公司', '青霉素类抗生素', '用于敏感菌所致的呼吸道感染、泌尿生殖道感染、皮肤软组织感染等', '口服', '一次0.5g，每6-8小时1次', '青霉素过敏者禁用', '恶心、呕吐、腹泻及假膜性肠炎等', '青霉素过敏及青霉素皮肤试验阳性患者禁用', '0.25g*24粒/盒', '抗生素', 12.50, 600, 2000, 4.4),
('硝苯地平控释片', '硝苯地平', 'Nifedipine Controlled-release Tablets', '拜耳医药保健有限公司', '钙通道阻滞剂', '用于治疗高血压、冠心病、慢性稳定型心绞痛', '口服', '一次30mg，一日1次', '整片吞服，不可咀嚼或掰开服用', '头痛、面部潮红、头晕、心悸', '心源性休克、怀孕20周以内禁用', '30mg*7片/盒', '心血管药', 35.00, 250, 600, 4.2),
('奥美拉唑肠溶胶囊', '奥美拉唑', 'Omeprazole Enteric-coated Capsules', '阿斯利康制药有限公司', '质子泵抑制剂', '用于胃酸过多引起的烧心和反酸症状的短期缓解', '口服', '一次20mg，一日1-2次', '本品为肠溶胶囊，吞服时不可咀嚼', '头痛、腹泻、恶心、呕吐、便秘', '对本品过敏者禁用', '20mg*14粒/盒', '消化系统药', 45.80, 350, 900, 4.5),
('维生素C片', '维生素C', 'Vitamin C Tablets', '石药集团欧意药业有限公司', '维生素类药', '用于预防坏血病，也可用于各种急慢性传染疾病及紫癜等的辅助治疗', '口服', '一次1片，一日3次', '不宜长期过量服用本品', '腹泻、皮肤红而亮、头痛、尿频', '对本品过敏者禁用', '0.1g*100片/瓶', '维生素', 8.90, 800, 3000, 4.7),
('云南白药气雾剂', '云南白药', 'Yunnan Baiyao Aerosol', '云南白药集团股份有限公司', '活血散瘀，消肿止痛', '用于跌打损伤，瘀血肿痛，肌肉酸痛及风湿疼痛', '外用', '一日3-5次', '孕妇禁用', '过敏性药疹', '孕妇禁用', '85g+30g/盒', '外用药', 38.50, 200, 700, 4.6),
('六味地黄丸', '六味地黄丸', 'Liuwei Dihuang Pills', '北京同仁堂股份有限公司', '滋阴补肾', '用于肾阴亏损，头晕耳鸣，腰膝酸软，骨蒸潮热，盗汗遗精', '口服', '一次8丸，一日3次', '忌辛辣食物', '尚不明确', '感冒发热病人不宜服用', '200丸/瓶', '中药', 25.00, 450, 1100, 4.4),
('氯雷他定片', '氯雷他定', 'Loratadine Tablets', '西安杨森制药有限公司', '抗组胺药', '用于缓解过敏性鼻炎有关的症状', '口服', '一次10mg，一日1次', '严重肝功能受损者，剂量减半', '乏力、头痛、嗜睡、口干、胃肠道不适', '对本品过敏者禁用', '10mg*6片/盒', '抗过敏药', 18.60, 380, 850, 4.3);

-- 插入症状映射数据
INSERT INTO symptom_mappings (symptom, medicine_id, recommendation_level, description, severity, advice) VALUES
('感冒', 1, 5, '感冒灵颗粒是治疗感冒的常用药物', 'MILD', '多喝水，注意休息'),
('发烧', 1, 4, '感冒灵颗粒有解热作用', 'MILD', '注意休息，必要时就医'),
('头痛', 3, 5, '布洛芬是缓解头痛的常用药物', 'MILD', '注意休息，避免过度劳累'),
('咳嗽', 2, 5, '连花清瘟胶囊对咳嗽有缓解作用', 'MILD', '多喝水，保持空气湿润'),
('肚子疼', 6, 4, '奥美拉唑可缓解胃酸过多引起的疼痛', 'MILD', '注意饮食，避免辛辣刺激'),
('胃痛', 6, 5, '奥美拉唑是治疗胃痛的常用药物', 'MILD', '规律饮食，避免暴饮暴食'),
('腹泻', 6, 3, '奥美拉唑对胃肠道有保护作用', 'MILD', '注意饮食卫生，补充水分'),
('过敏', 10, 5, '氯雷他定是治疗过敏的常用药物', 'MILD', '避免接触过敏原'),
('鼻炎', 10, 5, '氯雷他定可缓解鼻炎症状', 'MILD', '保持室内空气清新'),
('高血压', 5, 5, '硝苯地平是治疗高血压的常用药物', 'MODERATE', '定期监测血压，遵医嘱服药'),
('跌打损伤', 8, 5, '云南白药是治疗跌打损伤的特效药', 'MILD', '注意休息，避免剧烈运动'),
('肾阴虚', 9, 5, '六味地黄丸是治疗肾阴虚的经典方剂', 'MILD', '注意休息，节制房事');

-- 插入系统配置
INSERT INTO system_config (config_key, config_value, description) VALUES
('system.name', '药品查询系统', '系统名称'),
('system.version', 'v2.0', '系统版本'),
('system.description', '智能药品查询与推荐系统', '系统描述'),
('page.size', '20', '分页大小'),
('upload.max.size', '10485760', '最大上传文件大小(字节)');
