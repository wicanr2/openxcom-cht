#!/bin/bash
# OpenXcom 繁中化 ship gate — 跑所有 validator，pass/fail 退碼，輸出 markdown 摘要
# Usage: bash wsl_ship_gate.sh > /mnt/d/openxcom/docs/ship_gate.md

set -uo pipefail

TOOLS=/mnt/d/openxcom/tools
echo "# OpenXcom 繁中化 Ship Gate Report"
echo
echo "Generated: $(date)"
echo

pass=0
fail=0

run() {
    local title="$1"; shift
    local th="$1"; shift  # threshold count for issues (0 = strict)
    echo "## $title"
    echo
    echo '```'
    local out
    out=$("$@" 2>&1)
    echo "$out"
    echo '```'
    echo
    # threshold check: if any "Affected keys: N" with N > th, fail
    local affected
    affected=$(echo "$out" | grep -oE 'Affected keys: [0-9]+' | head -1 | grep -oE '[0-9]+' || echo 0)
    local simp
    simp=$(echo "$out" | grep -oE 'simplified char hits: [0-9]+' | head -1 | grep -oE '[0-9]+' || echo 0)
    local total_issues
    total_issues=$(echo "$out" | grep -oE 'total issues: [0-9]+' | tail -1 | grep -oE '[0-9]+' || echo 0)

    # allow up to 2 simp false positives (e.g. "算" mis-detected)
    if [ "$affected" -gt "$th" ] || [ "$simp" -gt 2 ]; then
        echo "**Status: FAIL** (affected=$affected, simp=$simp, total_issues=$total_issues)"
        fail=$((fail+1))
    else
        echo "**Status: PASS** (affected=$affected, simp=$simp, total_issues=$total_issues)"
        pass=$((pass+1))
    fi
    echo
}

run "Basic validator (coverage + 簡體 + empty)" 0 python3 "$TOOLS/wsl_validate_translations.py"
run "Deep validator (FMT/GLOSS/LEN/UNTRANSLATED)" 5 python3 "$TOOLS/wsl_deep_validate.py"
run "Char coverage (font missing chars)" 0 python3 "$TOOLS/wsl_check_char_coverage.py"

echo "## Summary"
echo
echo "- PASS: $pass"
echo "- FAIL: $fail"
echo

if [ $fail -gt 0 ]; then
    echo "**SHIP GATE: BLOCKED**"
    exit 1
else
    echo "**SHIP GATE: PASS**"
    exit 0
fi
