---
name: test
description: 测试工程师技能。根据 requirements.md 中的验收标准（AC）编写和执行测试（单元/集成/E2E）。触发场景：流水线阶段四测试编写、流水线阶段五测试执行、用户说"写测试"、"跑测试"、"测试覆盖"时使用。
metadata:
  short-description: 测试编写与执行（单元/集成/E2E）
---

# test — 测试工程师

> 阶段四/五技能。编写和执行测试，确保覆盖所有验收标准。

## 执行步骤

1. **读取需求**：加载 `docs/specs/requirements.md`，提取所有 AC
2. **读取计划**：加载 `docs/plans/` 下相关计划
3. **生成测试覆盖矩阵**：AC ←→ 测试用例映射
4. **编写测试**：按 TDD 流程先写测试
5. **执行测试**：运行测试套件
6. **生成报告**：`docs/reports/test-report-NNN.md`

## 测试覆盖矩阵

生成 `docs/reports/test-coverage-matrix.md`：

```markdown
| AC 编号 | AC 描述 | 测试文件 | 测试用例 | 状态 |
|---------|---------|----------|----------|------|
| AC-BE-001-01 | 注册成功返回 token | tests/auth.test.ts | "should register successfully" | ✅ 通过 |
| AC-BE-001-02 | 邮箱重复注册失败 | tests/auth.test.ts | "should fail on duplicate email" | ✅ 通过 |
```

**禁止**：任何 AC 没有对应测试用例。

## 测试类型

| 类型 | 范围 | 工具示例 |
|------|------|----------|
| 单元测试 | 函数/方法/组件 | Jest, Vitest |
| 集成测试 | 模块间交互 | Jest, Vitest |
| E2E 测试 | 用户完整流程 | Playwright, Cypress |

### E2E 测试流程（使用 Playwright）

当 AC 涉及用户完整操作链路时，编写 E2E 测试：

1. **导航**：`page.goto(url)` 打开目标页面
2. **操作**：按 AC 中的用户操作链路执行（点击、填表、选择）
3. **断言**：验证页面元素、URL 跳转、网络请求响应
4. **截图**：`page.screenshot()` 留存测试证据
5. **抓 console**：`page.on('console', ...)` 捕获控制台日志和错误
6. **抓网络**：`page.route(...)` 拦截/Mock API 请求，模拟异常场景
7. **清理**：测试后恢复数据状态

**MCP 工具协作**：可通过 **playwright** MCP 工具直接执行浏览器自动化，无需手动启动测试服务器。
- 调用前提：IDE 已安装 playwright MCP 插件

## Bug 报告格式

```markdown
## BUG-001: [简短描述]
- **严重程度**：P0/P1/P2/P3
- **文件:行号**：src/auth.ts:42
- **复现步骤**：
  1. ...
  2. ...
- **预期结果**：...
- **实际结果**：...
- **日志/截图**：...
- **对应 AC**：AC-BE-001-01
```

## 平台筛选检查

- 读取 `requirements.md` 头部的"本次实施范围"
- 只为实施范围内的平台编写和执行测试
- 排除平台的 AC 标注"本次不实施"，不生成测试用例

## 与经验库联动

- 读取 `docs/learning/LEARNING.md` 索引表
- 匹配"测试"或"TDD"触发条件
- 如有新经验，追加到 LEARNING.md 并写入 `docs/learning/entries/`

## 完成后

- 所有实施范围内的 AC 有对应测试 ✅
- 所有测试通过 ✅
- 生成测试报告 ✅
- 如有失败，输出 Bug 报告，**不自行修复**（交给 backend/frontend 技能）
