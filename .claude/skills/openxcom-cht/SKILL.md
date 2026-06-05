---
name: openxcom-cht
description: OpenXcom (vanilla master + TFTD/xcom2) 繁中化的完整工具鏈、字型 Font.dat / WQY Sharp 12px / 源碼 patch 點與 Geoscape widget 排版調整。當使用者談到「OpenXcom 中文化」「Font.dat」「FontSmall_zh-TW」「FontBig_zh-TW」「WQY Zen Hei Sharp 12px」「ArticleStateCraft 色」「GeoscapeState weekday widget」「ufopedia 文字顏色」「PaletteShift ramp」「主選單作者簽名」「ghost overlap」「星期五 被遮擋」「TFTD 翻譯」「xcom2 zh-TW」「openxcom AppImage」「openxcom portable」「Windows ZIP 整包」「1994 第三波幽浮手冊」等情境觸發。也涵蓋 WSL2 + Xvfb + xdotool 對 SDL 1.2 headless test harness、PostMessage 3-msg click sequence、tesseract OCR 對 12-16px pixel-art font 失效這類陷阱。
---

# OpenXcom 繁中化完整 SOP

OpenXcom (1994 X-COM: UFO Defense 開源重寫) 從 fresh master clone 到 v2.17 ship 全程踩雷與通用模式。**vanilla 320×200 UI 寫死 ASCII 9px 字身假設**是核心限制，所有 CJK trade-off 圍繞它。

## Repo layout

```
D:\openxcom\
├── OpenXcom\              # vanilla master clone (含 3+ source patches)
│   ├── src\
│   │   ├── Engine\Font.cpp           ⭐ patch:193 getHeight() max image height
│   │   ├── Engine\Options.cpp        ⭐ patch:80-85 unlock baseXResolution OptionInfo
│   │   ├── Geoscape\GeoscapeState.cpp  ⭐ patch:156-168 widget layout for CJK
│   │   └── Ufopaedia\ArticleStateCraft.cpp + CraftWeapon.cpp  ⭐ color 239→255
│   ├── bin\common\Language\
│   │   ├── Font.dat               # YAML（副檔名 .dat 騙人）— image-level override
│   │   ├── FontBig_zh-TW.png      # cell 12×12 WQY Sharp + spacing:2
│   │   ├── FontSmall_zh-TW.png    # cell 12×12 同上
│   │   ├── FontGeoSmall_zh-TW.png # cell 12×12 — **不可改！** Geoscape menu 用
│   │   ├── zh-TW.yml              # 437 keys (102% common cover)
│   │   └── *.bak / *.bak2         # 多個 backup
│   ├── bin\standard\xcom1\Language\zh-TW.yml  # 1101 keys (102%)
│   ├── bin\standard\xcom2\Language\zh-TW.yml  # 975 keys TFTD (83.6%)
│   ├── bin\UFO\                   # Steam X-COM data copied here
│   ├── build-win64-release\bin\Release\openxcom.exe   # Windows EXE
│   └── deps\lib\x64\*.dll         # runtime DLL (跟 EXE 同層 ship)
├── fontsrc\wqy-zenhei.ttc         # 16.8 MB GPL Apache 2.0
├── tools\
│   ├── make_fonts_zhtw.py         # designer (PIL + WQY)
│   ├── wsl_validate_translations.py  # YAML coverage + 簡體
│   ├── wsl_deep_validate.py       # FMT/GLOSS/LEN/UNTRANSLATED
│   ├── wsl_check_char_coverage.py # font missing chars
│   ├── wsl_ship_gate.sh           # 3-validator CI
│   ├── wsl_build_linux.sh         # Linux build pipeline
│   └── wsl_xvfb_run.sh            # headless Xvfb + game
└── docs\                          # v2_plan.md / SHIP_FINAL_V212.md / dev_round1_font_fix.md ...
```

## 字型機制核心

### Font.dat YAML schema

