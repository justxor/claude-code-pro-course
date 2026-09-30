# Лаба 8. Автоматизация: headless и GitHub Actions

**Цель:** Claude работает без вас — в скриптах и в CI.

## Часть A — headless

1. Сообщение коммита одной командой:
   ```bash
   git diff --staged | claude -p "Напиши сообщение коммита в формате Conventional Commits. Только сообщение."
   ```
   Оформите как alias или git hook `prepare-commit-msg`.
2. JSON и продолжение сессии:
   ```bash
   SID=$(claude -p "найди TODO в src/ и сгруппируй по файлам" --output-format json | jq -r .session_id)
   claude -p --resume "$SID" "теперь оцени сложность каждого TODO"
   ```
3. Fan-out: обработайте 3 файла в цикле с `--allowedTools "Read,Edit" --max-turns 8`.

## Часть B — GitHub Actions

1. В Claude Code: `/install-github-app` (или вручную по [модулю 10](../course/10-headless-ci.md)).
2. Создайте issue: `@claude добавь валидацию email в POST /users, с тестами`.
3. Откройте PR и проверьте авто-ревью из [`claude-review.yml`](../.github/workflows/claude-review.yml).

## ✅ Готово, если
- [ ] Alias/хук для сообщений коммитов работает
- [ ] Вы продолжили headless-сессию по `session_id`
- [ ] `@claude` в issue создал ветку/PR
- [ ] Авто-ревью оставило комментарии в PR
- [ ] В workflow ограничены `--max-turns` и права

🎓 Все лабы пройдены — вы уверенный пользователь Claude Code. Отметьте это в [чек-листе](../README.md#прогресс)!
