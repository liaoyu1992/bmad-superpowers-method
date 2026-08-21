﻿# ============================================================================
# BMAD + Superpowers + BOSS 项目初始化脚本 v3.0 (Windows PowerShell)
# ============================================================================
# 用法：
#   1. 将此脚本复制到新项目根目录
#   2. 在 PowerShell 中执行：.\init-project.ps1
#   3. 将需求文档放入 docs/input/ 目录（支持多格式混合）
#   4. 按 DEVELOPMENT_WORKFLOW.md 的步骤开始工作流
# ============================================================================

$ErrorActionPreference = "Stop"
$ROOT = $PSScriptRoot

function Write-Step($step, $msg) {
    Write-Host "`n[$step] $msg" -ForegroundColor Cyan
}

function Write-Ok($msg) {
    Write-Host "  OK  $msg" -ForegroundColor Green
}

function Write-Skip($msg) {
    Write-Host "  SKIP $msg" -ForegroundColor Yellow
}

# ============================================================================
# Step 0: 检查 Node.js
# ============================================================================
Write-Step "0/10" "检查 Node.js 环境"
try {
    $nodeVer = node -v 2>&1
    if ($LASTEXITCODE -ne 0) { throw "node not found" }
    Write-Ok "Node.js $nodeVer"
} catch {
    Write-Host "  ERROR: Node.js 未安装或不在 PATH 中。请安装 Node.js 18+ 后重试。" -ForegroundColor Red
    Write-Host "  下载地址：https://nodejs.org/" -ForegroundColor Red
    exit 1
}

# ============================================================================
# Step 1: 创建 docs/ 目录结构（v3.0 新增 converted/ 和 learning/）
# ============================================================================
Write-Step "1/10" "创建 docs/ 目录结构（IDE 无关，v3.0）"
$dirs = @(
    "docs/input",
    "docs/input/converted",
    "docs/specs",
    "docs/design/prototypes",
    "docs/design/screenshots",
    "docs/plans",
    "docs/reports",
    "docs/learning/entries"
)
foreach ($d in $dirs) {
    $fullPath = Join-Path $ROOT $d
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Ok "创建 $d"
    } else {
        Write-Skip "$d 已存在"
    }
}

# docs/input/README.md
$inputReadme = Join-Path $ROOT "docs/input/README.md"
if (-not (Test-Path $inputReadme)) {
    "# 此目录存放原始需求文档（PRD、用户故事、业务说明等）" | Out-File -FilePath $inputReadme -Encoding utf8
    Write-Ok "创建 docs/input/README.md"
}

# docs/input/converted/README.md
$convertedReadme = Join-Path $ROOT "docs/input/converted/README.md"
if (-not (Test-Path $convertedReadme)) {
    "# 此目录存放阶段零自动转换后的 Markdown 文件（AI 自动生成，不要手动放入）" | Out-File -FilePath $convertedReadme -Encoding utf8
    Write-Ok "创建 docs/input/converted/README.md"
}

# docs/reports/README.md
$reportsReadme = Join-Path $ROOT "docs/reports/README.md"
if (-not (Test-Path $reportsReadme)) {
@'
# 审查报告与对齐验证报告

此目录存放以下报告：
- req-validation-NNN.md — 需求反向校验报告（防线 B）
- req-grill-NNN.md — 需求交叉审问报告（防线 C）
- design-validation-NNN.md — 设计校验报告
- alignment-report.md — Spec 合规性对齐报告
- test-coverage-report.md — 测试覆盖验证报告
- delivery-report.md — 最终交付报告
- review-NNN.md — 代码审查报告
'@ | Out-File -FilePath $reportsReadme -Encoding utf8
    Write-Ok "创建 docs/reports/README.md"
}

# docs/learning/LEARNING.md（经验库索引）
$learningIdx = Join-Path $ROOT "docs/learning/LEARNING.md"
if (-not (Test-Path $learningIdx)) {
@'
# 经验库索引

> 本文件是经验库的索引表。AI 每次任务启动时读取此文件，
> 根据任务描述提取关键词，匹配"触发条件"列，
> 读取匹配到的经验全文（docs/learning/entries/ 下的文件），
> 在当前任务中强制执行经验中的规则。
>
> 任务结束后，如有新经验（踩坑/教训），追加到本索引表并写入 entries/ 目录。

| 编号 | 触发条件 | 经验文件 | 简述 |
|------|----------|----------|------|
| L-001 | 需求分析 + 多平台 | entries/platform-split-traps.md | 平台拆分常见陷阱 |
| L-002 | TDD + 测试失败 | entries/tdd-common-pitfalls.md | TDD 常见坑 |
| L-003 | API + 契约不一致 | entries/api-contract-checklist.md | API 契约检查清单 |
| L-004 | 质量门禁 + Null | entries/null-safety-patterns.md | Null 安全模式 |
| L-005 | 需求漂移 + 多了/少了 | entries/req-drift-prevention.md | 需求漂移防范清单 |

<!-- 新经验在此行下方追加 -->
'@ | Out-File -FilePath $learningIdx -Encoding utf8
    Write-Ok "创建 docs/learning/LEARNING.md（经验库索引）"
}

