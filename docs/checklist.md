# 灵枢台 开发检查清单

> 版本：v1.0 | 更新：2026-06-05  
> 每项开发任务开始前、提交前、迭代结束时的强制检查

---

## 一、开发前检查

在开始写代码/内容之前，确认：

- [ ] 任务目标明确：要新增什么？修改什么？解决什么问题？
- [ ] 已检查是否与现有 Skill 功能重叠（避免重复造轮子）
- [ ] 已确认数据来源（自有/外部），外部数据已评估增量价值
- [ ] 任务已拆解为 ≤3 天的可交付单元
- [ ] 新建 Skill 已从 `tcm-template/` 复制骨架

---

## 二、提交前自查

每次 `git commit` 前，逐项确认：

### 代码/内容质量

- [ ] SKILL.md ≤ 7KB（`wc -c` 验证）
- [ ] SKILL.md 无超过 20 行的表格（如有 → 外挂到 references/）
- [ ] SKILL.md 无超过 500 字的连续段落（如有 → 拆到 references/）
- [ ] 无硬编码绝对路径（`/Users/`、`C:\Users\`）
- [ ] 无内嵌 base64 图片
- [ ] 无 Skill 之间循环依赖

### 外部数据

- [ ] 外部数据文件位于 `references/external/<来源>/`
- [ ] 目录包含 `SOURCE.md`（原始出处+许可+清洗记录）
- [ ] 文件命名符合小写连字符规范
- [ ] 文件头部有来源标注
- [ ] 数据与灵枢台已有知识库无冗余

### 集成

- [ ] 新 Skill 已加入 `tcm/SKILL.md` 路由表
- [ ] 新数据已加入对应 Skill 的加载策略表
- [ ] 新功能已更新 `README.md` 的项目结构或功能说明

### Git

- [ ] Commit message 符合 Conventional Commits 格式（`feat:`/`fix:`/`docs:`/`data:`/`audit:`）
- [ ] 无提交二进制大文件（>1MB）
- [ ] 无提交 API Key / Token / 密码
- [ ] 无提交系统临时文件（`.DS_Store`, `Thumbs.db`）

### 文档

- [ ] 架构变更已更新 `docs/architecture.md`
- [ ] 知识库字段变更已更新 `docs/data_dictionary.md`
- [ ] 新 Skill 的 SKILL.md 三段式完整（frontmatter + 加载策略 + Phase 流程）

---

## 三、新 Skill 验收标准

- [ ] `SKILL.md` 包含完整的 YAML frontmatter（name + description）
- [ ] 加载策略表清晰（场景 → 文件路径）
- [ ] Phase 流程完整（入口 → 步骤 → 输出模板 → 结束）
- [ ] 与其他 Skill 的协作关系明确
- [ ] 安全措辞到位（如涉及辨证/方药，必须含 risk_level + 安全审查）
- [ ] 至少一个完整的使用示例可跑通

---

## 四、迭代/Sprint 结束检查

每个开发阶段结束：

- [ ] 全量审计通过：`bash scripts/audit.sh`（待建）或手动对照 §二 自查
- [ ] 所有 SKILL.md ≤ 7KB
- [ ] 所有外部数据 SOURCE.md 齐全
- [ ] `docs/architecture.md` 与当前结构一致
- [ ] GitHub 工作区干净（`git status` 无残留）
- [ ] README.md 功能列表/项目结构与实际一致
- [ ] 技术债已记录：任何已知但未修的代码异味/数据不完整 → 标记 `TODO` 或开 Issue

---

## 五、文档更新触发条件

以下情况**必须当天同步**对应文档：

| 操作 | 需更新的文档 |
|------|------------|
| 新增/删除 Skill | `README.md` + `architecture.md` + `tcm/SKILL.md` |
| 修改 Skill 路由/依赖 | `architecture.md` |
| 知识库字段增删改 | `data_dictionary.md` |
| 外部数据导入 | 对应 `SOURCE.md` |
| 宪章修订 | `DEVELOPMENT.md` 版本号 + 日期 |
| 架构决策 | `architecture.md` §六 |

---

*本清单随灵枢台演进持续修订。*
