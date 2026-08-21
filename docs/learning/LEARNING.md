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