# ============================================================================
# Step 2: 安装 Superpowers（运行安装器）
# ============================================================================
Write-Step "2/10" "安装 Superpowers（运行安装器）"
$claudeInstructions = Join-Path $ROOT ".claude/instructions.md"
if (Test-Path $claudeInstructions) {
    Write-Skip ".claude/instructions.md 已存在，跳过安装器"
} else {
    Write-Host "  运行 npx @agilite-2025/superpowers ..." -ForegroundColor Gray
    npx @agilite-2025/superpowers 2>&1 | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    if (Test-Path $claudeInstructions) {
        Write-Ok "Superpowers 安装完成"
    } else {
        Write-Host "  WARN: 安装器可能未成功，将手动创建基础文件" -ForegroundColor Yellow
    }
}

# ============================================================================
# Step 3: 向 .claude/instructions.md 追加 v3.0 Spec-Driven Development 段落
# ============================================================================
Write-Step "3/10" "配置 .claude/instructions.md（v3.0 融合版）"

$specDrivenSection = @'

## Spec-Driven Development（v3.0 BMAD + Superpowers + BOSS 融合）

本项目使用 BMAD + Superpowers + BOSS 融合工作流。所有规范文档存放在 `docs/` 目录（IDE 无关），详见 `DEVELOPMENT_WORKFLOW.md`。

### 文档目录结构

| 目录 | 用途 | 说明 |
|------|------|------|
| `docs/input/` | 原始需求文档 | PRD、用户故事等输入（多格式混合） |
| `docs/input/converted/` | 自动转换后的 Markdown | 阶段零自动生成 |
| `docs/specs/requirements.md` | 需求规格 | 按平台分区编号（REQ-BE- / REQ-PC- / REQ-APP- / REQ-XP-） |
| `docs/specs/design-spec.md` | 设计规格 | 页面规格、组件规格、交互逻辑 |
| `docs/specs/tech-spec.md` | 技术设计规格 | 技术栈、API 定义、数据模型、架构 |
| `docs/design/design-system.md` | 设计规范 | 色彩、排版、间距、组件样式 |
| `docs/design/prototypes/` | 设计原型 | HTML 原型文件（按平台命名） |
| `docs/design/screenshots/` | 设计截图 | 页面截图 |
| `docs/plans/plan-NNN-platform-*.md` | 任务计划 | 原子化实施计划（每计划≤5步，按平台分文件） |
| `docs/reports/` | 审查报告 | 需求校验、对齐报告、测试覆盖、交付报告 |
| `docs/learning/` | 经验库 | LEARNING.md 索引 + entries/ 全文 |

### 七大设计原则

1. **文档即真理**：所有变更先改 Spec，再改代码
2. **测试即真理**：测试用例必须覆盖所有 AC
3. **需求反向校验**：阶段一必须生成校验报告和交叉审问报告
4. **平台精准拆分**：混合 PRD 必须按平台拆分需求
5. **YAGNI**：不添加 Spec 未提及的功能
6. **经验自动沉淀**：踩坑/教训写入 docs/learning/
7. **流水线自动接力**：阶段间自动衔接，人工只参与审批门禁

### 质量门禁（借鉴 BOSS /quality-gate）

6 道关卡：编译 / Null / API 契约 / 事务 / 并发 / 错误处理

### 工作流阶段

| 阶段 | 角色 | 输入 | 产出 | 门禁 |
|------|------|------|------|------|
| 零·文档转换 | 自动 | `docs/input/*.{doc,docx,pdf}` | `docs/input/converted/*.md` | 无 |
| 一·需求规格化 | Analyst | 转换后所有 `.md` | `requirements.md` + 校验报告 | Gate 1 |
| 二·设计产出 | Architect | `requirements.md` | `design-system` + `prototypes` + `design-spec` + `tech-spec` | Gate 2 |
| 三·任务拆解 | Planner | `tech-spec` + `design-spec` | `plans/plan-NNN-platform-*.md` | Gate 3 |
| 四·TDD 实现 | Developer | `plans/` + 所有 Spec | 源代码 + 测试代码 | 测试+门禁全绿 |
| 五·对齐验证 | Quality Architect | 代码 + 测试 + Spec | `reports/` + `learning/` | 审查通过 |

### 流水线提示词

