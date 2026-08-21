---
name: alignment
description: Spec 对齐验证技能。阶段五对齐验证：将代码+测试+Spec 三方对齐，生成交付清单和最终对齐报告，触发经验沉淀。触发场景：流水线阶段五、用户说"对齐验证"、"最终检查"、"交付"时使用。
metadata:
  short-description: 三方对齐验证（代码↔测试↔Spec）
---

# alignment — Spec 对齐验证

> 阶段五技能。代码 + 测试 + Spec 三方对齐验证。

## 执行步骤

1. **读取所有 Spec**：requirements + tech-spec + design-spec
2. **读取所有代码**：按平台/模块读取
3. **读取测试覆盖矩阵**：`docs/reports/test-coverage-matrix.md`
4. **读取审查报告**：`docs/reports/review-*.md`
5. **读取门禁报告**：`docs/reports/quality-gate-*.md`
6. **三方对齐**：REQ ←→ 代码 ←→ 测试
7. **生成对齐报告**：`docs/reports/alignment-NNN.md`
8. **生成交付清单**：`docs/reports/delivery-checklist.md`
9. **经验沉淀**：更新 `docs/learning/LEARNING.md`

## 三方对齐矩阵

```markdown
| REQ 编号 | AC 编号 | 代码位置 | 测试文件 | 测试用例 | 对齐状态 |
|----------|---------|----------|----------|----------|----------|
| REQ-BE-001 | AC-BE-001-01 | src/api/auth.ts:15 | tests/auth.test.ts | "register success" | ✅ 完全对齐 |
| REQ-BE-001 | AC-BE-001-02 | src/api/auth.ts:30 | tests/auth.test.ts | "duplicate email" | ✅ 完全对齐 |
| REQ-PC-001 | AC-PC-001-01 | src/pages/Login.tsx:10 | tests/login.test.tsx | "render login form" | ✅ 完全对齐 |
```

**对齐状态定义**：
- ✅ 完全对齐：REQ → 有代码 → 有测试 → 测试通过
- ⚠️ 部分对齐：REQ → 有代码 → 无测试 或 测试失败
- ❌ 未对齐：REQ → 无代码 或 代码 → 无对应 REQ（YAGNI 违规）

## 交付清单

```markdown
# 交付清单

## Spec 文档
- [x] docs/specs/requirements.md
- [x] docs/specs/tech-spec.md
- [x] docs/specs/design-spec.md

## 代码
- [x] 后端：src/api/, src/models/, src/services/
- [x] PC 端：src/pages/, src/components/
- [x] APP 端：src/pages/mobile/

## 测试
- [x] 单元测试：tests/unit/
- [x] 集成测试：tests/integration/
- [x] E2E 测试：tests/e2e/
- [x] 测试覆盖率：92%

## 报告
- [x] 需求校验报告
- [x] 交叉审问报告
- [x] 代码审查报告
- [x] 质量门禁报告
- [x] 对齐验证报告

## 经验沉淀
- [x] docs/learning/LEARNING.md 已更新
```

## 经验沉淀

任务结束后，将新发现的踩坑/教训写入经验库：
1. 提取关键教训（不是流水账）
2. 写入 `docs/learning/entries/NNN-{关键词}.md`
3. 更新 `docs/learning/LEARNING.md` 索引表

## 平台筛选检查

- 读取 `requirements.md` 头部的"本次实施范围"
- 只对实施范围内的平台做三方对齐
- 排除平台的 REQ 标注"本次不实施"，不纳入对齐矩阵

## 与上下游技能衔接

| 衔接方向 | 说明 |
|----------|------|
| ← `backend`/`frontend` | 读取已完成的代码 |
| ← `test` | 读取测试覆盖矩阵 |
| ← `review`/`security`/`quality-gate` | 读取审查/安全/门禁报告 |
| → `docs/learning/` | 经验沉淀写入经验库 |
