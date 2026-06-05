#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
# 灵枢台 倪海厦截图同步
# 从 nihaisha-tcm GitHub 仓库下载所有截图 WebP 文件到本地
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ASSETS_DIR="$SCRIPT_DIR/../assets/nihaisha"
GITHUB_RAW="https://raw.githubusercontent.com/JuneYaooo/nihaisha-tcm/main"

# 11 个模块
MODULES=(
  "shanghanlun"
  "jingui"
  "acupuncture"
  "bencao"
  "huangdi"
  "tianji"
  "zhongjing-xinfa"
  "clinical-cases"
  "bagang"
  "fuyang"
  "yijinjing"
)

echo "灵枢台 · 倪海厦截图同步"
echo "从 nihaisha-tcm 下载截图到本地"
echo ""
echo "预计下载: 2986 张 WebP (~78MB)"
echo ""

# 检查依赖
if ! command -v curl &>/dev/null; then
  echo "❌ 需要 curl，请先安装"
  exit 1
fi

mkdir -p "$ASSETS_DIR"

# 下载索引文件获取截图列表
echo "📥 下载索引文件..."
TMP_INDEX=$(mktemp -d)
trap "rm -rf $TMP_INDEX" EXIT

INDEX_URLS=(
  "$GITHUB_RAW/references/screenshot-evidence.md"
  "$GITHUB_RAW/references/jingui-screenshot-evidence.md"
  "$GITHUB_RAW/references/acupuncture-screenshot-evidence.md"
  "$GITHUB_RAW/references/bencao-screenshot-evidence.md"
  "$GITHUB_RAW/references/huangdi-screenshot-evidence.md"
  "$GITHUB_RAW/references/tianji-screenshot-evidence.md"
  "$GITHUB_RAW/references/zhongjing-xinfa-screenshot-evidence.md"
  "$GITHUB_RAW/references/clinical-cases-screenshot-evidence.md"
  "$GITHUB_RAW/references/bagang-screenshot-evidence.md"
  "$GITHUB_RAW/references/fuyang-screenshot-evidence.md"
  "$GITHUB_RAW/references/yijinjing-screenshot-evidence.md"
)

for url in "${INDEX_URLS[@]}"; do
  fname=$(basename "$url")
  curl -sL "$url" -o "$TMP_INDEX/$fname" 2>/dev/null || echo "  ⚠ 下载失败: $fname"
  echo "  ✓ $fname"
done

echo ""
echo "📥 下载截图文件..."

total=0
downloaded=0
skipped=0
failed=0

for module in "${MODULES[@]}"; do
  # 从索引中提取该模块的截图文件名
  case "$module" in
    shanghanlun) index_file="screenshot-evidence.md" ;;
    *)           index_file="${module}-screenshot-evidence.md" ;;
  esac
  
  if [ ! -f "$TMP_INDEX/$index_file" ]; then
    continue
  fi

  # 提取图片路径
  paths=$(grep -oE "assets/screenshots/${module}/[^) ]+\.webp" "$TMP_INDEX/$index_file" 2>/dev/null || true)
  count=$(echo "$paths" | wc -l | tr -d ' ')
  
  if [ "$count" -eq 0 ]; then
    continue
  fi
  
  echo "  📁 $module ($count 张)..."
  mkdir -p "$ASSETS_DIR/$module"
  
  echo "$paths" | while IFS= read -r img_path; do
    [ -z "$img_path" ] && continue
    img_name=$(basename "$img_path")
    dest="$ASSETS_DIR/$module/$img_name"
    
    if [ -f "$dest" ]; then
      skipped=$((skipped + 1))
    else
      if curl -sL "$GITHUB_RAW/$img_path" -o "$dest" 2>/dev/null; then
        downloaded=$((downloaded + 1))
      else
        echo "    ❌ $img_name"
        failed=$((failed + 1))
      fi
    fi
  done
  
  total=$((total + count))
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "同步完成"
echo "  总计: $total 张"
echo "  下载: $downloaded 张"
echo "  跳过: $skipped 张（已存在）"
[ "$failed" -gt 0 ] && echo "  失败: $failed 张"
echo ""
echo "截图位置: $ASSETS_DIR"
echo "验证: ls $ASSETS_DIR/*/"