```yaml
fonts:
  - id: FONT_BIG
    width: 16        # 全局基準
    height: 16
    spacing: 0
    images:
      - file: FontBig.png       # ASCII Latin (繼承全局)
      - file: FontBig_zh-TW.png
        width: 12               # ⭐ per-image override（韓文 width:10 先例）
        height: 12
        spacing: 2              # ⭐ 解 CJK ghost overlap 關鍵
        chars: >
          一丁七三下丈上丑丐不丙世丕且丘丞丟…
```

- 副檔名 `.dat` 但內容是 YAML，PyYAML 解
- 每張 image 可 per-image override width/height/spacing
- chars 字串 4808 字單行 (folded scalar `>`)
- PNG 8bpp paletted，Font.cpp 看 `pixel != 0` 即前景

### Cell layout (Font.cpp init)

```cpp
int length = (surface->getWidth() / image->width);  // cells per row
int startX = i % length * image->width;
int startY = i / length * image->height;
```

PNG 必須 `width = N × cell_w`、`height = M × cell_h`。chars[i] 對應 cell (i % length, i / length)。

### Font 種類與用途

| Font | 預設 cell | zh-TW image | 主要用在 |
|---|---|---|---|
| FONT_BIG | 16×16 ASCII | 12×12 WQY | Main menu / Basescape / Battlescape 按鈕 / Ufopedia / dialog title |
| FONT_SMALL | 8×9 ASCII | 12×12 WQY | 副標題 / 表格 / status 列 / 對話描述 |
| FONT_GEO_BIG | 5×9 ASCII | **無 zh-TW image！** | Geoscape 速度按鈕 (5秒/1分) |
| FONT_GEO_SMALL | 5×7 ASCII | 12×12 WQY | **Geoscape 右側 menu (攔截/基地/圖表/幽浮百科/選項/資金) + 時鐘下方** |

⚠️ **FontGeoBig 沒有 zh-TW image** — Geoscape 速度按鈕用 ASCII 數字「5秒」"5" 是 ASCII + "秒" 應從 FontGeoSmall fall back（OpenXcom Font lookup 跨 image search）。

⚠️ **FontGeoSmall 共用 Geoscape menu + 時鐘** — 改 cell 大小**會同步影響兩處**。Korean `FontGeoSmall_ko.png` chars 列「요격기지그래프사전옵션후원금확장」證實這點。

## 字型 designer (make_fonts_zhtw.py)

```python
JOBS = [
    # (font_id, image_file, cell_w, cell_h, glyph_px, cols)
    ("FONT_SMALL",    "FontSmall_zh-TW.png",    12, 12, 12, 50),
    ("FONT_BIG",      "FontBig_zh-TW.png",      12, 12, 12, 50),
    ("FONT_GEO_SMALL","FontGeoSmall_zh-TW.png", 12, 12, 12, 50),  # 不要動 — Geoscape menu 共用
]
```

關鍵：
- **WQY Zen Hei Sharp 12px embedded bitmap** (Apache 2.0 / GPL) — TTC face index 2
- Per-glyph render to temp canvas → bbox crop → paste centered in cell（避免 advance-width 溢出鄰格）
- `crop.width > cell_w` 時 clip + 累計 warning（cell 10 + glyph 9 → 71 clipped；cell 12 + glyph 12 → 0 clipped）
- 4 字 swap（不在 chars list）：殭→喪、污→汙、佈→布、擷→提；TFTD 另有 鱝→曼塔、魟→變體、踨→蹤、鎵→砷化物、鈦→高強度合金、崴→海參威

## 關鍵踩雷（不踩會死）

### 1. 不要動 FONT_SMALL global height

從 9 → 12 看似讓 CJK 不撞，但 `FontSmall.png` 8×9 ASCII PNG 被當 8×12 cell 切，整個 ASCII glyph table 錯位 → main menu 副標題與按鈕英文字全壞。**只在 zh-TW image 加 per-image override**（仿韓文 width:10 寫法）。

### 2. zh-TW image 一定要設 spacing:2

