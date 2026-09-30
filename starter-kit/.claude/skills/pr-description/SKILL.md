---
name: pr-description
description: Готовит заголовок и описание pull request по изменениям в ветке. Используй, когда просят описать PR, подготовить pull request или написать описание изменений.
allowed-tools: Bash(git diff:*), Bash(git log:*), Bash(git status), Bash(git branch:*), Read, Grep
---

# PR description

## Контекст
- Ветка: !`git branch --show-current`
- Коммиты: !`git log --oneline main..HEAD 2>/dev/null | head -30`

## Шаги
1. Изучи `git diff main...HEAD` и коммиты.
2. Сформируй описание по шаблону [template.md](template.md).
3. Пиши для ревьюера: что и **зачем**, на что смотреть внимательно, как проверить.
4. Не выдумывай: если не знаешь, как тестировали, — оставь пункт для автора.
5. Выведи результат. Создавать PR (`gh pr create`) — только если пользователь явно попросил.
