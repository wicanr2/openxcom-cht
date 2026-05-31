# OpenXcom 繁體中文化（zh-TW）

[![Ship gate](https://img.shields.io/badge/ship_gate-PASS_3%2F3-brightgreen)]()
[![Coverage](https://img.shields.io/badge/coverage-common_102%25_%2F_xcom1_102%25_%2F_xcom2_84%25-blue)]()
[![Keys](https://img.shields.io/badge/translation_keys-2513-orange)]()
[![License](https://img.shields.io/badge/license-GPL--3.0-blueviolet)]()

> [OpenXcom](https://github.com/OpenXcom/OpenXcom)（1994 經典策略遊戲 X-COM: UFO Defense 的開源重寫）的**繁體中文化專案**，包含字型、翻譯、UI patch、TFTD 海底支線。

---

## 截圖

| Main Menu | 難度選擇 | Geoscape |
|---|---|---|
| ![main_menu](screenshots/main_menu.png) | ![difficulty](screenshots/difficulty.png) | ![geoscape](screenshots/geoscape.png) |

| Basescape | Geoscape Options | UFOpaedia |
|---|---|---|
| ![basescape](screenshots/basescape.png) | ![options](screenshots/options.png) | ![ufopaedia](screenshots/ufopaedia.png) |

**Before / After**（上游 8×9 中空字 vs 本 patch 12×12 WQY Sharp）:

![before_after](screenshots/before_after.png)

**v2.18 UFOpaedia 文字色（兩種背景兩種配色）**：

| 天空背景（craft article） | 黑底（craft weapon） |
|---|---|
| ![ufo_v2_skyranger](screenshots/ufopaedia_v2_skyranger.png) | ![ufo_v2_cannon](screenshots/ufopaedia_v2_cannon.png) |
| `blockOffset(14)+10`=234 → 235..239 deep brown ramp | vanilla `+15`=239 → 240..244 light blue ramp |

---

## 主要成果

| 項目 | 內容 |
|---|---|
| **翻譯總量** | 2 513 個 unique keys |
| common UI | 437 / 427 = **102%** |
| xcom1 (UFO Defense) | 1 101 / 1 075 = **102%**（含 ufopedia 長段落） |
| xcom2 (TFTD) | 975 / 1 166 = **84%**（含 14 段 mission briefings + 結局劇情） |
| **字型** | WQY Zen Hei Sharp 12 px embedded bitmap（Apache 2.0 / GPL） |
| **字型 PNG** | FontBig / FontSmall / FontGeoSmall_zh-TW（皆 12×12 cell） |
| **Source patches** | 5 個 .cpp 檔（Font line step / Options baseRes / Geoscape widget / Ufopedia Craft 深棕 / CraftWeapon 維持 vanilla） |
| **驗證** | Ship gate 3/3 PASS（YAML coverage / format specifier / char coverage） |

---

## 安裝

### 方式 A：把翻譯資產 drop 進 OpenXcom data 目錄

不必重 build。直接用 vanilla OpenXcom 1.0 release 或更新 EXE。

```bash
# 1. 把 bin/ 內容 merge 到 OpenXcom data 目錄（覆蓋 Font.dat、補 zh-TW.yml + 3 個 PNG）
cp -r bin/common/Language/*    /path/to/OpenXcom/data/common/Language/
cp    bin/standard/xcom1/Language/zh-TW.yml  /path/to/OpenXcom/data/standard/xcom1/Language/
cp    bin/standard/xcom2/Language/zh-TW.yml  /path/to/OpenXcom/data/standard/xcom2/Language/

# 2. 設語言（在 options.cfg 或遊戲內 Options > Language）
#    language: zh-TW
```

**注意**：vanilla EXE 沒有 source patch，所以 line-step / Geoscape 時鐘 widget / Ufopaedia 文字色 issue 仍存在。要完整體驗請走方式 B。

### 方式 B：從 source 重 build（含全部 patch）

```bash
# 1. clone vanilla OpenXcom master
git clone https://github.com/OpenXcom/OpenXcom /tmp/openxcom-src
cd /tmp/openxcom-src

# 2. 套 4 個 source patch（檔在 patches/src/）
cp /path/to/this-repo/patches/src/Engine/Font.cpp           src/Engine/
cp /path/to/this-repo/patches/src/Engine/Options.cpp        src/Engine/
cp /path/to/this-repo/patches/src/Geoscape/GeoscapeState.cpp  src/Geoscape/
cp /path/to/this-repo/patches/src/Ufopaedia/ArticleStateCraft.cpp        src/Ufopaedia/
cp /path/to/this-repo/patches/src/Ufopaedia/ArticleStateCraftWeapon.cpp  src/Ufopaedia/

# 3. 複製翻譯資產
cp -r /path/to/this-repo/bin/* bin/

# 4. Build (Linux)
mkdir build && cd build
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)

# 或 Windows (VS 2022 BT)
# 重點：set CL=/utf-8 否則 MSVC 在 cp950 系統會把 UTF-8 string literal 認成多字節
# 詳見 tools/wsl_build_linux.sh
```

### Steam X-COM data

OpenXcom 需要原版 X-COM data。Steam 版的「XCom UFO Defense」買下後在 `steamapps/common/XCom UFO Defense/XCOM/` 子目錄。把 9 個子目錄 (`GEODATA / GEOGRAPH / MAPS / ROUTES / SOUND / TERRAIN / UFOGRAPH / UFOINTRO / UNITS`) 複到 OpenXcom 的 `data/UFO/`。

---

## Source patches 說明

| Patch | 用途 |
|---|---|
| `Font.cpp:193` | `getHeight()` 取所有 image max height — 修 line step 不跟 per-image override |
| `Options.cpp:80-85` | 解鎖 `baseXResolution` / `baseYResolution` OptionInfo（options.cfg 可改 base resolution） |
| `GeoscapeState.cpp:156-168, 347-378` | Hour widget 改 `setSmall()`、Min/Sec 對齊、Weekday widget h=12、Day/Month/Year 合併為「1999 / 1 / 1」西元格式 |
| `ArticleStateCraft.cpp` | UFOpedia 飛機介紹文字色：vanilla `blockOffset(14)+15` (=239) 對天空背景 UP004 對比不足 → 改 `blockOffset(14)+10` (=234)，pixels 落 235..239 = `#7C5440..#503020` deep brown ramp，對藍天 L 差 40-170 |
| `ArticleStateCraftWeapon.cpp` | 武器介紹頁背景是 **黑底 weapon 圖**（UP006..UP011），維持 vanilla `+15` (=239)，pixels 240..244 淺藍 ramp `#A0B8D8..#2C3C4C` 對黑底完美 |

---

## 字型 designer

`tools/make_fonts_zhtw.py` — Python + Pillow 從 [WQY Zen Hei Sharp TTC](http://wenq.org/) 渲染 zh-TW 字型 PNG。

```python
JOBS = [
    ("FONT_SMALL",    "FontSmall_zh-TW.png",    12, 12, 12, 50),
    ("FONT_BIG",      "FontBig_zh-TW.png",      12, 12, 12, 50),
    ("FONT_GEO_SMALL","FontGeoSmall_zh-TW.png", 12, 12, 12, 50),
]
```

每張 image：
- Cell 12×12（per-image override，仿韓文 `width: 10` 寫法）
- Glyph 12 px（WQY Sharp embedded bitmap 銳利）
- 50 cells/row, 4 808 字（涵蓋 BMP 常用字）
- 8 bpp paletted PNG（idx 0 = bg, idx 1 = fg）
- ⚠️ `FontGeoSmall_zh-TW.png` cell **不可降到 10** — Geoscape 右側 menu（攔截/基地/圖表/...）共用這張字型，cell 10 + glyph 9 會有 71 chars 被 clip → menu 字身殘缺

---

## Validators

```bash
# 3 個 validator + 1 ship gate runner
python3 tools/wsl_validate_translations.py    # YAML coverage + 簡體偵測 + empty 值
python3 tools/wsl_deep_validate.py            # format specifier / glossary / length / untranslated
python3 tools/wsl_check_char_coverage.py      # 翻譯中是否有字型沒涵蓋的字
bash    tools/wsl_ship_gate.sh                # 跑全 3 個 + PASS/FAIL summary
```

Ship gate 全 PASS 條件：
- 0 missing chars（所有翻譯中的字都在字型 cell list 內）
- 0 真簡體（「算」字為繁體常用「算作 / 算法」誤判，可忽略）
- 0 FMT_MISMATCH（`{0} / {NEWLINE} / {ALT}` 數量 en==zh）
- Coverage 100% (en key set 全翻完)

---

## Glossary（台灣慣用譯名）

> 📖 **完整 1994 第三波官方手冊譯名對照** 見 [`docs/GLOSSARY_1994_MANUAL.md`](docs/GLOSSARY_1994_MANUAL.md) — 含 200+ 條英中對照、衝突分析、後續修正建議。原始 PDF 收錄於 [`docs/DDSC-J-00120-遊戲手冊：幽浮１－地球防衛武力.pdf`](docs/)。

### X-COM 載具 / 兵種

| English | 繁中 | 1994 第三波 |
|---|---|---|
| Interceptor | 攔截機 | 攔截機 ✓ |
| Skyranger | 天空遊俠 | **運兵機** ⚠️ 1994 較佳，後續版本待改 |
| Lightning / Avenger / Firestorm | 閃電 / 復仇者 / 風暴 | — |
| Sectoid | 腦蟲 |
| Snakeman | 蛇人 |
| Ethereal | 靈體 |
| Floater | 浮游者 |
| Muton | 巨型怪 |
| Chryssalid | 蟹形蟲 |
| Reaper | 收割者 |
| Sectopod | 腦機甲 |
| Cyberdisc | 電腦碟 |
| Celatid / Silacoid | 盲蟲 / 矽生物 |
| Plasma / Laser / Heavy | 電漿 / 雷射 / 重型 | 電漿 / 雷射 / 重型 ✓ 全沿用 1994 |
| Stingray (missile) | 刺尾 | **黃貂魚式飛彈** ⚠️ 1994 為正譯（魟），「刺尾」是誤譯 |
| Avalanche (missile) | 雪崩 | 崩雪式飛彈 |
| Medi-Kit | 醫療包 | 醫藥箱 |
| Cydonia | 賽多尼亞 | — |

### TFTD（海底支線）

| English | 繁中 |
|---|---|
| Aquatoid / Gillman / Lobsterman | 水生人 / 魚鰓人 / 龍蝦人 |
| Tasoth / Deep One / Calcinite | 塔索斯 / 深淵者 / 鈣化體 |
| Triscene / Hallucinoid / Xarquid | 三角龍 / 幻象生物 / 薩奎 |
| Bio-Drone / Tentaculat | 生物無人機 / 觸手怪 |
| Triton / Manta / Hammerhead | 海神號 / 曼塔號 / 槌鯊號 |
| Z'rbite / T'leth | Z 元素 / 賽爾斯 |

---

## License

| Component | License |
|---|---|
| OpenXcom (上游 + source patches) | GPL-3.0-or-later |
| zh-TW translation YAML | CC BY-SA 4.0（譯者 own work） |
| WQY Zen Hei Sharp（FontBig / Small / GeoSmall 來源） | Apache 2.0 / GPL |
| `tools/` Python scripts | MIT |

OpenXcom 本體繼承上游 GPL-3.0。Source patch 同樣 GPL-3.0。翻譯內容 CC BY-SA 4.0 — 修改/散佈請保留 attribution 並用相同 license。字型內嵌 ink 來自 WQY Zen Hei Sharp（雙授權 Apache 2.0 / GPL），不另外申明嵌入。

---

## 開發歷程 / 設計 doc

詳見 `docs/`：

- [`GLOSSARY_1994_MANUAL.md`](docs/GLOSSARY_1994_MANUAL.md) — 1994 第三波官方手冊 vs 本專案譯名對照（200+ 條）
- [`ux_color_v2_designer.md`](docs/ux_color_v2_designer.md) — UFOpaedia 文字色 v2 配色 root cause（PaletteShift `dest = color + src*mul` 公式）+ 兩種背景兩種選色推導
- [`v2_plan.md`](docs/v2_plan.md) — 4 階段路線圖（v2.1 → v2.4）
- [`v2_review.md`](docs/v2_review.md) — v2 全 round design review（1 356 keys）
- [`SHIP_FINAL_V212.md`](docs/SHIP_FINAL_V212.md) — v2.12 ship final report
- [`dev_round1_font_fix.md`](docs/dev_round1_font_fix.md) — Font ghost overlap 根因 re-diagnosis（不是 line step bug，是 image spacing:0）
- [`trans_v23_batch1.md`](docs/trans_v23_batch1.md) — v2.3 round 117 條 UFOpedia 補翻
- [`DDSC-J-00120-遊戲手冊：幽浮１－地球防衛武力.pdf`](docs/) — 1994 第三波官方繁中手冊原文（46 頁，30 MB；DDSC 數位化，非商業流傳）

## 已知 issues

1. **「資」字 12×12 視覺近「宜」** — 12 px 點陣下「次」部首壓縮，純字型品質限制（不修，記錄）
2. **Weekday 跟 Hour 上緣 5 px overlap** — vintage 320×200 sprite 寫死 ASCII 9 px line，CJK 12 px 在時鐘區無法兩全（已盡力 layout）
3. **混排 ASCII + CJK advance 不一致** — `FontBig.png spacing:0` vs `FontBig_zh-TW spacing:2` → 「X-COM 載具」整行對位輕微偏（cosmetic only）
4. **TFTD 全 UFOpedia 長段落未補完** — 剩 ~190 條長 narrative，玩家較少看到（v2.4 候選）

---

## 參考

- [OpenXcom](https://github.com/OpenXcom/OpenXcom) — 上游
- [OpenXcom Extended (OXCE)](https://github.com/MeridianOXC/OpenXcom) — fork with hi-res mod support
- [WQY Zen Hei](http://wenq.org/) — 字型來源
- **1994 第三波官方繁中手冊**（DDSC-J-00120）— 譯名歷史對照基準，見 [`docs/GLOSSARY_1994_MANUAL.md`](docs/GLOSSARY_1994_MANUAL.md)
- 完整 skill 細節：[`~/.claude/skills/openxcom-cht/SKILL.md`](https://github.com/wicanr2/openxcom-cht)（如果你也在用 Claude Code）

PR / issue welcome — 特別是 v2.4 TFTD 長 narrative 補翻、字典統一、UI 排版 trade-off 改進。
