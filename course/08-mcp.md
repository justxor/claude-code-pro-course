# Модуль 08. MCP — подключение внешних инструментов

**MCP (Model Context Protocol)** — открытый протокол, через который Claude подключается к внешним системам: GitHub, базы данных, браузер, Sentry, Figma, Notion, Jira, ваши внутренние API.

## Добавление сервера

```bash
# Удалённый HTTP-сервер
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# С заголовком авторизации
claude mcp add --transport http myapi https://api.example.com/mcp \
  --header "Authorization: Bearer $MY_TOKEN"

# Локальный stdio-сервер (всё после -- — команда запуска)
claude mcp add playwright -- npx -y @playwright/mcp@latest
claude mcp add --env DATABASE_URL=postgres://... db -- npx -y @bytebase/dbhub --dsn "$DATABASE_URL"
```

Управление:

```bash
claude mcp list
claude mcp get github
claude mcp remove github
/mcp                       # внутри сессии: статус, OAuth-логин
```

## Области (scopes)

| Scope | Флаг | Где хранится | Для кого |
|---|---|---|---|
| local (по умолчанию) | `-s local` | `~/.claude.json` (для проекта) | Вы, этот проект |
| project | `-s project` | `.mcp.json` в корне | Вся команда (в git) |
| user | `-s user` | `~/.claude.json` | Вы, все проекты |

## `.mcp.json` для команды

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": { "Authorization": "Bearer ${GITHUB_TOKEN}" }
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@bytebase/dbhub", "--dsn", "${DATABASE_URL:-postgres://localhost/dev}"]
    }
  }
}
```

Переменные `${VAR}` и `${VAR:-default}` раскрываются из окружения — **секреты не коммитятся**. При первом запуске Claude спросит подтверждение на использование серверов проекта.

## Популярные серверы

| Сервер | Зачем |
|---|---|
| GitHub | Issues, PR, ревью, Actions |
| Playwright / Chrome DevTools | Браузер: открыть страницу, кликнуть, скриншот, консоль |
| PostgreSQL / DBHub | Запросы к БД (лучше read-only пользователь!) |
| Sentry | Ошибки продакшена → исправление |
| Figma | Макеты → код |
| Context7 | Актуальная документация библиотек |
| Notion / Linear / Jira | Задачи и спецификации |

## Использование

```
> возьми issue #231 из GitHub, реализуй и открой PR
> открой localhost:3000/checkout в браузере, пройди оформление заказа и найди ошибку в консоли
> сколько заказов за вчера упало со статусом failed? (из БД)
```

MCP-ресурсы можно упоминать через `@`: `@github:issue://231`. MCP-промпты становятся командами `/mcp__server__prompt`.

## Разрешения для MCP

```json
"permissions": {
  "allow": ["mcp__github__get_issue", "mcp__playwright"],
  "deny":  ["mcp__postgres__execute_write"]
}
```

## Контекст и MCP

Каждый сервер добавляет описания инструментов в контекст. Подключайте только нужное, проверяйте `/context`. Большие наборы инструментов Claude может загружать по требованию (tool search), но лишние серверы всё равно отключайте.

## Безопасность

- Доверяйте только проверенным серверам — они получают данные и могут выполнять действия.
- Данные из MCP (страницы, issues, письма) могут содержать prompt injection. Не давайте широких разрешений на запись.
- Для БД — read-only учётка.

## Свой MCP-сервер

Официальные SDK: TypeScript, Python и другие (`modelcontextprotocol` на GitHub). Минимальный сервер на Python (FastMCP) — ~20 строк: объявляете функцию с декоратором `@mcp.tool()` — Claude получает инструмент.

## Практика

1. Подключите Playwright MCP, попросите Claude открыть ваш локальный сайт и сделать скриншот.
2. Создайте `.mcp.json` для команды без секретов, через `${VAR}`.
3. Выполните `/context` и оцените, сколько места занимают MCP-инструменты.

🧪 Закрепите на практике: [лабораторная работа](../labs/lab-07-mcp.md)

➡️ Далее: [09. Плагины](09-plugins.md)
