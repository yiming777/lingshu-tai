# 倪海厦课程截图桥接指南

> 灵枢台 · tcm-vision 参考文件
> 当需要方剂板书、穴位实操、病机图等视频证据时，复用 nihaisha-tcm 的截图检索系统

---

## 概述

[nihaisha-tcm](https://github.com/JuneYaooo/nihaisha-tcm) 已将倪海厦课程视频中的关键板书/PPT/实操画面提取为 2986 张 WebP 截图，并建立了按关键词检索的索引系统。

灵枢台通过本桥接指南，可以在以下场景中利用这些截图证据：

| 灵枢台场景 | nihaisha 截图来源 | 张数 |
|-----------|------------------|:---:|
| 方剂推荐（tcm-fangji）→ 需要方剂板书佐证 | 伤寒论 screenshot-evidence | 649 |
| 方剂推荐 → 金匮要略经方佐证 | 金匮要略 jingui-screenshot-evidence | 656 |
| 针灸配穴（tcm-zhenjiu）→ 需要穴位/经络图 | 针灸 acupuncture-screenshot-evidence | 501 |
| 拆方解方（tcm-chaifang）→ 需要仲景心法病机图 | 仲景心法 zhongjing-xinfa-screenshot-evidence | 68 |
| 本草药性查询 → 需要药物图文 | 神农本草 bencao-screenshot-evidence | 127 |
| 内经理论 → 需要内经板书 | 黄帝内经 huangdi-screenshot-evidence | 272 |
| 天纪/易经/术数 | 天纪 tianji-screenshot-evidence | 527 |

---

## 安装 nihaisha（与灵枢台共存）

```bash
# 1. 克隆 nihaisha
git clone https://github.com/JuneYaooo/nihaisha-tcm.git ~/nihaisha-tcm

# 2. 安装为 OpenClaw Skill
cd ~/nihaisha-tcm
bash install_as_skill.sh --target openclaw
# 或手动复制：
cp -r ~/nihaisha-tcm ~/.openclaw/plugin-skills/nihaisha/

# 3. 重启 Gateway
openclaw gateway restart
```

安装后，灵枢台和 nihaisha 作为两个独立 Skill 共存，互不依赖。

---

## 检索方式

### 方式一：Python 搜索脚本（推荐）

nihaisha 自带的搜索脚本：

```bash
cd ~/nihaisha-tcm

# 按方名搜索
python3 scripts/search_screenshots.py 桂枝汤
python3 scripts/search_screenshots.py 小柴胡汤 加减

# 按穴位搜索
python3 scripts/search_screenshots.py 足三里
python3 scripts/search_screenshots.py 任脉 督脉

# 按病机搜索
python3 scripts/search_screenshots.py 少阴 下利
python3 scripts/search_screenshots.py 太阳 中风

# 按课次搜索
python3 scripts/search_screenshots.py 伤寒论 第12讲
```

脚本返回匹配的截图路径（`assets/screenshots/...`），可用图片查看器打开。

### 方式二：直接 grep 索引文件

```bash
# 伤寒论截图
grep "桂枝汤" ~/nihaisha-tcm/references/screenshot-evidence.md

# 金匮要略截图
grep "胸痹" ~/nihaisha-tcm/references/jingui-screenshot-evidence.md

# 针灸截图
grep "足三里" ~/nihaisha-tcm/references/acupuncture-screenshot-evidence.md
```

---

## 灵枢台调用流程

在灵枢台的对应环节中，按需调用 nihaisha 截图：

### tcm-fangji：方剂推荐时

```
Phase 5 方药输出 → 附加：
> 📷 倪海厦课程板书参考：
> 运行：cd ~/nihaisha-tcm && python3 scripts/search_screenshots.py {方名}
```

### tcm-zhenjiu：针灸配穴时

```
配穴输出 → 附加：
> 📷 倪海厦针灸实操参考：
> 运行：cd ~/nihaisha-tcm && python3 scripts/search_screenshots.py {穴位}
```

### tcm-chaifang：拆方时

```
拆方分析 → 附加：
> 📷 仲景心法病机图参考：
> 运行：cd ~/nihaisha-tcm && python3 scripts/search_screenshots.py {方名} 病机
```

---

## 边界说明

| 能做的 | 不能做的 |
|--------|---------|
| ✅ 按方名查倪海厦板书 | ❌ 自动截图（需手动运行脚本） |
| ✅ 按穴位查针灸实操 | ❌ 实时视频跳转 |
| ✅ 按病机查仲景心法图 | ❌ 替代经典原文（截图是辅助，原文是根本） |
| ✅ 按课次查课程板书 | ❌ 直接嵌入灵枢台输出（截图路径需手动查看） |

---

## 安全

- nihaisha 截图来自公开课程视频，仅用于学术参考
- 引用时标注来源：「倪海厦《{课程}》第 {X} 讲」
- 不作为独立诊断依据，仅为学习辅助材料

---

*桥接指南 v0.1 · nihaisha-tcm 版本：main*
