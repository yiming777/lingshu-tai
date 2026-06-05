#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
# 灵枢台 · 一键安装脚本
# 将 11 个 TCM Skill + 知识底座安装到 OpenClaw 插件目录
# 支持：macOS / Linux / Windows (Git Bash / WSL)
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"
WORKSPACE_SRC="$SCRIPT_DIR/workspace"

# --------------- 颜色 ---------------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

# --------------- 参数 ---------------
DRY_RUN=false
SKILLS_ONLY=false
WORKSPACE_ONLY=false
RESTART=true
SHOW_HELP=false

for arg in "$@"; do
  case "$arg" in
    --dry-run)     DRY_RUN=true ;;
    --skills-only) SKILLS_ONLY=true ;;
    --workspace-only) WORKSPACE_ONLY=true ;;
    --no-restart)  RESTART=false ;;
    --help|-h)     SHOW_HELP=true ;;
    *) echo -e "${RED}未知参数: $arg${NC}"; exit 1 ;;
  esac
done

if $SHOW_HELP; then
  echo "灵枢台 安装脚本"
  echo ""
  echo "用法: bash install.sh [选项]"
  echo ""
  echo "选项:"
  echo "  --dry-run          模拟运行，不实际复制"
  echo "  --skills-only      只安装 Skills，跳过 workspace 文件"
  echo "  --workspace-only   只安装 workspace 文件，跳过 Skills"
  echo "  --no-restart       安装后不重启 Gateway"
  echo "  --help, -h         显示帮助"
  exit 0
fi

# --------------- 检测环境 ---------------
echo -e "${CYAN}${BOLD}灵枢台 · 安装程序${NC}"
echo ""

# 检测操作系统
case "$(uname -s)" in
  Darwin)  OS="macOS" ;;
  Linux)   OS="Linux" ;;
  MINGW*|MSYS*|CYGWIN*) OS="Windows (Git Bash)" ;;
  *)       OS="Unknown" ;;
esac
echo -e "  系统: ${GREEN}$OS${NC}"

# 检测插件目录
if [ -n "${OPENCLAW_STATE_DIR:-}" ]; then
  PLUGIN_DIR="$OPENCLAW_STATE_DIR/plugin-skills"
elif [ -d "$HOME/.openclaw" ]; then
  PLUGIN_DIR="$HOME/.openclaw/plugin-skills"
else
  echo -e "${YELLOW}  ⚠ 未检测到 ~/.openclaw 目录。${NC}"
  echo -e "  请先安装 OpenClaw：${CYAN}npm install -g openclaw && openclaw configure${NC}"
  echo "  或者手动指定插件目录："
  echo "    bash install.sh --plugin-dir /path/to/plugin-skills"
  exit 1
fi

echo -e "  插件目录: ${GREEN}$PLUGIN_DIR${NC}"

# 检测 workspace 目录
WORKSPACE_DIR=""
if [ -f "$HOME/.openclaw/openclaw.json" ]; then
  WORKSPACE_DIR=$(python3 -c "
import json, os
try:
    with open(os.path.expanduser('~/.openclaw/openclaw.json')) as f:
        c = json.load(f)
    print(c.get('agents',{}).get('defaults',{}).get('workspace',''))
except: pass
" 2>/dev/null || echo "")
fi
WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/.openclaw/workspace}"
echo -e "  工作区: ${GREEN}$WORKSPACE_DIR${NC}"

# 检测 Gateway 状态
GATEWAY_RUNNING=false
if command -v lsof &>/dev/null && lsof -i :18789 &>/dev/null 2>&1; then
  GATEWAY_RUNNING=true
fi
echo -e "  Gateway: $($GATEWAY_RUNNING && echo "${GREEN}运行中${NC}" || echo "${YELLOW}未运行${NC}")"
echo ""

# --------------- 安装 Skills ---------------
install_skills() {
  echo -e "${BOLD}📦 安装灵枢台 Skills...${NC}"
  mkdir -p "$PLUGIN_DIR"

  local count=0
  for skill_dir in "$SKILLS_SRC"/tcm*; do
    [ -d "$skill_dir" ] || continue
    local name=$(basename "$skill_dir")
    local dest="$PLUGIN_DIR/$name"

    if $DRY_RUN; then
      echo -e "  ${YELLOW}[DRY]${NC} $name → $dest"
    else
      rm -rf "$dest"
      cp -r "$skill_dir" "$dest"
      echo -e "  ${GREEN}✓${NC} $name"
    fi
    count=$((count + 1))
  done

  echo ""
  echo -e "  ${GREEN}已安装 $count 个 Skill${NC}"
}

