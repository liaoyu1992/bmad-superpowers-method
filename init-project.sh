#!/usr/bin/env bash
# ============================================================================
# BMAD + Superpowers + BOSS 项目初始化脚本 v3.0 (Mac/Linux Bash)
# ============================================================================
# 用法：
#   1. 将此脚本复制到新项目根目录
#   2. 执行：chmod +x init-project.sh && ./init-project.sh
#   3. 将需求文档放入 docs/input/ 目录（支持多格式混合）
#   4. 按 DEVELOPMENT_WORKFLOW.md 的步骤开始工作流
# ============================================================================

set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"

ok()   { echo -e "  \033[32mOK  \033[0m $1"; }
skip() { echo -e "  \033[33mSKIP\033[0m $1"; }
step() { echo -e "\n\033[36m[$1]\033[0m $2"; }

# ============================================================================
# Step 0: 检查 Node.js
# ============================================================================
step "0/10" "检查 Node.js 环境"
if ! command -v node &>/dev/null; then
    echo -e "  \033[31mERROR: Node.js 未安装。请安装 Node.js 18+ 后重试。\033[0m"
    echo -e "  下载地址：https://nodejs.org/"
    exit 1
fi
NODE_VER=$(node -v)
ok "Node.js $NODE_VER"

# ============================================================================
# Step 1: 创建 docs/ 目录结构（v3.0）
# ============================================================================
step "1/10" "创建 docs/ 目录结构（IDE 无关，v3.0）"
DIRS=(
    "docs/input"
    "docs/input/converted"
    "docs/specs"
    "docs/design/prototypes"
    "docs/design/screenshots"
    "docs/plans"
    "docs/reports"
    "docs/learning/entries"
)
for d in "${DIRS[@]}"; do
    fullpath="$ROOT/$d"
    if [ ! -d "$fullpath" ]; then
        mkdir -p "$fullpath"
        ok "创建 $d"
    else
        skip "$d 已存在"
    fi
done

# docs/input/README.md
if [ ! -f "$ROOT/docs/input/README.md" ]; then
    echo "# 此目录存放原始需求文档（PRD、用户故事、业务说明等）" > "$ROOT/docs/input/README.md"
    ok "创建 docs/input/README.md"
fi

# docs/input/converted/README.md
if [ ! -f "$ROOT/docs/input/converted/README.md" ]; then
    echo "# 此目录存放阶段零自动转换后的 Markdown 文件（AI 自动生成，不要手动放入）" > "$ROOT/docs/input/converted/README.md"
    ok "创建 docs/input/converted/README.md"
fi

# docs/reports/README.md
if [ ! -f "$ROOT/docs/reports/README.md" ]; then
    cat > "$ROOT/docs/reports/README.md" <<'EOF'
# 审查报告与对齐验证报告

此目录存放以下报告：
- req-validation-NNN.md — 需求反向校验报告（防线 B）
- req-grill-NNN.md — 需求交叉审问报告（防线 C）
- design-validation-NNN.md — 设计校验报告
- alignment-report.md — Spec 合规性对齐报告
- test-coverage-report.md — 测试覆盖验证报告
- delivery-report.md — 最终交付报告
- review-NNN.md — 代码审查报告
EOF
    ok "创建 docs/reports/README.md"
fi

# docs/learning/LEARNING.md（经验库索引）
if [ ! -f "$ROOT/docs/learning/LEARNING.md" ]; then
    cat > "$ROOT/docs/learning/LEARNING.md" <<'EOF'
# 经验库索引

> 本文件是经验库的索引表。AI 每次任务启动时读取此文件，
> 根据任务描述提取关键词，匹配"触发条件"列，
> 读取匹配到的经验全文（docs/learning/entries/ 下的文件），
> 在当前任务中强制执行经验中的规则。

> 任务结束后，如有新经验（踩坑/教训），追加到本索引表并写入 entries/ 目录。

