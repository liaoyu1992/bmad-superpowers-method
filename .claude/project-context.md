# 项目上下文

## 项目信息
- **项目名称**：[项目名称]
- **技术栈**：[填写技术栈，如 React + TypeScript + Node.js / Spring Boot + Java]
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