| 阶段 | 提示词 |
|------|--------|
| 0+1 | `流水线执行阶段 0+1` |
| 2 | `流水线执行阶段 2` |
| 3 | `流水线执行阶段 3` |
| 4 | `流水线执行阶段 4` |
| 5 | `流水线执行阶段 5` |
'@

if (Test-Path $claudeInstructions) {
    $content = Get-Content $claudeInstructions -Raw -Encoding utf8
    if ($content -match "Spec-Driven Development.*v3") {
        Write-Skip "v3.0 Spec-Driven Development 段落已存在"
    } elseif ($content -match "Spec-Driven Development") {
        # 有旧版本，替换为新版本
        $content = $content -replace "(?s)## Spec-Driven Development.*$", $specDrivenSection
        $content | Out-File -FilePath $claudeInstructions -Encoding utf8
        Write-Ok "已更新为 v3.0 Spec-Driven Development 段落"
    } else {
        Add-Content -Path $claudeInstructions -Value $specDrivenSection -Encoding utf8
        Write-Ok "已追加 v3.0 Spec-Driven Development 段落"
    }
} else {
    # 安装器未创建文件，手动创建
    $fullContent = @'
# Claude Instructions (v3.0 — BMAD + Superpowers + BOSS 融合)

# --- SUPERPOWERS:START ---

## CRITICAL RULES - READ EVERY SESSION
- **NEVER touch code without approval**: Explain problem definition -> List possible solutions -> Wait for user approval -> ONLY then write/edit code
- **NEVER use git**: User runs ALL git commands
- **NEVER use Task/Agent tools**: Do all analysis directly yourself with Read, Grep, Glob tools
- **Read this file at START of EVERY session** (including after compaction/restart)
- **Do not assume, always check**: Validate code, trace execution, verify assumptions

## ENFORCEMENT MECHANISM - MANDATORY WORKFLOW

**Before using Write/Edit tools, ALWAYS:**
1. STOP - Have I explained the problem?
2. STOP - Has user explicitly approved?
3. ONLY THEN -> Use Write/Edit

## Test-First, Fail-Fast Principle
- **NEVER write code without knowing how to test it first**
- Before writing any functionality:
  1. Define test cases
  2. Write automated test (unit or integration)
  3. Run test -> Watch it fail (red)
  4. Write code meeting ALL best practices
  5. Run test -> Watch it pass (green)
  6. Validate everything - do NOT assume

# --- SUPERPOWERS:END ---
'@
    $fullContent += $specDrivenSection
    $dir = Split-Path $claudeInstructions -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $fullContent | Out-File -FilePath $claudeInstructions -Encoding utf8
    Write-Ok "已创建 .claude/instructions.md（v3.0 融合版）"
}

# ============================================================================
# Step 4: 创建 .claude/project-context.md
# ============================================================================
Write-Step "4/10" "创建 .claude/project-context.md"
$projectContextPath = Join-Path $ROOT ".claude/project-context.md"
if (Test-Path $projectContextPath) {
    Write-Skip ".claude/project-context.md 已存在"
} else {
@'
# 项目上下文

## 项目信息
- **项目名称**：[项目名称]
- **技术栈**：[填写技术栈，如 React + TypeScript + Node.js]
- **工作流**：BMAD + Superpowers + BOSS 融合工作流 v3.0（详见 `DEVELOPMENT_WORKFLOW.md`）

## 规范文档位置
所有规范文档存放在 `docs/` 目录（IDE 无关）：
- 需求规格：`docs/specs/requirements.md`（按平台分区编号）
- 设计规格：`docs/specs/design-spec.md`
- 技术规格：`docs/specs/tech-spec.md`
- 设计规范：`docs/design/design-system.md`
- 任务计划：`docs/plans/plan-NNN-platform-*.md`
- 经验库：`docs/learning/LEARNING.md`

## 开发纪律
1. 代码修改前必须获得人工批准（Approval Workflow）
2. 提交前必须执行 Mental Model Execution 追踪（2-3 个场景）
3. 先写测试，再写实现（TDD 红/绿/重构）
4. 所有代码变更必须引用 Spec 章节号和 REQ 编号
5. 禁止自行执行 git 命令
6. 每个功能模块完成后必须通过质量门禁 6 道关卡
7. 禁止添加 Spec 未提及的功能（YAGNI）
8. 需求规格化阶段必须执行三道防线校验
'@ | Out-File -FilePath $projectContextPath -Encoding utf8
    Write-Ok "创建 .claude/project-context.md"
}