| 编号 | 触发条件 | 经验文件 | 简述 |
|------|----------|----------|------|
| L-001 | 需求分析 + 多平台 | entries/platform-split-traps.md | 平台拆分常见陷阱 |
| L-002 | TDD + 测试失败 | entries/tdd-common-pitfalls.md | TDD 常见坑 |
| L-003 | API + 契约不一致 | entries/api-contract-checklist.md | API 契约检查清单 |
| L-004 | 质量门禁 + Null | entries/null-safety-patterns.md | Null 安全模式 |
| L-005 | 需求漂移 + 多了/少了 | entries/req-drift-prevention.md | 需求漂移防范清单 |

<!-- 新经验在此行下方追加 -->
EOF
    ok "创建 docs/learning/LEARNING.md（经验库索引）"
fi

# ============================================================================
# Step 2: 安装 Superpowers（运行安装器）
# ============================================================================
step "2/10" "安装 Superpowers（运行安装器）"
if [ -f "$ROOT/.claude/instructions.md" ]; then
    skip ".claude/instructions.md 已存在，跳过安装器"
else
    echo "  运行 npx @agilite-2025/superpowers ..."
    npx @agilite-2025/superpowers || true
    if [ -f "$ROOT/.claude/instructions.md" ]; then
        ok "Superpowers 安装完成"
    else
        echo -e "  \033[33mWARN: 安装器可能未成功，将手动创建基础文件\033[0m"
    fi
fi

# ============================================================================
# Step 3: 配置 .claude/instructions.md（v3.0 融合版）
# ============================================================================
step "3/10" "配置 .claude/instructions.md（v3.0 融合版）"
INSTRUCTIONS_FILE="$ROOT/.claude/instructions.md"

if [ -f "$INSTRUCTIONS_FILE" ]; then
    if grep -q "Spec-Driven Development.*v3" "$INSTRUCTIONS_FILE"; then
        skip "v3.0 Spec-Driven Development 段落已存在"
    else
        # 追加 v3.0 段落
        cat >> "$INSTRUCTIONS_FILE" <<'SPEC_EOF'

## Spec-Driven Development（v3.0 BMAD + Superpowers + BOSS 融合）

本项目使用 BMAD + Superpowers + BOSS 融合工作流。所有规范文档存放在 `docs/` 目录（IDE 无关），详见 `DEVELOPMENT_WORKFLOW.md`。

### 七大设计原则
1. 文档即真理：所有变更先改 Spec，再改代码
2. 测试即真理：测试用例必须覆盖所有 AC
3. 需求反向校验：阶段一必须生成校验报告和交叉审问报告
4. 平台精准拆分：混合 PRD 必须按平台拆分需求
5. YAGNI：不添加 Spec 未提及的功能
6. 经验自动沉淀：踩坑/教训写入 docs/learning/
7. 流水线自动接力：阶段间自动衔接，人工只参与审批门禁

### 质量门禁（6 道关卡）
编译 / Null 安全 / API 契约 / 事务 / 并发 / 错误处理

