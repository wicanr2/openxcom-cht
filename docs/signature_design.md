# `signature_pang.png` — 主選單作者簽名圖像 design note

1990 年代《電腦玩家》《軟體世界》三大誌的攻略本背後一定都有那麼一張「主編簽名」——通常是 5cm×3cm 的小方塊，半張臉照片配一個手寫名字。我們這個 OpenXcom 繁中化專案做到 v2.20 之後，覺得也該給主選單留一個類似的小簽章，**讓 30 年後重玩到這個版本的人知道是哪個老幽浮迷捧場做的**。但 X-COM 1994 的主選單只有 320×200 的可憐空間，按鈕擠滿了一整片，根本沒地方塞 5cm×3cm 的照片簽章——只能擠進右下角一塊 **48×24 像素**的小天地。下面這份 design note 把那一小塊像素佈局裡藏的所有彩蛋寫下來，給後續想 fork 改色或重畫的人參考。

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

短短幾條 spec 看似工程文件，其實每一行都是設計取捨——4× 放大是 OpenXcom 主選單渲染管線天生決定的，48×24 是「能塞下去又不喧賓奪主」的最大尺寸，PAL_GEOSCAPE 是「跟主畫面 palette 不打架」的唯一選擇。Layout 細節請看下一節。

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

這個 48×24 的小方塊分成左右兩半：左半（24×24）是 chibi 圓臉戴眼鏡頭像，右半上段是 GitHub username `WICANR2`、中段一條虛線、下段「胖仔」兩個 12×12 手繪漢字。完整 layout 上下左右每個 region 用途見上表。**這是把 1990s 雜誌主編簽名格式翻譯成 X-COM palette 像素藝術的嘗試**——用最小的空間放最多的辨識資訊。

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

8 個 palette indices，全部來自 GEOSCAPE 字塊 14（橄欖→暗棕漸層）+ 一個 block 2 的亮綠當眼鏡鏡片的賽博龐克彩蛋。這個選色策略後面有完整解釋（看下面 Design rationale），先看 actual pixel 怎麼擺。

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

24×24 的頭像區裡能塞下完整的「髮、額、眼鏡、鼻、嘴、下巴、肩」是這個 design 的小驕傲——大部分 24px chibi pixel art 連嘴巴都要省略，這裡的雙圓框眼鏡（4 個 pixel × 2）+ BK 瞳孔（單 pixel × 2）+ 1 row 雙點小笑硬是擠進去了，**像在針孔上刻清明上河圖**。「胖仔」兩個 12×12 漢字則是手繪不靠 font subset，因為任何 12×12 中文 font 在 1× 顯示都會糊，hand-pixel 把每一筆畫的位置都掐到剛剛好。

## Design rationale

| 議題 | 決策 | 理由 |
|---|---|---|
| 為何用大寫 WICANR2 而非 wicanr2? | 大寫 | 3×5 lowercase 在 1x 太糊；GitHub username 慣常無大小寫差異所以視覺優先 |
| 為何左半放頭像而非 logo? | 頭像 | 用戶提供圓臉戴眼鏡頭像作為視覺 anchor，比抽象 logo 更有人格 |
| 為何鏡片用綠色而非黑色? | GL idx 32 | (a) 原圖頭像戴眼鏡;(b) 全黑會像太陽眼鏡破壞 chibi 可愛感;(c) 引入一個高飽和點綴讓簽名不會悶 |
| 為何 transparent 背景而非 BACK01 同色 fill? | 透明 | 讓簽名可重用於不同 sub-state；如果 BACK01 換主題不會出現方框 |
| 為何 48×24 而非更大? | 48×24 | 主選單空間有限 (window 右下外 52×26)，且 4x 放大後 192×96 已經足夠醒目而不喧賓奪主 |
| Palette 為何選 GEOSCAPE 而非 mainMenu? | GEOSCAPE | MainMenuState.cpp 用 `PAL_GEOSCAPE`；rendering pipeline 沿用同 palette 不需 remap |

這 6 個 design rationale 條目串起來看，可以發現整個簽章的核心哲學是「**人格大於品牌**」——大寫 username 是給 GitHub fork 我這份 repo 的人看的，圓臉頭像是給玩家看的，鏡片亮綠那一抹是 1990 年代雜誌主編的小簽名彩蛋。**把這個簽章疊在主選單背景上的瞬間，這個 repo 就有了具體的、人格的、可辨識的作者標記**——不再是匿名的 GitHub URL，而是某個老幽浮迷在 2026 年留下的印章。

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