# ============================================================================
# Step 5: 创建 AGENTS.md（v3.0）
# ============================================================================
Write-Step "5/10" "创建 AGENTS.md（CatPaw / Codex 入口，v3.0）"
$agentsPath = Join-Path $ROOT "AGENTS.md"
if (Test-Path $agentsPath) {
    Write-Skip "AGENTS.md 已存在"
} else {
@'
# AGENTS.md — CatPaw / Codex / 通用 Agent 入口

> 本项目使用 BMAD + Superpowers + BOSS 融合工作流（v3.0）。
> 完整工作流文档见 `DEVELOPMENT_WORKFLOW.md`。

## 全局纪律（适用于所有角色）

### CRITICAL RULES
- **NEVER touch code without approval**: Explain problem definition → List possible solutions → Wait for user approval → ONLY then write/edit code
- **NEVER use git**: User runs ALL git commands
- **NEVER spawn sub-agents**: Do all analysis directly
- **Do not assume, always check**: Validate code, trace execution, verify assumptions

### ENFORCEMENT MECHANISM
Before writing/editing any code, ALWAYS:
1. STOP — Have I explained the problem?
2. STOP — Has user explicitly approved?
3. ONLY THEN → write/edit

### Test-First, Fail-Fast
1. Define test cases
2. Write automated test
3. Run test → Watch it fail (red)
4. Write code meeting ALL best practices
5. Run test → Watch it pass (green)
6. Validate everything — do NOT assume

### Mental Model Execution
Before submitting code, trace 2-3 realistic scenarios step-by-step.

### 质量门禁（6 道关卡）
编译 / Null 安全 / API 契约 / 事务 / 并发 / 错误处理

### Spec-Driven Development

所有规范文档存放在 `docs/` 目录（IDE 无关）：

| 目录 | 用途 |
|------|------|
| `docs/input/` | 原始需求文档（多格式混合） |
| `docs/input/converted/` | 自动转换后的 Markdown |
| `docs/specs/requirements.md` | 需求规格（按平台分区编号） |
| `docs/specs/design-spec.md` | 设计规格 |
| `docs/specs/tech-spec.md` | 技术设计规格 |
| `docs/design/` | 设计规范、原型、截图 |
| `docs/plans/` | 原子化任务计划（按平台分文件） |
| `docs/reports/` | 校验报告、审查报告、对齐报告 |
| `docs/learning/` | 经验索引 + 经验全文 |

### 工作流阶段

| 阶段 | 输入 | 产出 | 门禁 |
|------|------|------|------|
| 零·文档转换 | `docs/input/*.{doc,docx,pdf}` | `docs/input/converted/*.md` | 无 |
| 一·需求规格化 | 转换后 `.md` | `requirements.md` + 校验报告 | Gate 1 |
| 二·设计产出 | `requirements.md` | `design-system` + `prototypes` + `design-spec` + `tech-spec` | Gate 2 |
| 三·任务拆解 | `tech-spec` + `design-spec` | `plans/plan-NNN-platform-*.md` | Gate 3 |
| 四·TDD 实现 | `plans/` + 所有 Spec | 源代码 + 测试代码 | 测试+门禁全绿 |
| 五·对齐验证 | 代码 + 测试 + Spec | `reports/` + `learning/` | 审查通过 |

### 防需求漂移三道防线
A·正向提取（标注原文出处） / B·反向校验（多了/少了） / C·交叉审问（术语/冲突/串台）

### 经验库机制
每次任务开始先读取 `docs/learning/LEARNING.md` 索引表，匹配触发条件，加载经验全文。

## 角色

### Developer
- 实现：按 tech-spec.md 和 design-spec.md 构建功能
- TDD：先写测试 → 失败 → 写代码 → 通过 → 重构
- Mental Model Execution：每个里程碑后追踪 2-3 个场景
- 质量门禁：每个功能模块完成后执行 6 道关卡
- YAGNI：禁止添加 Spec 未提及的功能
- 禁止：git、子任务生成

### Quality Architect
- 独立质量审查：只为用户工作，不为开发团队
- Spec 合规：代码与 tech-spec / design-spec / requirements 逐条对齐
- 平台检查：每个平台的 REQ 是否在对应平台代码中实现
- 输出裁定：APPROVE / REQUEST CHANGES / BLOCK

### QA Engineer
- 测试执行：功能测试、性能测试、集成测试
- Bug 报告：含证据（文件:行号、截图、日志）
- 验收标准覆盖：确认测试用例覆盖所有 AC
- 验证，不修复

### SDET
- 测试自动化：从 QA 测试用例实现自动化测试
- TDD：写测试 → 失败 → 实现 → 通过

## 角色切换

```
以 Developer 角色执行：流水线执行阶段 4
以 Quality Architect 角色执行：审查代码规格合规性
以 QA Engineer 角色执行：验证测试覆盖所有验收标准
以 SDET 角色执行：实现自动化测试
```

## 流水线提示词速查

| 阶段 | 提示词 |
|------|--------|
| 0+1 | `流水线执行阶段 0+1` |
| 2 | `流水线执行阶段 2` |
| 3 | `流水线执行阶段 3` |
| 4 | `流水线执行阶段 4` |
| 5 | `流水线执行阶段 5` |
'@ | Out-File -FilePath $agentsPath -Encoding utf8
    Write-Ok "创建 AGENTS.md（v3.0）"
}