### 工作流阶段
| 阶段 | 输入 | 产出 | 门禁 |
|------|------|------|------|
| 零·文档转换 | docs/input/*.{doc,docx,pdf} | docs/input/converted/*.md | 无 |
| 一·需求规格化 | 转换后 .md | requirements.md + 校验报告 | Gate 1 |
| 二·设计产出 | requirements.md | design-system + prototypes + design-spec + tech-spec | Gate 2 |
| 三·任务拆解 | tech-spec + design-spec | plans/plan-NNN-platform-*.md | Gate 3 |
| 四·TDD 实现 | plans/ + 所有 Spec | 源代码 + 测试代码 | 测试+门禁全绿 |
| 五·对齐验证 | 代码 + 测试 + Spec | reports/ + learning/ | 审查通过 |

### 流水线提示词
| 阶段 | 提示词 |
|------|--------|
| 0+1 | 流水线执行阶段 0+1 |
| 2 | 流水线执行阶段 2 |
| 3 | 流水线执行阶段 3 |
| 4 | 流水线执行阶段 4 |
| 5 | 流水线执行阶段 5 |
SPEC_EOF
        ok "已追加 v3.0 Spec-Driven Development 段落"
    fi
else
    # 安装器未创建文件，手动创建
    mkdir -p "$ROOT/.claude"
    cat > "$INSTRUCTIONS_FILE" <<'BASIC_EOF'
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

## Spec-Driven Development（v3.0 BMAD + Superpowers + BOSS 融合）

本项目使用 BMAD + Superpowers + BOSS 融合工作流。所有规范文档存放在 `docs/` 目录（IDE 无关），详见 `DEVELOPMENT_WORKFLOW.md`。

### 七大设计原则
1. 文档即真理：所有变更先改 Spec，再改代码
2. 测试即真理：测试用例必须覆盖所有 AC
3. 需求反向校验：阶段一必须生成校验报告和交叉审问报告
4. 平台精准拆分：混合 PRD 必须按平台拆分需求
5. YAGNI：不添加 Spec 未提及的功能
6. 经验自动沉淀：踩坑/教训写入 docs/learning/
7. 流水线自动接力：阶段间自动衔接，人工只参与审批门禁

### 质量门禁（6 道关卡）
编译 / Null 安全 / API 契约 / 事务 / 并发 / 错误处理

### 工作流阶段
| 阶段 | 输入 | 产出 | 门禁 |
|------|------|------|------|
| 零·文档转换 | docs/input/*.{doc,docx,pdf} | docs/input/converted/*.md | 无 |
| 一·需求规格化 | 转换后 .md | requirements.md + 校验报告 | Gate 1 |
| 二·设计产出 | requirements.md | design-system + prototypes + design-spec + tech-spec | Gate 2 |
| 三·任务拆解 | tech-spec + design-spec | plans/plan-NNN-platform-*.md | Gate 3 |
| 四·TDD 实现 | plans/ + 所有 Spec | 源代码 + 测试代码 | 测试+门禁全绿 |
| 五·对齐验证 | 代码 + 测试 + Spec | reports/ + learning/ | 审查通过 |

### 流水线提示词
| 阶段 | 提示词 |
|------|--------|
| 0+1 | 流水线执行阶段 0+1 |
| 2 | 流水线执行阶段 2 |
| 3 | 流水线执行阶段 3 |
| 4 | 流水线执行阶段 4 |
| 5 | 流水线执行阶段 5 |
BASIC_EOF
    ok "已创建 .claude/instructions.md（v3.0 融合版）"
fi

# ============================================================================
# Step 4: 创建 .claude/project-context.md
# ============================================================================
step "4/10" "创建 .claude/project-context.md"
PC_FILE="$ROOT/.claude/project-context.md"
if [ -f "$PC_FILE" ]; then
    skip ".claude/project-context.md 已存在"
else
    mkdir -p "$ROOT/.claude"
    cat > "$PC_FILE" <<'EOF'
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
EOF
    ok "创建 .claude/project-context.md"
fi

# ============================================================================
# Step 5: 创建 AGENTS.md（v3.0）
# ============================================================================
step "5/10" "创建 AGENTS.md（CatPaw / Codex 入口，v3.0）"
AGENTS_FILE="$ROOT/AGENTS.md"
if [ -f "$AGENTS_FILE" ]; then
    skip "AGENTS.md 已存在"
else
    cat > "$AGENTS_FILE" <<'EOF'
# AGENTS.md — CatPaw / Codex / 通用 Agent 入口

> 本项目使用 BMAD + Superpowers + BOSS 融合工作流（v3.0）。
> 完整工作流文档见 `DEVELOPMENT_WORKFLOW.md`。

## 全局纪律（适用于所有角色）

### CRITICAL RULES
- **NEVER touch code without approval**: Explain problem definition → List possible solutions → Wait for user approval → ONLY then write/edit code
- **NEVER use git**: User runs ALL git commands
- **NEVER spawn sub-agents**: Do all analysis directly
- **Do not assume, always check**: Validate code, trace execution, verify assumptions

### 质量门禁（6 道关卡）
编译 / Null 安全 / API 契约 / 事务 / 并发 / 错误处理

### Spec-Driven Development
所有规范文档存放在 `docs/` 目录（IDE 无关）。

### 防需求漂移三道防线
A·正向提取 / B·反向校验 / C·交叉审问

### 经验库机制
每次任务开始先读取 `docs/learning/LEARNING.md` 索引表，匹配触发条件，加载经验全文。

## 角色

### Developer
- 实现：按 tech-spec.md 和 design-spec.md 构建功能
- TDD：先写测试 → 失败 → 写代码 → 通过 → 重构
- YAGNI：禁止添加 Spec 未提及的功能
- 禁止：git、子任务生成

### Quality Architect
- 独立质量审查：只为用户工作，不为开发团队
- Spec 合规：代码与 tech-spec / design-spec / requirements 逐条对齐
- 输出裁定：APPROVE / REQUEST CHANGES / BLOCK

## 角色切换

```
以 Developer 角色执行：流水线执行阶段 4
以 Quality Architect 角色执行：审查代码规格合规性
```

## 流水线提示词速查

| 阶段 | 提示词 |
|------|--------|
| 0+1 | `流水线执行阶段 0+1` |
| 2 | `流水线执行阶段 2` |
| 3 | `流水线执行阶段 3` |
| 4 | `流水线执行阶段 4` |
| 5 | `流水线执行阶段 5` |
EOF
    ok "创建 AGENTS.md（v3.0）"
fi

# ============================================================================
# Step 6: 创建 CLAUDE.md（v3.0）
# ============================================================================
step "6/10" "创建 CLAUDE.md（Claude Code 入口，v3.0）"
CLAUDE_MD="$ROOT/CLAUDE.md"
if [ -f "$CLAUDE_MD" ]; then
    skip "CLAUDE.md 已存在"
else
    cat > "$CLAUDE_MD" <<'EOF'
# CLAUDE.md — Claude Code 入口文件

> 本项目使用 BMAD + Superpowers + BOSS 融合工作流（v3.0）。
> 完整工作流文档见 `DEVELOPMENT_WORKFLOW.md`。

## 启动检查清单（每次会话开始时读取）

1. 读取 `.claude/instructions.md` 获取全局纪律规则
2. 读取 `.claude/project-context.md` 获取项目信息
3. 读取 `docs/learning/LEARNING.md` 获取经验索引（如存在）
4. 根据当前任务匹配经验触发条件，加载相关经验全文

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
EOF
    ok "创建 CLAUDE.md（v3.0）"
fi

# ============================================================================
# Step 7: 创建 .cursor/rules/*.mdc 文件（v3.0）
# ============================================================================
step "7/10" "创建 .cursor/rules/*.mdc 文件（CatPaw / Cursor 角色规则，v3.0）"
mkdir -p "$ROOT/.cursor/rules"

# --- instructions.mdc ---
if [ ! -f "$ROOT/.cursor/rules/instructions.mdc" ]; then
    cat > "$ROOT/.cursor/rules/instructions.mdc" <<'EOF'
---
description: 全局纪律规则 - Approval Workflow、Mental Model Execution、Guardrails、Spec-Driven Development、防需求漂移、质量门禁
globs: ["**/*"]
alwaysApply: true
---

