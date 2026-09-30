#!/usr/bin/env bash
# PreToolUse (Edit|Write): блокирует изменение защищённых файлов. Требует jq.
# exit 2 => вызов инструмента отменяется, stderr передаётся Claude.
file=$(jq -r '.tool_input.file_path // empty')
[ -z "$file" ] && exit 0

protected=(".env" ".git/" "package-lock.json" "pnpm-lock.yaml" "yarn.lock" "migrations/" "secrets/")
for p in "${protected[@]}"; do
  if [[ "$file" == *"$p"* ]]; then
    echo "Файл '$file' защищён (совпадение с '$p'). Не изменяй его; если это действительно нужно — попроси пользователя." >&2
    exit 2
  fi
done
exit 0
