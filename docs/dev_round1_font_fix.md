# OpenXcom 繁中化 v2 — Round 1 Font Fix 報告

日期：2026-05-31  
基準：vanilla OpenXcom `1.0.1edb0a5a2-dirty`，Linux native build at `/tmp/openxcom-linux-build/bin/openxcom`  
驗證解析度：1280×800 windowed, base 320×200, xBRZ off

---

## 摘要

| Bug | 嚴重度 | Root cause | 修法 | 結果 |
|---|---|---|---|---|
| 1. FontBig/Small CJK ghost overlap | P0 | zh-TW image `spacing=0`（與 FontBig.png 同），CJK glyph ink 寬 = cell-1，相鄰字緊貼無間距，視覺上像疊字 | Font.dat 對 FontBig_zh-TW.png 與 FontSmall_zh-TW.png 加 `spacing: 2` | **解決 90%+**：難度選擇、basescape menu、ufopaedia menu、options 全部字距乾淨 |
| 2. FontGeoSmall「資」字 → 顯示「宜」 | P1 | **誤判** — 經 cell extract 驗證，cell idx=3950 的 glyph 確實是「資」（兩點水+欠+貝），只是 12×12 像素下「次」部首細節壓縮後視覺與「宜」(宀+目) 接近 | 無，glyph 渲染本身正確；視覺問題只能透過更大 cell (e.g. 14×14) 或字型微調解 | 不修，document as known limitation |

---

## Bug 1 — Root cause 重新定性

### 之前的誤判（Round 1 v2_plan §5）

v2_plan 假設 root cause = `Font::getHeight()` 回傳 `_images[0].height`（英文圖的高度 16），導致 zh-TW image cell 高（16）超過 line step（同 16），造成「line step bug」。Round 1 patch 改 getHeight 取 max → 沒解決 ghost。

### 實測 root cause

對「建造新基地」5 字模擬 Font::init() 計算每字 `rect.w`：

```
建 idx=1236 cell-relative left=0, right=14, rect.w=15
造 idx=4145 cell-relative left=0, right=14, rect.w=15
新 idx=1756 cell-relative left=0, right=14, rect.w=15
基 idx=780  cell-relative left=0, right=14, rect.w=15
地 idx=741  cell-relative left=0, right=14, rect.w=15
```

每字 `rect.w = 15`（ink 邊界），advance = `rect.w + image->spacing`：
- 修前：`image->spacing = 0` → advance 15 → 字間 **零 gap** → glyph stroke 視覺融合
- 修後：`image->spacing = 2` → advance 17 → 字間 **2px gap** → 清楚分開

「ASCII 正常 但 CJK ghost」的原因：ASCII glyph 在 8×8 / 16×16 cell 內天然帶 1-2px ink padding；CJK glyph stroke 撐滿 cell（特別是「擇」「建」「難」這種多筆畫字），相鄰字的左/右 stroke 在 0 spacing 下直接相連。

### 為什麼 GEO_SMALL 沒事？

FONT_GEO_SMALL global `spacing: 1`，FontGeoSmall_zh-TW 沒 override → 繼承 1。所以 GeoSmall 每字字間 1px gap，**已 OK**。Geoscape 6 顆右欄 button（攔截/基地/圖表/幽浮百科/選項/資金）一直都乾淨。

---

## 修法 detail

**檔案**：`D:\openxcom\OpenXcom\bin\common\Language\Font.dat`（YAML，runtime 讀取，**不需 rebuild binary**）

**Diff**:
```diff
       - file: FontBig_zh-TW.png
+        spacing: 2
         chars: >
...
       - file: FontSmall_zh-TW.png
-        spacing: 0
+        spacing: 2
         width: 16
         height: 16
         chars: >
```

備份檔：`Font.dat.bak2`  
patcher：`tools/patch_font_dat_zh_spacing.py`

`src/Engine/Font.cpp` line 193 的 getHeight() max-height patch（Round 1）保留 — 雖然不是 ghost 主因，但對未來 mixed-image 場景仍是正確 hardening。

---

## 驗證

**Driver**：`tools/wsl_drive_v4.sh`（相同 13 step sequence）  
**截圖**：`screenshots/wsl_v4_*.png`（已覆寫，舊版回收）