預設 spacing:0 → CJK glyph ink 寬幾乎等於 cell-1，相鄰字 stroke 零 gap 黏在一起，視覺上像 ghost overlap。**Dev round1 root cause re-diagnosis**：之前以為是 Font.cpp:193 line step bug，實際是 image spacing 0。加 `spacing: 2` per-image 解 90%+ ghost，**runtime YAML 不需 rebuild EXE**。

### 3. FontGeoSmall_zh-TW cell **不可低於 12**

Cell 10 + glyph 9 → 71 chars clip → Geoscape 右側 menu「攔截/基地/圖表」等 chars 渲染破。確認方式：grep FontGeoSmall_ko.png chars，含「요격기지그래프」就是 menu 在用 FontGeoSmall。

### 4. Font.cpp:193 getHeight() 取 max image height

```cpp
int Font::getHeight() const {
    int h = 0;
    for (auto& i : _images) h = std::max(h, i.height);
    return h;
}
```

Vanilla 回 `_images[0].height`（永遠英文）→ line step 不跟 per-image override，multi-line text 撞行。**Patch 1 行解決**。但對單 row「ghost overlap」無效 — 那是 spacing 問題（#2）。

### 5. Options.cpp:80-85 解鎖 baseXResolution

```cpp
_info.push_back(OptionInfo("baseXResolution", &baseXResolution, Screen::ORIGINAL_WIDTH));
_info.push_back(OptionInfo("baseYResolution", &baseYResolution, Screen::ORIGINAL_HEIGHT));
// + baseXGeoscape/Y, baseXBattlescape/Y
```

註解掉時 options.cfg 設這幾個 key 沒用。Un-comment 後可從 cfg 改。**vanilla 在 320×200 base 下 sprite 寫死，改 baseRes 會 sprite 散左上 — 慎用**。

### 6. Geoscape widget y-position 寫死 ASCII 9px

`GeoscapeState.cpp:156-168` 設定時鐘區 widget：
- `_txtHour` h=16 y=-26 (Big font)
- `_txtSec` h=8 y=-20 (Small)
- `_txtWeekday` h=8 y=-13
- `_txtDay/_txtMonth` h=8 y=-6
- `_txtYear` h=8 y=+1

CJK 12 px 字身在 h=8 widget 中下半 4px 被切。修法 (v2.17 ship)：

```cpp
// Hour setSmall → ASCII 9px 字，騰出空間給 Weekday
_txtHour->setSmall();
_txtHourSep->setSmall(); _txtMin->setSmall();
_txtMin->setAlign(ALIGN_LEFT);                      // 12:00:00 緊湊
_txtMinSep->setX(screenWidth-21);                   // 跟 Min 對齊
_txtSec->setX(screenWidth-17);
_txtSec->setAlign(ALIGN_LEFT);

// Weekday widget h=12 容納 CJK
_txtWeekday = new Text(59, 12, screenWidth-61, screenHeight/2-15);

// 西元日期合併到 Year widget：「1999 / 1 / 1」
_txtDay = new Text(20, 12, screenWidth-37, screenHeight/2-4);  // 隱藏
_txtMonth = new Text(20, 12, screenWidth-61, screenHeight/2-4); // 隱藏
_txtYear = new Text(59, 12, screenWidth-61, screenHeight/2-4); // 顯示完整日期

// updateTime():
_txtDay->setText("");
_txtMonth->setText("");
ss5 << year << " / " << month << " / " << day;
_txtYear->setText(ss5.str());
```

### 7. ArticleStateCraft 文字色 — PaletteShift ramp 根因（v2.18 修正）

**Root cause**（前兩輪都漏掉）：`src/Interface/Text.cpp:466` `PaletteShift::func` 公式：

```cpp
dest_palette_index = color + src * mul       // src = font glyph AA pixel 1..5
```

**`Text::setColor()` 的 `color` 不是顯示色，是 ramp 基底**。真實像素落在 `[color+1..color+5]`。所以選色必須讓 ramp 連續可讀。

