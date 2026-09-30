# Репозиторий курса Claude Code PRO

Учебный курс на русском + готовые шаблоны. Здесь нет приложения — только Markdown, JSON, YAML и bash.

## Структура
- `course/` — модули 00–11, `cheatsheet.md`, `faq.md`
- `labs/` — лабораторные работы
- `recipes/prompts.md` — библиотека промптов
- `starter-kit/` — шаблоны для копирования в проекты (`.claude/`, `CLAUDE.md`, `.mcp.json`)
- `plugin-example/` — пример плагина
- `install.sh` — установщик starter-kit; `scripts/validate.py` — проверки

## Команды
- `python3 scripts/validate.py` — обязательно после изменений
- `shellcheck $(git ls-files '*.sh')`
- `bash install.sh "$(mktemp -d)"` — проверить установщик

## Правила
- Факты о Claude Code сверяй с https://code.claude.com/docs; при сомнении — помечай.
- Добавил файл → добавь в оглавление (README.md, labs/README.md, starter-kit/README.md).
- Имя skill = имя папки; имя агента = имя файла.
- Модули заканчиваются разделом «Практика» и ссылкой «➡️ Далее».
- Никаких реальных токенов и ключей в примерах.
