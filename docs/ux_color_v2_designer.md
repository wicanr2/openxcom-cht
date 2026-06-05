# OpenXcom UFOpaedia 文字色修復 v2 (designer pass)

這份 doc 記錄的是 OpenXcom 繁中化 v2.x 過程中一個**整整三輪 agent 才解開**的調色盤踩雷——UFOpaedia 載具條目（Skyranger / Interceptor / Lightning / Avenger / Firestorm）打開後，中文標題與描述文字**會直接消失在淡藍色雲彩背景裡**，肉眼根本看不見字。前兩輪 agent 都以為是「換個顏色就好」，第三輪坐下來把 X-COM 1994 的 `PaletteShift::func` 渲染公式從 `src/Interface/Text.cpp:466` 一行一行讀完才發現：**widget 的「color」屬性根本不是文字顏色，而是 5 階 ramp 的基底 index**，真正出現在螢幕上的 5 個 pixel index 是 `color + 1 .. color + 5`。1990 年代 X-COM 那套 8-bit palette 渲染美學，30 年後在 OpenXcom 開源碼裡仍然咬人——這份 doc 就是給後續 designer 留的踩雷地圖。

## TL;DR

- ArticleStateCraft (Skyranger / Interceptor / ...) 文字色：
  `Palette::blockOffset(14)+10` (= 234)
  → PAL_UFOPAEDIA 字 pixel 落 idx 235..239 = `#7C5440 .. #503020`
     deep brown ramp (L=93.7→55.7)。
- ArticleStateCraftWeapon (Stingray / Cannon / ...) 文字色：
  **revert 回 vanilla** `Palette::blockOffset(14)+15` (= 239)
  → PAL_BATTLEPEDIA 字 pixel 落 idx 240..244 = `#A0B8D8 .. #2C3C4C`
     light blue ramp (L=180→57)，對黑底 weapon 圖完美。
- 不開 `setHighContrast()`（會把 ramp 散到別 block 變亂）。

三句話 TL;DR 看似簡單，但底下的踩雷史血淚交織。下一節從渲染公式講起。

## 為什麼前兩輪都失敗 — palette 渲染公式

關鍵在 `src/Interface/Text.cpp:466` 的 `PaletteShift::func`:

```cpp
static inline void func(Uint8& dest, Uint8& src, int off, int mul, int mid)
{
    if (src) {
        ...
        dest = off + src * mul + ...;
    }
}
```

其中 `off = _color`（widget 的 color），`src` 是 font glyph
pixel value 1..5（anti-alias 漸層），`mul = 1` 預設 / `mul = 3` 開
`setHighContrast(true)` 時。

**所以 widget 的「color」不是文字「顏色」，而是 ramp 基底**。
真正出現在螢幕的 5 個 palette index 是 `color + 1 .. color + 5`。

選色必須讓 `[color+1 .. color+5]` 構成連續可讀漸層。

看懂這個公式之後再回看前兩輪 agent 的失敗，會發現他們不是粗心，是被 1990s palette 美學的隱性 invariant 騙了——「color = 顏色 index」這個直覺在 32bpp 系統是對的，在 X-COM 1994 的 ramp shift 系統是錯的。完全不同典範。

## PAL_UFOPAEDIA 真實內容（前一輪 agent 誤判處）

從 `bin/UFO/GEODATA/PALETTES.DAT` 抽 + 乘 4 (X-COM 0-63 scale → 0-255)：

| idx | RGB | L | 說明 |
|-----|-----|---|------|
| 0 | #000000 | 0 | 透明 (`.unused = 0`) |
| 32..47 | 米黃帶 | 高 | UP004 雲色用 |
| 128..143 | 淡藍帶 | 高 | UP004 天空主色 |
| 144..159 | 紫紫深紫深 navy | 漸 | block 9 dark ramp |
| 224..239 | **#F4DCCC..#503020 棕色 ramp** | 225→56 | block 14, vanilla 用此 block 末端 |
| 239 | #503020 | 55.7 | vanilla `blockOffset(14)+15` |
| 240 | #9C94BC | 155 | block 15 起點 (紫) |
| 241..244 | 紫→灰→#1C1C20 ramp | 漸 | block 15 中段 |
| 244 | #1C1C20 | 28.5 | 最深「中性灰黑」(secondary 用) |
| 245..249 | teal/dark teal | 漸 | block 15 中後段 |
| 250, 251 | **#FC00FC magenta** | 104 | transparency 慣例 (block 15 末) |
| **252..255** | **#FCFCA4..#A4C068 淡黃綠 ramp** | 173→242 | **block 15 最末段是淡色**！ |

