---
name: planner
description: 任务计划师技能。读取 tech-spec + design-spec + requirements，按平台拆解为原子化任务计划文件 plan-NNN-platform-*.md。支持平台筛选（只为指定平台生成计划）。触发场景：流水线阶段三、用户说"任务拆解"、"拆计划"、"生成 plan"、"只做APP的计划"时使用。
metadata:
  short-description: 原子化任务计划拆解（支持平台筛选）
---

# planner — 任务计划师

> 阶段三技能。将 Tech Spec 和 Design Spec 拆解为原子化任务计划。

## 执行步骤

### 步骤 0：解析平台筛选

读取 `requirements.md` 头部的"本次实施范围"：
- 如果有平台筛选，只为实施范围内的平台生成计划
- 如果没有平台筛选，为所有平台生成计划

### 步骤 1：读取 Spec

读取以下文件：
1. `docs/specs/tech-spec.md`
2. `docs/specs/design-spec.md`
3. `docs/specs/requirements.md`

### 步骤 2：按平台拆解

按 **平台 + 功能模块** 拆解为多个计划文件，写入 `docs/plans/`。

**平台筛选**：只为实施范围内的平台生成计划文件。

## 原子化原则

- 每个计划不超过 5 个步骤；超出则拆分为多个计划
- 每个步骤在 2～5 分钟内可完成
- 严格遵循 YAGNI，不添加 Spec 未提及的功能
- 文件名格式：`plan-NNN-{平台}-{功能名}.md`
- 按平台分组：后端计划优先于前端计划

## 每个步骤必须包含

- ▸ 目标文件路径（精确到文件名）
- ▸ 要完成的具体代码描述（禁止 TBD/TODO/占位符）
- ▸ 验证命令（单元测试命令或手动检查步骤）
- ▸ 引用的 Spec 章节（如 "对应 tech-spec §4.2.3"）
- ▸ 引用的 REQ 编号（如 "对应 REQ-BE-001, AC-BE-001-01"）

## 计划文件模板

```markdown
# 实施计划：plan-001-backend-user-api

> 平台：后端（Backend）
> 依赖：无
> 对应 Spec：tech-spec §4.2 / design-spec §3.1 / requirements REQ-BE-001
> 状态：[ ] 待执行 → [ ] 进行中 → [x] 已完成

## Step 1: 创建 User 数据模型
- **目标文件**：`src/models/user.ts`
- **操作**：创建 User 数据模型
- **验证**：`npm test -- --grep "User model"`
- **Spec 引用**：tech-spec §4.2.1, REQ-BE-001, AC-BE-001-01
```

## 依赖关系标注

每个计划文件必须在头部标注依赖：
- `依赖：无` — 无前置依赖，可立即执行
- `依赖：plan-001-backend-user-api` — 必须等 plan-001 完成后才能执行
- 跨平台依赖：后端 API 计划优先于前端消费计划

## 与经验库联动

- 读取 `docs/learning/LEARNING.md` 索引表
- 匹配"任务拆解"或"计划"触发条件
- 如有新经验，追加到 LEARNING.md 并写入 `docs/learning/entries/`

## 与上下游技能衔接

| 衔接方向 | 说明 |
|----------|------|
| ← `architect` + `designer` | 读取 tech-spec + design-spec 作为拆解输入 |
| → `backend`/`frontend` | 生成的计划文件供 TDD 实现执行 |

完成后等待人工确认 Gate 3。
