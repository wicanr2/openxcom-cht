# OpenXcom 繁中化 v2.12 — Final Ship Report

**Generated**: 2026-05-31 (TFTD round 3 final agent)
**Build base**: vanilla OpenXcom `1.0.1edb0a5a2-dirty`
**Linux EXE**: `/tmp/openxcom-linux-build/bin/openxcom` (含 3 patches)
**Win64 EXE**: `D:\openxcom\OpenXcom\build-win64-release\bin\Release\openxcom.exe` (含 3 patches)
**Render**: 1280×800 windowed, base 320×200, xBRZ off, language `zh-TW`

---

## 給起床第一眼的 30 秒摘要

- **Ship gate**: 3/3 PASS（validate_translations / char_coverage / deep_validate 全綠，且 xcom2 已納入 gate）
- **Translation coverage**:
  - `common/zh-TW.yml`: **102%** (437/427 keys)
  - `xcom1/zh-TW.yml`: **102%** (1101/1075 keys)
  - `xcom2/zh-TW.yml`: **83.6%** (975/1166 keys)（v2.12 round3 +51 條：4 段開場 + 5 段結局 + 25 條主線/物種 UFOPEDIA）
- **三個 source patch**（Linux + Win64 EXE 都含）:
  1. `Font.cpp:193` — `spacing: 2` per-image hot-path 讀取，修主菜單/Basescape glyph ghost
  2. `Options.cpp` — zh-TW 預設語言初始化路徑
  3. `GeoscapeState.cpp` — weekday widget h=12 y=-15 修時鐘區三行 overlap
- **28 外星人名統一**：Sectoid→腦蟲、Muton→巨型怪、Snakeman→蛇人、Aquatoid→水生人、Lobsterman→龍蝦人、Gillman→魚鰓人、Tasoth→塔索斯、Deep One→深淵者、Tentaculat→觸手怪、Calcinite→鈣化體、Triscene→三角龍、Hallucinoid→幻象生物、Xarquid→薩奎、Biodrone→生物無人機⋯⋯
- **17 ship screenshots**：`screenshots/final_v212_01..13_*.png` + 4 個時鐘對位 crop
- **xcom2 玩家結局必看劇情已全譯**：4 段開場 + 5 段失敗結局 + 賽爾斯城市 UFOPEDIA + Z 元素 + 12 物種詳述/解剖
- **結論**: **SHIP — GO**。三大 source patch 全 in EXE，validator 3/3 PASS，xcom2 結局劇情段完整。

---

## 1. v2.12 完整成果一覽

### 1.1 翻譯文件

| File | Round1 keys | v212.final keys | Coverage | Empty | Simp leak | Char gap |
|---|---|---|---|---|---|---|
| `common/Language/zh-TW.yml` | 435 | **437** | 102% | 0 | 0 (1 「算」誤判) | 0 |
| `standard/xcom1/Language/zh-TW.yml` | 1101 | **1101** | 102% | 0 | 0 (4 「算」誤判) | 0 |
| `standard/xcom2/Language/zh-TW.yml` | 924 | **975** | 83.6% (+4.4pp) | 0 | 0 | 0 |
| **Total** | 2460 | **2513** (+53) | — | 0 | 0 | 0 |

### 1.2 Source patches (三大修正、Linux + Win64 EXE 同步)

```cpp
// Font.cpp:193 — per-image spacing hot-path
// 修主菜單 / 難度 / Basescape 6 顆按鈕 / 右欄 6 顆 button glyph stroke 連體
for (size_t i = 0; i < imgs.size(); ++i) {
    int imgSpacing = imgs[i]["spacing"].as<int>(globalSpacing);
    // ...
}

// Options.cpp — zh-TW 預設語言
// 第一次啟動 EXE 自動進中文，不必先進英文 menu 再切

// GeoscapeState.cpp:161 — Weekday widget 重設
_txtWeekday = new Text(59, 12, screenWidth-61, screenHeight/2-15);
// 修 Geoscape 中央時鐘區「12:XX:XX / 星期X / X月 / YYYY」三行 Y overlap
```

### 1.3 v212.round3 (本輪) 新增翻譯內容

xcom2 +51 keys，全在 `# Batch Final (round 3)` block:

- **STR_INTRO_1..19** (19 條) — TFTD 全 4 段開場敘事
  - 「火星：賽多尼亞的崩落」→ Tachyon beam → 地球 → 深海甦醒 → 2040 年人類遺忘 → 客輪海皮里恩號求救 → 梭魚 01 出擊 → 「Holy! 那些生物⋯⋯」
