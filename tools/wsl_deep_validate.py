#!/usr/bin/env python3
"""Deep translation validator: find inconsistent glossary use, missing format specifiers,
escape sequence mismatches, and overly long strings that may overflow UI widgets."""
import yaml, re, json, sys
from pathlib import Path

ROOT = Path("/mnt/d/openxcom/OpenXcom/bin")

GLOSSARY = {
    # English -> Expected ZH (case-insensitive match)
    "Sectoid":  "腦蟲",
    "Snakeman": "蛇人",
    "Ethereal": "靈體",
    "Floater":  "浮游者",
    "Muton":    "蠻牛",
    "Chryssalid": "蟹形蟲",
    "Cyberdisc": "電腦碟",
    "Reaper":   "收割者",
    "Sectopod": "腦機甲",
    "Interceptor": "攔截機",
    "Skyranger": "天空遊俠",
    "Lightning": "閃電",
    "Avenger":  "復仇者",
    "Firestorm": "風暴",
    "Hangar":   "機庫",
    "Workshop": "工坊",
    "Living Quarters": "宿舍",
    "Cydonia":  "賽多尼亞",
    "Plasma":   "電漿",
    "TU":       "TU",
}

def validate_pair(zh_path, en_path):
    print(f"\n=== {zh_path.name} ===")
    zh = yaml.safe_load(zh_path.read_text(encoding="utf-8"))
    en = yaml.safe_load(en_path.read_text(encoding="utf-8"))
    zh_keys = zh.get("zh-TW", {})
    en_keys = en.get("en-US", {})

    issues = []

    # 1. Format specifier consistency: {0}, {1}, {ALT}, {NEWLINE} must match en->zh
    for k, en_v in en_keys.items():
        if k not in zh_keys: continue
        zh_v = zh_keys[k]
        if not isinstance(en_v, str) or not isinstance(zh_v, str): continue
        en_fmt = sorted(re.findall(r"\{[^}]+\}", en_v))
        zh_fmt = sorted(re.findall(r"\{[^}]+\}", zh_v))
        if en_fmt != zh_fmt:
            issues.append(("FMT_MISMATCH", k, f"en={en_fmt} zh={zh_fmt}"))

    # 2. Glossary consistency
    for k, zh_v in zh_keys.items():
        if not isinstance(zh_v, str): continue
        en_v = en_keys.get(k, "")
        if not isinstance(en_v, str): continue
        for eng, expected_zh in GLOSSARY.items():
            if eng.lower() in en_v.lower() and expected_zh not in zh_v and "STR_" + eng.upper().replace(" ","_") in k:
                # Only flag if it's a name string (not a verbose context where the term may be omitted)
                if len(zh_v) < 30:
                    issues.append(("GLOSS", k, f"expected '{expected_zh}' for '{eng}' in {zh_v[:30]!r}"))

    # 3. Length sanity: short en (UI label) translated to >2x length zh
    for k, zh_v in zh_keys.items():
        if not isinstance(zh_v, str): continue
        en_v = en_keys.get(k, "")
        if not isinstance(en_v, str) or len(en_v) > 20: continue
        # Rule of thumb: zh CJK chars take ~2x width as en ASCII, so 1 zh char ≈ 1 en char
        if len(zh_v) > len(en_v) * 1.5 + 2:
            issues.append(("TOO_LONG", k, f"en len={len(en_v)} '{en_v}' -> zh len={len(zh_v)} '{zh_v}'"))

    # 4. Untranslated (en value identical to zh value, indicates copy-paste)
    for k, zh_v in zh_keys.items():
        if not isinstance(zh_v, str): continue
        en_v = en_keys.get(k, "")
        if isinstance(en_v, str) and en_v == zh_v and any(0x4E00 <= ord(c) <= 0x9FFF for c in en_v):
            continue  # accept if has CJK
        if isinstance(en_v, str) and en_v == zh_v and len(en_v) > 5:
            issues.append(("UNTRANSLATED", k, f"both='{en_v[:40]}'"))

    # Aggregate
    from collections import Counter
    cnt = Counter(t for t,_,_ in issues)
    print(f"  total issues: {len(issues)}  by category: {dict(cnt)}")
    by_cat = {}
    for t, k, msg in issues:
        by_cat.setdefault(t, []).append((k, msg))
    for cat in ("FMT_MISMATCH", "UNTRANSLATED", "GLOSS", "TOO_LONG"):
        rows = by_cat.get(cat, [])[:6]
        if rows:
            print(f"\n  [{cat}] sample {len(rows)} of {len(by_cat[cat])}:")
            for k, msg in rows:
                print(f"    {k}: {msg}")

    return issues

if __name__ == "__main__":
    all_issues = []
    for zh_name in ["common/Language/zh-TW.yml", "standard/xcom1/Language/zh-TW.yml", "standard/xcom2/Language/zh-TW.yml"]:
        zh = ROOT / zh_name
        en = ROOT / zh_name.replace("zh-TW", "en-US")
        all_issues += validate_pair(zh, en)
    print(f"\n=== TOTAL {len(all_issues)} issues across all files ===")
