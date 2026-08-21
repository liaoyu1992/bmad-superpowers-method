---
name: convert-documents
description: 自动将 docs/input/ 下的 Word/PDF/TXT 需求文档转换为 Markdown。触发场景：流水线阶段零、用户说"转换文档"、"转MD"、docs/input/ 下有 .doc/.docx/.pdf 文件需要处理时使用。
metadata:
  short-description: Word/PDF → Markdown 自动转换
---

# convert-documents — 需求文档自动转换

> 阶段零技能。将 `docs/input/` 下所有非 Markdown 文档自动转换为 Markdown。

## 执行步骤

1. **扫描** `docs/input/` 目录（不含 `converted/` 子目录）下所有文件
2. **按格式转换**：

| 格式 | 工具 | 命令 |
|------|------|------|
| `.md` | 无需转换 | 跳过 |
| `.doc` / `.docx` | pandoc | `pandoc input.docx -o converted/output.md --extract-media=converted/media/` |
| `.pdf` | pymupdf 或 pandoc | `pandoc input.pdf -o converted/output.md` 或 Python pymupdf |
| `.txt` | 直接复制 | 重命名为 `.md` |

3. **存入** `docs/input/converted/` 目录
4. **图片提取**到 `docs/input/converted/media/`
5. **生成转换清单**写入 `docs/input/converted/CONVERSION_LOG.md`

## 转换后验证

- 转换后的 `.md` 文件是否非空
- 是否有图片丢失
- 中文是否乱码

发现问题记录到 `CONVERSION_LOG.md` 警告部分，不阻断流程但提示人工检查。

## CONVERSION_LOG.md 格式

```markdown
# 文档转换清单

| 原始文件 | 格式 | 转换后文件 | 图片数 | 状态 |
|----------|------|------------|--------|------|
| prd-backend.docx | docx | prd-backend.md | 3 | ✅ 成功 |
| prd-app.pdf | pdf | prd-app.md | 0 | ✅ 成功 |
| prd-pc.md | md | — | — | ⏭️ 跳过 |

## 警告
（如有问题在此列出）
```

## 支持的格式

| 格式 | 工具 | 说明 |
|------|------|------|
| `.md` | 无需转换 | 直接跳过 |
| `.doc` / `.docx` | pandoc / mammoth | Word 文档 |
| `.pdf` | pymupdf / pandoc | PDF 文档 |
| `.txt` | 直接复制 | 重命名为 `.md` |
| `.ppt` / `.pptx` | pandoc / markitdown | PPT 演示文稿 |
| `.xls` / `.xlsx` | markitdown / Python openpyxl | Excel 表格 |
| 其他 | markitdown | markitdown 支持 25+ 格式 |

## pandoc 不可用时的降级方案

1. 尝试 `npx mammoth --output-format=markdown` 转换 Word
2. 尝试 Python `pymupdf` 转换 PDF
3. 尝试 `npx markitdown` 转换 PPT/Excel 等 25+ 格式
4. 如都不可用，提示安装命令，将原文件保留在 `docs/input/`，AI 直接读取

## 与经验库联动

- 读取 `docs/learning/LEARNING.md` 索引表
- 匹配"文档转换"触发条件
- 如转换中发现常见问题（如乱码、图片丢失），追加到 LEARNING.md

## 完成后

自动进入阶段一（`requirement` 技能）。
