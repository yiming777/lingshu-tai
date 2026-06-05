# 倪海厦课程截图证据

> 灵枢台 · tcm-vision 参考文件
> 2986 张倪海厦课程板书/PPT/实操截图证据索引，已内建至灵枢台

---

## 概述

本目录已将 [nihaisha-tcm](https://github.com/JuneYaooo/nihaisha-tcm) 的截图证据索引（12 个 .md 文件，~700KB）直接导入灵枢台框架。数据来源标注清晰，不依赖外部 repo。

| 模块 | 截图张数 | 索引文件 |
|------|:---:|------|
| 伤寒论 | 649 | `nihaisha-screenshots/screenshot-evidence.md` |
| 金匮要略 | 656 | `nihaisha-screenshots/jingui-screenshot-evidence.md` |
| 针灸课程 | 501 | `nihaisha-screenshots/acupuncture-screenshot-evidence.md` |
| 神农本草 | 127 | `nihaisha-screenshots/bencao-screenshot-evidence.md` |
| 黄帝内经 | 272 | `nihaisha-screenshots/huangdi-screenshot-evidence.md` |
| 天纪 | 527 | `nihaisha-screenshots/tianji-screenshot-evidence.md` |
| 仲景心法 | 68 | `nihaisha-screenshots/zhongjing-xinfa-screenshot-evidence.md` |
| 临床案例 | 88 | `nihaisha-screenshots/clinical-cases-screenshot-evidence.md` |
| 八纲辨证 | 33 | `nihaisha-screenshots/bagang-screenshot-evidence.md` |
| 扶阳论坛 | 37 | `nihaisha-screenshots/fuyang-screenshot-evidence.md` |
| 易筋经 | 28 | `nihaisha-screenshots/yijinjing-screenshot-evidence.md` |
| **合计** | **2986** | |

---

## 检索方式

### 方式一：灵枢台内置搜索（推荐）

```bash
# 从灵枢台仓库根目录
bash tcm-vision/scripts/search_nihaisha.sh <关键词>
```

示例：
```bash
bash tcm-vision/scripts/search_nihaisha.sh 桂枝汤
bash tcm-vision/scripts/search_nihaisha.sh 少阴 下利
bash tcm-vision/scripts/search_nihaisha.sh 足三里
bash tcm-vision/scripts/search_nihaisha.sh 天纪 命宫
```

### 方式二：直接 grep 索引

```bash
grep -r "桂枝汤" tcm-vision/references/nihaisha-screenshots/
```

---

## 截图文件

### 下载截图（可选）

索引文件只包含元数据（路径+时间戳+描述）。实际的 .webp 截图文件（~78MB）可通过同步脚本下载：

```bash
bash tcm-vision/scripts/sync_nihaisha_screenshots.sh
```

下载后截图存放在 `tcm-vision/assets/nihaisha/{模块}/`。

### 不下载也能用

索引文件已是纯文本，可以直接搜索关键词→获取截图文件名→知道"倪海厦在第 X 讲用什么板书讲了这个方"。只是不能直接打开看图片。

---

## 灵枢台调用流程

在辨证/方剂/针灸输出时，Agent 自动搜索截图索引并附加引用：

```
📷 倪海厦课程截图证据：
  - 伤寒论·第X讲·桂枝汤板书 → assets/nihaisha/shanghanlun/xxx.webp
  - 检索命令：bash tcm-vision/scripts/search_nihaisha.sh 桂枝汤
```

---

## 数据来源

- 原始数据：[nihaisha-tcm](https://github.com/JuneYaooo/nihaisha-tcm) by JuneYaooo
- 使用范围：个人学习、学术引用（非商业）
- 版权声明：课程截图版权归原权利人所有；侵权请联系删除
- 索引文件导入时间：2026-06-05

---

*内建索引 v0.1 · 2986 条证据 · 12 个索引文件 · ~700KB*
