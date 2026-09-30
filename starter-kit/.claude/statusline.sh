#!/usr/bin/env bash
# Статусная строка: модель | папка | ветка git (+изменения) | стоимость сессии.
# Подключение: "statusLine": {"type": "command", "command": "bash .claude/statusline.sh"}
# Требует jq. Claude Code передаёт JSON сессии в stdin.
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "?"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "."')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

branch=""
if git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$dir" branch --show-current 2>/dev/null)
  if [ -n "$(git -C "$dir" status --porcelain 2>/dev/null)" ]; then branch="$branch*"; fi
fi

out="🤖 $model | 📁 $(basename "$dir")"
[ -n "$branch" ] && out="$out | 🌿 $branch"
[ -n "$cost" ] && out="$out | 💰 \$$(printf '%.2f' "$cost")"
echo "$out"
