#!/usr/bin/env bash
# PreToolUse (Bash): блокирует опасные команды. Требует jq.
cmd=$(jq -r '.tool_input.command // empty')
if echo "$cmd" | grep -Eq 'rm -rf (/|~)|git push (-f|--force)|DROP (TABLE|DATABASE)|mkfs|:\(\)\{'; then
  echo "Команда заблокирована политикой team-toolkit: $cmd" >&2
  exit 2
fi
exit 0
