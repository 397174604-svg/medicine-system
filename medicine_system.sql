/*
 Navicat Premium Dump SQL

 Source Server         : gen
 Source Server Type    : MySQL
 Source Server Version : 50721 (5.7.21-log)
 Source Host           : localhost:3306
 Source Schema         : medicine_system

 Target Server Type    : MySQL
 Target Server Version : 50721 (5.7.21-log)
 File Encoding         : 65001

 Date: 30/03/2026 09:31:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for medicines
-- ----------------------------
DROP TABLE IF EXISTS `medicines`;
CREATE TABLE `medicines`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '药品ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '药品名称',
  `generic_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '通用名称',
  `english_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '英文名',
  `manufacturer` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '生产厂家',
  `manufacturer_qualification` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '厂家资质',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '药品描述',
  `indications` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '适应症',
  `usage_method` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '用法',
  `dosage` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '用量',
  `precautions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '注意事项',
  `side_effects` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '副作用',
  `contraindications` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '禁忌症',
  `allergic_reactions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '过敏反应',
  `batch_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '批号',
  `expiry_date` date NULL DEFAULT NULL COMMENT '有效期',
  `specifications` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规格',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类别',
  `drug_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '药品类型',
  `storage_condition` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '储存条件',
  `is_prescription` tinyint(1) NULL DEFAULT 0 COMMENT '是否处方药',
  `price` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '价格',
  `stock` int(11) NULL DEFAULT 0 COMMENT '库存',
  `sales` int(11) NULL DEFAULT 0 COMMENT '销量',
  `rating` decimal(2, 1) NULL DEFAULT 5.0 COMMENT '评分',
  `created_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  `update_date` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE,
  INDEX `idx_manufacturer`(`manufacturer`) USING BTREE,
  INDEX `idx_price`(`price`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '药品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of medicines
-- ----------------------------
INSERT INTO `medicines` VALUES (1, '感冒灵颗粒', '感冒灵', 'Ganmaoling Granules', '华润三九医药股份有限公司', NULL, '解热镇痛药', '用于感冒引起的头痛、发热、鼻塞、流涕、咽痛等', '口服', '一次1袋，一日3次', '忌烟、酒及辛辣、生冷、油腻食物', '偶见皮疹、荨麻疹、药热及粒细胞减少', '严重肝肾功能不全者禁用', NULL, NULL, NULL, '10g*9袋/盒', '感冒药', NULL, NULL, 0, 15.50, 500, 1200, 4.5, '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `medicines` VALUES (2, '连花清瘟胶囊', '连花清瘟', 'Lianhua Qingwen Capsule', '石家庄以岭药业股份有限公司', NULL, '清瘟解毒，宣肺泄热', '用于治疗流行性感冒属热毒袭肺证', '口服', '一次4粒，一日3次', '忌烟、酒及辛辣、生冷、油腻食物', '恶心、呕吐、腹痛、腹泻、腹胀、反胃', '对本品过敏者禁用', NULL, NULL, NULL, '0.35g*24粒/盒', '感冒药', NULL, NULL, 0, 28.00, 300, 800, 4.3, '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `medicines` VALUES (3, '布洛芬缓释胶囊', '布洛芬', 'Ibuprofen Sustained-release Capsules', '中美天津史克制药有限公司', NULL, '非甾体抗炎药', '用于缓解轻至中度疼痛如头痛、关节痛、偏头痛、牙痛、肌肉痛、神经痛、痛经', '口服', '一次1粒，一日2次', '本品为对症治疗药，不宜长期或大量使用', '恶心、呕吐、胃烧灼感或轻度消化不良', '对其他非甾体抗炎药过敏者禁用', NULL, NULL, NULL, '0.3g*20粒/盒', '止痛药', NULL, NULL, 0, 22.80, 400, 1500, 4.6, '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `medicines` VALUES (4, '阿莫西林胶囊', '阿莫西林', 'Amoxicillin Capsules', '华北制药股份有限公司', NULL, '青霉素类抗生素', '用于敏感菌所致的呼吸道感染、泌尿生殖道感染、皮肤软组织感染等', '口服', '一次0.5g，每6-8小时1次', '青霉素过敏者禁用', '恶心、呕吐、腹泻及假膜性肠炎等', '青霉素过敏及青霉素皮肤试验阳性患者禁用', NULL, NULL, NULL, '0.25g*24粒/盒', '抗生素', NULL, NULL, 0, 12.50, 600, 2000, 4.4, '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `medicines` VALUES (5, '硝苯地平控释片', '硝苯地平', 'Nifedipine Controlled-release Tablets', '拜耳医药保健有限公司', NULL, '钙通道阻滞剂', '用于治疗高血压、冠心病、慢性稳定型心绞痛', '口服', '一次30mg，一日1次', '整片吞服，不可咀嚼或掰开服用', '头痛、面部潮红、头晕、心悸', '心源性休克、怀孕20周以内禁用', NULL, NULL, NULL, '30mg*7片/盒', '心血管药', NULL, NULL, 0, 35.00, 250, 600, 4.2, '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `medicines` VALUES (6, '奥美拉唑肠溶胶囊', '奥美拉唑', 'Omeprazole Enteric-coated Capsules', '阿斯利康制药有限公司', NULL, '质子泵抑制剂', '用于胃酸过多引起的烧心和反酸症状的短期缓解', '口服', '一次20mg，一日1-2次', '本品为肠溶胶囊，吞服时不可咀嚼', '头痛、腹泻、恶心、呕吐、便秘', '对本品过敏者禁用', NULL, NULL, NULL, '20mg*14粒/盒', '消化系统药', NULL, NULL, 0, 45.80, 350, 900, 4.5, '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `medicines` VALUES (7, '维生素C片', '维生素C', 'Vitamin C Tablets', '石药集团欧意药业有限公司', NULL, '维生素类药', '用于预防坏血病，也可用于各种急慢性传染疾病及紫癜等的辅助治疗', '口服', '一次1片，一日3次', '不宜长期过量服用本品', '腹泻、皮肤红而亮、头痛、尿频', '对本品过敏者禁用', NULL, NULL, NULL, '0.1g*100片/瓶', '维生素', NULL, NULL, 0, 8.90, 800, 3000, 4.7, '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `medicines` VALUES (8, '云南白药气雾剂', '云南白药', 'Yunnan Baiyao Aerosol', '云南白药集团股份有限公司', NULL, '活血散瘀，消肿止痛', '用于跌打损伤，瘀血肿痛，肌肉酸痛及风湿疼痛', '外用', '一日3-5次', '孕妇禁用', '过敏性药疹', '孕妇禁用', NULL, NULL, NULL, '85g+30g/盒', '外用药', NULL, NULL, 0, 38.50, 200, 700, 4.6, '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `medicines` VALUES (9, '六味地黄丸', '六味地黄丸', 'Liuwei Dihuang Pills', '北京同仁堂股份有限公司', NULL, '滋阴补肾', '用于肾阴亏损，头晕耳鸣，腰膝酸软，骨蒸潮热，盗汗遗精', '口服', '一次8丸，一日3次', '忌辛辣食物', '尚不明确', '感冒发热病人不宜服用', NULL, NULL, NULL, '200丸/瓶', '中药', NULL, NULL, 0, 25.00, 450, 1100, 4.4, '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `medicines` VALUES (10, '氯雷他定片', '氯雷他定', 'Loratadine Tablets', '西安杨森制药有限公司', NULL, '抗组胺药', '用于缓解过敏性鼻炎有关的症状', '口服', '一次10mg，一日1次', '严重肝功能受损者，剂量减半', '乏力、头痛、嗜睡、口干、胃肠道不适', '对本品过敏者禁用', NULL, NULL, NULL, '10mg*6片/盒', '抗过敏药', NULL, NULL, 0, 18.60, 380, 850, 4.3, '2026-03-29 17:30:55', '2026-03-29 17:30:55');

-- ----------------------------
-- Table structure for price_history
-- ----------------------------
DROP TABLE IF EXISTS `price_history`;
CREATE TABLE `price_history`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `medicine_id` bigint(20) NOT NULL COMMENT '药品ID',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `price_change` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '价格变动',
  `change_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '变动日期',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '变动原因',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_medicine_id`(`medicine_id`) USING BTREE,
  INDEX `idx_change_date`(`change_date`) USING BTREE,
  CONSTRAINT `price_history_ibfk_1` FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '药品价格历史表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of price_history
-- ----------------------------

-- ----------------------------
-- Table structure for reviews
-- ----------------------------
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `medicine_id` bigint(20) NOT NULL COMMENT '药品ID',
  `rating` int(11) NOT NULL COMMENT '评分(1-5)',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '评价内容',
  `is_anonymous` tinyint(1) NULL DEFAULT 0 COMMENT '是否匿名',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_medicine_id`(`medicine_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '药品评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reviews
-- ----------------------------

-- ----------------------------
-- Table structure for search_history
-- ----------------------------
DROP TABLE IF EXISTS `search_history`;
CREATE TABLE `search_history`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `keyword` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '搜索关键词',
  `search_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '搜索类型',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '搜索时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_created_at`(`created_at`) USING BTREE,
  CONSTRAINT `search_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '搜索历史表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of search_history
-- ----------------------------

-- ----------------------------
-- Table structure for symptom_mappings
-- ----------------------------
DROP TABLE IF EXISTS `symptom_mappings`;
CREATE TABLE `symptom_mappings`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `symptom` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '症状',
  `medicine_id` bigint(20) NOT NULL COMMENT '药品ID',
  `recommendation_level` int(11) NULL DEFAULT 1 COMMENT '推荐等级(1-5)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '描述',
  `severity` enum('MILD','MODERATE','SEVERE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'MILD' COMMENT '严重程度',
  `advice` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '建议',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `medicine_id`(`medicine_id`) USING BTREE,
  INDEX `idx_symptom`(`symptom`) USING BTREE,
  CONSTRAINT `symptom_mappings_ibfk_1` FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '症状映射表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of symptom_mappings
-- ----------------------------
INSERT INTO `symptom_mappings` VALUES (1, '感冒', 1, 5, '感冒灵颗粒是治疗感冒的常用药物', 'MILD', '多喝水，注意休息', '2026-03-29 17:30:55');
INSERT INTO `symptom_mappings` VALUES (2, '发烧', 1, 4, '感冒灵颗粒有解热作用', 'MILD', '注意休息，必要时就医', '2026-03-29 17:30:55');
INSERT INTO `symptom_mappings` VALUES (3, '头痛', 3, 5, '布洛芬是缓解头痛的常用药物', 'MILD', '注意休息，避免过度劳累', '2026-03-29 17:30:55');
INSERT INTO `symptom_mappings` VALUES (4, '咳嗽', 2, 5, '连花清瘟胶囊对咳嗽有缓解作用', 'MILD', '多喝水，保持空气湿润', '2026-03-29 17:30:55');
INSERT INTO `symptom_mappings` VALUES (5, '肚子疼', 6, 4, '奥美拉唑可缓解胃酸过多引起的疼痛', 'MILD', '注意饮食，避免辛辣刺激', '2026-03-29 17:30:55');
INSERT INTO `symptom_mappings` VALUES (6, '胃痛', 6, 5, '奥美拉唑是治疗胃痛的常用药物', 'MILD', '规律饮食，避免暴饮暴食', '2026-03-29 17:30:55');
INSERT INTO `symptom_mappings` VALUES (7, '腹泻', 6, 3, '奥美拉唑对胃肠道有保护作用', 'MILD', '注意饮食卫生，补充水分', '2026-03-29 17:30:55');
INSERT INTO `symptom_mappings` VALUES (8, '过敏', 10, 5, '氯雷他定是治疗过敏的常用药物', 'MILD', '避免接触过敏原', '2026-03-29 17:30:55');
INSERT INTO `symptom_mappings` VALUES (9, '鼻炎', 10, 5, '氯雷他定可缓解鼻炎症状', 'MILD', '保持室内空气清新', '2026-03-29 17:30:55');
INSERT INTO `symptom_mappings` VALUES (10, '高血压', 5, 5, '硝苯地平是治疗高血压的常用药物', 'MODERATE', '定期监测血压，遵医嘱服药', '2026-03-29 17:30:55');
INSERT INTO `symptom_mappings` VALUES (11, '跌打损伤', 8, 5, '云南白药是治疗跌打损伤的特效药', 'MILD', '注意休息，避免剧烈运动', '2026-03-29 17:30:55');
INSERT INTO `symptom_mappings` VALUES (12, '肾阴虚', 9, 5, '六味地黄丸是治疗肾阴虚的经典方剂', 'MILD', '注意休息，节制房事', '2026-03-29 17:30:55');

-- ----------------------------
-- Table structure for system_config
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '配置值',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `config_key`(`config_key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_config
-- ----------------------------
INSERT INTO `system_config` VALUES (1, 'system.name', '药品查询系统', '系统名称', '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `system_config` VALUES (2, 'system.version', 'v2.0', '系统版本', '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `system_config` VALUES (3, 'system.description', '智能药品查询与推荐系统', '系统描述', '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `system_config` VALUES (4, 'page.size', '20', '分页大小', '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `system_config` VALUES (5, 'upload.max.size', '10485760', '最大上传文件大小(字节)', '2026-03-29 17:30:55', '2026-03-29 17:30:55');

-- ----------------------------
-- Table structure for user_favorites
-- ----------------------------
DROP TABLE IF EXISTS `user_favorites`;
CREATE TABLE `user_favorites`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `medicine_id` bigint(20) NOT NULL COMMENT '药品ID',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_medicine`(`user_id`, `medicine_id`) USING BTREE,
  INDEX `medicine_id`(`medicine_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `user_favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_favorites_ibfk_2` FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_favorites
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码(加密存储)',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `role` enum('GUEST','USER','ADMIN','SUPER_ADMIN') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'USER' COMMENT '角色',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否激活',
  `register_date` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `last_login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `age` int(11) NULL DEFAULT NULL COMMENT '年龄',
  `gender` enum('MALE','FEMALE','OTHER') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '性别',
  `medical_history` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '病史',
  `allergies` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '过敏史',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE,
  INDEX `idx_username`(`username`) USING BTREE,
  INDEX `idx_role`(`role`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', 'admin@medicine.com', NULL, 'ADMIN', 1, '2026-03-29 17:30:55', NULL, '系统管理员', NULL, NULL, NULL, NULL, NULL, '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `users` VALUES (2, 'user1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', 'user1@medicine.com', NULL, 'USER', 1, '2026-03-29 17:30:55', NULL, '测试用户', NULL, NULL, NULL, NULL, NULL, '2026-03-29 17:30:55', '2026-03-29 17:30:55');
INSERT INTO `users` VALUES (5, 'gengen', '$2a$10$ikeNxUOO3v5Y8aQktUkTU.vzuDoxgJ1O92.dTWDH98oApJtwToaoG', '397174604@qq.com', '13784085090', 'ADMIN', 1, '2026-03-29 17:44:52', '2026-03-29 23:24:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-29 17:49:47');

SET FOREIGN_KEY_CHECKS = 1;
