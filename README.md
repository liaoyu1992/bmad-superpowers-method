# BMAD + Superpowers + BOSS 融合工作流（v3.0）

> **Spec-Driven Development × AI Agent Skills** — 一套面向 AI 编程助手的规范驱动开发方法论，融合三大框架的精华，让 AI 像一个有纪律的工程团队一样工作。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Workflow Version](https://img.shields.io/badge/Workflow-v3.0-blue.svg)](DEVELOPMENT_WORKFLOW.md)
[![BMAD](https://img.shields.io/badge/BMAD-Method-orange.svg)](https://github.com/bmad-code-org/BMAD-METHOD)
[![Superpowers](https://img.shields.io/badge/Superpowers-Enhanced-green.svg)](https://www.npmjs.com/package/@agilite-2025/superpowers)

---

## 📖 项目简介

本项目是一套**面向 AI 编程助手**（CatPaw / Claude Code / Codex 等）的开发工作流方法论，融合了三大框架的优势：

| 治理层 | 来源 | 核心理念 | 管什么 |
|--------|------|----------|--------|
| **BMAD Method** | 角色体系 + Spec 文档 | 文档即真理 | 做什么（需求、设计、架构） |
| **Superpowers** | 纪律规则 | 测试即真理 | 怎么做（TDD、审批、审查） |
| **BOSS 工具化** | 经验沉淀 + 质量门禁 + 自动流水线 | 经验自动沉淀 | 怎么做对（防漂移、防遗漏） |

### 解决什么问题？

AI 编程助手常见的"痛点"：

- ❌ **需求漂移** — AI 自行发挥，代码偏离原始需求
- ❌ **功能蔓延** — AI "顺便"实现了需求文档没提到的功能
- ❌ **平台串台** — 混合 PRD 中后端/前端/APP 需求混淆
- ❌ **质量黑箱** — AI 生成的代码缺乏系统审查
- ❌ **经验丢失** — 踩过的坑下次还会踩

本工作流通过 **三道防线 + 六道质量门禁 + 经验库机制** 系统性解决以上问题。

---

## ✨ 核心特性

### 🛡️ 三道防线（防需求漂移）

| 防线 | 时机 | 检查内容 |
|------|------|----------|
| A · 正向提取 | AI 生成 Spec 时 | 每条 Spec 必须标注原文出处 |
| B · 反向校验 | Spec 生成后 | 原文每条 ←→ Spec 每条，有没有多了/少了 |
| C · 交叉审问 | 人工审批前 | 术语一致性、业务冲突、平台串台、YAGNI 违规 |

### 🚪 六道质量门禁

| 关卡 | 检查内容 | 通过标准 |
|------|----------|----------|
| 编译 | 代码是否通过编译/类型检查 | 0 error |
| Null 安全 | 是否有空指针风险 | 无未处理的 null |
| API 契约 | 接口定义是否与 tech-spec 一致 | 100% 对齐 |
| 事务 | 数据库操作是否有事务包裹 | 所有写操作有事务 |
| 并发 | 是否有并发安全问题 | 无竞态条件 |
| 错误处理 | 是否有未捕获的异常 | 快速失败，不静默吞错 |

### 🎯 平台精准拆分

混合 PRD 自动按平台（后端 / PC / APP / 小程序）拆分需求，支持"只做 APP"、"只做后端"等平台筛选。

### 📚 经验库机制

每次任务自动加载历史经验，踩坑教训自动沉淀，形成团队知识资产。

### 🤖 19 个 AI 技能

内置 19 个自包含技能（`.skills/` 目录），覆盖从需求到交付的完整生命周期，AI 自动按需调度。

---

## 🚀 快速开始

### 1. 一键初始化

```bash
# Windows (PowerShell)
.\init-project.ps1

# Mac / Linux
chmod +x init-project.sh && ./init-project.sh
```

脚本自动完成：创建 `docs/` 目录结构 → 生成 IDE 配置文件 → 创建经验库索引 → 检查工作流文档。

### 2. 放入需求文档

将需求文档放入 `docs/input/`（支持 `.md` / `.doc` / `.docx` / `.pdf` / `.txt`，多个文档可混合放入）：

```
docs/input/
├── prd-backend.docx
├── prd-app.pdf
└── prd-pc.md
```

### 3. 在 AI IDE 中发送提示词

```
流水线执行阶段 0+1
```

AI 将自动执行：文档转换 → 需求规格化 → 多平台拆分 → 三道防线校验。

### 4. 人工审批后继续

审批 Gate 1 后，依次发送：

```
流水线执行阶段 2    # 设计产出
流水线执行阶段 3    # 任务拆解 + 计划审问
流水线执行阶段 4    # TDD 实现 + 质量门禁
流水线执行阶段 5    # 对齐验证 + 交付
```

> 除 3 个人工审批门禁（Gate 1/2/3）外，其余步骤均可流水化自动运行。

---

## 📋 工作流总览

```
┌─────────────────────────────────────────────────────────────────┐
│                     六阶段流水线                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  阶段零          阶段一           阶段二          阶段三          │
│  文档转换   ──▶  需求规格化  ──▶  设计产出  ──▶  任务拆解        │
│  (自动)          (三道防线)       (tech-spec)    (原子化计划)     │
│                   Gate 1            Gate 2          Gate 3        │
│                                                                 │
│  阶段四                         阶段五                            │
│  TDD 实现         ──▶          对齐验证                           │
│  (测试+门禁全绿)                (审查+交付)                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 阶段详解

| 阶段 | 输入 | 产出 | 门禁 |
|------|------|------|------|
| 零 · 文档转换 | `docs/input/*.{doc,docx,pdf}` | `docs/input/converted/*.md` | 无 |
| 一 · 需求规格化 | 转换后 `.md` | `requirements.md` + 校验报告 | Gate 1 |
| 二 · 设计产出 | `requirements.md` | `design-spec` + `tech-spec` + 原型 | Gate 2 |
| 三 · 任务拆解 | `tech-spec` + `design-spec` | `plans/plan-NNN-*.md` | Gate 3 |
| 四 · TDD 实现 | `plans/` + 所有 Spec | 源代码 + 测试代码 | 测试+门禁全绿 |
| 五 · 对齐验证 | 代码 + 测试 + Spec | `reports/` + `learning/` | 审查通过 |

---

## 🧩 技能体系

> 19 个自包含技能存放在 `.skills/` 目录，随项目走，可复制到任意项目。技能被 AI IDE 自动发现并按需加载。

### 技能架构

```
.skills/
├── SKILL.md                     # /boss — 主调度器（入口）
├── convert-documents/           # 阶段零：文档自动转换
├── requirement/                 # 阶段一：需求规格化 + 三道防线
├── brainstorm/                  # 前置：需求探索与方案收敛
├── architect/                   # 阶段二：技术 Spec 生成
├── designer/                    # 阶段二：设计规范 + 原型
├── planner/                     # 阶段三：原子化任务拆解
├── backend/                     # 阶段四：后端 TDD 实现
├── frontend/                    # 阶段四：前端 TDD 实现
├── devops/                      # 部署 + CI/CD + Docker
├── config/                      # 多环境配置管理
├── test/                        # 测试编写与执行
├── review/                      # Spec 合规性审查
├── quality-gate/                # 6 道关卡质量门禁
├── security/                    # 安全漏洞扫描
├── grill/                       # 交叉审问（防线 C）
├── alignment/                   # 三方对齐验证
├── troubleshoot/                # 故障排查与根因分析
├── research/                    # 技术调研与选型
├── describe-image/              # 多模态图片识别桥接
├── loop/                        # 编译→测试→审查循环修复
└── references/                  # 共享参考文档
```

### 技能与流水线阶段映射

| 阶段 | 主技能 | 辅助技能 | 人工门禁 |
|------|--------|----------|----------|
| 前置 · 探索 | `brainstorm` / `research` | — | 无 |
| 零 · 文档转换 | `convert-documents` | — | 无 |
| 一 · 需求规格化 | `requirement` | `grill`（防线 C） | Gate 1 |
| 二 · 设计产出 | `architect` + `designer` | — | Gate 2 |
| 三 · 任务拆解 | `planner` | `grill`（计划审问） | Gate 3 |
| 四 · TDD 实现 | `backend` / `frontend` | `quality-gate` + `loop` | 测试+门禁全绿 |
| 五 · 对齐验证 | `review` + `security` + `alignment` | `test` | 审查通过 |
| 运维 · 部署 | `devops` + `config` | — | 无 |
| 运维 · 排查 | `troubleshoot` | — | 无 |

### MCP 工具协作

本工作流支持以下 MCP 工具增强 AI 能力：

| MCP 工具 | 使用场景 | 调用技能 |
|----------|----------|----------|
| codegraph | 跨模块依赖分析、调用链追踪 | backend, frontend, review, troubleshoot |
| upgrade-mcp | 依赖版本扫描、升级建议 | research |
| firecrawl / anysearch | 抓取官方文档 | research |
| context7 | 查询第三方库最新 API | architect, research |
| playwright | E2E 测试、页面问题复现 | test, troubleshoot |
| markitdown | 25+ 格式文档转 Markdown | convert-documents |

> MCP 工具需要 IDE 已安装对应插件。如未安装，技能仍可正常运行，仅缺少增强能力。

---

## 👥 角色体系

| 角色 | 职责 | 核心纪律 |
|------|------|----------|
| **Developer** | 按 Spec 构建，TDD 实现 | 禁止添加 Spec 未提及的功能（YAGNI） |
| **Quality Architect** | 独立质量审查 | 证据驱动，每条批评包含 文件:行号 |
| **QA Engineer** | 测试执行与验收 | 验证，不修复 |
| **SDET** | 测试自动化 | TDD：写测试 → 失败 → 实现 → 通过 |
| **Orchestrator** | 护栏执行 | 修复系统，不只是修复症状 |

---

## 📁 项目结构

```
bmad-superpowers-method/
├── .skills/                     # AI 技能库（19 个技能 + 主调度器）
├── .claude/                      # Claude Code 配置
├── .cursor/                     # Cursor 配置
├── .vscode/                     # VS Code 配置
├── docs/
│   ├── input/                   # 原始需求文档（多格式混合）
│   │   └── converted/           # 自动转换后的 Markdown
│   ├── specs/
│   │   ├── requirements.md       # 需求规格（按平台分区编号）
│   │   ├── design-spec.md        # 设计规格
│   │   └── tech-spec.md         # 技术设计规格
│   ├── design/
│   │   ├── prototypes/          # 原型
│   │   └── screenshots/         # 截图
│   ├── plans/                   # 原子化任务计划
│   ├── reports/                 # 校验/审查/对齐报告
│   └── learning/
│       ├── LEARNING.md          # 经验索引表
│       └── entries/             # 经验全文
├── AGENTS.md                    # 通用 Agent 入口（CatPaw / Codex）
├── CLAUDE.md                    # Claude Code 入口
├── DEVELOPMENT_WORKFLOW.md      # 完整工作流文档（1275 行）
├── init-project.ps1             # Windows 初始化脚本
├── init-project.sh              # Mac/Linux 初始化脚本
├── LICENSE                      # MIT 许可证
└── README.md                    # 本文件
```

---

## 📝 命令速查

### 流水线提示词

| 阶段 | 提示词 | 说明 |
|------|--------|------|
| 0+1 | `流水线执行阶段 0+1` | 文档转换 + 需求规格化 |
| 2 | `流水线执行阶段 2` | 设计产出 |
| 3 | `流水线执行阶段 3` | 任务拆解 + 计划审问 |
| 4 | `流水线执行阶段 4` | TDD 实现 + 质量门禁 |
| 5 | `流水线执行阶段 5` | 对齐验证 + 交付 |

### 平台筛选

```
流水线执行阶段 0+1 只做APP        # 只生成 APP 相关需求
流水线执行阶段 2 只做后端          # 只生成后端 tech-spec
流水线执行阶段 4 只做PC+后端       # 只执行 PC 和后端的 TDD
```

### 场景组合

| 场景 | 推荐组合 |
|------|----------|
| 新增功能（完整流程） | 阶段 0+1 → 2 → 3 → 4 → 5 |
| 小修小补 | review + quality-gate |
| 需求变更 | requirement → 更新 design-spec → 受影响 plan → TDD |
| 需求不明确 | brainstorm → requirement |
| 技术选型 | research → architect |
| 生产排查 | troubleshoot |
| 安全审查 | security → review |

---

## 📐 七大设计原则

1. **文档即真理** — 所有变更先改 Spec，再改代码
2. **测试即真理** — 测试用例必须覆盖所有验收标准（AC）
3. **需求反向校验** — 阶段一必须生成校验报告和审问报告
4. **平台精准拆分** — 混合 PRD 必须按平台拆分需求
5. **YAGNI** — 禁止添加 Spec 未提及的功能
6. **经验自动沉淀** — 踩坑/教训写入 `docs/learning/`
7. **流水线自动接力** — 阶段间自动衔接，人工只参与审批门禁

---

## 🔧 前置条件

| 工具 | 用途 | 安装 |
|------|------|------|
| AI IDE | CatPaw / Claude Code / Codex 等 | 按需选择 |
| Pandoc（可选） | Word/PDF 转 Markdown | [pandoc.org](https://pandoc.org/) |
| Node.js（可选） | Superpowers 增强包 | [nodejs.org](https://nodejs.org/) |

> 阶段零的文档转换优先使用 MCP 工具 `markitdown`，如未安装则回退到 `pandoc` 或 Python `pymupdf`。

---

## 📚 完整文档

详细工作流文档请阅读 [DEVELOPMENT_WORKFLOW.md](DEVELOPMENT_WORKFLOW.md)（1275 行），涵盖：

- 核心理念与设计原则
- 项目目录结构
- 前置条件与环境配置
- 六个阶段的详细操作步骤
- 流水线自动化运行机制
- 多 IDE 适配指南
- 技能体系设计
- 最佳实践与故障排查

---

## 🔗 参考链接

- [BMAD Method](https://github.com/bmad-code-org/BMAD-METHOD) — 文档驱动开发方法论
- [@agilite-2025/superpowers](https://www.npmjs.com/package/@agilite-2025/superpowers) — Superpowers 增强包
- [Pandoc](https://pandoc.org/) — 通用文档转换工具

---

## 📄 License

[MIT](LICENSE) © 2026 liaoyu1992 &lt;1519778181@qq.com&gt;
