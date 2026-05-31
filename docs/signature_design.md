# `signature_pang.png` — 主選單作者簽名圖像 design note

## 規格

- 檔名: `signature_pang.png`
- 尺寸: **48 × 24 px**
- 格式: 8 bpp paletted PNG (PIL `P` mode)
- Palette 來源: OpenXcom GEOSCAPE palette (`PALETTES.DAT` idx 0)
- 透明 colour: idx 0
- 安裝位置:
  - `D:\openxcom\OpenXcom\bin\common\Resources\signature_pang.png` (主程式)
  - `D:\openxcom\openxcom-cht\bin\common\Resources\signature_pang.png` (繁中 repo 鏡像)
- 顯示時被 OpenXcom 4x 放大 → 1280×800 上呈現 192×96 px
- 預期擺位: 主選單 (32,20)-(288,180) window 外面右下角 (264,170)~(316,196)

## Layout (48 × 24)

```
+------------------------+------------------------+
|                        |   WICANR2  (rows 1-5)  |
|                        |   ········ (row 7)     |
|   chibi 圓臉戴眼鏡      |   ┌────────┐           |
|   胖仔頭像              |   │ 胖   仔│ (rows 9-20)|
|   (cols 0-23,           |   └────────┘           |
|    rows 0-23)           |    (cols 24-47)        |
+------------------------+------------------------+
   24 px                     24 px
```

| Region | Pixels | Content |
|---|---|---|
| Left half | cols 0-23, rows 0-23 | 24×24 chibi head with shoulders |
| Right top | cols 24-47, rows 1-5 | `WICANR2` (3×5 font, uppercase) |
| Right mid | cols 24-47, row 7 | dotted separator (M2 colour) |
| Right bottom | cols 24-35, rows 9-20 | `胖` glyph (12×12 hand-pixelled) |
| Right bottom | cols 36-47, rows 9-20 | `仔` glyph (12×12 hand-pixelled) |
| Vertical seam | col 23, rows 2-21 step 4 | dotted separator between portrait and text |
| Anchor tick | cols 46-47, row 22-23 | 3-pixel decorative corner |

## Palette indices used

| Alias | Idx | RGB (GEOSCAPE) | Role |
|---|---|---|---|
| **T**  | 0   | `(0,0,0)`         | transparent background |
| **HL** | 224 | `(104,124,68)`    | bright olive — face / text highlight |
| **M1** | 226 | `(100,108,60)`    | mid olive — face mid tone |
| **M2** | 230 | `(84,76,48)`      | warm mid-brown — shadows / hair / separator |
| **SH** | 234 | `(60,44,32)`      | dark brown — hair shading, neck |
| **LN** | 237 | `(40,24,24)`      | outline — glasses frame, text body, hair edge |
| **BK** | 239 | `(28,16,16)`      | deepest — pupils, accent |
| **GL** | 32  | `(116,156,44)`    | block-2 bright green — glasses **lens** (cyberpunk hint) |

Indices used (final image): `[0, 32, 224, 226, 230, 234, 237, 239]` (8 colours total).

選色策略:
1. **以 GEOSCAPE block 14** (idx 224-239 橄欖→暗棕漸層) 作為「皮膚 + 線稿」主色帶，跟主選單 BACK01 灰藍背景自然分離又不衝突。
2. **block 14 不是純灰**: 在 GEOSCAPE 是橄欖綠色相 (因 GEOSCAPE 整體偏陸地+海洋藍綠色)，所以「灰」字面意義不準，但漸層對比清晰。
3. **眼鏡鏡片故意用 idx 32 亮綠** (block 2)，引入 1px cyberpunk 高飽和點綴，呼應「賽博胖仔」氣質。鏡片內 BK 瞳孔提供強對比 → 不會在縮放後糊掉。
4. **避開 magenta / 高飽和原色 slot** (block 5 cyan、block 6 紫粉)，避免破壞主選單統一色調。
5. 沒用 BG fill — 全程透過 idx 0 透明，所以簽名可以疊在 BACK01.SCR 或任何背景上。

## 像素佈局細節

