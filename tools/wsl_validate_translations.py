#!/usr/bin/env python3
"""Validate zh-TW translations: parse, find simplified chars, missing/empty values."""
import yaml, sys, os

# Common simplified -> traditional chars that often slip through (subset)
SIMP = "资讯图选项纪录电视计算机网络优开发军机药价证负责达运绪给账时间历经历类历对极极轻类历经报视错门错运动报报场画历经车录线纪国国发声场处"

PATHS = [
    "/mnt/d/openxcom/OpenXcom/bin/common/Language/zh-TW.yml",
    "/mnt/d/openxcom/OpenXcom/bin/standard/xcom1/Language/zh-TW.yml",
    "/mnt/d/openxcom/OpenXcom/bin/standard/xcom2/Language/zh-TW.yml",
]
EN_PATHS = [
    "/mnt/d/openxcom/OpenXcom/bin/common/Language/en-US.yml",
    "/mnt/d/openxcom/OpenXcom/bin/standard/xcom1/Language/en-US.yml",
    "/mnt/d/openxcom/OpenXcom/bin/standard/xcom2/Language/en-US.yml",
]

def validate(zh_path, en_path):
    print(f"\n=== {zh_path} ===")
    try:
        with open(zh_path, encoding="utf-8") as f:
            zh = yaml.safe_load(f).get("zh-TW", {})
        with open(en_path, encoding="utf-8") as f:
            en = yaml.safe_load(f).get("en-US", {})
    except Exception as e:
        print(f"  PARSE FAIL: {e}")
        return

    print(f"  en keys: {len(en)}")
    print(f"  zh keys: {len(zh)}")
    print(f"  coverage: {len(zh)*100//max(len(en),1)}%")

    empty = [k for k, v in zh.items() if not v or (isinstance(v, str) and not v.strip())]
    simp_hits = []
    for k, v in zh.items():
        if not isinstance(v, str): continue
        for c in SIMP:
            if c in v:
                simp_hits.append((k, v[:50], c))
                break

    print(f"  empty values: {len(empty)}")
    print(f"  simplified char hits: {len(simp_hits)}")
    for k, v, c in simp_hits[:10]:
        print(f"    [{c}] {k}: {v!r}")

    # Find missing keys (in en but not zh) limited to short keys (likely UI strings)
    en_short = {k: v for k, v in en.items() if isinstance(v, str) and len(v) < 60}
    missing_short = [k for k in en_short if k not in zh]
    print(f"  missing short keys (< 60 chars): {len(missing_short)} (of {len(en_short)} short en keys)")
    for k in missing_short[:5]:
        print(f"    MISS {k}: {en_short[k][:40]!r}")

    return {
        "zh_keys": len(zh),
        "en_keys": len(en),
        "empty": len(empty),
        "simp_hits": len(simp_hits),
        "missing_short": len(missing_short),
    }

if __name__ == "__main__":
    for zh, en in zip(PATHS, EN_PATHS):
        validate(zh, en)