(swatch render 在 `_ux_v2_tools/swatch_PAL_UFOPAEDIA.png`)

### v1 (上一個 agent) 失敗理由

選 `blockOffset(15)+15 = 255` 假設 block 15 末端是黑色（PAL_BATTLESCAPE 確
實如此因 Mod.cpp:2820 手動 override 過），但 PAL_UFOPAEDIA / PAL_BATTLEPEDIA
**沒有那個 override**。block 15 直接走 PALETTES.DAT 內容 = 雜色（紫/灰
/teal/magenta/**淡黃綠**）。

從公式 `color=255, mul=1` → pixels 落 idx 0..4 (wrap 後)，
= `#000000, #FCFCE4, #FCF8D8, #FCF8CC, #FCF4C0` —
第 1 個 pixel 是 idx 0 = **透明**！剩下 4 個全是淡奶油色。所以渲染出來
**主要 pixel 是透明 + 周圍淡色**，luminance 跟天空雲幾乎相同 → 完全看不見。

### v2 第一次 attempt (本 session 中途錯誤)

選 `blockOffset(15)+9 = 249`，理由是 249 自己是 #14282C dark teal。
但 widget color 不是直接渲染色，pixels 落 idx 250..254 =
magenta + magenta + 淡黃綠 + 淡黃綠 + 淡黃綠 → 文字呈現**亮黃米色**，
luminance 接近天空，仍然看不清。

(這個錯誤的 build 留下截圖 `wsl_uxv2_04_skyranger_article_yellow.png`
但因為被覆寫了沒留實體 — 結論記在這。)

前兩輪 agent 失敗的根因都是「沒去 dump 真實 PAL_UFOPAEDIA / PAL_BATTLEPEDIA 內容、直接用 PAL_BATTLESCAPE 的直覺猜」——這就像 1995 玩家不查《電腦玩家》攻略直接在 X-COM 第一張地圖鑽進外星人運兵艇後門，**保證團滅**。

## v2 final 選色推導

### ArticleStateCraft (PAL_UFOPAEDIA, sky/cloud 背景)

需 ramp `color+1..+5` 全是 dark：

候選比較 (mul=1)：

| color | pixels (idx) | RGB ramp | L range |
|-------|--------------|----------|---------|
| 234 (block14+10) | 235..239 | #7C5440 .. #503020 | 93.7 → 55.7 |
| 153 (block9+9) | 154..158 | #082864 .. #00184C | 37.3 → 22.8 |
| 218 (block13+10) | 219..223 | #68A45C 翻 dark green | 149 → 64 |
| 106 (block6+10) | 107..111 | dark purple ramp | 35 → 18 |

153 (deep navy) 對比最強但**單一色相**(deep navy 從頭到尾)，X-COM 12×12
中文 stroke 的 AA 沒漸層 = 字心跟邊一樣黑沒層次感，缺 vintage 質感。

**選 234 (deep brown ramp)**：
- 跟 vanilla 在同個 block 14，純粹往下移 5 階 → 風格延續
- 5-step ramp 從中棕到深棕，AA 漸層保留
- 對天空 L=130..230 形成 L 差 40-170 → 100% 可讀
- vintage warm look 跟 X-COM 經典暗棕 UI 一致

### ArticleStateCraftWeapon (PAL_BATTLEPEDIA, **黑底** weapon 圖)

關鍵發現：UP006..UP011.SPK 是 **黑底 weapon 照片**，不是天空。

vanilla 239 在 PAL_BATTLEPEDIA 渲染 → pixels 240..244 =
`#A0B8D8..#2C3C4C` = **淺藍漸到深藍**，src=1 那層 (亮淡藍 L=180)
正是黑底上的 highlight outline。

如果跟 ArticleStateCraft 一樣套 234 → pixels 235..239 =
`#484064..#201830` (深紫 ramp L=70→29) — **完全沒入黑背景**！

→ **ArticleStateCraftWeapon 維持 vanilla** (239)，
是這次 designer pass 修正前一輪 agent 的盲改。

### `setHighContrast(true)` 不用

mul=3 會讓 src=1..5 各自落 +3, +6, +9, +12, +15 — 跨越 block 邊界
進入完全不同色相區（例如 234+3=237 棕，234+6=240 紫，234+9=243 灰
深紫，234+12=246 teal，234+15=249 dark teal）— ramp 變雜色拼接，
視覺紊亂。X-COM 用 contrast 是針對 Battlescape 黃字 vs 暗背景的
特殊路線，不適合 dark-on-light layout。

這個 234 深棕 ramp 與 vanilla 239 淺藍 ramp 並存的選色決定，是這次 designer pass 最關鍵的取捨。**Craft article 配 234 深棕對天空淡藍**——對比強、視覺穩、X-COM vintage warm look 延續；**Craft Weapon article 維持 vanilla 239 淺藍對黑底**——黑底上的淺藍 highlight outline 是 1994 原版設計，本來就沒壞別瞎改。

## 產出

- 改動：`src/Ufopaedia/ArticleStateCraft.cpp` (3 處 setColor + 註解)
- 改動：`src/Ufopaedia/ArticleStateCraftWeapon.cpp` (revert 3 處 + 註解)
- Linux build: `/tmp/openxcom-linux-build/bin/openxcom` (~7.5 MB)
  `wsl bash /mnt/d/openxcom/tools/wsl_build_linux.sh`
- Windows build: **尚未 trigger** — 等 user 確認 Linux 視覺效果後再執行
- 工具：
  - `D:\openxcom\docs\_ux_v2_tools\dump_pal.py` — 完整 palette dump
  - `D:\openxcom\docs\_ux_v2_tools\analyze_and_swatch.py` — 渲染 swatch + UP004 byte histogram
  - `D:\openxcom\docs\_ux_v2_tools\simulate_text_color.py` — 模擬 PaletteShift 公式
  - `D:\openxcom\docs\_ux_v2_tools\swatch_PAL_UFOPAEDIA.png` — 256-color grid
  - `D:\openxcom\docs\_ux_v2_tools\swatch_PAL_BATTLEPEDIA.png` — 256-color grid

## 截圖

主要驗證頁 (1280×800 zh-TW window mode)：

- `screenshots/ufopaedia_color_v2_04_skyranger_article.png` — 天空遊俠 (UP004 天空背景)
  - 文字深棕清楚壓在淡藍/白雲上，stats 數值墨綠 (secondary 244 ramp)
- `screenshots/ufopaedia_color_v2_05_interceptor_article.png` — 攔截機 (UP001 淡紫天空背景)
  - 文字深棕對紫天空對比佳
- `screenshots/ufopaedia_color_v2_08_firestorm_article.png` — 加農炮 (Cannon UC, craft weapon, UP008 黑底)
  - vanilla 淺藍 ramp 對黑底完美
- `screenshots/ufopaedia_color_v2_11_craftweapon_article.png` — Vehicle 重型武器平台 (Cannon Vehicle, ArticleStateVehicle, **本次未動**)

## 驗證 driver

`D:\openxcom\tools\wsl_drive_ufo_v2_color.sh` — 從主選單跑到
ufopaedia → X-COM Craft & Armament list → 5 craft + craft weapon
articles，捕完整 flow 截圖。

## 不動

- 不動 `zh-TW.yml` / `Font.dat` / 字型 PNG（scope 約束）
- 不動 git
- 不動其他 ArticleState* (Vehicle/Item/Armor/Ufo/Text/TextImage/BaseFacility)
- 不動 ruleset (`interfaces.rul` 的 ufopaedia text color: 138 yellow 不適用此處)

## Windows build 觸發時機

user 確認 Linux 截圖效果可接受 → 跑 VS 2022 build (與之前 zh-TW font
同 pipeline)。本 session 不主動 trigger（task 規範）。

## Known limitations

1. 只 fix craft article (Skyranger/Interceptor/Lightning/Avenger/
   Firestorm 共 5 篇)；craft weapon 篇刻意 revert vanilla。
2. 沒走 ruleset config 路線（前一輪 agent 已說明 ArticleStateCraft 不讀
   `interfaces.rul`），維持 source patch。
3. 中文 12×12 字型 stroke 細是 root cause 的另一半 — 但 scope 不動
   font。深 ramp 已足夠補償，無需加粗。

最後一段話留給後續想動 UFOpaedia 配色的人：**動之前必先 dump 該 article 用的 palette、跑 simulator 模擬 5 階 ramp**——這是 1990s X-COM 美學的「文獻學步驟」。直接拍腦袋換顏色保證踩三次雷才解出來，跟 1995 年我打 TFTD 不查《電腦玩家》就直接派魚叉去打龍蝦人一樣的下場。