# ============================================================================
# Step 6: 创建 CLAUDE.md（v3.0）
# ============================================================================
Write-Step "6/10" "创建 CLAUDE.md（Claude Code 入口，v3.0）"
$claudeMdPath = Join-Path $ROOT "CLAUDE.md"
if (Test-Path $claudeMdPath) {
    Write-Skip "CLAUDE.md 已存在"
} else {
@'
# CLAUDE.md — Claude Code 入口文件

> 本项目使用 BMAD + Superpowers + BOSS 融合工作流（v3.0）。
> 完整工作流文档见 `DEVELOPMENT_WORKFLOW.md`。

## 启动检查清单（每次会话开始时读取）

1. 读取 `.claude/instructions.md` 获取全局纪律规则
2. 读取 `.claude/project-context.md` 获取项目信息
3. 读取 `docs/learning/LEARNING.md` 获取经验索引（如存在）
4. 根据当前任务匹配经验触发条件，加载相关经验全文

## 角色切换

```
Start Developer session
Start Quality Architect session
Start QA session
Start SDET session
Start Orchestrator session
```

## 流水线提示词

| 阶段 | 提示词 |
|------|--------|
| 0+1 | `流水线执行阶段 0+1` |
| 2 | `流水线执行阶段 2` |
| 3 | `流水线执行阶段 3` |
| 4 | `流水线执行阶段 4` |
| 5 | `流水线执行阶段 5` |

## 核心纪律

1. 文档即真理：所有变更先改 Spec，再改代码
2. 测试即真理：测试用例必须覆盖所有 AC
3. 需求反向校验：阶段一必须生成校验报告和交叉审问报告
4. 平台精准拆分：混合 PRD 必须按平台拆分需求
5. YAGNI：禁止添加 Spec 未提及的功能
6. 经验自动沉淀：踩坑/教训写入 docs/learning/
7. Approval Workflow：代码修改前必须获得人工批准
8. 质量门禁：6 道关卡全绿才可提交
9. 禁止自行执行 git 命令

## 文档目录

| 目录 | 用途 |
|------|------|
| `docs/input/` | 原始需求文档（多格式混合） |
| `docs/input/converted/` | 自动转换后的 Markdown |
| `docs/specs/requirements.md` | 需求规格（按平台分区编号） |
| `docs/specs/design-spec.md` | 设计规格 |
| `docs/specs/tech-spec.md` | 技术设计规格 |
| `docs/design/` | 设计规范、原型、截图 |
| `docs/plans/` | 原子化任务计划（按平台分文件） |
| `docs/reports/` | 校验报告、审查报告、对齐报告 |
| `docs/learning/` | 经验索引 + 经验全文 |
'@ | Out-File -FilePath $claudeMdPath -Encoding utf8
    Write-Ok "创建 CLAUDE.md（v3.0）"
}

# ============================================================================
# Step 7: 创建 .cursor/rules/*.mdc 文件（v3.0）
# ============================================================================
Write-Step "7/10" "创建 .cursor/rules/*.mdc 文件（CatPaw / Cursor 角色规则，v3.0）"
$cursorDir = Join-Path $ROOT ".cursor/rules"
if (-not (Test-Path $cursorDir)) {
    New-Item -ItemType Directory -Path $cursorDir -Force | Out-Null
}

