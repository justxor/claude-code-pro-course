# team-toolkit — пример плагина

Содержит:
- skill `review` — ревью безопасности (`/team-toolkit:review`)
- агент `security-auditor`
- hook, блокирующий опасные shell-команды

Попробовать локально:
```bash
claude --plugin-dir ./plugin-example
```

Проверить манифест:
```bash
claude plugin validate ./plugin-example
```

Подробнее — [модуль 09](../course/09-plugins.md).
