#!/usr/bin/env bash
# Установка starter-kit в проект.
#   bash install.sh /path/to/project          — скопировать, не перезаписывая существующие файлы
#   bash install.sh /path/to/project --force  — перезаписать (старые файлы сохраняются как *.bak)
#   bash install.sh --user                    — skills, агенты и output styles в ~/.claude (для всех проектов)
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/starter-kit"
FORCE=0
TARGET=""
USER_MODE=0
for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    --user) USER_MODE=1 ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) TARGET="$arg" ;;
  esac
done

copy() { # copy <src> <dst>
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ]; then
    if [ "$FORCE" -eq 1 ]; then
      cp "$dst" "$dst.bak"; cp "$src" "$dst"; echo "  ↻ $dst (старый → .bak)"
    else
      echo "  · пропущен (уже есть): $dst"
    fi
  else
    cp "$src" "$dst"; echo "  + $dst"
  fi
}

if [ "$USER_MODE" -eq 1 ]; then
  DEST="$HOME/.claude"
  echo "Установка в $DEST (личный уровень)"
  for dir in skills agents output-styles; do
    (cd "$SRC/.claude" && find "$dir" -type f) | while read -r f; do copy "$SRC/.claude/$f" "$DEST/$f"; done
  done
  echo "Готово. Перезапустите Claude Code и проверьте /agents и /help."
  exit 0
fi

[ -z "$TARGET" ] && { echo "Укажите путь к проекту: bash install.sh /path/to/project"; exit 1; }
[ -d "$TARGET" ] || { echo "Папка не найдена: $TARGET"; exit 1; }
TARGET="$(cd "$TARGET" && pwd)"
echo "Установка starter-kit в $TARGET"

(cd "$SRC" && find .claude -type f) | while read -r f; do copy "$SRC/$f" "$TARGET/$f"; done
copy "$SRC/CLAUDE.md" "$TARGET/CLAUDE.md"
copy "$SRC/.mcp.json" "$TARGET/.mcp.json"
chmod +x "$TARGET"/.claude/hooks/*.sh "$TARGET"/.claude/statusline.sh 2>/dev/null || true

GI="$TARGET/.gitignore"
touch "$GI"
for line in ".claude/settings.local.json" "CLAUDE.local.md"; do
  grep -qxF "$line" "$GI" || { echo "$line" >> "$GI"; echo "  + .gitignore: $line"; }
done

command -v jq >/dev/null || echo "⚠️  Не найден jq — он нужен для hooks и statusline. Установите: brew install jq / apt install jq"
cat <<MSG

Готово! Дальше:
  1. Отредактируйте $TARGET/CLAUDE.md под свой проект
  2. Поправьте allow/deny в .claude/settings.json и пути в .claude/rules/
  3. Запустите claude и проверьте: /context  /agents  /hooks  /mcp
MSG
