# OpenXcom 繁中 widget clip patches — v2.22 round (high-risk reflow)

**Date**: 2026-05-31
**Scope**: 3 個高風險 widget patches (audit doc Tier 1 #4 / #7 / #10)
**Build target**: Linux `/tmp/openxcom-linux-build/` (incremental `make openxcom -j8`)
**前置條件**: v2.21 7 patches 已 land 並 PASS

---

## Patch 表

| # | 檔案 | 行號 | 改動摘要 | Build |
|---|---|---|---|---|
| **T1** | `src/Basescape/BaseInfoState.cpp` | 60-102 | 26 widgets：14 `_txt*` h 9→11, y -1；6 `_bar*` y -1 (h=5 不變)；6 `_num*` h 9→11, y -1。三段 (Personnel/Space/Defense) 三元運算 enforced/!enforced 同步調整 | **PASS** |
| **T2** | `src/Geoscape/MonthlyReportState.cpp` | 59-64 | 5 header widgets h 9→13, 行距 8→13；y: 24,32,40 → 24,37,50。`_txtDesc` y 48→63, h 132→117 (底邊 180 保留) | **PASS** |
| **T3** | `src/Geoscape/GeoscapeCraftState.cpp` | 63-75 | 12 widgets h 9→11, 行距 8→10；y 序列 52,60,68,76,84,92,100 → 52,62,72,82,92,102,112；`_txtSoldier/HWP` 對齊 MaxSpd/Altitude row；`_txtRedirect` (h=17 big) y=108 保持原狀 (條件式 overlay) | **PASS** |

**全 3/3 Linux incremental build PASS** — 0 compile error, 0 link error。

---

## T1 BaseInfoState — ASCII y-layout

**Before** (h=9, 行距 11 px, range y=30..172)
```
Personnel block:
y=30  _txtPersonnel       (heading, h=9)
y=41  _txtSoldiers        + _barSoldiers @ y=43
y=51  _txtEngineers       + _barEngineers @ y=53
y=61  _txtScientists      + _barScientists @ y=63

Space block:
y=72  _txtSpace           (heading)
y=83  _txtQuarters        + _bar @ y=85
y=93  _txtStores          + _bar @ y=95
y=103 _txtLaboratories    + _bar @ y=105
y=113 _txtWorkshops       + _bar @ y=115
y=123 _txtContainment     (if enforced) + _bar @ y=125
y=123/133 _txtHangars     + _bar @ y=125/135

Defense block:
y=138/147 _txtDefense     + _bar @ y=140/149
y=153/157 _txtShortRange  + _bar @ y=155/159
y=163/167 _txtLongRange   + _bar @ y=165/169  (enforced 底邊=176)

y=180 buttons (Transfers/Stores/MonthlyCosts h=14)
```

**After** (h=11, 行距仍 11 px, all y -1)
```
Personnel:    29 (head), 40, 50, 60                  bars: 42, 52, 62
Space:        71 (head), 82, 92, 102, 112,
              122 (containment if enforced),
              132 (hangars enforced) / 122 (hangars !enforced)
              bars: 84, 94, 104, 114, 124 / 134 / 124
Defense:      146/137, 156/152, 166/162               bars: 148/139, 158/154, 168/164
Buttons:      y=180 (unchanged) — enforced LongRange 底邊 166+11=177，gap=3 px
```

**設計**: audit doc §8「甜蜜點 h=11」直譯 — **保留原 11 px 行距，h 9→11 把字身吃到行距邊界**；每列 y -1 維持原 vertical center。`_bar` y 同步 -1 維持原 +2 offset（_bar h=5 嵌入 _txt 11 px 內仍視覺一致）。

**為何不行距 11→13**: audit 表第 4 行寫「全表行距須改 11→13」與 §8「11 px 行距 = 甜蜜點」實際矛盾。enforced 模式有 13 列 (Containment+Hangars 都在)，若改 13 px 行距 → 從 y=30 到 LongRange 需要 ≥30+12×13=186 → 撞 button y=180。**§8 才是正解**，採之。

---

## T2 MonthlyReportState — ASCII y-layout

**Before** (h=9, 行距 8 px)
```
y=8   _txtTitle (h=17, big)
y=24  [_txtMonth h=9 ][_txtRating h=9 ]   底=33
y=32  [_txtIncome h=9              ]      底=41   <- 9 px 寬卻只 8 px pitch → 撞
y=40  [_txtMaintenance][_txtBalance]      底=49   <- 同上撞
y=48  [_txtDesc h=132                  ]  底=180
y=180 _btnOk
```

**After** (h=13, 行距 13 px)
```
y=8   _txtTitle (unchanged)
y=24  [_txtMonth h=13][_txtRating h=13 ]   底=37
y=37  [_txtIncome h=13               ]     底=50   gap=0 (緊貼)
y=50  [_txtMaintenance h=13][_txtBalance]  底=63   gap=0 (緊貼)
y=63  [_txtDesc h=117                  ]   底=180  (preserve bottom edge)
y=180 _btnOk
```

**設計**: 行距 13 px = h 13 px，0 gap。OpenXcom Text widget 內字渲染 12 px CJK + 1 px clip buffer → 底部不切。視覺上仍是有間距感（字身字身相鄰，無重疊）。`_txtDesc` 多吃 15 px 高 (148→132 字寬 280 估算 ~37 字/行，少 1-2 行)。月末強制 popup, 仍夠 4-7 行 narrative。

**Deviation from audit**: audit 寫 (24→24, 32→39, 40→55) — 不均勻。我採均勻 13 px (24, 37, 50)，行距一致，視覺更穩。`_txtDesc` h 我選 117（保 100%+ 高），audit 寫 ~108 (更激進)；我傾向保守。

---

## T3 GeoscapeCraftState — ASCII y-layout

**Before** (h=9, 行距 8 px, 7 列)
```
y=20  _txtTitle (h=17, big)
y=36  _txtStatus (h=17)                          底=53
y=52  [_txtBase                    ]   底=61
y=60  [_txtSpeed                   ]   底=69
y=68  [_txtMaxSpeed   ][_txtSoldier]   底=77
y=76  [_txtAltitude   ][_txtHWP    ]   底=85
y=84  [_txtFuel       ][_txtDamage ]   底=93
y=92  [_txtW1Name     ][_txtW1Ammo ]   底=101
y=100 [_txtW2Name     ][_txtW2Ammo ]   底=109
y=108 _txtRedirect (h=17, big, overlay)   底=125
y=124 _btnBase
```

**After** (h=11, 行距 10 px)
```
y=20  _txtTitle  (unchanged)
y=36  _txtStatus (unchanged)                     底=53
y=52  [_txtBase                    ]   底=63   gap from Status=-1 (overlap by 1 同原版)
y=62  [_txtSpeed                   ]   底=73
y=72  [_txtMaxSpeed   ][_txtSoldier]   底=83
y=82  [_txtAltitude   ][_txtHWP    ]   底=93
y=92  [_txtFuel       ][_txtDamage ]   底=103
y=102 [_txtW1Name     ][_txtW1Ammo ]   底=113
y=112 [_txtW2Name     ][_txtW2Ammo ]   底=123
y=108 _txtRedirect (UNCHANGED — overlays W1/W2 when _waypoint!=0 as before)
y=124 _btnBase  → gap=1 px from W2 底邊 123
```

**設計**: 行距 10 px + h 11 px → -1 px overlap per row（字身相鄰，視覺上 12 px CJK 字身會貼齊，但 SDL clip rect 給 11 px 仍夠顯示 12px 字身底（OpenXcom 字型用 1 px 底 buffer 故 11 px clip 能完整顯示）。Last row 底邊 123 + 1 px = 124 _btnBase top → 0 gap 緊貼但不撞。

**_txtRedirect 不動**: 它是 h=17 big-font overlay，只在 `_waypoint != 0` 時 setVisible(true)。原始即 overlap W1/W2 區（y=108 底=125 vs W2 y=100 底=109，overlay 上層）。新版仍保持 `add()` 順序蓋頂 — 視覺行為與原版一致。

**為何不 h=13 / 行距 13**: 7 列 × 13 = 91 px range，從 y=52 起需到 y=143 — 完全壓過 _btnBase y=124，layout 崩潰。h=11 / 行距 10 是 popup 窄空間下唯一可行方案。

**Deviation from audit**: audit 寫「行距 8→11 或 8→13 整段重排到 y=128 上方」。實算 _btnBase y=124（不是 128），所以 buffer 是 19 px 而非 23。我採行距 10、h=11，更貼近 audit 推薦的較緊版本。

---

## 視覺 review 優先級

1. **T1 BaseInfoState** (最高優先) — 26 widgets 連動，**h=11 + 11 px 行距 = 0 gap**。字身緊貼相鄰列上緣。若視覺感「行距過密」或字底毛邊明顯 → fallback h=10 (audit 表並未推薦但仍保 1 px gap)。**最痛點: bar 與 text 視覺對齊**，bar y=text y+2, h=5；text 升到 h=11 後 bar 應仍在 text 中段（text 內部 y2~y7 是字身，bar y2~y6 5 px 落在字身上 → 視覺重疊可能輕微）。
2. **T3 GeoscapeCraftState** — popup 行距 10 px **0 gap** 設計。檢查 `_txtSpeed/_txtMaxSpeed` 「速/度/最/速」字底是否乾淨。`_txtRedirect` 啟動時 (`_waypoint != 0`) overlay 視覺需專測。
3. **T2 MonthlyReportState** — 3 header row + 1 desc，0 gap 設計。`_txtDesc` 縮 15 px 後最差情況：月末 narrative 文字超過 8 行（h=117 / 12 px 字身 ≈ 9 行）會被 clip。需玩到實際月末 popup 看 narrative 長度。

---

## Build PASS/FAIL 統計

- **3/3 PASS** (100%)
- 0 compile error
- 0 link error
- v2.21 + v2.22 累計：10/10 patches PASS

---

## Deviation 與意外發現

1. **audit doc §2 表 #4 與 §8 自相矛盾** — 表寫「行距改 11→13」，§8 寫「11 px 是甜蜜點不要動」。實算 enforced 模式 13 行用 13 px 行距 absolutely 撞 button (y=30+12×13=186 > 180)。**§8 為正**，採之。建議下次 audit 修表行 #4 改為「h 9→11, y -1（保留 11 px 行距）」。
2. **audit doc §2 表 #7 給的 y 序列 (24→24, 32→39, 40→55) 不均勻** — gap 為 (37→39=2, 50→55=5 不等)。可能是 auditor 手算誤差。採均勻 13 px pitch (24,37,50) 更穩。
3. **GeoscapeCraftState `_txtRedirect` 不在 audit patch list 但邏輯上應考慮** — 它是條件式 overlay big-font widget，與下方 W1/W2 row 物理 overlap。**正確策略是「保持原樣不動」**，因為它本來就是 overlay 用途；強行下移反而會壓 button 區。audit doc 沒提這點，本 patch 補上。
4. **_bar widget 是 row text 的內嵌視覺元素而非獨立列** — 原 design `_bar y = _txt y + 2, h=5`，bar 5 px 嵌入 9 px text 後段。Text 升 h=11 後 bar 仍 +2 offset, 5 px 內嵌 11 px text 視覺一致（bar 落在 y_text+2 ~ y_text+6 仍在 text 內部 41% 區間）。**不需要動 bar h，只 y -1 跟著 text 移動即可**。
5. **T2 _txtDesc h=117 是保守選擇** — audit 推 ~108，我選 117 多保留 9 px 高（約 0.75 行）。若月末 narrative 字數短（多數情況），多餘空白無害；若超長，~117 vs ~108 差異也不影響「截行」結局。保守 wins。
6. **MonthlyReportState 0 gap 與 GeoscapeCraftState -1 gap 都依賴 OpenXcom Text widget 渲染特性** — Text setClipRect 給 h px 但字型本身 12 px CJK 渲染含 1 px 底 buffer，所以 h=11 對 12 px 字看似不夠卻能完整顯示底橫。**若實測仍切**，fallback 全升 h=13 並擴行距，但會嚴重壓縮 layout。

---

## 不確定 / 待 user 測試

- **T1 _bar 與升 h 後 _txt 的視覺重疊** — bar 落在 text 內 y2~y6 區間，與 11 px text 字身（y0~y10）部分重疊。原 9 px text 時 bar y2~y6 是 text 字身底半部，視覺上 bar 是「下方延伸」。新 11 px text 後 bar 仍在底半部但 text 字身整體下移 → 視覺感或許更「bar 切過字底」。需截圖確認。
- **T3 _txtRedirect overlay** — 啟動條件 `_waypoint != 0`（攔截 UFO 時點 craft icon 才會出現），不容易 reproduce。需手動建立攔截場景測。
- **T2 _txtDesc 長 narrative 截行** — 月末事件多時 narrative 可能 8+ 行，h=117 約 9 行容量，邊緣 case 會截。需玩到 year 2+ 多 country pact / liberation 月份測。

---

## 對應 audit doc 修正建議 (回饋)

| audit § | 原寫法 | 建議修正 |
|---|---|---|
| §2 表 #4 「建議 patch」 | 「h 9→11 (擠不下 13)，**全表行距須改 11→13**」 | 「h 9→11，y -1，**保留原 11 px 行距**」（§8 已正確說明，表行需同步） |
| §2 表 #7 「建議 patch」 y 序列 | (24→24, 32→39, 40→55) | (24, 37, 50) — 均勻 13 px pitch；`_txtDesc` y 48→63, h 132→117 |
| §2 表 #10 補充 | 未提 `_txtRedirect` 處理 | 註明 `_txtRedirect` 為條件式 overlay，h=17 big，**保持原 y=108 不動**，與下移後 W1/W2 row 仍 overlay 行為一致 |

---

## 下一步

1. User 跑 Linux binary `/tmp/openxcom-linux-build/bin/openxcom` 視覺 review 三畫面
2. 若全 OK → main session 統一 git commit (v2.21 7 patches + v2.22 3 patches)
3. 若 T1 _bar 視覺問題明顯 → v2.23 fallback 方案：h=10 全升保 1 px gap
4. 若 T2 _txtDesc 截行 → v2.23 重新評估 (考慮 h 117→112 但拉 desc 底邊到 188 接近 _btnBigOk y=174)
