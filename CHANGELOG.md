# Changelog

## [1.1.0] — 2026-09-30
### Добавлено
- 8 лабораторных работ (`labs/`) с критериями готовности
- Библиотека промптов (`recipes/prompts.md`) — 13 категорий
- FAQ и решение проблем (`course/faq.md`)
- Skills: `refactor`, `pr-description` (с шаблоном), `release-notes`, `onboard`
- Субагенты: `architect`, `docs-writer`
- Правила по путям: `.claude/rules/{testing,api,frontend}.md`
- Output style «Mentor», статусная строка, hooks `notify.sh` и `session-context.sh`
- `install.sh` — установка starter-kit в проект или в `~/.claude`
- CI: `validate.yml` (JSON, frontmatter, ссылки, shellcheck, smoke-тесты hooks) и `claude-review.yml` (авто-ревью PR)
- `CONTRIBUTING.md`, `CLAUDE.md` репозитория, шаблоны issue и PR
- README: схема курса, карта конфигурации, чек-лист прогресса

### Изменено
- hooks вызываются через `bash`, чтобы не зависеть от прав на исполнение

## [1.0.0] — 2026-09-30
- Первая версия: 12 модулей, шпаргалка, starter-kit, пример плагина, workflow для `@claude`
