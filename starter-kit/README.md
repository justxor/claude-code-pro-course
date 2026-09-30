# Starter kit

Готовая конфигурация Claude Code для копирования в проект.

## Установка

```bash
# в проект (существующие файлы не перезаписываются)
bash install.sh /path/to/your-project

# личные skills/агенты/стили — для всех проектов (~/.claude)
bash install.sh --user
```

Или вручную: `cp -r starter-kit/.claude starter-kit/CLAUDE.md starter-kit/.mcp.json your-project/`.

> Для hooks и statusline нужен `jq`.

## Состав

| Путь | Что это | Модуль |
|---|---|---|
| `CLAUDE.md` | Шаблон памяти проекта — **отредактируйте!** | [02](../course/02-claude-md.md) |
| `CLAUDE.local.md.example` | Личные предпочтения | [02](../course/02-claude-md.md) |
| `.claude/rules/` | Правила по путям: `testing`, `api`, `frontend` | [02](../course/02-claude-md.md) |
| `.claude/settings.json` | Разрешения, hooks, statusline | [03](../course/03-settings-permissions.md) |
| `.claude/skills/` | 8 skills (см. ниже) | [05](../course/05-skills.md) |
| `.claude/agents/` | 5 субагентов (см. ниже) | [06](../course/06-subagents.md) |
| `.claude/hooks/` | 4 hook-скрипта (см. ниже) | [07](../course/07-hooks.md) |
| `.claude/output-styles/mentor.md` | Режим наставника (`/output-style`) | [11](../course/11-pro-tips.md) |
| `.claude/statusline.sh` | Модель, ветка, стоимость в статусной строке | [11](../course/11-pro-tips.md) |
| `.mcp.json` | GitHub + Playwright MCP | [08](../course/08-mcp.md) |

### Skills

| Skill | Вызов | Что делает |
|---|---|---|
| code-review | `/code-review` | Ревью ветки по чек-листу 🔴🟡🟢 |
| commit | `/commit` | Conventional commit по изменениям |
| write-tests | `/write-tests <файл>` | Тесты в стиле проекта |
| fix-issue | `/fix-issue <номер>` | Issue → тест → фикс → коммит (только ручной вызов) |
| refactor | `/refactor <модуль>` | Рефакторинг маленькими шагами под защитой тестов |
| pr-description | `/pr-description` | Описание PR по шаблону |
| release-notes | `/release-notes [v1.0 v1.1]` | Release notes из истории коммитов |
| onboard | `/onboard` | Онбординг новичка в проект |

### Субагенты

| Агент | Модель | Права | Для чего |
|---|---|---|---|
| architect | opus | только чтение | Варианты решения и план до кода |
| code-reviewer | sonnet | только чтение | Ревью после изменений |
| test-runner | haiku | чтение + bash | Прогон тестов и разбор падений |
| debugger | inherit | полные | Методичная отладка |
| docs-writer | sonnet | чтение + правка | Актуализация документации |

### Hooks

| Скрипт | Событие | Действие |
|---|---|---|
| protect-files.sh | PreToolUse (Edit\|Write) | Блокирует правку `.env`, lock-файлов, миграций |
| format-on-edit.sh | PostToolUse (Edit\|Write) | prettier / ruff / gofmt / rustfmt |
| notify.sh | Notification | Системное уведомление, когда Claude ждёт |
| session-context.sh | SessionStart | Ветка, изменения, последние коммиты, активный план |

После установки проверьте: `/context`, `/agents`, `/hooks`, `/mcp`.