# --- instructions.mdc ---
$instructionsMdc = Join-Path $cursorDir "instructions.mdc"
if (Test-Path $instructionsMdc) {
    Write-Skip ".cursor/rules/instructions.mdc 已存在"
} else {
@'
---
description: 全局纪律规则 - Approval Workflow、Mental Model Execution、Guardrails、Spec-Driven Development、防需求漂移、质量门禁
globs: ["**/*"]
alwaysApply: true
---

# 全局纪律规则（v3.0 BMAD + Superpowers + BOSS 融合）

## CRITICAL RULES
- **NEVER touch code without approval**: Explain problem definition → List possible solutions → Wait for user approval → ONLY then write/edit code
- **NEVER use git**: User runs ALL git commands
- **NEVER spawn sub-agents**: Do all analysis directly
- **Do not assume, always check**: Validate code, trace execution, verify assumptions

## ENFORCEMENT MECHANISM
Before writing/editing any code, ALWAYS:
1. STOP — Have I explained the problem?
2. STOP — Has user explicitly approved?
3. ONLY THEN → write/edit

## Test-First, Fail-Fast
1. Define test cases
2. Write automated test
3. Run test → Watch it fail (red)
4. Write code meeting ALL best practices
5. Run test → Watch it pass (green)
6. Validate everything — do NOT assume

## 质量门禁（6 道关卡）
编译 / Null 安全 / API 契约 / 事务 / 并发 / 错误处理

## Spec-Driven Development
所有规范文档存放在 `docs/` 目录（IDE 无关）。

## 防需求漂移三道防线
A·正向提取 / B·反向校验 / C·交叉审问

## 经验库机制
每次任务开始先读取 `docs/learning/LEARNING.md` 索引表。

## 工作流阶段
| 阶段 | 输入 | 产出 | 门禁 |
|------|------|------|------|
| 零·文档转换 | `docs/input/*.{doc,docx,pdf}` | `docs/input/converted/*.md` | 无 |
| 一·需求规格化 | 转换后 `.md` | `requirements.md` + 校验报告 | Gate 1 |
| 二·设计产出 | `requirements.md` | `design-system` + `prototypes` + `design-spec` + `tech-spec` | Gate 2 |
| 三·任务拆解 | `tech-spec` + `design-spec` | `plans/plan-NNN-platform-*.md` | Gate 3 |
| 四·TDD 实现 | `plans/` + 所有 Spec | 源代码 + 测试代码 | 测试+门禁全绿 |
| 五·对齐验证 | 代码 + 测试 + Spec | `reports/` + `learning/` | 审查通过 |
'@ | Out-File -FilePath $instructionsMdc -Encoding utf8
    Write-Ok "创建 .cursor/rules/instructions.mdc（v3.0）"
}

# --- developer.mdc ---
$devMdc = Join-Path $cursorDir "developer.mdc"
if (Test-Path $devMdc) {
    Write-Skip ".cursor/rules/developer.mdc 已存在"
} else {
@'
---
description: Developer 角色 - TDD + Approval Workflow + 质量门禁 + YAGNI
globs: ["src/**/*", "tests/**/*"]
alwaysApply: false
---

# Developer 角色（v3.0）

**职责**：按 tech-spec.md 和 design-spec.md 构建功能

## 核心职责
1. 实现：按 Spec 构建功能
2. TDD：先写测试 → 失败 → 写代码 → 通过 → 重构
3. Mental Model Execution：每个里程碑后追踪 2-3 个场景
4. 质量门禁：6 道关卡全绿
5. YAGNI：禁止添加 Spec 未提及的功能
6. Spec 引用：每次编码必须引用 Spec 章节号和 REQ 编号

## 工具使用
- OK: Read, Edit, Write, Grep, Glob, Bash（构建和测试，非 git）
- NO: Task（禁止生成子代理）
- NO: Git 命令（由用户执行）

## 完成标准
- [ ] 按 requirements.md 的验收标准实现功能
- [ ] 每个实现能追溯到 REQ 编号
- [ ] 测试编写并通过
- [ ] 质量门禁 6 道关卡全绿
- [ ] Mental Model Execution 完成
'@ | Out-File -FilePath $devMdc -Encoding utf8
    Write-Ok "创建 .cursor/rules/developer.mdc（v3.0）"
}

# --- quality-architect.mdc ---
$qaMdc = Join-Path $cursorDir "quality-architect.mdc"
if (Test-Path $qaMdc) {
    Write-Skip ".cursor/rules/quality-architect.mdc 已存在"
} else {
@'
---
description: Quality Architect 角色 - 独立质量审查，规格合规性检查，平台对齐验证
globs: ["src/**/*", "tests/**/*"]
alwaysApply: false
---

# Quality Architect 角色（v3.0）

**权限**：可以挑战任何决策、任何角色、任何代码

## 核心职责
1. 规格合规性审查：代码是否偏离 Spec
2. 平台对齐：每个平台的 REQ 是否在对应平台代码中实现
3. YAGNI 检查：代码没有添加 Spec 未提及的功能
4. 质量门禁验证：6 道关卡是否全绿
5. 输出裁定：APPROVE / REQUEST CHANGES / BLOCK

## 审查清单
- [ ] 代码简单可读
- [ ] 类型安全（禁止 any）
- [ ] 分层架构
- [ ] DRY
- [ ] 安全（参数化查询）
- [ ] 错误处理（快速失败）
- [ ] Spec 合规（逐条对齐）
- [ ] 平台对齐
- [ ] YAGNI
- [ ] 质量门禁全绿

## 工具使用
- OK: Read, Glob, Grep, Bash（信息收集）
- NO: Task, Edit（审查代码，不修复代码）
'@ | Out-File -FilePath $qaMdc -Encoding utf8
    Write-Ok "创建 .cursor/rules/quality-architect.mdc（v3.0）"
}

