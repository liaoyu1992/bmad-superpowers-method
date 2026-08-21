---
name: config
description: 配置读写管理技能。统一管理多环境配置（开发/测试/生产），生成配置文件、环境变量模板、配置读取封装。触发场景：用户说"配置管理"、"config"、"环境变量"、"多环境配置"、需要统一管理项目配置时使用。
metadata:
  short-description: 多环境配置统一管理
---

# config — 配置读写管理

> 借鉴 BOSS /boss-config 机制。统一管理项目配置。

## 执行步骤

### 步骤 1：识别配置项

从 `tech-spec.md` 中提取所有需要配置的参数：
- 数据库连接
- API 端口
- 第三方服务密钥
- 功能开关
- 环境特定参数

### 步骤 2：生成配置文件

按环境分层生成：

```
config/
├── default.json       # 默认配置（公共部分）
├── development.json   # 开发环境覆盖
├── test.json          # 测试环境覆盖
├── production.json    # 生产环境覆盖（不含敏感值）
└── index.ts           # 配置读取封装
```

### 步骤 3：生成环境变量模板

```env
# .env.example（提交到版本控制）
NODE_ENV=development
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
REDIS_URL=redis://localhost:6379
JWT_SECRET=your-secret-key
API_PORT=3000

# 生产环境通过 CI/CD 注入，不写入文件
```

### 步骤 4：生成配置读取封装

封装配置读取逻辑，支持：
- 环境变量优先级高于配置文件
- 类型校验（启动时验证必需配置是否存在）
- 敏感信息脱敏（日志中不输出密码/密钥）

### 步骤 5：验证配置完整性

生成配置后自动检查：
- 每个环境（开发/测试/生产）的配置项是否完整
- 环境变量是否都在 `.env.example` 中列出
- 配置读取封装是否能正确处理缺失的必填项
- 敏感信息是否做了脱敏处理

## 安全要求

- **禁止**将真实密码/密钥写入配置文件或 `.env`
- `.env` 必须加入 `.gitignore`
- 生产环境配置通过 CI/CD 环境变量注入
- 配置读取时做类型校验和必需性检查

## 与经验库联动

- 读取 `docs/learning/LEARNING.md` 索引表
- 匹配"配置"触发条件
- 如有新经验，追加到 LEARNING.md 并写入 `docs/learning/entries/`
