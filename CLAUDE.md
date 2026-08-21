# CLAUDE.md — Claude Code 入口文件

> 本项目使用 BMAD + Superpowers + BOSS 融合工作流（v3.0）。
> 完整工作流文档见 `DEVELOPMENT_WORKFLOW.md`。

## 启动检查清单（每次会话开始时读取）

1. 读取 `.claude/instructions.md` 获取全局纪律规则
2. 读取 `.claude/project-context.md` 获取项目信息
3. 读取 `docs/learning/LEARNING.md` 获取经验索引（如存在）
4. 根据 当前任务 匹配经验触发条件，加载相关经验全文

## 角色切换

```
Start Developer session          # 开发工程师
Start Quality Architect session  # 质量架构师
Start QA session                 # QA 工程师
Start SDET session               # 测试自动化工程师
Start Orchestrator session       # 编排器
```

## 流水线提示词

| 阶段 | 提示词 |
|------|--------|
| 0+1（转换+需求） | `流水线执行阶段 0+1` |
| 2（设计产出） | `流水线执行阶段 2` |
| 3（任务拆解） | `流水线执行阶段 3` |
| 4（TDD 实现） | `流水线执行阶段 4` |
| 5（对齐验证） | `流水线执行阶段 5` |

## 核心纪律

1. **文档即真理**：所有变更先改 `docs/specs/` 下的 Spec，再改代码
2. **测试即真理**：测试用例必须覆盖所有验收标准（AC）
3. **需求反向校验**：阶段一必须生成校验报告（防线 B）和交叉审问报告（防线 C）
4. **平台精准拆分**：混合 PRD 必须按平台（后端/PC/APP/小程序）拆分需求
5. **YAGNI**：禁止添加 Spec 未提及的功能
6. **经验自动沉淀**：踩坑/教训写入 `docs/learning/`
7. **Approval Workflow**：代码修改前必须获得人工批准
8. **质量门禁**：6 道关卡全绿才可提交（编译/Null/契约/事务/并发/错误处理）
9. **禁止自行执行 git 命令**

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
