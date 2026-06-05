#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
# 灵枢台 倪海厦截图证据检索
# 用法: bash search_nihaisha.sh <关键词> [...]
# ═══════════════════════════════════════════════════════
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INDEX_DIR="$SCRIPT_DIR/../references/external/nihaisha"

if [ $# -eq 0 ]; then
  echo "用法: bash search_nihaisha.sh <关键词> [...]"
  echo "示例: bash search_nihaisha.sh 桂枝汤"
  exit 0
fi

total=0
for f in "$INDEX_DIR"/*.md; do
  name=$(basename "$f" | sed 's/screenshot-evidence/伤寒论/' | sed 's/-screenshot-evidence//' | sed 's/\.md//')
  
  # 用 grep -A 取匹配行和后 2 行，找内含截图路径的段落
  chunk=$(grep -i -A 2 "$1" "$f" 2>/dev/null || true)
  for kw in "${@:2}"; do
    chunk=$(echo "$chunk" | grep -i -A 2 "$kw" || true)
  done
  
  if [ -z "$chunk" ]; then continue; fi
  
  # 提取匹配行数
  matches=$(grep -i -c "$1" "$f" 2>/dev/null || echo "0")
  matches=$(echo "$matches" | tr -d ' ')
  echo "📁 $name ($matches 条)"
  
  # 只用 grep 取匹配行本身
  grep -i "$1" "$f" 2>/dev/null | while IFS= read -r line; do
    # 跳过所有关键词过滤
    skip=false
    for kw in "${@:2}"; do
      echo "$line" | grep -qi "$kw" || skip=true
    done
    $skip && continue
    
    # 提取截图路径（同一行或附近）
    img=$(echo "$line" | grep -oE 'assets/[^ )]+\.webp' | head -1)
    desc=$(echo "$line" | sed 's/^- /  /' | cut -c1-120)
    echo "  $desc"
    [ -n "$img" ] && echo "    📷 $img"
  done
  echo ""
  total=$((total + matches))
done

echo "共 $total 条 · 截图下载: bash scripts/sync_nihaisha_screenshots.sh"
