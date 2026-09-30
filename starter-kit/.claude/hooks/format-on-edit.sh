#!/usr/bin/env bash
# PostToolUse (Edit|Write): форматирует изменённый файл. Требует jq.
file=$(jq -r '.tool_input.file_path // empty')
[ -z "$file" ] || [ ! -f "$file" ] && exit 0

case "$file" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.json|*.css|*.scss|*.md|*.yml|*.yaml)
    command -v npx >/dev/null && npx --no-install prettier --write "$file" >/dev/null 2>&1 ;;
  *.py)
    command -v ruff >/dev/null && ruff format "$file" >/dev/null 2>&1 ;;
  *.go)
    command -v gofmt >/dev/null && gofmt -w "$file" ;;
  *.rs)
    command -v rustfmt >/dev/null && rustfmt "$file" >/dev/null 2>&1 ;;
esac
exit 0