| 嘗試 | 配色 | Pixels 落在 | 結果 |
|---|---|---|---|
| vanilla 239 | `blockOffset(14)+15` | 240..244 PAL_UFOPAEDIA 淡奶油/淡紫 | 對天空 UP004 對比災難 |
| v1 嘗試 255 | `blockOffset(15)+15` | 0..4（wrap）— idx 0 透明 + block 15 起點淡奶油 | **完全不可見** |
| v2-mid 嘗試 249 | `blockOffset(15)+9` | 250..254 = magenta + 淡黃綠 | 亮黃米色，仍看不清 |
| **v2.18 final** | **`blockOffset(14)+10` = 234** | 235..239 deep brown `#7C5440..#503020` L=93→55 | ✓ 對天空 L=130-230 對比 40-170 |

**關鍵設計決策（v2.18）**：
- ArticleStateCraft (Skyranger/Interceptor 在 UP004 天空背景) → `234` deep brown ramp
- ArticleStateCraftWeapon (Cannon/Stingray 在 UP006-011 **黑底** weapon photo) → **revert vanilla 239**，pixels 240..244 = light blue ramp `#A0B8D8..#2C3C4C` 對黑底完美

**不開 `setHighContrast(true)`** — mul=3 會讓 ramp 跨 block 散到 magenta/淡黃綠，視覺紊亂。

**PAL 工具**：`D:\openxcom\docs\_ux_v2_tools\dump_pal.py` + `simulate_text_color.py` 模擬 PaletteShift。完整推導見 `D:\openxcom\docs\ux_color_v2_designer.md`。

### 8. Tesseract OCR 對 12-16px pixel-art font 失效

實測 0% 識別率（即使 4x upscale）。Pixel art font 跟 print font ground-truth 差太遠。改用：
- `wsl_check_char_coverage.py` 找翻譯中 font 沒涵蓋的字
- `wsl_deep_validate.py` 找 format specifier {0}/{NEWLINE} mismatch
- 視覺人工 review screenshot

### 9. WSL2 + SDL 1.2 互動陷阱

OpenXcom 是 SDL 1.2 (vanilla)。WSL Xvfb 內 xdotool click 對 SDL 1.2 SDL_app window 可 work 但不 100%（depend on fluxbox WM）。Windows 端用 **PostMessage WM_MOUSEMOVE + WM_LBUTTONDOWN + WM_LBUTTONUP 三連發** 對 hwnd 100% work（agent 多輪驗證）。

**截圖**：F12（SDL key code 293）= OpenXcom 內建截圖鍵，寫入 `$user/$mod/screen000.png`（1280×800 framebuffer 完整擷取）。比 PowerShell `CopyFromScreen` 可靠 — 後者會被 screen height < window height 截斷（1280×800 window 在 1418×798 螢幕下底部 50px 切掉）。

### 10. options.cfg schema 必須是 `options:` 鍵下嵌套

```yaml
mods:
  - active: true
    id: xcom1
options:               # ← 必須這個 wrapper！
  language: zh-TW
  displayWidth: 1280
  displayHeight: 800
  fullscreen: false
  ...
```

把選項直接放 root level 會被完全 ignore（log 仍 640x400 default）。OpenXcom exit 時會把整份 ~280 行 default config 補完整寫回。

### 11. v2.19 主選單作者簽名整合（chibi pixel art）

加 PNG 圖像到主選單右下角不走 `extraSprites` ruleset，直接用 `Surface::loadImage()`：

```cpp
// MainMenuState.h
Surface *_sigBadge;

// MainMenuState.cpp constructor
_sigBadge = new Surface(48, 24, 270, 174);  // base 320x200, 右下角
add(_sigBadge);                              // raw surface overload, 不走 interfaces.rul
try {
    _sigBadge->loadImage(FileMap::getFilePath("Resources/signature_pang.png"));
} catch (...) { /* PNG 缺失 non-fatal */ }
```