# --------------- 安装 Workspace 文件 ---------------
install_workspace() {
  echo -e "${BOLD}📝 安装 Workspace 文件...${NC}"

  # 如果 SKILLS_SRC 目录旁边有 workspace 目录则用，否则跳过
  if [ ! -d "$WORKSPACE_SRC" ]; then
    echo -e "  ${YELLOW}⊘ 未找到 workspace/ 目录，跳过${NC}"
    echo -e "  ${YELLOW}  提示：workspace 文件可通过 GitHub clone 单独获取${NC}"
    return
  fi

  mkdir -p "$WORKSPACE_DIR/memory"

  local copied=0
  for f in AGENTS.md SOUL.md IDENTITY.md USER.md MEMORY.md TOOLS.md HEARTBEAT.md; do
    if [ -f "$WORKSPACE_SRC/$f" ]; then
      if ! $DRY_RUN; then
        # 如果目标已存在，先备份
        if [ -f "$WORKSPACE_DIR/$f" ]; then
          cp "$WORKSPACE_DIR/$f" "$WORKSPACE_DIR/$f.bak.$(date +%s)" 2>/dev/null || true
        fi
        cp "$WORKSPACE_SRC/$f" "$WORKSPACE_DIR/"
      fi
      echo -e "  ${GREEN}✓${NC} $f"
      copied=$((copied + 1))
    fi
  done

  # 复制记忆目录（如果源有内容）
  if [ -d "$WORKSPACE_SRC/memory" ] && [ "$(ls -A "$WORKSPACE_SRC/memory" 2>/dev/null)" ]; then
    if ! $DRY_RUN; then
      cp -n "$WORKSPACE_SRC/memory"/* "$WORKSPACE_DIR/memory/" 2>/dev/null || true
    fi
    echo -e "  ${GREEN}✓${NC} memory/ (不覆盖已有文件)"
  fi

  echo ""
  echo -e "  ${GREEN}已安装 $copied 个 Workspace 文件${NC}"
}

# --------------- 重启 Gateway ---------------
restart_gateway() {
  if $DRY_RUN; then
    echo -e "  ${YELLOW}[DRY]${NC} 跳过 Gateway 重启"
    return
  fi

  echo -e "${BOLD}🔄 重启 Gateway...${NC}"

  if command -v openclaw &>/dev/null; then
    openclaw gateway restart 2>/dev/null && echo -e "  ${GREEN}✓ Gateway 已重启${NC}" || \
      echo -e "  ${YELLOW}⚠ Gateway 重启失败，请手动执行: openclaw gateway restart${NC}"
  else
    echo -e "  ${YELLOW}⚠ 未找到 openclaw CLI，请手动重启 Gateway${NC}"
  fi
}

# --------------- 执行 ---------------
if $WORKSPACE_ONLY; then
  install_workspace
elif $SKILLS_ONLY; then
  install_skills
else
  install_skills
  echo ""
  install_workspace
fi

if $RESTART && ! $WORKSPACE_ONLY && ! $DRY_RUN; then
  echo ""
  restart_gateway
fi

# --------------- 完成提示 ---------------
echo ""
echo -e "${GREEN}${BOLD}═══════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}  灵枢台 安装完成 🧬⚡🌿${NC}"
echo -e "${GREEN}${BOLD}═══════════════════════════════════════${NC}"
echo ""
echo -e "  启动命令："
echo -e "    ${CYAN}openclaw gateway restart${NC}   # 重启 Gateway 加载 Skill"
echo -e "    ${CYAN}openclaw gateway status${NC}   # 确认 Gateway 状态"
echo ""
echo -e "  验证安装："
echo -e "    ${CYAN}ls ~/.openclaw/plugin-skills/tcm*/SKILL.md${NC}"
echo ""
echo -e "  开始使用："
echo -e "    在 WebChat / Dashboard 中输入："
echo -e "    ${CYAN}/tcm${NC}  或  ${CYAN}帮我辨证一下${NC}"
echo ""
echo -e "  中控台："
echo -e "    ${CYAN}cd lingshu-tai/dashboard && node server.js${NC}"
echo -e "    ${CYAN}http://localhost:3333${NC}"
echo ""
