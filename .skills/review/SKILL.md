---
name: review
description: 代码审查技能。审查代码与 Spec（requirements/tech-spec/design-spec）的合规性，输出审查报告，给出 APPROVE/REQUEST CHANGES/BLOCK 裁定。支持平台筛选（只检查实施范围内的代码）。触发场景：流水线阶段五、用户说"代码审查"、"review"、"审查合规性"时使用。
metadata:
  short-description: Spec 合规性审查 → APPROVE / REQUEST CHANGES / BLOCK
---

# review — 代码审查（Spec 合规性）

> 阶段五技能。独立质量审查，只为用户工作。

## 执行步骤

1. **读取所有 Spec**：`requirements.md` + `tech-spec.md` + `design-spec.md`
2. **检查平台筛选**：读取 `requirements.md` 头部的"本次实施范围"，只检查实施范围内的平台代码
3. **读取代码**：按模块/平台逐文件审查
4. **逐条对齐**：Spec 条目 ←→ 代码实现
5. **生成报告**：`docs/reports/review-NNN.md`
6. **加载经验库**：读取 `docs/learning/LEARNING.md`，匹配"代码审查"触发条件

## 审查维度

### 1. Spec 对齐

- 每个 REQ 是否在代码中有对应实现？
- 代码中是否有 Spec 未提及的功能？（YAGNI 违规）
- API 实现（字段、类型、校验规则）是否与 tech-spec 逐字段对齐？
- 前端组件（Props、样式、交互）是否与 design-spec 对齐？

### 2. 代码质量

- 错误处理是否完整？（无未捕获异常、无静默吞错）
- Null 安全？（外部输入有空值检查）
- 事务完整性？（数据库写操作有事务包裹）
- 并发安全？（无竞态条件）

### 3. 平台覆盖

- 实施范围内的后端 REQ 是否在后端代码中实现？
- 实施范围内的 PC REQ 是否在 PC 代码中实现？
- 实施范围内的 APP REQ 是否在 APP 代码中实现？
- 跨平台 REQ 是否在所有相关平台中实现？
- 排除平台的代码不检查

## MCP 工具协作

当需要分析跨模块依赖关系时，可调用 **codegraph** MCP 工具：
- 检查"改 A 炸 B"风险：修改某函数前，先用 codegraph 查看谁调用了它
- 审查跨模块影响面：分析接口变更的级联影响
- 调用前提：IDE 已安装 codegraph MCP 插件

## 报告格式

```markdown
# 代码审查报告 review-001

## 裁定：REQUEST CHANGES

## 审查范围
- 后端：src/api/auth.ts, src/models/user.ts
- PC：src/pages/Login.tsx
- APP：src/pages/MobileLogin.tsx

## Spec 对齐情况
| REQ 编号 | Spec 要求 | 代码位置 | 状态 |
|----------|----------|----------|------|
| REQ-BE-001 | 用户注册 API | src/api/auth.ts:15 | ✅ 对齐 |
| REQ-BE-002 | 邮箱校验 | src/validators/email.ts:8 | ⚠️ 缺少空值检查 |

## YAGNI 违规
- src/api/extra.ts:1 — "积分系统" 在 Spec 中未提及，应删除

## 问题清单
| # | 严重程度 | 文件:行号 | 问题 | 修复建议 |
| 1 | P1 | src/api/auth.ts:42 | 缺少事务包裹 | 添加 transaction() |
```

## 裁定标准

- **APPROVE**：所有 Spec 对齐，无 P0/P1 问题
- **REQUEST CHANGES**：有 P1/P2 问题，需修改后重新审查
- **BLOCK**：有 P0 问题或 Spec 严重偏离

REQUEST CHANGES 或 BLOCK 时自动触发 `/loop` 技能进入修复循环。