PNG 必須是 8bpp paletted (PIL `P` mode)、palette 對齊 PAL_GEOSCAPE（MainMenuState 用的 palette）— 不對齊會被當不同 palette remap 後色相錯。設計師 agent 用 GEOSCAPE block 14 橄欖→暗棕 + idx 32 亮綠（眼鏡點綴），8 個 palette idx 全在範圍內。詳見 `D:\openxcom\docs\signature_design.md`。

## Build Pipeline

### Win64 (cp950 trap)

```bat
:: build-win64-release\_build_vs2022.bat
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
set "CL=/utf-8"          ← ⭐ MSVC 在 cp950 系統會把 UTF-8 source 認成多字節，沒這行 C2001 「常數中包含新行字元」
cmake -G "Visual Studio 17 2022" -A x64 -DCMAKE_SYSTEM_VERSION=10.0 -DDEV_BUILD=OFF -DBUILD_PACKAGE=OFF ..
cmake --build . --config Release --parallel --clean-first
```

Win10 SDK 必需（VS 2017 + 8.1 stub 不夠）。VS 2022 BT installer:
```
vs_BuildTools.exe --passive --norestart --wait \
  --add Microsoft.VisualStudio.Workload.VCTools \
  --add Microsoft.VisualStudio.Component.Windows11SDK.22621
```

### Linux (WSL Ubuntu 22.04)

```bash
apt install cmake pkg-config libsdl1.2-dev libsdl-image1.2-dev \
            libsdl-mixer1.2-dev libsdl-gfx1.2-dev libyaml-cpp-dev \
            fluxbox scrot ffmpeg xdotool imagemagick
cp -a /mnt/d/openxcom/OpenXcom /tmp/openxcom-src        ← /mnt/d cross-FS 太慢，cp 到 /tmp
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release /tmp/openxcom-src
make -j$(nproc)
# 結果在 /tmp/openxcom-linux-build/bin/openxcom (7.5 MB ELF)
```

### Runtime DLLs (Win64)

從 `deps/lib/x64` 拷 17 個 DLL 到 EXE 旁邊（不是 v1.0 release 那組 — 版本不對）：
SDL.dll / SDL_gfx / SDL_image / SDL_mixer / libpng15-15 / libjpeg-8 / libtiff-5 / libwebp-7 / libogg-0 / libvorbis-0 / libvorbisfile-3 / libFLAC-8 / libmikmod-2 / libmpg123-0 / yaml-cpp / yaml-cppd / zlib1

## 翻譯規範與 glossary

繁體中文 zh-TW（不是簡體！），台灣慣用譯名，X-COM 1994 軍方 vintage 風格。

| 英文 | 中文 |
|---|---|
| Interceptor | 攔截機 |
| Skyranger | 天空遊俠 |
| Lightning / Avenger / Firestorm | 閃電 / 復仇者 / 風暴 |
| Sectoid | 腦蟲 |
| Snakeman | 蛇人 |
| Ethereal | 靈體 |
| Floater | 浮游者（**不是浮空人**，agent round1 用了「浮空人」需統一） |
| Muton | 巨型怪（不是「蠻牛」/「穆頓人」） |
| Chryssalid | 蟹形蟲 |
| Reaper | 收割者 |
| Sectopod | 腦機甲 |
| Cyberdisc | 電腦碟 |
| Celatid / Silacoid | 盲蟲 / 矽生物 |
| Plasma / Laser / Heavy | 電漿 / 雷射 / 重型 |
| Cydonia | 賽多尼亞 |
| TU (Time Units) | TU (保留簡稱 + 必要時並列「時間單位」) |

TFTD-specific:
| 英文 | 中文 |
|---|---|
| Aquatoid | 水生人 |
| Gillman | 魚鰓人 |
| Lobsterman | 龍蝦人 |
| Tasoth | 塔索斯 |
| Deep One | 深淵者 |
| Calcinite | 鈣化體 |
| Triton / Manta / Hammerhead | 海神號 / 曼塔號 / 槌鯊號 |
| Z元素 / T'leth | Z 元素 / 賽爾斯（or 特列斯） |

