---
name: devops
description: 部署与 CI/CD 技能。生成 Dockerfile、CI/CD 配置、部署脚本、环境配置。触发场景：用户说"部署"、"Docker"、"CI/CD"、"发布"、"流水线配置"、"devops"、"环境配置"时使用。
metadata:
  short-description: 部署 + CI/CD + Docker + 环境配置
---

# devops — 部署与 CI/CD

> 借鉴 BOSS /boss-devops 机制。处理部署、CI/CD、环境配置。

## 执行步骤

### 步骤 1：读取技术 Spec

读取 `docs/specs/tech-spec.md` 中的技术栈和部署相关章节。

### 步骤 2：生成部署配置

根据技术栈生成对应配置文件：

| 技术栈 | 产出文件 |
|--------|----------|
| Node.js | `Dockerfile` + `docker-compose.yml` + `.dockerignore` |
| Java | `Dockerfile` + `pom.xml` 部署配置 |
| Python | `Dockerfile` + `requirements.txt` |
| 通用 | `.env.example` + `Makefile` |

### 步骤 3：生成 CI/CD 配置

根据用户选择的 CI/CD 平台生成配置：

| 平台 | 配置文件 |
|------|----------|
| GitHub Actions | `.github/workflows/ci.yml` |
| GitLab CI | `.gitlab-ci.yml` |
| Jenkins | `Jenkinsfile` |

CI/CD 流程包含：
1. **Lint** — 代码风格检查
2. **Build** — 编译构建
3. **Test** — 单元测试 + 集成测试
4. **Quality Gate** — 调用质量门禁检查
5. **Deploy** — 部署（区分测试/预发/生产环境）

### 步骤 4：生成环境配置

```env
# .env.example（禁止写入真实凭据）
NODE_ENV=development
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
API_PORT=3000
```

### 步骤 5：验证部署配置

生成配置后自动检查：
- Dockerfile 是否能 `docker build` 成功（如 Docker 可用）
- `.env.example` 是否包含所有必需环境变量
- CI/CD 配置是否引用了正确的测试命令和门禁检查
- `.gitignore` 是否包含 `.env`、`node_modules/` 等敏感目录

## 安全红线

- **禁止**将真实凭据写入文件
- 凭据从环境变量读取，`.env` 加入 `.gitignore`
- 生产环境配置与开发环境严格隔离
- 部署脚本不包含硬编码 IP/密码

## 与经验库联动

- 读取 `docs/learning/LEARNING.md` 索引表
- 匹配"部署"或"CI/CD"触发条件
- 如有新经验，追加到 LEARNING.md 并写入 `docs/learning/entries/`
