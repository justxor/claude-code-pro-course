---
name: release-notes
description: Генерирует release notes / CHANGELOG между двумя тегами или от последнего тега. Используй, когда просят release notes, changelog или список изменений релиза.
allowed-tools: Bash(git log:*), Bash(git tag:*), Bash(git describe:*), Read, Edit
argument-hint: "[от-тега] [до-тега]"
---

# Release notes

Диапазон: `$ARGUMENTS` (если пусто — от последнего тега `git describe --tags --abbrev=0` до HEAD).

1. `git log <от>..<до> --pretty=format:'%h %s (%an)' --no-merges`
2. Сгруппируй по типам Conventional Commits:
   - ✨ Новое (`feat`)
   - 🐛 Исправления (`fix`)
   - ⚡ Производительность (`perf`)
   - ♻️ Рефакторинг и прочее (`refactor`, `chore`, `docs`, `ci`) — кратко, одной строкой
   - 💥 **Breaking changes** (`!` или `BREAKING CHANGE`) — всегда первым блоком
3. Переписывай технические сообщения на язык пользователя: что изменилось для него.
4. Если есть `CHANGELOG.md` — предложи добавить секцию сверху (формат Keep a Changelog).
