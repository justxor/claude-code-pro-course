---
name: commit
description: Создаёт git-коммит в формате Conventional Commits по текущим изменениям. Используй, когда просят закоммитить или сделать коммит.
allowed-tools: Bash(git status), Bash(git diff:*), Bash(git add:*), Bash(git commit:*), Bash(git log:*)
argument-hint: "[необязательное пояснение]"
---

# Commit

Контекст от пользователя: $ARGUMENTS

1. `git status` и `git diff` (+ `git diff --staged`) — пойми, что изменилось.
2. `git log --oneline -10` — посмотри стиль сообщений в репозитории.
3. Если изменения логически разные — предложи разбить на несколько коммитов.
4. Не добавляй в коммит `.env`, секреты, временные и сгенерированные файлы.
5. Сообщение:
   ```
   <type>(<scope>): <кратко, повелительное наклонение, до 72 символов>

   <зачем сделано изменение, если неочевидно>
   ```
   type: feat | fix | refactor | test | docs | chore | perf | ci
6. Сделай коммит и покажи `git log --oneline -1`.
