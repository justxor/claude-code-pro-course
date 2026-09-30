#!/usr/bin/env python3
"""Проверка репозитория: JSON, YAML frontmatter skills/агентов/правил/стилей, bash-синтаксис, относительные ссылки в Markdown.

Запуск: python3 scripts/validate.py   (нужен PyYAML: pip install pyyaml)
"""
import json
import re
import subprocess
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("Нужен PyYAML: pip install pyyaml")

ROOT = Path(__file__).resolve().parent.parent
SKIP_DIRS = {".git", "node_modules"}
errors: list[str] = []


def files(pattern: str):
    for p in ROOT.rglob(pattern):
        if not SKIP_DIRS.intersection(p.relative_to(ROOT).parts):
            yield p


def rel(p: Path) -> str:
    return str(p.relative_to(ROOT))


def frontmatter(p: Path):
    text = p.read_text(encoding="utf-8")
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not m:
        errors.append(f"{rel(p)}: нет YAML frontmatter (--- ... ---)")
        return None
    try:
        data = yaml.safe_load(m.group(1)) or {}
    except yaml.YAMLError as e:
        errors.append(f"{rel(p)}: невалидный YAML frontmatter: {e}")
        return None
    if not isinstance(data, dict):
        errors.append(f"{rel(p)}: frontmatter должен быть словарём")
        return None
    return data


def require(p: Path, data: dict, keys):
    for k in keys:
        if not data.get(k):
            errors.append(f"{rel(p)}: во frontmatter нет обязательного поля '{k}'")


# 1. JSON
for p in files("*.json"):
    try:
        json.loads(p.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        errors.append(f"{rel(p)}: невалидный JSON: {e}")

# 2. Skills
for p in files("SKILL.md"):
    data = frontmatter(p)
    if data is None:
        continue
    require(p, data, ["name", "description"])
    if data.get("name") and data["name"] != p.parent.name:
        errors.append(f"{rel(p)}: name '{data['name']}' не совпадает с папкой '{p.parent.name}'")
    if len(str(data.get("description", ""))) > 1024:
        errors.append(f"{rel(p)}: description длиннее 1024 символов")

# 3. Агенты, правила, output styles
for p in files("*.md"):
    parts = p.relative_to(ROOT).parts
    if len(parts) >= 2 and parts[-2] == "agents":
        data = frontmatter(p)
        if data is not None:
            require(p, data, ["name", "description"])
            if data.get("name") and data["name"] != p.stem:
                errors.append(f"{rel(p)}: name '{data['name']}' не совпадает с именем файла")
    elif len(parts) >= 2 and parts[-2] == "rules":
        data = frontmatter(p)
        if data is not None and "paths" in data and not isinstance(data["paths"], list):
            errors.append(f"{rel(p)}: paths должен быть списком")
    elif len(parts) >= 2 and parts[-2] == "output-styles":
        data = frontmatter(p)
        if data is not None:
            require(p, data, ["name", "description"])

# 4. Bash-синтаксис
for p in files("*.sh"):
    r = subprocess.run(["bash", "-n", str(p)], capture_output=True, text=True)
    if r.returncode != 0:
        errors.append(f"{rel(p)}: ошибка синтаксиса bash: {r.stderr.strip()}")

# 5. Относительные ссылки в Markdown (вне блоков кода)
link_re = re.compile(r"\[[^\]]*\]\(([^)\s]+)\)")
for p in files("*.md"):
    text = re.sub(r"```.*?```", "", p.read_text(encoding="utf-8"), flags=re.S)
    text = re.sub(r"`[^`\n]*`", "", text)
    for target in link_re.findall(text):
        if re.match(r"^(https?:|mailto:|#)", target):
            continue
        path = target.split("#")[0]
        if not path:
            continue
        if not (p.parent / path).exists():
            errors.append(f"{rel(p)}: битая ссылка -> {target}")

if errors:
    print(f"❌ Найдено проблем: {len(errors)}")
    for e in errors:
        print("  -", e)
    sys.exit(1)
print("✅ Всё в порядке")
