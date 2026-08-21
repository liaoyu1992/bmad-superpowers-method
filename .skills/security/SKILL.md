---
name: security
description: 安全审计技能。对代码进行安全漏洞扫描：SQL注入、XSS、CSRF、敏感信息泄露、依赖漏洞、权限绕过。触发场景：用户说"安全审计"、"security"、"安全检查"、"漏洞扫描"、流水线阶段五安全审查时使用。
metadata:
  short-description: 安全漏洞扫描与审计
---

# security — 安全审计

> 借鉴 BOSS /boss-security 机制。对代码进行安全漏洞扫描。

## 执行步骤

### 步骤 1：静态安全扫描

逐文件扫描代码中的安全漏洞：

| 漏洞类型 | 检查内容 | 检查方法 |
|----------|----------|----------|
| SQL 注入 | 是否使用字符串拼接 SQL？ | grep 搜索 `'SELECT.*\+.*\$\{` 等模式 |
| XSS | 前端是否对用户输入做转义？ | 检查 dangerouslySetInnerHTML / v-html |
| CSRF | 是否有 CSRF Token 校验？ | 检查中间件配置 |
| 敏感信息泄露 | 日志/错误信息是否包含密码？ | 检查 console.log / logger 中的敏感字段 |
| 硬编码密钥 | 代码中是否有 API Key/密码？ | grep 搜索常见密钥模式 |
| 权限绕过 | API 是否有权限校验？ | 检查路由中间件 |
| 依赖漏洞 | 第三方库是否有已知 CVE？ | 运行 `npm audit` / `pip audit` |

### 步骤 2：生成安全审计报告

写入 `docs/reports/security-audit-NNN.md`：

```markdown
# 安全审计报告 security-audit-001

## 裁定：FAIL

## 漏洞清单

| # | 严重程度 | 类型 | 文件:行号 | 漏洞描述 | 修复建议 |
| 1 | P0 | SQL注入 | src/api/user.ts:42 | 拼接 SQL 字符串 | 使用参数化查询 |
| 2 | P1 | 硬编码密钥 | src/config/db.ts:15 | 密码明文 | 从环境变量读取 |
| 3 | P2 | XSS | src/components/Comment.tsx:20 | 未转义用户输入 | 使用 DOMPurify |

## 依赖漏洞
| 包名 | 版本 | CVE | 严重程度 | 修复版本 |
| lodash | 4.17.15 | CVE-2021-23337 | HIGH | 4.17.21 |
```

## 裁定标准

- **PASS**：无 P0/P1 漏洞，无 HIGH 级别依赖漏洞
- **FAIL**：有 P0/P1 漏洞或 HIGH 级别依赖漏洞

FAIL 时自动触发 `/loop` 进入修复循环。

## 安全红线

1. **禁止**硬编码密码/API Key/Token
2. **禁止**拼接 SQL 字符串
3. **禁止**在前端代码中存储敏感信息
4. **禁止**在日志中输出用户密码/Token
5. **禁止**在生产环境中开启 CORS `*`

## 与经验库联动

- 读取 `docs/learning/LEARNING.md` 索引表
- 匹配"安全"或"漏洞"触发条件
- 如有新经验，追加到 LEARNING.md 并写入 `docs/learning/entries/`
