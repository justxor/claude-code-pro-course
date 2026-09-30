#!/usr/bin/env bash
# Notification: системное уведомление, когда Claude ждёт ввода или разрешения.
msg=$(jq -r '.message // "Claude Code ждёт вашего ввода"' 2>/dev/null || echo "Claude Code ждёт вашего ввода")
if command -v osascript >/dev/null 2>&1; then
  osascript -e "display notification \"${msg//\"/\\\"}\" with title \"Claude Code\"" >/dev/null 2>&1
elif command -v notify-send >/dev/null 2>&1; then
  notify-send "Claude Code" "$msg" >/dev/null 2>&1
elif command -v powershell.exe >/dev/null 2>&1; then
  powershell.exe -NoProfile -Command "[console]::beep(800,300)" >/dev/null 2>&1
else
  printf '\a'
fi
exit 0
