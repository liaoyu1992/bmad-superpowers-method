# Claude Instructions (v3.0 — BMAD + Superpowers + BOSS 融合)

# --- SUPERPOWERS:START ---

## CRITICAL RULES - READ EVERY SESSION
- **NEVER touch code without approval**: Explain problem definition → List possible solutions → Wait for user approval → ONLY then write/edit code
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

## Spec-Driven Development（v3.0 融合版）

本项目使用 BMAD + Superpowers + BOSS 融合工作流。详见 `DEVELOPMENT_WORKFLOW.md`。

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

1. **文档即真理**：所有变更先改 `docs/specs/` 下的 Spec，再改代码
2. **测试即真理**：测试用例必须覆盖 `requirements.md` 中所有验收标准（AC）
3. **需求反向校验**：阶段一必须生成校验报告（防线 B）和交叉审问报告（防线 C）
4. **平台精准拆分**：混合 PRD 必须按平台（后端/PC/APP/小程序）拆分需求
5. **YAGNI**：不添加 Spec 未提及的功能
6. **经验自动沉淀**：踩坑/教训写入 `docs/learning/`
7. **流水线自动接力**：阶段间自动衔接，人工只参与审批门禁

### 质量门禁（借鉴 BOSS /quality-gate）

每个功能模块完成后必须通过 6 道关卡：

| 关卡 | 检查内容 | 通过标准 |
|------|----------|----------|
| 编译 | 代码是否通过编译/类型检查 | 0 error |
| Null 安全 | 是否有空指针风险 | 无未处理的 null |
| API 契约 | 接口定义是否与 tech-spec 一致 | 100% 对齐 |
| 事务 | 涉及数据库操作是否有事务包裹 | 所有写操作有事务 |
| 并发 | 是否有并发安全问题 | 无竞态条件 |
| 错误处理 | 是否有未捕获的异常 | 快速失败，不静默吞错 |

### 防需求漂移三道防线

| 防线 | 时机 | 检查内容 |
|------|------|----------|
| A·正向提取 | AI 生成 Spec 时 | 每条 Spec 必须标注原文出处 |
| B·反向校验 | Spec 生成后 | 原文每条 ←→ Spec 每条，有没有多了/少了 |
| C·交叉审问 | 人工审批前 | 术语一致性、业务冲突、平台串台、YAGNI 违规 |

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
| 0+1（转换+需求） | `流水线执行阶段 0+1` |
| 2（设计产出） | `流水线执行阶段 2` |
| 3（任务拆解） | `流水线执行阶段 3` |
| 4（TDD 实现） | `流水线执行阶段 4` |
| 5（对齐验证） | `流水线执行阶段 5` |

### 经验库机制

- 每次任务开始先读取 `docs/learning/LEARNING.md` 索引表
- 从任务描述提取关键词，匹配索引中的"触发条件"
- 读取匹配到的经验全文，在当前任务中强制执行
- 任务结束后将新经验写回
