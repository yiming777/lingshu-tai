# 灵枢台知识底座 · 总索引

> 版本：v0.1 | 更新：2026-06-05

## 文件地图

| 文件 | 内容 | 条数 | 适用场景 |
|------|------|:----:|----------|
| `fangji-db.md` | 方剂数据库 | 40+ | 辨证后开方、方剂查询 |
| `zhongyao/INDEX.md` | 中药数据库总索引 | 99 | 先查索引定位药物所在文件与行号 |
| `zhongyao/zhongyao-biao-li-re.md` | 解表·清热·泻下药 | 35味 | 含出处原文、药理、现代注解 |
| `zhongyao/zhongyao-shi-wen.md` | 祛湿·温里药 | 19味 | 含出处原文、药理、现代注解 |
| `zhongyao/zhongyao-qi-xue.md` | 理气·消食·止血·活血药 | 22味 | 含出处原文、药理、现代注解 |
| `zhongyao/zhongyao-tan-shen-feng.md` | 化痰·安神·平肝熄风药 | 13味 | 含出处原文、药理、现代注解 |
| `zhongyao/zhongyao-bu-yi-se.md` | 补虚·收涩药 | 22味 | 含出处原文、药理、现代注解 |
| `jingdian-tiaowen.md` | 经典条文索引 | 50+ | 引用出处、辨证佐证 |
| `zhenghou-db.md` | 证型数据库 | 30+ | 证型诊断标准确认 |
| `safety.md` | 安全分级清单 | — | 高风险方药警告 |

## 数据覆盖范围

### 方剂（fangji-db.md）
解表剂 / 清热剂 / 泻下剂 / 和解剂 / 温里剂 / 补益剂 / 固涩剂 / 理气剂 / 理血剂 / 祛湿剂 / 祛痰剂 / 消导剂

### 中药（zhongyao/ 目录，5个分类文件）

| 文件 | 分类 | 药味 |
|------|------|:----:|
| zhongyao-biao-li-re.md | 解表药·清热药·泻下药 | 35 |
| zhongyao-shi-wen.md | 祛风湿药·化湿药·利水渗湿药·温里药 | 19 |
| zhongyao-qi-xue.md | 理气药·消食药·止血药·活血化瘀药 | 22 |
| zhongyao-tan-shen-feng.md | 化痰止咳平喘药·安神药·平肝熄风药 | 13 |
| zhongyao-bu-yi-se.md | 补虚药·收涩药 | 22 |

每味药含：出处/原文、性味归经、功效、剂量、用法、毒性（五级）、配伍、药理（证据分级）、现代注解、来源标记

### 经典条文（jingdian-tiaowen.md）
《伤寒论》六经各篇 + 《金匮要略》杂病各篇 + 《温病条辨》选条

### 证型（zhenghou-db.md）
八纲证型 / 脏腑证型 / 六经证型 / 气血津液证型 / 常见复合证型

## 检索策略

1. **开方** → fangji-db.md（查方剂组成剂量）→ zhongyao/INDEX.md（定位药物所在文件+行号）→ 按索引读取具体药物（含禁忌、药理）→ safety.md（查安全警告）
2. **辨证** → zhenghou-db.md（确认证型标准）→ jingdian-tiaowen.md（查经典条文佐证）
3. **拆方** → fangji-db.md（查原方组成）→ zhongyao/INDEX.md（定位药物所在文件+行号）→ 按索引读取（含出处原文、药理、现代注解）
4. **安全审查** → safety.md（查高风险药物清单）

## 加载策略

使用 `read` 工具带 `offset` 和 `limit` 参数精确定位，避免全量加载到上下文。

例如：
```
read(fangji-db.md, offset=100, limit=30)  # 只看温里剂部分
grep "麻黄" zhongyao/INDEX.md  # 先查索引定位
grep "桂枝" zhongyao/INDEX.md  # 再按索引读具体药物
```
