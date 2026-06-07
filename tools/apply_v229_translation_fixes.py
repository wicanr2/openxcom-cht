"""v2.29 翻譯修正 — apply 6 條 user 校對。"""
import re
from pathlib import Path

ROOT = Path("/mnt/d/openxcom/openxcom-cht")

# Files to modify
COMMON = ROOT / "bin/common/Language/zh-TW.yml"
XCOM1  = ROOT / "bin/standard/xcom1/Language/zh-TW.yml"
XCOM2  = ROOT / "bin/standard/xcom2/Language/zh-TW.yml"

# (find, replace, comment)
REPLACEMENTS = [
    # SONIC: 聲波 → 音波 (TFTD only, 25 places)
    ("聲波", "音波", "SONIC = 音波 (台灣慣用)"),

    # GILLMAN: 魚鰓人 → 鰓型人 (TFTD only, 11 places, 1995 第三波原譯)
    ("魚鰓人", "鰓型人", "GILLMAN = 鰓型人 (1995 第三波原譯)"),

    # STAMINA: 耐力 → 體力 (xcom1 + common ABBREVIATION)
    ('STR_STAMINA: "耐力"',                 'STR_STAMINA: "體力"', "STAMINA = 體力"),
    ('STR_STAMINA_ABBREVIATION: "耐力"',    'STR_STAMINA_ABBREVIATION: "體力"', "STAMINA abbr = 體力"),

    # HEALTH: 生命 → 健康 (xcom1 + xcom2 short label + UFOPEDIA description)
    ('STR_HEALTH: "生命"',                  'STR_HEALTH: "健康"', "HEALTH = 健康"),
    ('STR_HEALTH_ABBREVIATION: "血"',       'STR_HEALTH_ABBREVIATION: "健"', "HEALTH abbr = 健 (與健康一致)"),
    # 醫療包描述裡的「生命值」改「健康值」
    ("生命值", "健康值", "HEALTH desc text"),

    # FIRING/THROWING ACCURACY: 統一為 射擊命中 / 投擲命中
    ('STR_FIRING_ACCURACY: "射擊精準度"',   'STR_FIRING_ACCURACY: "射擊命中"', "Firing acc = 射擊命中 (xcom1)"),
    ('STR_THROWING_ACCURACY: "投擲精準度"', 'STR_THROWING_ACCURACY: "投擲命中"', "Throw acc = 投擲命中 (xcom1)"),
    ('STR_FIRING_ACCURACY: "射擊準度"',     'STR_FIRING_ACCURACY: "射擊命中"', "Firing acc = 射擊命中 (xcom2)"),
    ('STR_THROWING_ACCURACY: "投擲準度"',   'STR_THROWING_ACCURACY: "投擲命中"', "Throw acc = 投擲命中 (xcom2)"),
]

# Process each file
report = []
for f in (COMMON, XCOM1, XCOM2):
    txt = f.read_text(encoding="utf-8")
    file_changes = 0
    for find, repl, _ in REPLACEMENTS:
        before = txt.count(find)
        if before == 0:
            continue
        txt = txt.replace(find, repl)
        after = txt.count(repl) - (txt.count(repl) - before) if find != repl else before
        # cleaner: count diff
        n = before
        file_changes += n
        report.append((f.name, find[:40], repl[:40], n))
    f.write_text(txt, encoding="utf-8")
    print(f"{f.name}: {file_changes} replacements")

print()
print("=== Detailed report ===")
for name, find, repl, n in report:
    print(f"  {name}: '{find}' -> '{repl}' ({n}x)")
