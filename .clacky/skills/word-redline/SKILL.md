---
name: word-redline
description: 为 Word/WPS 文档添加批注（Comments）和修订（Track Changes）。当用户给出一个 .docx 文件，并提出修改意见、批注建议、或扮演审核角色（如律师审合同）时使用本技能。输出一个包含真正 Word 修订标记和批注气泡的新 .docx 文件，在 Word 和 WPS 中均可正常显示。
---

# Word 文档批注与修订 Skill

## 核心工具

`scripts/word_editor.py` — 操作 OpenXML，直接向 .docx 写入批注和修订。

```bash
python3 word_editor.py <input.docx> <instructions.json> [output.docx]
```

- 输出默认为 `原文件名_reviewed.docx`
- 作者信息自动从文档 `docProps/core.xml` 读取（兼容 Word 和 WPS）

## 工作流程

### 第一步：理解用户意图

用户可能以两种方式表达需求：

**A. 明确指令**：「删除第三条'甲方不承担责任'，改成'甲方依法承担责任'」「在违约金条款加批注，提示风险」

**B. 角色扮演**：「你是一名律师，帮我审这份合同」→ 先阅读文档，自行找出问题，再生成指令

### 第二步：读取文档内容

```bash
# 解压查看文档文字（可选，用于角色扮演模式）
python3 -c "
import zipfile, os
from lxml import etree
with zipfile.ZipFile('input.docx') as z:
    xml = z.read('word/document.xml')
root = etree.fromstring(xml)
W = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
texts = [t.text for t in root.iter(f'{{{W}}}t') if t.text]
print(''.join(texts))
"
```

### 第三步：生成 instructions.json

根据用户意见或自主审查结果，生成指令文件。格式见 `references/instructions-format.md`。

**批注**：用于「标注问题、提出建议、风险提示」，不改动原文
**修订**：用于「实际修改文字」，Word 显示删除线+新增内容

### 第四步：执行并输出

```bash
python3 ~/.openclaw/workspace/skills/word-redline/scripts/word_editor.py \
  input.docx instructions.json output_reviewed.docx
```

检查输出：
- 无报错 → 发送给用户
- 有 `[WARN] 未找到...` → 检查 `target_text` / `old_text` 是否与文档内容精确匹配

## 依赖

```bash
pip install lxml
```

`python-docx` 不需要。脚本直接操作 XML，兼容性更好。

## 参考

- 批注/修订 JSON 格式：`references/instructions-format.md`
- OpenXML 技术原理：~/Desktop/Word文档批注与修订模式技术原理.md