## Validator 與 ship gate

```bash
# 3 個 validator (Windows path: D:\openxcom\tools\)
python3 wsl_validate_translations.py   # YAML parse + coverage + 簡體 detect + empty
python3 wsl_deep_validate.py           # FMT specifier + glossary + length + untranslated
python3 wsl_check_char_coverage.py     # font cell 沒涵蓋的字
bash    wsl_ship_gate.sh > ship_gate.md  # 跑全 3 個 + pass/fail summary
```

Ship gate 3/3 PASS 條件:
- 0 missing chars
- 0 真簡體（「算」字 false-positive 可 ignore）
- coverage 100% (en key set)
- FMT_MISMATCH = 0

## Multi-agent ship pipeline

| Agent role | 用途 |
|---|---|
| **UX designer** | 評估 layout / 字色 / glossary，寫 v2_plan.md / v2_review.md |
| **Translation batch** | 批次翻譯 ~100-200 keys，append-only 安全併行 |
| **Developer (font fix)** | Font.cpp / GeoscapeState.cpp / ArticleState 等 source patch |
| **Game-test (Xvfb)** | WSL headless drive game + 13 screen 截圖 + visual review |
| **Final verification** | 整合多 patch + ship gate + 寫 SHIP_FINAL.md |

並行 fork agents → 等通知接續，主 session 用 background `wait_*.sh` poll 等待。

## v1.0 → v2.17 ship 演進

| Version | 主要改 |
|---|---|
| v1.x | 字 cell 反覆 12/14/16/18/24 iter，user 反饋 |
| v2.0 | Font.cpp:193 max-height patch、Options baseRes 解鎖 |
| v2.1 | Font.dat per-image spacing:2 解 ghost |
| v2.3 | 117 條 UFOpedia 補翻 = xcom1 102% |
| v2.11 | 28 alien 名統一（賽克托人→腦蟲 etc） |
| v2.12 | TFTD batch 1+2+3 = xcom2 83.6% / 975 keys |
| v2.14 | Weekday widget h=8→12 (CJK 字身完整) |
| v2.15 | Hour setSmall + Day/Month/Year h=12 同 row + FontGeoSmall cell 10 (broke menu) |
| v2.16 | FontGeoSmall revert cell 12 (menu 修復) |
| v2.17 | 日期改西元「1999 / 1 / 1」+ Min/Sec 緊湊 + UFOpaedia color 239→255（**失敗**：255 透明落 idx 0）|
| v2.17.2 | 砲→炮 19 處 swap（砲不在 chars list）|
| v2.18 | UFOpaedia 配色 root-cause fix — 234 (deep brown) for craft article + revert 239 (light blue) for weapon。**1994 第三波官方手冊 PDF 收錄** + 200+ 條譯名對照 GLOSSARY |
| v2.19 | 主選單作者簽名 chibi pixel art 整合（MainMenuState.cpp + 48×24 paletted PNG）+ Linux AppImage + Windows portable ZIP |
| v2.20 | **TFTD 補完 100%（1166 keys）** + 1995 第三波手冊 PDF + GLOSSARY_1995_TFTD_MANUAL.md（80+ 條，5 條譯名警告）+ 士兵名 Phase A 6 國 ~2400 entries CJK 音譯 + **四包 ship**（Win/Linux × UFO/TFTD，避免 mod 切換 crash）|
| v2.21 | **Widget 切字 7 處 source patch** (BasescapeState/FundingState/Purchase/Sell/Manufacture/ManufactureInfo/Research) — h 9→13 或 11 折衷 + 鄰 widget y 同步調，解 user 抱怨「資金」變「資余」+ 士兵名 Phase B 5 國 ~1100 entries (JP/KR/ES/PT/IT) + TFTD 譯名改回 1995 風格（水生人→水族人 / 觸手怪→觸鬚人）|
| v2.22 | **Widget 切字 3 處進階 patch**（BaseInfo 26 widget 行距 11→13 / MonthlyReport 行距 8→13 重排 / GeoscapeCraft 行距 8→10 重排）+ **士兵名 Phase C 23 國 ~7500 entries**（北歐/東歐/中東/非洲/南亞/大洋洲/拉美/西歐/希臘）= **全 34 國累計 0 missing chars** + **ModListState i18n patch**（`STR_MOD_<id>` lookup + 42 條翻譯）|