# 全局纪律规则（v3.0 BMAD + Superpowers + BOSS 融合）

## CRITICAL RULES
- **NEVER touch code without approval**
- **NEVER use git**: User runs ALL git commands
- **NEVER spawn sub-agents**: Do all analysis directly
- **Do not assume, always check**

## 质量门禁（6 道关卡）
编译 / Null 安全 / API 契约 / 事务 / 并发 / 错误处理

## 防需求漂移三道防线
A·正向提取 / B·反向校验 / C·交叉审问

## 经验库机制
每次任务开始先读取 `docs/learning/LEARNING.md` 索引表。

## 工作流阶段
| 阶段 | 输入 | 产出 | 门禁 |
|------|------|------|------|
| 零·文档转换 | docs/input/*.{doc,docx,pdf} | docs/input/converted/*.md | 无 |
| 一·需求规格化 | 转换后 .md | requirements.md + 校验报告 | Gate 1 |
| 二·设计产出 | requirements.md | design-system + prototypes + design-spec + tech-spec | Gate 2 |
| 三·任务拆解 | tech-spec + design-spec | plans/plan-NNN-platform-*.md | Gate 3 |
| 四·TDD 实现 | plans/ + 所有 Spec | 源代码 + 测试代码 | 测试+门禁全绿 |
| 五·对齐验证 | 代码 + 测试 + Spec | reports/ + learning/ | 审查通过 |
EOF
    ok "创建 .cursor/rules/instructions.mdc（v3.0）"
else
    skip ".cursor/rules/instructions.mdc 已存在"
fi

# --- developer.mdc ---
if [ ! -f "$ROOT/.cursor/rules/developer.mdc" ]; then
    cat > "$ROOT/.cursor/rules/developer.mdc" <<'EOF'
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

## 完成标准
- [ ] 按 requirements.md 的验收标准实现功能
- [ ] 每个实现能追溯到 REQ 编号
- [ ] 测试编写并通过
- [ ] 质量门禁 6 道关卡全绿
- [ ] Mental Model Execution 完成
EOF
    ok "创建 .cursor/rules/developer.mdc（v3.0）"
else
    skip ".cursor/rules/developer.mdc 已存在"
fi

# --- quality-architect.mdc ---
if [ ! -f "$ROOT/.cursor/rules/quality-architect.mdc" ]; then
    cat > "$ROOT/.cursor/rules/quality-architect.mdc" <<'EOF'
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
EOF
    ok "创建 .cursor/rules/quality-architect.mdc（v3.0）"
else
    skip ".cursor/rules/quality-architect.mdc 已存在"
fi

# --- qa-engineer.mdc ---
if [ ! -f "$ROOT/.cursor/rules/qa-engineer.mdc" ]; then
    cat > "$ROOT/.cursor/rules/qa-engineer.mdc" <<'EOF'
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
EOF
    ok "创建 .cursor/rules/qa-engineer.mdc（v3.0）"
else
    skip ".cursor/rules/qa-engineer.mdc 已存在"
fi

# --- sdet.mdc ---
if [ ! -f "$ROOT/.cursor/rules/sdet.mdc" ]; then
    cat > "$ROOT/.cursor/rules/sdet.mdc" <<'EOF'
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
EOF
    ok "创建 .cursor/rules/sdet.mdc（v3.0）"
else
    skip ".cursor/rules/sdet.mdc 已存在"
fi

# ============================================================================
# Step 8: 创建 .vscode/ 工作区配置（CatPaw）
# ============================================================================
step "8/10" "创建 .vscode/ 工作区配置（CatPaw）"
mkdir -p "$ROOT/.vscode"

if [ ! -f "$ROOT/.vscode/settings.json" ]; then
    cat > "$ROOT/.vscode/settings.json" <<'EOF'
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
EOF
    ok "创建 .vscode/settings.json"
else
    skip ".vscode/settings.json 已存在"
fi

if [ ! -f "$ROOT/.vscode/extensions.json" ]; then
    cat > "$ROOT/.vscode/extensions.json" <<'EOF'
{
    "recommendations": []
}
EOF
    ok "创建 .vscode/extensions.json"
else
    skip ".vscode/extensions.json 已存在"
fi

# ============================================================================
# Step 9: 安装 .skills/ 目录（BOSS 技能体系）
# ============================================================================
step "9/10" "安装 .skills/ 目录（BOSS 技能体系）"
if [ -f "$ROOT/.skills/SKILL.md" ]; then
    skip ".skills/ 目录已存在"
else
    # 创建技能目录结构
    SKILL_DIRS=(
        ".skills/references"
        ".skills/convert-documents"
        ".skills/requirement"
        ".skills/architect"
        ".skills/designer"
        ".skills/planner"
        ".skills/backend"
        ".skills/frontend"
        ".skills/test"
        ".skills/review"
        ".skills/quality-gate"
        ".skills/grill"
        ".skills/alignment"
        ".skills/loop"
    )
    for d in "${SKILL_DIRS[@]}"; do
        fullpath="$ROOT/$d"
        if [ ! -d "$fullpath" ]; then
            mkdir -p "$fullpath"
        fi
    done
    ok "创建 .skills/ 目录结构"

    echo -e "  \033[33mNOTE: 技能 SKILL.md 文件需要从 bmad-superpowers-method 项目复制\033[0m"
    echo -e "       将 .skills/ 目录下所有 SKILL.md 文件复制到此处"
    echo -e "       或直接将整个 .skills/ 目录复制到新项目根目录"
fi

# ============================================================================
# Step 10: 检查 DEVELOPMENT_WORKFLOW.md
# ============================================================================
step "10/10" "检查 DEVELOPMENT_WORKFLOW.md"
if [ -f "$ROOT/DEVELOPMENT_WORKFLOW.md" ]; then
    if grep -q "v3" "$ROOT/DEVELOPMENT_WORKFLOW.md"; then
        ok "DEVELOPMENT_WORKFLOW.md 已是 v3.0 版本"
    else
        echo -e "  \033[33mWARN: DEVELOPMENT_WORKFLOW.md 不是 v3.0 版本\033[0m"
        echo -e "       请从 bmad-superpowers-method 项目复制最新版本"
    fi
else
    echo -e "  \033[33mWARN: DEVELOPMENT_WORKFLOW.md 不存在\033[0m"
    echo -e "       请从 bmad-superpowers-method 项目复制 DEVELOPMENT_WORKFLOW.md 到项目根目录"
fi

# ============================================================================
# 总结
# ============================================================================
echo ""
echo -e "\033[36m============================================\033[0m"
echo -e "\033[32m  v3.0 初始化完成！（BMAD + Superpowers + BOSS 融合）\033[0m"
echo -e "\033[36m============================================\033[0m"
echo ""
echo "已创建的文件结构："
echo "  docs/input/                # 放入需求文档（.md/.doc/.docx/.pdf，可多格式混合）"
echo "  docs/input/converted/      # 阶段零自动转换后的 Markdown"
echo "  docs/specs/                # AI 将在此生成 requirements/design-spec/tech-spec"
echo "  docs/design/               # AI 将在此生成 design-system/prototypes/screenshots"
echo "  docs/plans/                # AI 将在此生成 plan-NNN-platform-*.md"
echo "  docs/reports/              # AI 将在此生成校验/审查/对齐报告"
echo "  docs/learning/             # 经验库（LEARNING.md + entries/）"
echo "  .skills/                   # BOSS 技能体系（14 个子技能 + 主调度器）"
echo "  .claude/                   # Claude Code 配置（v3.0）"
echo "  .cursor/rules/             # CatPaw / Cursor 角色规则（5 个 .mdc 文件）"
echo "  .vscode/                   # CatPaw / VS Code 工作区配置"
echo "  AGENTS.md                  # CatPaw / Codex 入口（v3.0）"
echo "  CLAUDE.md                  # Claude Code 入口（v3.0）"
echo ""
echo -e "\033[33m下一步：\033[0m"
echo "  1. 将需求文档放入 docs/input/（支持多格式混合，如 prd-backend.docx + prd-app.pdf）"
echo "  2. （可选）编辑 .claude/project-context.md 填写项目信息"
echo "  3. 在 AI IDE 中发送流水线提示词："
echo -e "     \033[36m流水线执行阶段 0+1\033[0m"
echo -e "     （自动转换文档 → 识别平台 → 按平台拆分需求 → 生成 requirements.md → 反向校验 → 交叉审问）"
echo ""
echo "  完整流程详见 DEVELOPMENT_WORKFLOW.md"
echo ""
