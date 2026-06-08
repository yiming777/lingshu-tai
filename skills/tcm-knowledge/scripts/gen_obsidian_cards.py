#!/usr/bin/env python3
"""Generate Obsidian cards from zhongyao/ database - v2 fixed section parsing."""

import re, os

OBSIDIAN_DIR = os.path.expanduser("~/Documents/Obsidian Vault/00-卡片/中药/")
ZHONGYAO_DIR = os.path.expanduser("~/.openclaw/workspace/skills/tcm-knowledge/references/zhongyao/")

FILES = [
    "zhongyao-biao-li-re.md",
    "zhongyao-qing-re.md",
    "zhongyao-shi-wen.md",
    "zhongyao-qi-xue.md",
    "zhongyao-huo-xue.md",
    "zhongyao-wen-hua.md",
    "zhongyao-tan-shen-feng.md",
    "zhongyao-bu-yi-se.md", "zhongyao-shou-se.md",
]

# Chinese section name → English key mapping
SECTION_MAP = {
    '功效': 'efficacy',
    '常用剂量': 'dosage',
    '用法': 'usage',
    '毒性': 'toxicity_raw',
    '禁忌': 'contraindications',
    '配伍': 'compatibility',
    '炮制': 'paozhi',
    '药理': 'pharmacology',
}

def extract_drug_blocks(content):
    blocks = []
    current = []
    in_drug = False
    for line in content.split('\n'):
        if line.startswith('### '):
            if current:
                blocks.append('\n'.join(current))
            current = [line]
            in_drug = True
        elif in_drug and line.strip() == '---':
            continue
        elif in_drug:
            current.append(line)
    if current:
        blocks.append('\n'.join(current))
    return blocks

def parse_drug(block):
    lines = block.strip().split('\n')
    
    name_match = re.match(r'^###\s+(.+?)\s+【(\w+-\d+)】', lines[0])
    name = name_match.group(1).strip() if name_match else ""
    code = name_match.group(2) if name_match else ""
    
    if not name:
        return None
    
    # Collect all raw data
    sections = {}
    current_section = 'meta'  # metadata before any ####
    section_lines = []
    
    for line in lines[1:]:
        stripped = line.strip()
        
        if stripped.startswith('#### '):
            if current_section:
                sections[current_section] = '\n'.join(section_lines).strip()
            section_name = stripped.replace('#### ', '').strip()
            eng_name = SECTION_MAP.get(section_name, section_name)
            current_section = eng_name
            section_lines = []
            continue
        
        if stripped:
            section_lines.append(stripped)
    
    # Flush last section
    if current_section:
        sections[current_section] = '\n'.join(section_lines).strip()
    
    # Extract meta fields from the 'meta' section
    meta = sections.get('meta', '')
    meta_lines = meta.split('\n')
    
    pinyin = ''
    category = ''
    flavor = ''
    meridian = ''
    
    for ml in meta_lines:
        if '拼音' in ml:
            pinyin = ml.split('：', 1)[-1].strip() if '：' in ml else ''
        elif '分类' in ml:
            category = ml.split('：', 1)[-1].strip() if '：' in ml else ''
        elif '性味归经' in ml:
            raw = ml.split('：', 1)[-1].strip() if '：' in ml else ''
            parts = raw.split('；', 1)
            flavor = parts[0]
            meridian = parts[-1] if len(parts) > 1 else ''
    
    # Extract origin/modern note from raw block
    origin_source = ''
    origin_text = ''
    modern_note = ''
    
    for ml in block.split('\n'):
        s = ml.strip()
        if s.startswith('- 来源') or s.startswith('来源') and '：' in s:
            origin_source = s.split('：', 1)[-1].strip()
        elif s.startswith('- 原文') and '：' in s:
            origin_text = s.split('：', 1)[-1].strip().strip('"')
        elif s.startswith('- 现代注解') and '：' in s:
            modern_note = s.split('：', 1)[-1].strip()
    
    # Toxicity parsing
    toxicity_raw = sections.get('toxicity_raw', '')
    safety_display = ''
    
    # Collect toxicity lines (skip safety markers)
    tox_lines = []
    for tl in toxicity_raw.split('\n') if toxicity_raw else []:
        line = tl.strip('- ').strip()
        if '安全分级' in line:
            safety_display = line.split('：', 1)[-1].strip() if '：' in line else ''
        elif line:
            tox_lines.append(line)
    
    toxicity_display = '\n'.join(tox_lines) if tox_lines else '无毒'
    
    # Safety from meta as fallback
    if not safety_display and '安全分级' in meta:
        for ml in meta_lines:
            if '安全分级' in ml:
                safety_display = ml.split('：', 1)[-1].strip() if '：' in ml else ''
    
    return {
        'name': name,
        'code': code,
        'pinyin': pinyin,
        'category': category,
        'flavor': flavor,
        'meridian': meridian,
        'efficacy': sections.get('efficacy', ''),
        'dosage': sections.get('dosage', ''),
        'usage': sections.get('usage', ''),
        'toxicity': toxicity_display,
        'safety': safety_display,
        'contraindications': sections.get('contraindications', ''),
        'compatibility': sections.get('compatibility', ''),
        'pharmacology': sections.get('pharmacology', ''),
        'origin_source': origin_source,
        'origin_text': origin_text,
        'modern_note': modern_note,
    }

def build_card(data):
    today = "2026-06-08"
    
    cat = data['category']
    cat_parts = cat.split('·')
    cat_tag = cat_parts[0] if cat_parts else cat
    
    # Format toxicity
    tox = data['toxicity']
    if data['safety']:
        tox = f"{tox}\n\n**安全分级**：{data['safety']}"
    
    card = f"""---
tags: [中药, {cat_tag}]
created: {today}
source: 灵枢台知识底座·中药数据库 v0.4
verified: candidate
---

# {data['name']}

- **拼音**：{data['pinyin']}
- **分类**：{data['category']}
- **编码**：{data['code']}

## 性味归经
- **性味**：{data['flavor']}
- **归经**：{data['meridian']}

## 常用剂量
{data['dosage'] or '（待完善）'}

## 功效
{data['efficacy'] or '（待完善）'}

## 禁忌
{data['contraindications'] or '（待完善）'}

## 毒性
{tox or '无毒'}

## 配伍
{data['compatibility'] or '（待完善）'}

## 用法
{data['usage'] or '常规煎煮'}

## 药理
{data['pharmacology'] or '（尚未收录）'}

## 出处
- **来源**：{data['origin_source'] or data['category']}
- **原文**：{data['origin_text'] or '（尚未收录）'}

## 现代注解
{data['modern_note'] or '（尚未收录）'}

## 出现于
```dataview
LIST
FROM "00-卡片/方剂"
WHERE contains(组成, this.file.name)
```
"""
    return card

def main():
    count = 0
    
    for fname in FILES:
        filepath = os.path.join(ZHONGYAO_DIR, fname)
        if not os.path.exists(filepath):
            continue
        
        with open(filepath, 'r') as f:
            content = f.read()
        
        blocks = extract_drug_blocks(content)
        for block in blocks:
            data = parse_drug(block)
            if data and data['name']:
                card = build_card(data)
                out_path = os.path.join(OBSIDIAN_DIR, f"{data['name']}.md")
                with open(out_path, 'w') as f:
                    f.write(card)
                count += 1
                if count % 20 == 0:
                    print(f"  → {count} cards generated...")
    
    print(f"\nDone! Generated {count} Obsidian cards.")

if __name__ == '__main__':
    main()