每次 ship 後 user 反饋會 trigger 下一輪 iteration。**Geoscape 時鐘區 trade-off**：vintage 320×200 + CJK 12 px 物理擠不下，所有 layout 都是妥協。

## 已知限制（無法解，document as known）

1. **FontBig title 列 1-2 px 殘影** — sprite area 寬度緊張，FontBig spacing:2 仍偶見微 ghost
2. **「資」字 12×12 視覺近「宜」** — 12 px 點陣下「次」部首壓縮，純字型品質限制
3. **混排 ASCII + CJK advance 不一致** — FontBig.png spacing:0 vs FontBig_zh-TW spacing:2 → "X-COM 載具" 整行對位輕微偏
4. **Weekday 字身不能再小** — FontGeoSmall cell 12 是 menu 共用底線，cell 10 必破 menu glyph

## Portable packaging (v2.19)

### Windows ZIP (`tools/make_portable.ps1`)

1. Copy `openxcom.exe` + 17 個 SDL/yaml/codec DLL + 3 個 **MSVC runtime DLL**（MSVCP140.dll / VCRUNTIME140.dll / VCRUNTIME140_1.dll，從 `C:\Windows\System32`）
2. Copy `bin/common`, `bin/standard`, `bin/UFO` 到 `data/`
3. 寫 `OpenXcom-CHT.cmd` launcher: `start "" openxcom.exe -data data -user user -config user`
4. 寫 `user/options.cfg`（zh-TW + 1280×800 minimal schema）
5. `Compress-Archive -CompressionLevel Optimal` → 8 MB ZIP

關鍵：MSVC runtime 必須 bundle 否則別人沒裝 VC++ Redist 開不了。dumpbin /dependents 確認所有 .dll 都帶。

### Linux AppImage (`tools/build_appimage.sh`)

```bash
# 1. AppDir 結構
OpenXcom-CHT-v2.19.AppDir/
├── AppRun              # bash launcher: LD_LIBRARY_PATH + XDG paths
├── openxcom-cht.desktop
├── openxcom-cht.png    # 256x256 icon (signature chibi face NEAREST upscale)
├── usr/bin/openxcom
├── usr/lib/*.so        # 57 個 bundled deps (skip glibc/GL/X11/wayland)
└── usr/share/openxcom/{common,standard,UFO}/

# 2. ldd 過濾 — bundle 非系統 .so
LIBS=$(ldd $EXE | awk '/=>/ && $3!="" {print $3}')
for lib in $LIBS; do
  case $(basename $lib) in
    libc.so.*|libdl.so.*|libm.so.*|libpthread.so.*|libstdc++.so.*|libgcc_s.so.*) ;;
    libGL.so.*|libGLX*|libEGL*|libX11*|libxcb*|libXrender*|libwayland*|libdrm*) ;;
    libsystemd*|libudev*|libcap*|libapparmor*|libdbus*|libnsl*|ld-linux*) ;;
    *) cp -L $lib $AD/usr/lib/ ;;
  esac
done

# 3. appimagetool（fuse 在 WSL 不可用，需 --appimage-extract-and-run）
ARCH=x86_64 appimagetool --appimage-extract-and-run AppDir output.AppImage
```

AppRun XDG-compliant：`$XDG_DATA_HOME/openxcom-cht/` (存檔) + `$XDG_CONFIG_HOME/openxcom-cht/` (設定)，**不污染 OS** 也不用 root 權限。首次執行 seed `options.cfg`（zh-TW + 1280×800）。