# --- qa-engineer.mdc ---
$qaeMdc = Join-Path $cursorDir "qa-engineer.mdc"
if (Test-Path $qaeMdc) {
    Write-Skip ".cursor/rules/qa-engineer.mdc 已存在"
} else {
@'
---
description: QA Engineer 角色 - 测试验证、Bug 报告、验收标准覆盖检查
globs: ["tests/**/*"]
alwaysApply: false
---

# QA Engineer 角色（v3.0）

**职责**：验证功能、发现 Bug、确保生产就绪

## 核心职责
1. 测试执行：功能测试、性能测试、集成测试
2. Bug 报告：含证据，分级 CRITICAL/HIGH/MEDIUM/LOW
3. 验收标准覆盖：确认测试用例覆盖所有 AC
4. 平台测试：按平台分别验证

## 工具使用
- OK: Bash（运行测试、检查日志）, Read, Write（Bug 报告）
- NO: Task, Edit（QA 不修复代码）, Git
'@ | Out-File -FilePath $qaeMdc -Encoding utf8
    Write-Ok "创建 .cursor/rules/qa-engineer.mdc（v3.0）"
}

# --- sdet.mdc ---
$sdetMdc = Join-Path $cursorDir "sdet.mdc"
if (Test-Path $sdetMdc) {
    Write-Skip ".cursor/rules/sdet.mdc 已存在"
} else {
@'
---
description: SDET 角色 - 测试自动化工程师
globs: ["tests/**/*"]
alwaysApply: false
---

# SDET 角色（v3.0）

**职责**：从 QA 测试用例实现自动化测试，确保测试覆盖率

## 核心职责
1. 测试自动化：单元/集成/端到端
2. TDD：写测试 → 失败 → 实现 → 通过
3. 验收标准覆盖：确保自动化测试覆盖所有 AC

## 工具使用
- OK: Read, Write（测试文件）, Edit（修改测试）, Bash（运行测试）, Grep, Glob
- NO: Task, Git
'@ | Out-File -FilePath $sdetMdc -Encoding utf8
    Write-Ok "创建 .cursor/rules/sdet.mdc（v3.0）"
}

# ============================================================================
# Step 8: 创建 .vscode/ 工作区配置
# ============================================================================
Write-Step "8/10" "创建 .vscode/ 工作区配置（CatPaw）"
$vscodeDir = Join-Path $ROOT ".vscode"
if (-not (Test-Path $vscodeDir)) {
    New-Item -ItemType Directory -Path $vscodeDir -Force | Out-Null
}

# .vscode/settings.json
$vscodeSettings = Join-Path $vscodeDir "settings.json"
if (Test-Path $vscodeSettings) {
    Write-Skip ".vscode/settings.json 已存在"
} else {
@'
{
    "catpaw.enabled": true,
    "catpaw.ruleFileEnabled": true,
    "catpaw.inlayEnabled": true,
    "catpaw.selectionEnabled": true,
    "catpaw.agentAutocompleteEnabled": true,
    "files.associations": {
        "*.mdc": "markdown"
    },
    "search.exclude": {
        "**/node_modules": true,
        "**/docs/design/prototypes": false,
        "**/docs/design/screenshots": false
    },
    "files.exclude": {
        "**/.claude": false,
        "**/.cursor": false,
        "**/.vscode": false
    },
    "markdown.preview.fontSize": 14,
    "editor.fontSize": 14
}
'@ | Out-File -FilePath $vscodeSettings -Encoding utf8
    Write-Ok "创建 .vscode/settings.json"
}

# .vscode/extensions.json
$vscodeExts = Join-Path $vscodeDir "extensions.json"
if (Test-Path $vscodeExts) {
    Write-Skip ".vscode/extensions.json 已存在"
} else {
@'
{
    "recommendations": []
}
'@ | Out-File -FilePath $vscodeExts -Encoding utf8
    Write-Ok "创建 .vscode/extensions.json"
}

