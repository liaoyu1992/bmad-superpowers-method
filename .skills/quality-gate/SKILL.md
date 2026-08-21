---
name: quality-gate
description: 质量门禁技能。对指定功能模块执行 6 道关卡检查（编译/Null安全/API契约/事务/并发/错误处理），输出门禁报告，给出 PASS/FAIL 裁定。触发场景：功能模块完成后、流水线阶段四每个Step完成后、用户说"质量门禁"、"quality-gate"、"过门禁"时使用。
metadata:
  short-description: 6 道关卡质量检查 → PASS / FAIL
---

# quality-gate — 质量门禁

> 借鉴 BOSS /quality-gate 机制。每个功能模块完成后必须通过 6 道关卡。

## 执行步骤

对指定模块/平台代码执行以下 6 道关卡检查：

### 关卡 1：编译

```bash
# TypeScript 项目
npx tsc --noEmit
# 或
npm run build
```

**通过标准**：0 error（warning 可接受但需记录）

### 关卡 2：Null 安全

检查所有外部输入是否有空值处理：
- API 请求参数（query, body, params）
- 数据库查询结果
- 外部 API 响应
- 用户输入

**通过标准**：无未处理的 null/undefined 风险

### 关卡 3：API 契约

对比代码中的接口定义与 `tech-spec.md` 中的 API 定义：
- 路径、方法（GET/POST/...）是否一致？
- 请求参数（字段名、类型、是否必填）是否一致？
- 响应结构（字段名、类型、嵌套结构）是否一致？
- 状态码是否一致？

**通过标准**：100% 对齐

### 关卡 4：事务

检查所有数据库写操作：
- INSERT / UPDATE / DELETE 是否在事务内？
- 多表操作是否在同一事务内？
- 事务是否正确提交/回滚？

**通过标准**：所有写操作有事务包裹（前端项目可跳过此关）

### 关卡 5：并发

检查竞态条件：
- 共享状态是否有保护？
- 异步操作是否有竞态风险？（如 useEffect 中的异步操作）
- 数据库操作是否有乐观锁/悲观锁？

**通过标准**：无竞态条件

### 关卡 6：错误处理

检查异常处理：
- 是否有未捕获的异常？
- 是否有静默吞错？（catch 后不处理）
- 错误是否快速失败？
- 用户是否有错误反馈？

**通过标准**：无未捕获异常，不静默吞错

## 报告格式

生成 `docs/reports/quality-gate-NNN.md`：

```markdown
# 质量门禁报告 quality-gate-001

## 模块：后端 - 用户认证
## 裁定：FAIL

| 关卡 | 检查内容 | 状态 | 详情 |
|------|----------|------|------|
| 编译 | tsc --noEmit | ✅ PASS | 0 error |
| Null 安全 | 外部输入检查 | ❌ FAIL | src/api/auth.ts:42 未检查 email 为空 |
| API 契约 | 与 tech-spec 对齐 | ✅ PASS | 全部对齐 |
| 事务 | 写操作事务包裹 | ❌ FAIL | src/models/user.ts:78 INSERT 无事务 |
| 并发 | 竞态条件 | ✅ PASS | 无竞态风险 |
| 错误处理 | 异常处理 | ⚠️ WARN | src/api/auth.ts:100 catch 块只 console.log |

## 失败项详情

### Null 安全 - src/api/auth.ts:42
- **问题**：email 参数未做空值检查
- **修复建议**：在函数入口添加 `if (!email) throw new Error('email is required')`

### 事务 - src/models/user.ts:78
- **问题**：用户注册 INSERT 未包裹在事务中
- **修复建议**：使用 `db.transaction(async () => { ... })`
```

## 裁定标准

- **PASS**：6 道关卡全部 PASS（WARN 可接受但需记录）
- **FAIL**：任意关卡 FAIL

FAIL 时自动触发 `/loop` 技能进入修复循环。

## 平台筛选检查

- 读取 `requirements.md` 头部的"本次实施范围"
- 只检查实施范围内的平台代码
- 排除平台的代码不检查

## 与经验库联动

- 读取 `docs/learning/LEARNING.md` 索引表
- 匹配"质量门禁"触发条件
- 如有新经验，追加到 LEARNING.md 并写入 `docs/learning/entries/`
