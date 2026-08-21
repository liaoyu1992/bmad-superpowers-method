# 经验库机制详细说明

## 索引表格式（LEARNING.md）

```markdown
# 经验索引表

| 编号 | 关键词 | 触发条件 | 经验文件 | 严重程度 |
|------|--------|----------|----------|----------|
| 001 | 事务遗漏 | 涉及数据库写操作 | entries/001-transaction-missing.md | P0 |
| 002 | 平台串台 | 多平台需求拆分 | entries/002-platform-cross.md | P1 |
| 003 | AC 不可测 | 编写验收标准 | entries/003-untestable-ac.md | P1 |
```

## 经验全文格式（entries/NNN-keyword.md）

```markdown
# 经验 001：事务遗漏导致数据不一致

## 触发条件
- 涉及数据库写操作（INSERT/UPDATE/DELETE）
- 多表操作
- 涉及状态流转

## 问题描述
在用户注册流程中，先插入用户记录，再插入权限记录。如果第二步失败，用户记录已提交，导致数据不一致。

## 根因
- 未使用事务包裹多个写操作
- 异常处理在错误的位置

## 修复方案
所有涉及多表写操作必须包裹在事务中：
```typescript
await db.transaction(async (trx) => {
  const user = await User.insert(trx, userData);
  await Permission.insert(trx, { userId: user.id, role: 'user' });
});
```

## 检查清单
- [ ] 所有 INSERT/UPDATE/DELETE 是否在事务内？
- [ ] 事务是否正确提交/回滚？
- [ ] 异常时是否回滚？

## 强制执行
每次涉及数据库写操作时，必须执行上述检查清单。
```

## 自动加载流程

1. **任务开始时**：读取 `LEARNING.md` 索引表
2. **关键词匹配**：从任务描述和代码上下文提取关键词
3. **触发条件匹配**：检查是否有经验条目的触发条件被满足
4. **加载全文**：读取匹配到的 `entries/*.md`
5. **强制执行**：在当前任务中应用经验中的检查清单
6. **任务结束后**：如有新教训，写入新的经验条目并更新索引表