| Screen | Before (review round 1) | After |
|---|---|---|
| 02 難度選擇按鈕（新手/熟練/老兵/天才/超人）| 重疊嚴重 | **乾淨** |
| 02「鐵人模式」「確定」「取消」按鈕 | 重疊 | **乾淨** |
| 02 標題「選擇難度」 | 嚴重 ghost | 輕微 ghost 仍在（標題用 FontBig + 寬度緊） |
| 04「選擇新基地地點」標題 | 嚴重 ghost | 大幅改善但仍有微 ghost |
| 06「基地名稱?」dialog 標題 | 輕度 ghost | **乾淨** |
| 09 Basescape 右側 10 個 menu button | 全部嚴重 ghost | **全部乾淨**（包含 5 字長的「建造新基地」） |
| 13 Ufopaedia 9 個項目 button | 全部 ghost | **乾淨** |
| 12 Options menu | ghost | **乾淨** |
| 07 Geoscape 6 顆右欄 button | OK | OK（沒退化） |
| 07 Geoscape 星期X/1月/1999 | **行間重疊** | **行間仍重疊**（**獨立 bug，不在本 fix 範圍**） |

放大對位圖：`screenshots/basescape_btn_v2.png`（5× zoom）—「建造新基地」5 字 ink 各自獨立。

---

## 仍待修 (留給下一輪 agent)

### 1. Geoscape 時鐘區三行 Y 重疊 (P1)

`src/Geoscape/GeoscapeState.cpp:161-165`：
```cpp
_txtWeekday = new Text(59, 8, screenWidth-61, screenHeight/2-13);
_txtMonth   = new Text(29, 8, screenWidth-32, screenHeight/2-6);
_txtYear    = new Text(59, 8, screenWidth-61, screenHeight/2+1);
```

每個 Text widget y 間距 7px、widget 高 8px，原為 FontGeoSmall (英文 7px) 設計。中文 12px cell 在 y 方向 overlap 5px。

**Fix 方案**：把間距推到 13px，或 widget 高度推 12，調整起始 y 位置。但會影響英文版佈局 — 需 conditional on language 或 全部加大。

### 2. 標題「選擇難度」「選擇新基地地點」仍有 1px 等級殘影 (P2)

FontBig 用在 `WindowState` 標題列，widget 寬度可能仍緊張，可能 Text setText 邏輯讓字稍微 squeeze 或某 ASCII 標題用 FontBig 後切回 FontSmall 失敗。可進一步 trace `Text::setText` fallback 流程。

或直接：把 FontBig_zh-TW spacing 從 2 推到 3，但會更易 trigger fallback。

### 3. 「載具與武裝」「X-COM」混排對位 (P3)

Ufopaedia 第一個 button 含 ASCII "X-COM" + 中文「載具與武裝」，混排時 ASCII 用 FontBig.png (spacing 0) 中文用 FontBig_zh-TW.png (spacing 2)，advance 不一致導致整行對位有點怪。**Cosmetic only**。

### 4. 「資」字 12×12 視覺品質 (P3)

非真 bug，但 12×12 cell 對含「次」部首的字（資/姿/咨...）天然辨識難。**建議**：把 FontGeoSmall_zh-TW 從 12×12 升 14×14，重 render 用 14px glyph。但這需動 Font.dat + make_fonts_zhtw.py + 重 render PNG。

---

## 給下一輪 agent 的建議

1. **不要再假設 line step bug 是 root cause**。Round 1 review 把 ghost overlap 寫成 line step bug 是 misdiagnosis — 本輪確認 X advance 才是。
2. Geoscape 時鐘 y overlap **是真的 line spacing bug**，但在 `GeoscapeState.cpp` widget 定義階段，不在 Font / Text 通用層。
3. 補翻 xcom1 ~140 條長 description 應與字型修法解耦，可平行進行。
4. 若要 ship `v2.1-menu`：本 fix + 補 200 key 即可 tag。Geoscape 時鐘區 Y overlap 是 v2.2 議題。
5. **慎用 v2_plan §5 推薦的修法**：那個方案（getHeight 取 max）對 ghost 無效；本輪改 image spacing 才有效。可更新 v2_plan §5 反映。

## 工具新增

| File | 用途 |
|---|---|
| `tools/patch_font_dat_zh_spacing.py` | 主 patcher：對 Font.dat 加 spacing=2 |
| `tools/inspect_basescape_chars.py` | 模擬 Font::init() 算 CJK 字 rect.w / advance |
| `tools/debug_font_small_zh.py` | 驗證 FontSmall_zh-TW spacing 是否生效 |
| `tools/inspect_geo_zi.py` | 找特定字在 FontGeoSmall 的 cell idx + bbox |
| `tools/extract_zi_cell.py` | 把 cell glyph 印 ASCII art 並 8× 放大存圖 |
| `tools/crop_*.py` | 從遊戲截圖切特定 button / title 並放大目視驗證 |

備份：`Font.dat.bak2`（**保留**，方便回滾）