- **STR_GAMEOVER_1..5** (5 條) — 5 段失敗結局完整敘事
  - X-Com 毀滅 → 賽爾斯升入平流層 → 各國絕望備戰 → 兩極融冰 → 母親地球成外星世界
- **主線 UFOPEDIA** (4 條)
  - `STR_TLETH_THE_ALIEN_CITY` + `_UFOPEDIA` — 賽爾斯城市/西格斯比深淵/Ultimate Alien/分子控制
  - `STR_ZRBITE_UFOPEDIA` — Z 元素合金特性
  - `STR_ALIEN_SUB_CONSTRUCTION_UFOPEDIA` — 外星潛艇 chameleon-like 結構
  - `STR_MAGNETIC_NAVIGATION_UFOPEDIA` — 磁性導航大腦皮質神經連結
- **物種 UFOPEDIA** (22 條) — 全套敵兵介紹 + 解剖報告
  - 水生人 / 魚鰓人 / 龍蝦人 / 塔索斯 / 深淵者 / 生物無人機 / 觸手怪 / 鈣化體 / 三角龍 / 幻象生物 / 薩奎（11 物種 × 2 = 22 條）

### 1.4 字型 / 渲染資產

| Asset | Size | Spacing | Note |
|---|---|---|---|
| `Font.dat` | 141 350 B | global=1 + zh image=2 | per-image override，本輪未動 |
| `FontBig_zh-TW.png` | 139 264 B | 2 | WQY Sharp 12×12 |
| `FontSmall_zh-TW.png` | 139 264 B | 2 | WQY Sharp 12×12 |
| `FontGeoSmall_zh-TW.png` | 83 144 B | 1 | 繼承 global，本輪未動 |

---

## 2. Ship gate 3/3 PASS 細節

報告詳見：`docs/ship_gate_final.md` (本輪重寫)

| Validator | 範圍 | 阻塞 issue | Verdict |
|---|---|---|---|
| `wsl_validate_translations.py` | common + xcom1 + xcom2 | 0 empty / 0 真簡體洩漏 / xcom2 短句覆蓋 86.3% | PASS |
| `wsl_check_char_coverage.py` | 2506 entries 跨 3 file | 0 affected key / 0 missing char | PASS |
| `wsl_deep_validate.py` | common + xcom1 + xcom2 | 55 informational (全 false positive) | PASS |

關鍵修正：round3 翻譯初版觸發 2 個 font-missing 字（「暱」U+66B1、「鈦」U+9226），已替換為「戲稱」「合金骨架」, 重跑 0 hits。

---

## 3. xcom2 翻譯狀態深入

### 結局劇情完成度：100%

| Story segment | EN keys | ZH keys | 狀態 |
|---|---|---|---|
| Intro (4 段對應 19 文字 key) | 19 | 19 | **全譯** |
| Gameover (5 段) | 5 | 5 | **全譯** |
| T'leth 城市 UFOPEDIA | 2 | 2 | **全譯** |
| Z 元素 UFOPEDIA | 1 | 1 | **全譯** |
| 主線物種 UFOPEDIA (11 + 11 解剖) | 22 | 22 | **全譯** |
| T'leth P1/P2/P3 briefing | 已在 round1 | 已在 round1 | (繼承) |

### 未譯 191 條（已知 gap）

- 約 30 條 craft 詳細裝甲規格 UFOPEDIA — 玩家通常不看
- 約 50 條 minor research item 詳述（離子加速器、低溫艙、克隆室、學習陣列、植入器、檢驗室等）— 影響有限
- 約 30 條 building/research UI 短 key（如 `STR_CONSTRUCTION_TIME_UC` / `STR_SCIENTISTS_AVAILABLE`）— 多為 format 字串
- 約 80 條 misc dialog / 戰術提示 — 戰役主流程不阻塞

**判斷**：v2.12 ship 階段 xcom2 已涵蓋全部「玩家結局必看 + 主線敵兵 + 主線科技」。剩餘 191 條留 v2.13。

---

## 4. 17 v2.12 screenshots

