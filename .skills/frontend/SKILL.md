---
name: frontend
description: 前端 TDD 工程师技能。读取 plan + tech-spec + design-spec + design-system，按 TDD 流程实现前端代码（PC/APP/小程序）。触发场景：流水线阶段四、用户说"前端开发"、"实现前端"、"前端 TDD"、"页面开发"时使用。
metadata:
  short-description: 前端 TDD 实现（PC/APP/小程序）
---

# frontend — 前端 TDD 工程师

> 阶段四技能。按 TDD 流程实现前端功能。

## 执行流程（每个 Step 严格按此顺序）

1. **读取计划**：加载 `docs/plans/plan-NNN-{pc|app|mp}-*.md`（只为实施范围内的平台执行）
2. **读取 Spec**：加载 `design-spec.md`、`tech-spec.md`、`design-system.md` 对应章节
3. **读取原型**：加载 `docs/design/prototypes/` 中对应 HTML 原型
4. **检查平台筛选**：如果 `requirements.md` 有平台筛选，只执行实施范围内的前端计划
5. **依赖检查（codegraph）**：如果要修改已有组件/函数/API 调用，先用 codegraph 查看谁调用了它，评估影响面，避免「改 A 炸 B」
   - 调用前提：IDE 已安装 codegraph MCP 插件
   - 如果是新建文件/组件，跳过此步
6. **定义测试用例**：根据 AC 编写测试用例清单
7. **写测试代码**：先写自动化测试
8. **运行测试 → 红灯**：确认测试失败
9. **写实现代码**：满足所有最佳实践
10. **运行测试 → 绿灯**：确认测试通过
11. **重构**：优化代码质量，保持测试通过
12. **Mental Model Execution**：追踪 2-3 个场景
13. **质量门禁**：执行 6 道关卡检查
14. **更新计划状态**：将 plan 中对应 Step 标记为 [x] 已完成
15. **自动接力**：当前 Step 完成后自动开始下一个 Step

## 代码要求

- **设计对齐**：组件样式必须使用 `design-system.md` 中定义的变量和规范
- **原型对齐**：页面布局必须与 HTML 原型一致
- **Spec 对齐**：每个文件/组件注释标注对应的 Spec 章节号和 REQ 编号
- **响应式**：按 design-spec 中的断点适配
- **禁止**：占位代码、TODO、未经测试的代码路径

## TDD 红灯验证

写完测试后必须运行并确认失败。如果测试直接通过，说明：
- 测试写错了（检查断言逻辑）
- 或代码已存在（确认是否重复实现）

**禁止跳过红灯阶段。**

## 质量门禁（每完成一个功能模块）

执行 `/quality-gate` 检查 6 道关卡：
1. **编译**：`npm run build` 或 `tsc --noEmit`
2. **Null 安全**：检查所有外部输入（API 响应、用户输入）
3. **API 契约**：前端接口调用与 tech-spec API 定义对齐
4. **事务**：（前端一般无事务，跳过或检查乐观更新逻辑）
5. **并发**：无竞态条件（如 useEffect 依赖项、状态竞态）
6. **错误处理**：所有 API 调用有错误处理和用户提示

## 与上下游技能衔接

| 衔接方向 | 说明 |
|----------|------|
| ← `planner` | 读取 plan-NNN-{pc|app|mp}-*.md 计划文件 |
| ← `architect` | 读取 tech-spec.md 中的 API 定义 |
| ← `designer` | 读取 design-spec.md + design-system.md + 原型 |
| → `test` | TDD 写的测试由 test 技能管理和执行 |
| → `quality-gate` | 功能模块完成后触发质量门禁 |
| → `alignment` | 阶段五代码交由对齐验证 |

## 与经验库联动

- 读取 `docs/learning/LEARNING.md` 索引表
- 匹配"前端"或"TDD"触发条件
- 如有新经验，追加到 LEARNING.md 并写入 `docs/learning/entries/`
