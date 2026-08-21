---
name: designer
description: UI/UX 设计师技能。读取 requirements.md + tech-spec.md，生成 design-system.md（色彩/排版/间距/组件规范）、HTML 原型、design-spec.md。触发场景：流水线阶段二、用户说"设计规范"、"生成原型"、"设计 Spec"时使用。
metadata:
  short-description: 生成设计规范 + 原型 + 设计 Spec
---

# designer — UI/UX 设计师

> 阶段二技能。产出设计规范、原型、设计 Spec。

## 执行步骤（按顺序自动执行）

### 步骤 1：生成设计规范

读取 `requirements.md` + `tech-spec.md`，生成 `docs/design/design-system.md`。

产出：
- 色彩系统（主色、辅助色、语义色，含 HEX/RGB 值）
- 排版系统（字体族、字号梯度、行高、字重）
- 间距系统（基准间距单位和梯度）
- 组件规范（按钮、输入框、卡片、导航等核心组件的状态与样式）
- **按平台区分**设计规范（PC 和 APP 的规范可能不同）
- 响应式断点定义
- 暗色/亮色模式（如适用）

### 步骤 2：生成设计原型

基于 `requirements.md` + `tech-spec.md` + `design-system.md`，为每个核心页面生成 HTML 原型。

产出：
- 文件名格式：`{平台}-{页面名}.html`（如 `pc-login.html`, `app-home.html`）
- 内联 CSS（使用 design-system.md 中定义的样式变量）
- 展示完整的页面布局和组件排布
- 包含交互状态演示（hover、active、disabled 等）
- 使用真实数据的占位内容（非 lorem ipsum）
- 每个原型标注对应的 REQ 编号

### 步骤 3：生成设计 Spec

读取 `requirements.md` + `tech-spec.md` + `design-system.md`，生成 `docs/specs/design-spec.md`。

产出：
- **按平台分区**（后端 API 规格 / PC 页面规格 / APP 页面规格）
- 页面规格：布局结构、组件构成、数据展示规则
- 组件规格：Props、状态、事件、样式约束
- 交互逻辑：用户操作流程、状态流转图、异常处理展示规则
- 响应式适配：各断点下的布局变化
- **每条与 requirements.md 中的验收标准逐条对应**
- 每个 design-spec 条目标注对应的 REQ 编号

### 步骤 4：自动校验

生成 `docs/reports/design-validation-001.md`，检查：
1. 每个 REQ 是否在 design-spec 中有对应设计？
2. 原型文件是否覆盖了所有需要界面的平台页面？

### 步骤 5：加载经验库

- 读取 `docs/learning/LEARNING.md` 索引表
- 匹配"设计规范"或"原型"触发条件
- 如有新经验，追加到 LEARNING.md 并写入 `docs/learning/entries/`

## 与上下游技能衔接

| 衔接方向 | 说明 |
|----------|------|
| ← `architect` | 读取 tech-spec 中的技术栈和平台方案 |
| → `planner` | design-spec 作为任务拆解的输入 |
| → `backend`/`frontend` | design-spec + design-system + 原型作为 TDD 实现的输入 |

## 完成后

等待人工审批 Gate 2。审批时需查看：
1. `design-system.md` — 设计规范
2. `prototypes/` — HTML 原型
3. `design-spec.md` — 设计 Spec
4. `design-validation-001.md` — 校验报告
