---
name: architect
description: 技术架构师技能。读取 requirements.md，生成 tech-spec.md（技术栈、API 定义、数据模型、架构、非功能需求）。支持平台筛选（只为实施范围内的平台生成 tech-spec）。触发场景：流水线阶段二、用户说"技术设计"、"生成 tech-spec"、"架构设计"时使用。
metadata:
  short-description: 生成技术设计 Spec（支持平台筛选）
---

# architect — 技术架构师

> 阶段二技能。基于需求规格生成技术设计 Spec。

## 执行步骤

### 步骤 0：检查平台筛选

读取 `requirements.md` 头部的"本次实施范围"：
- 如果有平台筛选，只为实施范围内的平台生成 tech-spec
- 如果没有平台筛选，为所有平台生成 tech-spec

### 步骤 1：读取需求规格

读取 `docs/specs/requirements.md`，提取：
- 所有 REQ 编号和验收标准（AC）
- 平台清单和技术约束
- 非功能需求（性能、安全、兼容性）
- 待确认问题清单（如有，需要在 tech-spec 中给出技术侧的默认假设）

### 步骤 2：生成技术设计 Spec

写入 `docs/specs/tech-spec.md`。

### 步骤 3：加载经验库

- 读取 `docs/learning/LEARNING.md` 索引表
- 匹配"架构设计"或"API 设计"触发条件
- 如有新经验，追加到 LEARNING.md 并写入 `docs/learning/entries/`

## 产出要求

1. **技术栈选型**：明确指定版本号（如 React 18.2 + Vite 5 + TypeScript 5.3）
2. **按平台划分技术方案**：后端/PC/APP 可能技术栈不同，各自独立章节
3. **API 接口定义**：请求/响应 JSON Schema，标注服务于哪些平台的 REQ
4. **数据模型**：表结构 / ER 关系 / TypeScript 类型定义
5. **模块划分**：与职责边界
6. **非功能需求**：性能指标、安全策略、可扩展性方案
7. **章节编号**：每个章节编号（如 §4.2.3），便于后续代码引用对齐
8. **禁止**"待定"、"后续实现"等模糊表述
9. **追溯性**：每个技术决策必须能追溯到 requirements.md 中的某个 REQ

## 自动校验

生成后自动检查：
- requirements.md 中每个 REQ 是否在 tech-spec 中有对应设计？
- tech-spec 中的 API 是否标注了服务的 REQ 编号？
- 每个章节是否有编号？
- 是否有"待定"/"TBD"等模糊表述？

## 完成后

等待人工审批 Gate 2。审批时需查看：
1. `tech-spec.md` — 技术设计 Spec
2. `design-validation-001.md` — 校验报告（由 designer 生成）
