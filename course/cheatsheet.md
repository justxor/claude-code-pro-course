# Шпаргалка Claude Code

## Клавиши
| | |
|---|---|
| `Esc` | прервать |
| `Esc Esc` | rewind — откат к прошлому сообщению |
| `Shift+Tab` | режим: default → acceptEdits → plan |
| `@file` | файл в контекст |
| `!cmd` | shell-команда напрямую |
| `#текст` | добавить в память |
| `Ctrl+V` / drag&drop | вставить изображение |
| `Ctrl+R` | поиск по истории |

## Слэш-команды
```
/init /memory /clear /compact [фокус] /context /cost /model /config
/permissions /hooks /agents /mcp /plugin /resume /rewind /review
/statusline /output-style /install-github-app /doctor /help
```

## CLI
```bash
claude                          # интерактив
claude "задача"                 # старт с промптом
claude -c                       # продолжить последнюю
claude -r                       # выбрать сессию
claude -p "..."                 # headless
claude -p "..." --output-format json
claude --model opus
claude --permission-mode plan
claude --allowedTools "Read,Bash(npm test:*)"
claude --plugin-dir ./my-plugin
claude mcp add|list|remove
claude update | claude doctor
```

## Файлы
```
~/.claude/CLAUDE.md               личная память
~/.claude/settings.json           личные настройки
~/.claude/skills/ agents/         личные skills/агенты
./CLAUDE.md                       память проекта (git)
./CLAUDE.local.md                 личная память проекта
./.claude/settings.json           настройки команды (git)
./.claude/settings.local.json     личные настройки проекта
./.claude/skills/<n>/SKILL.md     skills проекта
./.claude/agents/<n>.md           субагенты проекта
./.claude/rules/*.md              правила с paths
./.mcp.json                       MCP-серверы проекта
```

## Разрешения
```json
"permissions": {
  "allow": ["Bash(npm run test:*)", "Read(src/**)"],
  "ask":   ["Bash(git push:*)"],
  "deny":  ["Read(./.env)", "Bash(rm -rf:*)"]
}
```

## Hook
```json
"hooks": { "PostToolUse": [ { "matcher": "Edit|Write",
  "hooks": [ { "type": "command", "command": "./.claude/hooks/fmt.sh" } ] } ] }
```
exit 0 — ок · exit 2 — блок (stderr → Claude)

## Skill
```markdown
---
name: my-skill
description: Что делает. Когда использовать.
allowed-tools: Read, Grep
---
Инструкции... $ARGUMENTS
```

## Subagent
```markdown
---
name: reviewer
description: Используй проактивно после изменений кода
tools: Read, Grep, Glob, Bash
model: sonnet
---
Системный промпт агента...
```

## Цикл
**Explore → Plan (Shift+Tab) → Code + тесты → Review → Commit → /clear**
