# Модуль 03. Настройки и разрешения

## Файлы настроек и приоритет

От высшего приоритета к низшему:

| # | Файл | Назначение |
|---|---|---|
| 1 | Managed settings (политика организации) | Нельзя переопределить |
| 2 | Флаги CLI (`--settings`, `--model`, …) | Текущая сессия |
| 3 | `.claude/settings.local.json` | Ваши личные настройки проекта (не в git) |
| 4 | `.claude/settings.json` | Общие настройки команды (**в git**) |
| 5 | `~/.claude/settings.json` | Ваши глобальные настройки |

Правило: **командные вещи — в `.claude/settings.json`, личные — в `.local.json` или `~`.**

## Пример `.claude/settings.json`

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(npm run test:*)",
      "Bash(npm run lint)",
      "Bash(git status)",
      "Bash(git diff:*)",
      "Bash(git log:*)"
    ],
    "ask": [
      "Bash(git push:*)"
    ],
    "deny": [
      "Read(./.env)",
      "Read(./.env.*)",
      "Read(./secrets/**)",
      "Bash(rm -rf:*)",
      "Bash(curl:*)"
    ],
    "defaultMode": "default"
  },
  "env": {
    "NODE_ENV": "development"
  }
}
```

Полная версия: [`starter-kit/.claude/settings.json`](../starter-kit/.claude/settings.json)

## Синтаксис правил

| Правило | Значение |
|---|---|
| `Bash(npm run build)` | Точная команда |
| `Bash(npm run test:*)` | Команды с таким префиксом |
| `Read(./.env)` | Конкретный файл |
| `Edit(src/**)` | Glob-паттерн |
| `WebFetch(domain:docs.python.org)` | Домен |
| `mcp__github` | Все инструменты MCP-сервера github |
| `mcp__github__create_issue` | Конкретный MCP-инструмент |

Порядок проверки: **deny → ask → allow**. Deny всегда побеждает.

> ⚠️ Правила для Bash работают по префиксу и не являются полноценной песочницей. Для реальной изоляции используйте sandbox/контейнер/devcontainer.

## Режимы разрешений

| Режим | Поведение |
|---|---|
| `default` | Спрашивает перед правками и командами |
| `acceptEdits` | Правки файлов без вопросов, команды — с вопросом |
| `plan` | Только чтение и планирование, ничего не меняет |
| `auto` | Классификатор сам решает, что безопасно (если доступен) |
| `dontAsk` | Отклоняет всё, что не разрешено явно |
| `bypassPermissions` | Без вопросов вообще. **Только в изолированных контейнерах** |

Переключение в сессии — `Shift+Tab`, при запуске — `claude --permission-mode plan`.

## Интерактивное управление

```
/permissions     # посмотреть и добавить правила
```

Когда Claude спрашивает разрешение, можно выбрать «разрешить и больше не спрашивать» — правило сохранится в `settings.local.json`.

## Выбор модели

```
/model                        # меню выбора
claude --model opus           # при запуске
```

Или в настройках: `"model": "opus"`. Рабочая схема:
- **Opus** — сложная архитектура, трудные баги, планирование.
- **Sonnet** — повседневная разработка, баланс скорости и качества.
- **Haiku** — быстрые простые задачи, subagents для поиска.

## Другие полезные поля

```json
{
  "model": "sonnet",
  "env": { "BASH_DEFAULT_TIMEOUT_MS": "120000" },
  "statusLine": { "type": "command", "command": "~/.claude/statusline.sh" },
  "includeCoAuthoredBy": true,
  "cleanupPeriodDays": 30,
  "enabledPlugins": {}
}
```

- **`statusLine`** — своя строка статуса (ветка git, модель, расход). Настроить: `/statusline`.
- **`hooks`** — см. модуль 07.

## Переменные окружения

| Переменная | Для чего |
|---|---|
| `ANTHROPIC_API_KEY` | Ключ API |
| `ANTHROPIC_MODEL` | Модель по умолчанию |
| `CLAUDE_CODE_USE_BEDROCK=1` / `CLAUDE_CODE_USE_VERTEX=1` | Облачные провайдеры |
| `BASH_DEFAULT_TIMEOUT_MS` | Таймаут команд |
| `DISABLE_TELEMETRY=1` | Отключить телеметрию |

## Практика

1. Создайте `.claude/settings.json` с allow-списком для команд тестов и линта.
2. Запретите чтение `.env`. Попросите Claude прочитать `.env` — убедитесь, что отказано.
3. Добавьте `.claude/settings.local.json` в `.gitignore`.

🧪 Закрепите на практике: [лабораторная работа](../labs/lab-02-permissions.md)

➡️ Далее: [04. Workflow профи](04-workflow.md)
