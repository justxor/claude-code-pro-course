# Модуль 10. Headless, CI и GitHub Actions

## Headless-режим: `claude -p`

`-p` (`--print`) — выполнить задачу без интерактива и выйти. Основа для скриптов, CI, pre-commit и пайплайнов.

```bash
claude -p "объясни, что делает этот проект"
cat build.log | claude -p "почему упала сборка?"
git diff --staged | claude -p "напиши сообщение коммита в формате Conventional Commits"
```

### Ключевые флаги

| Флаг | Зачем |
|---|---|
| `--output-format text\|json\|stream-json` | Формат вывода |
| `--allowedTools "Read,Edit,Bash(npm test:*)"` | Что разрешено без вопросов |
| `--disallowedTools "Bash(git push:*)"` | Что запрещено |
| `--permission-mode acceptEdits` | Режим разрешений |
| `--max-turns 10` | Ограничить число шагов |
| `--model sonnet` | Модель |
| `--append-system-prompt "..."` | Добавить к системному промпту |
| `--mcp-config ./mcp.json` | MCP-серверы |
| `-c` / `--resume <id>` | Продолжить сессию |
| `--verbose` | Подробный вывод |

### JSON-вывод

```bash
claude -p "сколько TODO в src/?" --output-format json | jq -r '.result'
```

Ответ содержит `result`, `session_id`, стоимость и число токенов — удобно для логирования и продолжения (`--resume $session_id`).

### Паттерн: fan-out по файлам

```bash
for f in $(git ls-files 'src/**/*.js'); do
  claude -p "мигрируй $f с CommonJS на ESM. Верни OK или FAIL: причина" \
    --allowedTools "Read,Edit" --max-turns 8
done
```

Сначала отладьте промпт на 2–3 файлах, потом запускайте на всех.

### Паттерн: Claude как линтер

```json
"scripts": {
  "lint:ai": "git diff main | claude -p 'ты ревьюер. Выведи только проблемы с опечатками и неясными именами: файл:строка — проблема'"
}
```

## GitHub Actions

### Быстрая установка

Внутри Claude Code:
```
/install-github-app
```
Команда установит GitHub App, добавит секрет и создаст workflow.

### Вручную

1. Установите [Claude GitHub App](https://github.com/apps/claude) на репозиторий.
2. Добавьте секрет `ANTHROPIC_API_KEY` (или `CLAUDE_CODE_OAUTH_TOKEN` из `claude setup-token` для подписки).
3. Добавьте workflow: [`.github/workflows/claude.yml`](../.github/workflows/claude.yml)

```yaml
name: Claude
on:
  issue_comment: { types: [created] }
  pull_request_review_comment: { types: [created] }
  issues: { types: [opened, assigned] }

jobs:
  claude:
    if: contains(github.event.comment.body, '@claude') || contains(github.event.issue.body, '@claude')
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
      issues: write
      id-token: write
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

Теперь в любом issue/PR: `@claude исправь этот баг` или `@claude сделай ревью`.

### Автоматическое ревью каждого PR

```yaml
on:
  pull_request: { types: [opened, synchronize] }
jobs:
  review:
    runs-on: ubuntu-latest
    permissions: { contents: read, pull-requests: write, id-token: write }
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Сделай ревью этого PR: баги, безопасность, тесты.
            Оставь комментарии к конкретным строкам. Будь краток.
          claude_args: "--max-turns 10 --model sonnet"
```

Claude в CI читает ваш `CLAUDE.md` — правила проекта работают и там.

### Другие идеи для CI
- Ночной job: «найди и исправь flaky-тесты, открой PR».
- По метке `claude-fix` на issue — автоматическая попытка исправления.
- Генерация release notes по тегу.
- Перевод документации при изменении `docs/`.

## Claude Agent SDK

Когда нужно встроить агента в свой продукт или сложный пайплайн — Agent SDK даёт тот же движок, что у Claude Code, как библиотеку:

```bash
pip install claude-agent-sdk
npm install @anthropic-ai/claude-agent-sdk
```

```python
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions

async def main():
    async for msg in query(
        prompt="Найди и исправь баг в utils.py",
        options=ClaudeAgentOptions(allowed_tools=["Read", "Edit", "Bash"]),
    ):
        print(msg)

asyncio.run(main())
```

Поддерживаются те же инструменты, hooks, MCP, subagents и настройки.

## Безопасность в автоматизации

- Минимальные `--allowedTools`, никаких широких `Bash(*)`.
- `bypassPermissions` — только в одноразовом контейнере без секретов.
- Ограничивайте `--max-turns` и бюджет.
- Помните о prompt injection из issues/комментариев внешних пользователей: ограничьте, кто может триггерить workflow.

## Практика

1. Сделайте alias: `git diff --staged | claude -p "commit message"`.
2. Подключите workflow из репозитория и напишите `@claude` в тестовом issue.
3. Получите JSON-вывод и достаньте `session_id`, продолжите сессию через `--resume`.

➡️ Далее: [11. Продвинутые приёмы](11-pro-tips.md)
