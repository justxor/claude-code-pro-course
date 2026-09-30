# Starter kit

Готовая конфигурация Claude Code для копирования в проект.

```bash
cp -r starter-kit/.claude your-project/
cp starter-kit/CLAUDE.md starter-kit/.mcp.json your-project/
cat starter-kit/.gitignore.example >> your-project/.gitignore
```

| Файл | Что это | Модуль |
|---|---|---|
| `CLAUDE.md` | Шаблон памяти проекта — отредактируйте! | [02](../course/02-claude-md.md) |
| `CLAUDE.local.md.example` | Личные предпочтения | [02](../course/02-claude-md.md) |
| `.claude/settings.json` | Разрешения + hooks | [03](../course/03-settings-permissions.md) |
| `.claude/skills/` | code-review, commit, write-tests, fix-issue | [05](../course/05-skills.md) |
| `.claude/agents/` | code-reviewer, test-runner, debugger | [06](../course/06-subagents.md) |
| `.claude/hooks/` | format-on-edit, protect-files (нужен `jq`) | [07](../course/07-hooks.md) |
| `.mcp.json` | GitHub + Playwright MCP | [08](../course/08-mcp.md) |

После копирования проверьте: `/context`, `/agents`, `/hooks`, `/mcp`.