### v2.20 雙作 ship（mod 切換 crash 解法）

**已知 issue**：OpenXcom runtime 切換 active mod (xcom1 ↔ xcom2) 會 crash。**解法是 ship 兩套 portable**：

```
OpenXcom-CHT-v2.20-UFO-portable.zip   (8 MB)   xcom1 mod + data/UFO/ 只
OpenXcom-CHT-v2.20-TFTD-portable.zip  (37 MB)  xcom2 mod + data/TFTD/ 只
OpenXcom-CHT-v2.20-UFO-x86_64.AppImage   (16 MB)
OpenXcom-CHT-v2.20-TFTD-x86_64.AppImage  (45 MB)
```

每包：同一 EXE + 同 5 patches + 同 zh-TW.yml + 同字型，**只差 options.cfg active mod + game data 資料夾**。

Build scripts: `tools/build_v2_20_quad.ps1` (Win) + `tools/build_appimage_v2_20_dual.sh` (Linux)。

### 共同 trap：options.cfg 必須在 zip/AppImage 內 user/ 目錄

第一次打 zip 沒 ship `user/options.cfg` → 解壓後 OpenXcom 用 default 開（640x400 + 英文）。修法：zip 前確認 `user/options.cfg` 存在（minimal schema 即可，OpenXcom exit 會補完整）。

## 1994 第三波官方手冊（譯名歷史基準）

PDF 收錄於 `D:\openxcom\openxcom-cht\docs\DDSC-J-00120-遊戲手冊：幽浮１－地球防衛武力.pdf`（30 MB，46 頁，DDSC 2009 數位化）。`pdftotext -layout` 可萃取（內容是英中對照表）。

200+ 條譯名對照分析在 `docs/GLOSSARY_1994_MANUAL.md`。**32 年來繁中圈不變**的核心譯名：

| 英文 | 1994 + 本專案沿用 |
|---|---|
| UFO | 幽浮 |
| UFOPAEDIA | 幽浮百科 |
| INTERCEPTOR | 攔截機 |
| PLASMA | 電漿 |
| MIND / PSI | 心靈 |
| GRENADE | 手榴彈 |
| GEOSCAPE | 地球視角 |
| COMMANDER | 指揮官 |
| BRAVERY | 勇氣 |
| NAVIGATOR | 領航員 |

**衝突未修**（後續版本候選）：
- SKYRANGER：1994「**運兵機**」較貼合機制 vs 本專案「天空遊俠」
- STINGRAY：1994「**黃貂魚式飛彈**」為正譯（魟魚）vs 本專案「刺尾」（誤譯）
- MEDI-KIT：1994「**醫藥箱**」更接近原意 vs 本專案「醫療包」
- 軍階：1994「兵/士官/尉官/校官」中華軍制 vs 本專案「下士/中士/上尉/上校」OpenXcom 慣例

## 參考檔

- 全 design doc + ship history: `D:\openxcom\docs\` (~14 個 .md)
- `v2_plan.md`：4 階段路線圖
- `v2_review.md`：v2 round 1356 keys
- `dev_round1_font_fix.md`：spacing:2 root cause re-diagnosis
- `SHIP_FINAL_V212.md`：v2.12 1419 keys ship
- **`ux_color_v2_designer.md`**：v2.18 UFOpaedia 配色 root cause + palette dump 推導
- **`signature_design.md`**：v2.19 主選單作者簽名 chibi pixel art 設計
- **`GLOSSARY_1994_MANUAL.md`**：1994 第三波 vs 本專案 200+ 條譯名對照
- Repo: <https://github.com/wicanr2/openxcom-cht>
- Portable artifacts: `D:\openxcom\dist\OpenXcom-CHT-v2.19-portable.zip` (Win) + `*.AppImage` (Linux)
- Session log: `wsl_session_log.md` + `agent_runlog.md`