# ============================================================================
# Step 9: 安装 .skills/ 目录（BOSS 技能体系）
# ============================================================================
Write-Step "9/10" "安装 .skills/ 目录（BOSS 技能体系）"
$skillsDir = Join-Path $ROOT ".skills"
$skillsMasterPath = Join-Path $skillsDir "SKILL.md"
if (Test-Path $skillsMasterPath) {
    Write-Skip ".skills/ 目录已存在"
} else {
    # 创建技能目录结构
    $skillSubDirs = @(
        ".skills/references",
        ".skills/convert-documents",
        ".skills/requirement",
        ".skills/architect",
        ".skills/designer",
        ".skills/planner",
        ".skills/backend",
        ".skills/frontend",
        ".skills/test",
        ".skills/review",
        ".skills/quality-gate",
        ".skills/grill",
        ".skills/alignment",
        ".skills/loop"
    )
    foreach ($d in $skillSubDirs) {
        $fullPath = Join-Path $ROOT $d
        if (-not (Test-Path $fullPath)) {
            New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        }
    }
    Write-Ok "创建 .skills/ 目录结构"

    # 提示：技能文件需要从 bmad-superpowers-method 项目复制
    Write-Host "  NOTE: 技能 SKILL.md 文件需要从 bmad-superpowers-method 项目复制" -ForegroundColor Yellow
    Write-Host "       将 .skills/ 目录下所有 SKILL.md 文件复制到此处" -ForegroundColor Yellow
    Write-Host "       或直接将整个 .skills/ 目录复制到新项目根目录" -ForegroundColor Yellow
}

# ============================================================================
# ============================================================================
Write-Step "10/10" "检查 DEVELOPMENT_WORKFLOW.md"
$workflowPath = Join-Path $ROOT "DEVELOPMENT_WORKFLOW.md"
if (Test-Path $workflowPath) {
    $wfContent = Get-Content $workflowPath -Raw -Encoding utf8
    if ($wfContent -match "v3") {
        Write-Ok "DEVELOPMENT_WORKFLOW.md 已是 v3.0 版本"
    } else {
        Write-Host "  WARN: DEVELOPMENT_WORKFLOW.md 不是 v3.0 版本" -ForegroundColor Yellow
        Write-Host "       请从 bmad-superpowers-method 项目复制最新版本" -ForegroundColor Yellow
    }
} else {
    Write-Host "  WARN: DEVELOPMENT_WORKFLOW.md 不存在" -ForegroundColor Yellow
    Write-Host "       请从 bmad-superpowers-method 项目复制 DEVELOPMENT_WORKFLOW.md 到项目根目录" -ForegroundColor Yellow
}

# ============================================================================
# 总结
# ============================================================================
Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "  v3.0 初始化完成！（BMAD + Superpowers + BOSS 融合）" -ForegroundColor Green
Write-Host "============================================`n" -ForegroundColor Cyan

Write-Host "已创建的文件结构：" -ForegroundColor White
Write-Host "  docs/input/                # 放入需求文档（.md/.doc/.docx/.pdf，可多格式混合）" -ForegroundColor Gray
Write-Host "  docs/input/converted/      # 阶段零自动转换后的 Markdown" -ForegroundColor Gray
Write-Host "  docs/specs/                # AI 将在此生成 requirements/design-spec/tech-spec" -ForegroundColor Gray
Write-Host "  docs/design/               # AI 将在此生成 design-system/prototypes/screenshots" -ForegroundColor Gray
Write-Host "  docs/plans/                # AI 将在此生成 plan-NNN-platform-*.md" -ForegroundColor Gray
Write-Host "  docs/reports/              # AI 将在此生成校验/审查/对齐报告" -ForegroundColor Gray
Write-Host "  docs/learning/             # 经验库（LEARNING.md + entries/）" -ForegroundColor Gray
Write-Host "  .skills/                   # BOSS 技能体系（14 个子技能 + 主调度器）" -ForegroundColor Gray
Write-Host "  .claude/                   # Claude Code 配置（v3.0）" -ForegroundColor Gray
Write-Host "  .cursor/rules/             # CatPaw / Cursor 角色规则（5 个 .mdc 文件）" -ForegroundColor Gray
Write-Host "  .vscode/                   # CatPaw / VS Code 工作区配置" -ForegroundColor Gray
Write-Host "  AGENTS.md                  # CatPaw / Codex 入口（v3.0）" -ForegroundColor Gray
Write-Host "  CLAUDE.md                  # Claude Code 入口（v3.0）" -ForegroundColor Gray

Write-Host "`n下一步：" -ForegroundColor Yellow
Write-Host "  1. 将需求文档放入 docs/input/（支持多格式混合，如 prd-backend.docx + prd-app.pdf）" -ForegroundColor White
Write-Host "  2. （可选）编辑 .claude/project-context.md 填写项目信息" -ForegroundColor White
Write-Host "  3. 在 AI IDE 中发送流水线提示词：" -ForegroundColor White
Write-Host "     流水线执行阶段 0+1" -ForegroundColor Cyan
Write-Host "     （自动转换文档 → 识别平台 → 按平台拆分需求 → 生成 requirements.md → 反向校验 → 交叉审问）" -ForegroundColor Cyan
Write-Host "`n  完整流程详见 DEVELOPMENT_WORKFLOW.md`n" -ForegroundColor Gray