### 頭像 (左半 24×24)
- 髮頂 row 0-3: SH/M2 漸層髮絲，帶 LN 外輪廓
- 額頭 row 4-6: HL/M1 高光 (左上光源)
- 眼鏡 row 7-11: LN 圓框 + GL 鏡片 + BK 瞳孔；雙圓框靠 col 11/12 之間留 2 px 鼻樑
- 鼻子 row 12-13: 中央 BK 單點 + M1/HL 漸層
- 嘴 row 15: BK 雙點小笑
- 下巴 row 17-19: 從 HL 漸至 SH 收縮
- 肩 row 20-23: SH/M2 寬肩外擴 + LN 收邊 → 「胖仔」體型暗示

### 「WICANR2」字串 (3×5 font)
- 全大寫設計，因為 3×5 lowercase 在 1x 顯示會糊
- 字寬: W(3)+I(1)+C(3)+A(3)+N(3)+R(3)+2(3) = 19
- 字距 gap: `[1,0,1,1,1,1]` (I 後不留 gap 避免太散) → 總寬 24 完美塞進右半
- 顏色: 全 HL idx 224 (亮橄欖)，背景透明
- 在 4x scale (192×96 顯示) 下每字佔 12×20 px，肉眼易辨

### 「胖仔」漢字 (12×12 each)
- 手繪 pixel 級簡化字形，**不是** font subset render
- 「胖」: 左 月 (5×9 包含 2 條 inner crossbar) + 右 半 (6×9 含 八/橫/直)
- 「仔」: 左 亻 (3×8 含 slant 頭 + 雙豎主幹) + 右 子 (5×8 含 頂橫/中橫/直勾)
- 全用 LN (idx 237) 單色填筆畫，不加 highlight (因為 12×12 太小，highlight 會讓筆畫崩)
- 兩字並排 12+12 = 24 完整填滿右半下半部

## Design rationale

| 議題 | 決策 | 理由 |
|---|---|---|
| 為何用大寫 WICANR2 而非 wicanr2? | 大寫 | 3×5 lowercase 在 1x 太糊；GitHub username 慣常無大小寫差異所以視覺優先 |
| 為何左半放頭像而非 logo? | 頭像 | 用戶提供圓臉戴眼鏡頭像作為視覺 anchor，比抽象 logo 更有人格 |
| 為何鏡片用綠色而非黑色? | GL idx 32 | (a) 原圖頭像戴眼鏡;(b) 全黑會像太陽眼鏡破壞 chibi 可愛感;(c) 引入一個高飽和點綴讓簽名不會悶 |
| 為何 transparent 背景而非 BACK01 同色 fill? | 透明 | 讓簽名可重用於不同 sub-state；如果 BACK01 換主題不會出現方框 |
| 為何 48×24 而非更大? | 48×24 | 主選單空間有限 (window 右下外 52×26)，且 4x 放大後 192×96 已經足夠醒目而不喧賓奪主 |
| Palette 為何選 GEOSCAPE 而非 mainMenu? | GEOSCAPE | MainMenuState.cpp 用 `PAL_GEOSCAPE`；rendering pipeline 沿用同 palette 不需 remap |

## 預覽檔案

- `D:\openxcom\docs\signature_preview.png` — 8x grid preview (384×192)，每像素有格線方便檢視
- `D:\openxcom\docs\signature_preview_4x_inmenu.png` — 1280×800 主選單 mock-up，簽名以 4x 實際遊戲尺寸 placed 在 (264,170)

## Tooling

- 產生腳本: `D:\openxcom\docs\_ux_v2_tools\build_signature.py`
- Palette dump: `D:\openxcom\docs\_ux_v2_tools\dump_geo_pal.py`
- 重新產生命令: `python D:\openxcom\docs\_ux_v2_tools\build_signature.py`

## 下一步 (不在本任務範圍)

1. `MainMenuState.cpp` 加 `Surface *_signature` 成員，`new Surface(48,24,264,170)`，`add(_signature)`，`loadImage("Resources/signature_pang.png")` (或對應 OpenXcom path resolution)
2. 確認 `Resources/signature_pang.png` 進入 `_common.zip` 或 paths 列表
3. 在 OptionsVideoState 或 about screen 也可重用此 surface
