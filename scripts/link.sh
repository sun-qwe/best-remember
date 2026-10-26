#!/usr/bin/env bash
# 把本仓库接入各个 AI 工具（macOS / Linux）。
#
#   bash scripts/link.sh            # 接入
#   bash scripts/link.sh --dry-run  # 只看会改哪些文件
#
# 与 PowerShell 版行为一致：
#   - 不建符号链接，写「带路径的入口文件」；
#   - 已有配置文件只在末尾【追加】指针，原有内容一个字不动，重复跑安全；
#   - 真需要改动已有文件时先备份到 ~/.brain-backup-<时间>/。

set -euo pipefail

DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENTRY="$REPO/AGENTS.md"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.brain-backup-$STAMP"

[ -f "$ENTRY" ] || { echo "在 $REPO 里找不到 AGENTS.md" >&2; exit 1; }

echo "仓库：$REPO"
echo "入口：$ENTRY"
echo

backup_one() {
  local path="$1" dest="$BACKUP/${path#"$HOME"/}"
  [ $DRY -eq 1 ] && return 0
  mkdir -p "$(dirname "$dest")"
  cp "$path" "$dest"
}

# 追加式目标：文件已存在就只在末尾追加指针
append_one() {
  local name="$1" path="$2" line="$3"
  local dir; dir="$(dirname "$path")"
  if [ ! -d "$dir" ]; then
    [ $DRY -eq 1 ] && echo "  [dry] 新建目录 $dir" || mkdir -p "$dir"
  fi

  if [ ! -f "$path" ]; then
    echo "  新建  $name  $path"
    [ $DRY -eq 0 ] && printf '# 个人档案入口（由 brain 仓库的 scripts/link.sh 生成）\n\n%s\n' "$line" > "$path"
    return 0
  fi

  if grep -qF "$ENTRY" "$path"; then
    echo "  已就绪  $name  （文件里已有指向本仓库的指针，跳过）"
    return 0
  fi

  backup_one "$path"
  echo "  追加  $name  $path"
  echo "        原有内容未改；备份在 $BACKUP/${path#"$HOME"/}"
  [ $DRY -eq 0 ] && printf '\n# 个人档案入口（以下由 brain 仓库的 scripts/link.sh 追加）\n%s\n' "$line" >> "$path"
}

# 本脚本独占的目标：整文件由脚本管理
owned_one() {
  local name="$1" path="$2" body="$3"
  local dir; dir="$(dirname "$path")"
  if [ ! -d "$dir" ]; then
    [ $DRY -eq 1 ] && echo "  [dry] 新建目录 $dir" || mkdir -p "$dir"
  fi
  if [ -f "$path" ] && ! grep -qF "$ENTRY" "$path"; then
    backup_one "$path"
    echo "  覆盖  $name  $path（原文件备份在 $BACKUP/${path#"$HOME"/}）"
  elif [ -f "$path" ]; then
    echo "  已就绪  $name  $path"
    return 0
  else
    echo "  新建  $name  $path"
  fi
  [ $DRY -eq 0 ] && printf '%s\n' "$body" > "$path"
}

append_one 'Claude Code' "$HOME/.claude/CLAUDE.md"  "@$ENTRY"
append_one 'Codex CLI'   "$HOME/.codex/AGENTS.md"   "开工前先读这个文件并遵守它：$ENTRY"
append_one 'Gemini CLI'  "$HOME/.gemini/GEMINI.md"  "@$ENTRY"

owned_one 'Cursor' "$HOME/.cursor/rules/brain.mdc" "---
description: 个人档案入口（由 brain 仓库的 scripts/link.sh 生成，重跑会覆盖）
alwaysApply: true
---

开工前先读这个文件，并遵守里面的路由表和写入协议：
$ENTRY"

echo
echo "完成。"
echo "验证：开一个【新】会话，直接问「我的排版偏好是什么？」答得出来就通了。"
echo "某个工具没反应：它的全局配置路径可能变了，把 $ENTRY 的内容粘进它的 Rules / Memory 设置。"
