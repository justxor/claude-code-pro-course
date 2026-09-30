# Claude Code PRO — курс и гайд

> Практический курс по работе с **Claude Code**: от первого запуска до профессиональной настройки команды — CLAUDE.md, settings, skills, subagents, hooks, MCP, плагины, headless-режим и CI.
> Всё на русском, с готовыми шаблонами, которые можно скопировать в свой проект.

![level](https://img.shields.io/badge/уровень-от_новичка_до_профи-blue) ![lang](https://img.shields.io/badge/язык-русский-green) ![license](https://img.shields.io/badge/license-MIT-lightgrey)

---

## Для кого

- Разработчики, которые уже пробовали Claude Code и хотят выжать из него максимум.
- Тимлиды, которым нужно настроить единые правила для команды.
- Все, кто хочет автоматизировать рутину: ревью, тесты, коммиты, CI.

## Как проходить

1. Читайте модули по порядку — каждый опирается на предыдущий.
2. В конце каждого модуля есть **практика** — делайте её в своём проекте.
3. Берите готовые файлы из [`starter-kit/`](starter-kit/) — это рабочая конфигурация, которую можно скопировать целиком.

## Программа

| # | Модуль | Что освоите |
|---|--------|-------------|
| 00 | [Установка и первый запуск](course/00-install.md) | Установка, логин, первая сессия, интерфейс |
| 01 | [Основы работы и промптинг](course/01-basics-prompting.md) | Как ставить задачи, контекст, @-упоминания, изображения |
| 02 | [CLAUDE.md — память проекта](course/02-claude-md.md) | Иерархия, импорты, rules, что писать и чего не писать |
| 03 | [Настройки и разрешения](course/03-settings-permissions.md) | settings.json, allow/ask/deny, режимы, env, модели |
| 04 | [Workflow профи](course/04-workflow.md) | Plan mode, Explore→Plan→Code→Commit, TDD, чекпоинты, контекст |
| 05 | [Skills и slash-команды](course/05-skills.md) | Свои навыки, SKILL.md, аргументы, авто-вызов |
| 06 | [Subagents](course/06-subagents.md) | Специализированные агенты, изоляция контекста, параллельность |
| 07 | [Hooks](course/07-hooks.md) | Автоформат, линт, защита файлов, уведомления |
| 08 | [MCP — подключение внешних инструментов](course/08-mcp.md) | GitHub, БД, браузер, свои серверы |
| 09 | [Плагины и маркетплейсы](course/09-plugins.md) | Упаковка и раздача конфигурации команде |
| 10 | [Headless, CI и GitHub Actions](course/10-headless-ci.md) | `claude -p`, JSON-вывод, @claude в PR, Agent SDK |
| 11 | [Продвинутые приёмы и чек-лист профи](course/11-pro-tips.md) | Worktrees, мульти-агенты, экономия токенов, безопасность |

📎 Дополнительно: [Шпаргалка](course/cheatsheet.md) · [Starter kit](starter-kit/) · [Пример плагина](plugin-example/) · [Workflow для GitHub Actions](.github/workflows/claude.yml)

## Быстрый старт за 5 минут

```bash
# 1. Установка (нативный установщик)
curl -fsSL https://claude.ai/install.sh | bash      # macOS / Linux / WSL
# или: npm install -g @anthropic-ai/claude-code

# 2. Запуск в проекте
cd my-project
claude

# 3. Внутри сессии
/init          # сгенерировать CLAUDE.md
/permissions   # настроить разрешения
/model         # выбрать модель
```

Скопируйте starter-kit в свой проект:

```bash
git clone https://github.com/<you>/claude-code-pro-course.git
cp -r claude-code-pro-course/starter-kit/.claude my-project/
cp claude-code-pro-course/starter-kit/CLAUDE.md my-project/   # затем отредактируйте
```

## Структура репозитория

```
.
├── course/                  # 12 модулей курса + шпаргалка
├── starter-kit/             # готовая конфигурация для копирования
│   ├── CLAUDE.md
│   ├── .mcp.json
│   └── .claude/
│       ├── settings.json
│       ├── skills/          # code-review, commit, write-tests, fix-issue
│       ├── agents/          # code-reviewer, test-runner, debugger
│       └── hooks/           # format-on-edit.sh, protect-files.sh
├── plugin-example/          # пример плагина для раздачи команде
└── .github/workflows/       # Claude в GitHub Actions
```

## Главные принципы (TL;DR)

1. **Контекст — ваш главный ресурс.** Чистите (`/clear`), сжимайте (`/compact`), выносите исследование в subagents.
2. **Сначала план, потом код.** Plan mode (`Shift+Tab`) для всего, что сложнее одного файла.
3. **Дайте Claude способ проверить себя** — тесты, линтер, скриншоты. Это самый сильный рычаг качества.
4. **CLAUDE.md короткий и конкретный.** Команды сборки, стиль, запреты. Не роман.
5. **Повторяется дважды — сделайте skill.** Повторяется всегда и детерминированно — сделайте hook.
6. **Разрешения — через allowlist,** а не через `bypassPermissions`.

## Полезные ссылки

- Документация: https://code.claude.com/docs
- Best practices от Anthropic: https://www.anthropic.com/engineering/claude-code-best-practices
- GitHub Action: https://github.com/anthropics/claude-code-action

> ⚠️ Claude Code быстро развивается. Если команда или поле не работает — сверьтесь с `/help` и официальной документацией. PR с исправлениями приветствуются.

## Лицензия

MIT — используйте, копируйте, адаптируйте.
