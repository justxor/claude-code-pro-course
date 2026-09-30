# Модуль 09. Плагины и маркетплейсы

**Плагин** — пакет, объединяющий skills, subagents, hooks, MCP-серверы (и старые commands). Это способ **раздать всю вашу настройку команде одной командой**.

## Структура плагина

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json         # манифест (обязателен)
├── skills/
│   └── review/SKILL.md
├── agents/
│   └── security-auditor.md
├── commands/               # (опционально, старый формат)
├── hooks/
│   └── hooks.json
└── .mcp.json
```

> Важно: в `.claude-plugin/` лежит только `plugin.json`. Остальные папки — в корне плагина.

Пример: [`plugin-example/`](../plugin-example/)

## plugin.json

```json
{
  "name": "team-toolkit",
  "description": "Стандарты команды: ревью, коммиты, защита файлов",
  "version": "1.0.0",
  "author": { "name": "Your Team" }
}
```

## hooks/hooks.json

Тот же формат, что в settings. Для путей внутри плагина — `${CLAUDE_PLUGIN_ROOT}`:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{ "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/scripts/protect.sh" }]
    }]
  }
}
```

## Локальная разработка

```bash
claude --plugin-dir ./plugin-example     # загрузить плагин на одну сессию
claude plugin validate ./plugin-example  # проверить манифест
/reload-plugins                          # перечитать после правок (если доступно)
```

Skills плагина вызываются с префиксом: `/team-toolkit:review`.

## Маркетплейс

Маркетплейс — git-репозиторий с каталогом плагинов в `.claude-plugin/marketplace.json`:

```json
{
  "name": "acme-tools",
  "owner": { "name": "Acme" },
  "plugins": [
    {
      "name": "team-toolkit",
      "source": "./plugins/team-toolkit",
      "description": "Стандарты команды"
    }
  ]
}
```

Использование:

```
/plugin marketplace add acme/claude-plugins     # GitHub owner/repo, URL или путь
/plugin install team-toolkit@acme-tools
/plugin                                          # менеджер: установленные, включить/выключить
```

## Автоподключение для команды

В `.claude/settings.json` проекта:

```json
{
  "extraKnownMarketplaces": {
    "acme-tools": { "source": { "source": "github", "repo": "acme/claude-plugins" } }
  },
  "enabledPlugins": {
    "team-toolkit@acme-tools": true
  }
}
```

Когда коллега откроет проект и доверит папке, ему предложат установить маркетплейс и плагины.

## Что упаковывать в плагин, а что нет

| В плагин | В репозиторий проекта |
|---|---|
| Общие стандарты для многих репо | Специфика одного проекта |
| Ревью, коммиты, безопасность | Команды сборки, архитектура |
| Интеграции (MCP) компании | CLAUDE.md проекта |

## Практика

1. Запустите `claude --plugin-dir ./plugin-example`, вызовите его skill.
2. Добавьте в плагин свой skill из модуля 05.
3. Создайте репозиторий-маркетплейс и установите из него плагин.

➡️ Далее: [10. Headless, CI и GitHub Actions](10-headless-ci.md)
