# Модуль 07. Hooks

**Hooks** — shell-команды, которые Claude Code запускает автоматически на событиях жизненного цикла. В отличие от инструкций в CLAUDE.md (которые Claude *может* забыть), hooks выполняются **всегда и детерминированно**.

> Правило: «Claude должен помнить» → CLAUDE.md. «Это должно случаться всегда» → hook.

## События

| Событие | Когда | Типичное применение |
|---|---|---|
| `PreToolUse` | Перед вызовом инструмента | Блокировать опасные команды, защищать файлы |
| `PostToolUse` | После вызова инструмента | Автоформат, линт, тесты |
| `UserPromptSubmit` | Вы отправили промпт | Добавить контекст, фильтровать промпт |
| `Notification` | Claude ждёт ввода/разрешения | Десктоп-уведомление |
| `Stop` | Claude закончил ответ | Проверка «всё ли готово», уведомление |
| `SubagentStop` | Субагент закончил | Логирование |
| `SessionStart` | Старт/возобновление сессии | Загрузить контекст (задачи, ветка) |
| `SessionEnd` | Конец сессии | Очистка, логи |
| `PreCompact` | Перед сжатием контекста | Сохранить важное |

## Формат конфигурации

В `settings.json` (любого уровня):

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/format-on-edit.sh" }
        ]
      }
    ]
  }
}
```

- `matcher` — regex по имени инструмента (`Bash`, `Edit|Write`, `mcp__github__.*`). Для событий без инструментов не нужен.
- `$CLAUDE_PROJECT_DIR` — корень проекта.
- Интерактивно: `/hooks`.

## Вход и выход hook

Hook получает JSON в **stdin**:

```json
{
  "session_id": "...",
  "hook_event_name": "PreToolUse",
  "tool_name": "Edit",
  "tool_input": { "file_path": "src/app.ts", "old_string": "...", "new_string": "..." }
}
```

Коды выхода:

| Код | Значение |
|---|---|
| `0` | Успех, продолжаем |
| `2` | **Блокировка.** Для `PreToolUse` — вызов отменяется, stderr передаётся Claude как объяснение. Для `Stop` — Claude продолжает работу |
| другой | Ошибка hook, показывается пользователю, выполнение продолжается |

Для тонкого управления hook может вывести JSON в stdout (например, `"decision": "block"` с `"reason"`, или `additionalContext`).

## Рецепты

### 1. Автоформат после правки

```bash
#!/usr/bin/env bash
# .claude/hooks/format-on-edit.sh
file=$(jq -r '.tool_input.file_path // empty')
[ -z "$file" ] && exit 0
case "$file" in
  *.ts|*.tsx|*.js|*.jsx|*.json|*.css|*.md) npx prettier --write "$file" >/dev/null 2>&1 ;;
  *.py) ruff format "$file" >/dev/null 2>&1 ;;
  *.go) gofmt -w "$file" ;;
esac
exit 0
```

### 2. Защита файлов

```bash
#!/usr/bin/env bash
# .claude/hooks/protect-files.sh — PreToolUse, matcher: Edit|Write
file=$(jq -r '.tool_input.file_path // empty')
for p in ".env" "package-lock.json" ".git/" "migrations/"; do
  if [[ "$file" == *"$p"* ]]; then
    echo "Файл $file защищён hook-ом. Не редактируй его." >&2
    exit 2
  fi
done
exit 0
```

### 3. Блокировка опасных команд

```json
{
  "matcher": "Bash",
  "hooks": [{
    "type": "command",
    "command": "jq -r '.tool_input.command' | grep -Eq 'rm -rf /|git push --force|DROP TABLE' && { echo 'Опасная команда заблокирована' >&2; exit 2; } || exit 0"
  }]
}
```

### 4. Уведомление, когда Claude ждёт

```json
"Notification": [{
  "hooks": [{ "type": "command", "command": "notify-send 'Claude Code' 'Нужен ваш ввод'" }]
}]
```
macOS: `osascript -e 'display notification "Нужен ввод" with title "Claude Code"'`

### 5. Контекст при старте сессии

```json
"SessionStart": [{
  "hooks": [{ "type": "command", "command": "echo \"Ветка: $(git branch --show-current)\"; gh issue list --assignee @me --limit 5" }]
}]
```
Stdout `SessionStart` добавляется в контекст Claude.

### 6. Тесты перед завершением (Stop)
Hook на `Stop`, который запускает быстрые тесты и при падении возвращает `exit 2` с выводом ошибок — Claude продолжит и исправит. Следите за бесконечными циклами: проверяйте поле `stop_hook_active` во входном JSON.

## Безопасность

Hooks выполняют **произвольные команды с вашими правами**.
- Читайте hooks из чужих репозиториев перед запуском.
- Кавычьте переменные (`"$file"`), проверяйте пути на `..`.
- Используйте абсолютные пути / `$CLAUDE_PROJECT_DIR`.

## Отладка

- `claude --debug` — подробный лог выполнения hooks.
- Тест вручную: `echo '{"tool_input":{"file_path":"a.ts"}}' | .claude/hooks/format-on-edit.sh`

## Практика

1. Подключите `format-on-edit.sh` из starter-kit. Попросите Claude написать неотформатированный код — проверьте результат.
2. Подключите `protect-files.sh` и попросите отредактировать `.env`.
3. Настройте уведомление на `Notification`.

🧪 Закрепите на практике: [лабораторная работа](../labs/lab-06-hooks.md)

➡️ Далее: [08. MCP](08-mcp.md)
