# 药品查询系统 - Vue3 + Spring Boot 版本

这是一个基于 Vue3 + Spring Boot + MySQL 技术栈重构的药品查询系统，复刻了原有 Windows Forms 版本的功能。

## 技术架构

### 前端

- **Vue 3** - 渐进式 JavaScript 框架
- **Vue Router 4** - 官方路由管理器
- **Pinia** - 状态管理工具
- **Element Plus** - UI 组件库
- **Axios** - HTTP 客户端
- **Vite** - 构建工具

### 后端

- **Spring Boot 3.2** - 应用框架
- **Spring Security** - 安全框架
- **MyBatis Plus** - ORM 框架
- **JWT** - 身份认证
- **MySQL 8.0** - 数据库

## 功能模块

### 已实现功能

1. **用户认证**
   - 用户登录/注册
   - JWT Token 认证
   - 角色权限控制
2. **药品查询**
   - 关键词搜索
   - 类别筛选
   - 价格范围筛选
   - 分页展示
   - 药品详情查看
3. **症状查询**
   - 症状输入查询
   - 常见症状快捷选择
   - 推荐药品展示
   - 推荐等级显示
4. **药品排行榜**
   - 销量排行
   - 价格排行
   - 评分排行
5. **药品对比**
   - 双药品对比
   - 多维度对比展示
6. **个人中心**
   - 个人信息查看
   - 资料编辑
   - 密码修改
7. **管理员功能**
   - 功能入口展示
   - 数据统计概览

## 项目结构

```
medicine-system-vue-springboot/
├── backend/                          # Spring Boot 后端
│   ├── src/main/java/com/medicine/
│   │   ├── config/                   # 配置类
│   │   ├── controller/               # 控制器
│   │   ├── dto/                      # 数据传输对象
│   │   ├── entity/                   # 实体类
│   │   ├── mapper/                   # MyBatis Mapper
│   │   ├── service/                  # 业务逻辑层
│   │   ├── utils/                    # 工具类
│   │   └── vo/                       # 视图对象
│   ├── src/main/resources/
│   │   └── application.yml           # 配置文件
│   └── pom.xml                       # Maven 配置
├── frontend/                         # Vue3 前端
│   ├── src/
│   │   ├── api/                      # API 接口
│   │   ├── components/               # 公共组件
│   │   ├── router/                   # 路由配置
│   │   ├── stores/                   # Pinia 状态管理
│   │   ├── utils/                    # 工具函数
│   │   ├── views/                    # 页面视图
│   │   ├── App.vue                   # 根组件
│   │   └── main.js                   # 入口文件
│   ├── index.html
│   ├── package.json
│   └── vite.config.js
├── database/
│   └── init.sql                      # 数据库初始化脚本
└── README.md
```

## 快速开始

### 环境要求

- JDK 17+
- Node.js 18+
- MySQL 8.0+
- Maven 3.6+

### 1. 数据库初始化

```bash
# 登录 MySQL
mysql -u root -p

# 执行初始化脚本
source database/init.sql
```

### 2. 启动后端服务

```bash
cd backend

# 编译项目
mvn clean install

# 运行项目
mvn spring-boot:run
```

后端服务默认运行在 <http://localhost:8080>

### 3. 启动前端服务

```bash
cd frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

前端服务默认运行在 <http://localhost:5173>

### 4. 访问系统

打开浏览器访问 <http://localhost:5173>

测试账号：

- 管理员：admin / admin123
- 普通用户：user1 / user123

## API 接口文档

### 认证接口

- `POST /api/auth/login` - 用户登录
- `POST /api/auth/register` - 用户注册

### 药品接口

- `POST /api/medicine/query` - 查询药品列表
- `GET /api/medicine/{id}` - 获取药品详情
- `GET /api/medicine/categories` - 获取所有类别
- `GET /api/medicine/manufacturers` - 获取所有厂家
- `GET /api/medicine/rankings` - 获取排行榜
- `POST /api/medicine/compare` - 对比药品

### 症状接口

- `GET /api/symptom/all` - 获取所有症状
- `GET /api/symptom/{symptom}` - 根据症状查询药品
- `GET /api/symptom/search` - 模糊搜索症状

## 配置说明

### 后端配置 (application.yml)

```yaml
# 数据库配置
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/medicine_system
    username: root
    password: your_password

# JWT 配置
jwt:
  secret: your_secret_key
  expiration: 86400000  # 24小时
```

### 前端配置 (vite.config.js)

```javascript
server: {
  port: 5173,
  proxy: {
    '/api': {
      target: 'http://localhost:8080',
      changeOrigin: true
    }
  }
}
```

## 功能对比

| 功能     | 原 Windows Forms 版本 | 新 Web 版本 |
| ------ | ------------------ | -------- |
| 用户认证   | ✅                  | ✅        |
| 药品查询   | ✅                  | ✅        |
| 症状查询   | ✅                  | ✅        |
| 排行榜    | ✅                  | ✅        |
| 药品对比   | ✅                  | ✅        |
| 个人中心   | ✅                  | ✅        |
| 管理员功能  | ✅                  | ✅        |
| AI价格查询 | ✅                  | ⏳ (待实现)  |
| 响应式布局  | ❌                  | ✅        |
| 移动端适配  | ❌                  | ✅        |

## 待实现功能

- [ ] AI咨询功能（原AI价格查询）
- [ ] 用户收藏功能
- [ ] 搜索历史记录
- [ ] 药品评价功能
- [ ] 完整的管理员功能
- [ ] 数据导入导出
- [ ] 系统日志记录

## 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 许可证

[MIT](LICENSE)

## 联系方式

如有问题或建议，请联系：[397174604@qq](mailto:medicine@system.com)
