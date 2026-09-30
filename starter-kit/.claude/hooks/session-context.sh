#!/usr/bin/env bash
# SessionStart: stdout добавляется в контекст Claude в начале сессии.
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
if git rev-parse --git-dir >/dev/null 2>&1; then
  echo "## Состояние репозитория"
  echo "- Ветка: $(git branch --show-current)"
  changed=$(git status --porcelain | wc -l | tr -d ' ')
  echo "- Незакоммиченных файлов: $changed"
  echo "- Последние коммиты:"
  git log --oneline -5 | sed 's/^/  - /'
fi
# Активный план, если есть
latest_plan=$(ls -t docs/plans/*.md 2>/dev/null | head -1)
if [ -n "$latest_plan" ]; then
  echo "- Активный план: $latest_plan (прочитай перед работой, если задача связана с ним)"
fi
exit 0
