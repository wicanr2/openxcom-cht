#!/usr/bin/env python3
"""Find translation strings containing characters NOT present in any zh-TW font image.
Those characters fall back to '?' or other glyphs at runtime."""
import yaml, sys, re
from pathlib import Path
from collections import Counter

ROOT = Path("/mnt/d/openxcom/OpenXcom/bin")

def load_font_chars():
    """Aggregate all chars across all zh-TW font images, per font_id."""
    doc = yaml.safe_load((ROOT / "common/Language/Font.dat").read_text(encoding="utf-8"))
    by_font = {}
    for f in doc["fonts"]:
        chars = set()
        for im in f["images"]:
            chars.update("".join(im["chars"].split()))
        by_font[f["id"]] = chars
    return by_font

def load_translations():
    """Return [(yml_path, key, value), ...] for all zh-TW strings."""
    out = []
    for name in ["common/Language/zh-TW.yml", "standard/xcom1/Language/zh-TW.yml", "standard/xcom2/Language/zh-TW.yml"]:
        p = ROOT / name
        doc = yaml.safe_load(p.read_text(encoding="utf-8"))
        for k, v in (doc.get("zh-TW") or {}).items():
            if isinstance(v, str):
                out.append((name, k, v))
    return out

CJK_RE = re.compile(r"[一-鿿　-〿＀-￯⺀-⻿]")

def main():
    font_chars = load_font_chars()
    # Union: chars covered by either FONT_BIG or FONT_SMALL (most UI uses these two)
    main_set = font_chars.get("FONT_BIG", set()) | font_chars.get("FONT_SMALL", set())
    geo_set  = font_chars.get("FONT_GEO_SMALL", set()) | font_chars.get("FONT_GEO_BIG", set())

    print(f"FONT_BIG chars: {len(font_chars.get('FONT_BIG', set()))}")
    print(f"FONT_SMALL chars: {len(font_chars.get('FONT_SMALL', set()))}")
    print(f"FONT_GEO_SMALL chars: {len(font_chars.get('FONT_GEO_SMALL', set()))}")
    print(f"FONT_GEO_BIG chars: {len(font_chars.get('FONT_GEO_BIG', set()))}")
    print(f"union BIG+SMALL: {len(main_set)} chars")
    print()

    translations = load_translations()
    print(f"Total translation entries: {len(translations)}")

    missing_chars = Counter()
    affected_keys = []
    for path, k, v in translations:
        cjk = CJK_RE.findall(v)
        cjk_chars = set("".join(cjk))
        outside = cjk_chars - main_set
        if outside:
            missing_chars.update(outside)
            affected_keys.append((path, k, sorted(outside)[:5], v[:50]))

    print(f"\n=== Translations with chars outside FONT_BIG/SMALL coverage ===")
    print(f"Affected keys: {len(affected_keys)}")
    print(f"Distinct missing chars: {len(missing_chars)}")
    print(f"Top 30 missing chars by frequency:")
    for ch, cnt in missing_chars.most_common(30):
        print(f"  {ch} (U+{ord(ch):04X})  appears in {cnt} keys")

    print(f"\n=== Sample affected keys ===")
    for path, k, outside, v in affected_keys[:15]:
        print(f"  [{path.split('/')[-2]}] {k}: missing={outside}  v={v!r}")

if __name__ == "__main__":
    main()
