"""v2.29 — apply translation fixes to README + other docs."""
from pathlib import Path

ROOT = Path("/mnt/d/openxcom/openxcom-cht")

# Doc files to touch (yml already done)
TARGETS = [
    ROOT / "README.md",
    ROOT / "docs/tftd_knowledge_base_draft.md",
    ROOT / "docs/tftd_knowledge_base_v2.md",
]

REPLACEMENTS = [
    # SONIC: 聲波 -> 音波 (case by case to be safe)
    ("聲波加農", "音波加農"),
    ("聲波手槍", "音波手槍"),
    ("聲波爆裂步槍", "音波爆裂步槍"),
    ("聲波振盪器", "音波振盪器"),
    ("聲波科技", "音波科技"),
    ("聲波武器", "音波武器"),
    ("聲波擾亂器", "音波擾亂器"),
    ("聲波偵測器", "音波偵測器"),
    ("聲波系列", "音波系列"),
    ("聲波襲擊", "音波襲擊"),
    ("受聲波壓制", "受音波壓制"),
    ("會被聲波淘汰", "會被音波淘汰"),
    # SONIC: 描述中的「聲波」單獨出現也改
    ("**聲波**", "**音波**"),
    ("「聲波」", "「音波」"),
    ("譯「音速」", "譯「音速」"),  # keep — historical reference
    # GILLMAN: 魚鰓人 -> 鰓型人 (multiple places)
    ("魚鰓人", "鰓型人"),
    # HEALTH (description text)
    ("生命值", "健康值"),
    # STAMINA stats column
    ('| STAMINA | 活力 | **耐力** |', '| STAMINA | 活力 | **體力** |'),
    # FIRING ACC stats column
    ('| FIRING ACC | ACC | **射擊準確度** |', '| FIRING ACC | ACC | **射擊命中** |'),
]

for f in TARGETS:
    if not f.exists():
        print(f"skip (not exist): {f.name}")
        continue
    txt = f.read_text(encoding="utf-8")
    orig_len = len(txt)
    n_total = 0
    for find, repl in REPLACEMENTS:
        n = txt.count(find)
        if n:
            txt = txt.replace(find, repl)
            n_total += n
            print(f"  {f.name}: '{find}' -> '{repl}' ({n}x)")
    if n_total:
        f.write_text(txt, encoding="utf-8")
        print(f"{f.name}: {n_total} total replacements")
    else:
        print(f"{f.name}: no changes")