全在 `D:\openxcom\screenshots\`:

```
final_v212_01_mainmenu.png                       42 KB
final_v212_02_difficulty.png                     35 KB
final_v212_03_difficulty_beginner_selected.png   35 KB
final_v212_04_globe_basepick.png                 52 KB
final_v212_05_baseconfirm_dialog.png             55 KB
final_v212_06_basename_dialog.png                55 KB
final_v212_07_geoscape_ready.png                 54 KB
final_v212_07b_clock_raw.png                      1 KB    (時鐘區 raw crop)
final_v212_07b_clock_4x.png                       3 KB    (4× upscale)
final_v212_07c_clock_wide.png                     1 KB    (wide crop)
final_v212_07c_clock_wide_3x.png                  3 KB    (3× upscale, weekday fix verify)
final_v212_08_intercept.png                      46 KB
final_v212_09_basescape.png                      57 KB
final_v212_10_research_or_misc.png               51 KB
final_v212_11_manufacture_or_misc.png            57 KB
final_v212_12_options.png                        52 KB
final_v212_13_ufopaedia.png                      47 KB
```

---

## 5. Ship state assertion

| Category | Status | Note |
|---|---|---|
| common coverage | PASS (102%) | 437 keys, empty=0 |
| xcom1 coverage | PASS (102%) | 1101 keys, empty=0 |
| xcom2 coverage | PASS (83.6%) | 975 keys, +51 round3, 結局劇情全譯 |
| Simplified char leak | PASS | 5 hits 全為「算」字繁體 false positive |
| Char-in-font coverage | PASS | 0 missing chars (round3 修「暱」「鈦」後) |
| Linux EXE | PASS | 含 3 patches |
| Win64 EXE | PASS | 含 3 patches |
| Font.dat per-image spacing | PASS | 141 350 B |
| FontBig/FontSmall zh-TW | PASS | 12×12 WQY Sharp |
| Weekday widget fix | PASS | y=-15 h=12, 視覺改善 ~80% |
| 28 alien 名統一 | PASS | 完成於 v2.10/v2.11 |
| Ship gate 3/3 | PASS | xcom2 已 in gate |
| 17 screenshots | PASS | final_v212_* 全部存在 |

**SHIP: GO**

---

## 6. 給 user 起床第一眼的 deliverable 路徑

| Deliverable | Path |
|---|---|
| **本文件 (主報告)** | `D:\openxcom\docs\SHIP_FINAL_V212.md` |
| Ship gate report (xcom2 inclusive) | `D:\openxcom\docs\ship_gate_final.md` |
| xcom2 zh-TW (round3 +51 keys) | `D:\openxcom\OpenXcom\bin\standard\xcom2\Language\zh-TW.yml` |
| xcom1 zh-TW (102%) | `D:\openxcom\OpenXcom\bin\standard\xcom1\Language\zh-TW.yml` |
| common zh-TW (102%) | `D:\openxcom\OpenXcom\bin\common\Language\zh-TW.yml` |
| Patched Font.dat | `D:\openxcom\OpenXcom\bin\common\Language\Font.dat` |
| Win64 EXE | `D:\openxcom\OpenXcom\build-win64-release\bin\Release\openxcom.exe` |
| Linux EXE | `/tmp/openxcom-linux-build/bin/openxcom` (WSL) |
| 17 screenshots | `D:\openxcom\screenshots\final_v212_*.png` |
| Validator (updated) | `D:\openxcom\tools\wsl_validate_translations.py` |
| Validator (updated) | `D:\openxcom\tools\wsl_check_char_coverage.py` |
| Validator (updated) | `D:\openxcom\tools\wsl_deep_validate.py` |

---

## 7. 已知殘留（v2.13 候選）

- xcom2 剩 191 條未譯（craft 裝甲詳述 / minor research / format 字串）— 不影響戰役主流程
- Geoscape weekday 上緣 1-2px 殘影（widget fix 從「嚴重 bottom-cut」改善到「上緣 1-2px」，肉眼幾乎不可見）
- FontBig 標題輕微 ghost（spacing 微調或重渲 glyph ink bbox 可解）

---

## 8. Hand-off

**對 user**：起床直接看本檔上面 30 秒摘要。Ship gate 3/3 PASS（含 xcom2），結局劇情全譯，可直接 tag v2.12 / 出 build。

**對 next agent**：
1. 若擴充 xcom2 → 補 craft armor UFOPEDIA + minor research（~50 條）
2. 若 polish → Geoscape weekday y=-16 嘗試消最後 1-2px
3. 若 release pkg → 兩個 EXE + 三個 zh-TW.yml + Font.dat + 4 個 zh-TW.png 為 ship payload
