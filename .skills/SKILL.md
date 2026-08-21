---
name: boss
description: BMAD+Superpowers+BOSS 融合工作流的主调度器。根据任务类型自动选择合适的子技能组合。支持平台筛选（只实施部分平台）。触发场景：用户说"流水线执行阶段N"、"/boss"、"按工作流执行"、需要从需求到交付的完整流程、或需要调度特定阶段（需求分析、设计、开发、测试、审查）时使用。支持"只做APP"、"只做后端"、"只做PC"等平台筛选。
metadata:
  short-description: 项目主管调度器 — 按任务类型自动选技能组合，支持平台筛选
---

# /boss — 项目主管调度器

> 本技能是 BMAD + Superpowers + BOSS 融合工作流（v3.0）的主调度器。
> 完整工作流文档见 `DEVELOPMENT_WORKFLOW.md`。

## 核心思想

AI 不是流水线，是**工具箱**。/boss 按任务类型自动选组合，按需调度，不强制走完整流程。

## 调度逻辑

当用户发送 `流水线执行阶段 N` 或 `/boss` 时，按以下逻辑调度：

| 用户输入 | 调度的子技能 | 说明 |
|----------|-------------|------|
| `流水线执行阶段 0+1` | convert-documents → requirement | 转换+需求规格化 |
| `流水线执行阶段 2` | architect → designer → design-spec | 设计产出全流程 |
| `流水线执行阶段 3` | planner → grill | 任务拆解 + 计划审问（写代码前先被审问一遍）|
| `流水线执行阶段 4` | backend / frontend → test → quality-gate | TDD 实现+门禁 |
| `流水线执行阶段 5` | review → security → alignment | 对齐验证+交付 |
| `/boss`（无参数） | 读取当前项目状态，推荐下一步 | 智能推荐 |

## ★ 平台筛选机制

用户可以在流水线提示词中指定**只实施部分平台**，而不需要全部实施：

| 用户输入 | 效果 |
|----------|------|
| `流水线执行阶段 0+1` | 识别所有平台，全部实施 |
| `流水线执行阶段 0+1 只做APP` | 识别所有平台，但只生成 APP 相关需求 |
| `流水线执行阶段 2 只做后端` | 只生成后端 tech-spec |
| `流水线执行阶段 3 只做APP` | 只拆解 APP 平台的任务计划 |
| `流水线执行阶段 4 只做PC` | 只执行 PC 平台的 TDD |
| `流水线执行阶段 0+1 只做APP+后端` | 只生成 APP 和后端的需求 |

**平台筛选规则**：
- 需求文档中可能混合了多平台需求，但用户只需实施部分平台时，`requirement` 技能会识别所有平台需求，但在 `requirements.md` 中标记"本次实施范围"
- `planner` 只为实施范围内的平台生成计划
- `backend`/`frontend` 只执行实施范围内的计划
- `review`/`alignment` 只检查实施范围内的代码
- 被排除的平台需求仍记录在 `requirements.md` 中，标记为"本次不实施"，便于后续追踪

## 启动流程

每次 /boss 启动时，按以下顺序执行：

1. **加载经验库**：读取 `docs/learning/LEARNING.md` 索引表
2. **关键词匹配**：从任务描述提取关键词，匹配触发条件
3. **加载经验全文**：读取匹配到的 `docs/learning/entries/*.md`
4. **解析平台筛选**：从用户输入中解析"只做XX"指令
5. **执行任务**：按调度逻辑选择子技能，传入平台筛选参数
6. **自动沉淀**：任务中发现踩坑/教训，写回 LEARNING.md

## 子技能清单

### 需求侧
- **convert-documents**：Word/PDF/TXT → Markdown 自动转换
- **requirement**：需求规格化 + 多平台拆分 + 三道防线校验（支持平台筛选）
- **brainstorm**：需求探索与方案收敛（需求不明确时使用）

### 设计侧
- **architect**：技术 Spec 生成（技术栈、API、数据模型）
- **designer**：设计规范 + 原型 + 设计 Spec

### 开发侧
- **backend**：后端 TDD 实现
- **frontend**：前端 TDD 实现（PC/APP/小程序）
- **planner**：原子化任务计划拆解（支持平台筛选）
- **devops**：部署 + CI/CD + Docker + 环境配置
- **config**：多环境配置统一管理

### 质量侧
- **test**：测试工程（单元/集成/E2E）
- **review**：代码审查（Spec 合规性）
- **quality-gate**：6 道关卡质量门禁
- **security**：安全漏洞扫描与审计
- **grill**：交叉审问（用需求挑战 Spec/代码）
- **alignment**：Spec 对齐验证

### 运维侧
- **troubleshoot**：故障排查与根因分析
- **research**：技术调研与选型分析

### 辅助
- **describe-image**：多模态图片识别桥接
- **loop**：编译→测试→审查循环迭代，直到全绿

## 使用场景

| 场景 | 推荐组合 |
|------|----------|
| 新增功能（完整流程） | 阶段 0+1 → 2 → 3 → 4 → 5 |
| 只做 APP（混合需求） | 阶段 0+1 只做APP → 2 只做APP → 3 只做APP → 4 只做APP → 5 只做APP |
| 只做后端 | 阶段 0+1 只做后端 → 2 只做后端 → 3 只做后端 → 4 只做后端 → 5 只做后端 |
| 小修小补 | review + quality-gate |
| 需求变更 | requirement → 对应 design-spec 更新 → 受影响的 plan → TDD |
| 跨模块大改 | grill（挑战设计）→ backend + frontend → test → review |
| 需求不明确 | brainstorm → requirement |
| 技术选型 | research → architect |
| 生产排查 | troubleshoot（查日志+查数据+源码分析）|
| 安全审查 | security → review |
| 设计图还原 | describe-image → frontend |
| 部署上线 | devops → config |

## 经验库机制

详见 `references/learning-mechanism.md`

## MCP 工具协作

本工作流支持以下 MCP 工具，增强 AI 的能力边界：

| MCP 工具 | 使用场景 | 调用技能 |
|----------|----------|----------|
| codegraph | 跨模块依赖分析、调用链追踪、"改A炸B"风险检查 | backend, frontend, review, troubleshoot |
| upgrade-mcp | 依赖版本扫描、过时依赖检查、升级建议、历史会话缺陷扫描 | research |
| firecrawl / anysearch | 抓取官方文档、技术博客 | research |
| context7 | 查询第三方库最新文档和 API | architect, research |
| playwright | E2E 测试自动化、页面问题复现、console 日志抓取 | test, troubleshoot |
| markitdown | 25+ 格式文档转 Markdown | convert-documents |

> **注意**：MCP 工具需要 IDE 已安装对应插件才能调用。如未安装，技能仍可正常运行，仅缺少增强能力。
