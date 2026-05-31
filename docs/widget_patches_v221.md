# OpenXcom 繁中 widget clip patches — v2.21 round

**Date**: 2026-05-31
**Scope**: 7 個低-中風險 widget patches (audit doc Tier 1 #8/3/9/1/2/5/6)
**Build target**: Linux `/tmp/openxcom-linux-build/` (incremental `make openxcom -j8`)
**未涵蓋（排 v2.22）**: BaseInfoState #4 (26 widgets 連動)、MonthlyReportState #7 (行距 8 重排)、GeoscapeCraftState #10 (行距 8 重排)

---

## 工作流程實況

每個 patch 走：Read → Edit Windows source (`D:\openxcom\OpenXcom\src\…`) → cp 到 Linux `/tmp/openxcom-src/src/…` → `make openxcom -j8` incremental → 確認 Linking OK。

**Linux build dir source 是獨立 copy**（`/tmp/openxcom-src`），不是 D 槽 symlink — 每次必須 `cp /mnt/d/openxcom/OpenXcom/src/…/<file>.cpp /tmp/openxcom-src/src/…/<file>.cpp` 才有效。

---

## Patch 表

| # | 檔案 | 行號 | 改了什麼 | Build |
|---|---|---|---|---|
| 1 | `src/Basescape/BasescapeState.cpp` | 70-71 | 2 widgets: `_txtLocation`/`_txtFunds` h 9→13, y 16→14 / 24→22。下方 `_btnNewBase` y=58 有 23px gap → 零干擾 | PASS |
| 2 | `src/Geoscape/FundingState.cpp` | 49-52 | 3 header widgets h 9→13, y 30→28；`_lstCountries` y 40→44, h 136→132（保持底邊 176） | PASS |
| 3 | `src/Basescape/ManufactureInfoState.cpp` | 79-81 | 3 widgets h 9→13, y 50→48 / 60→58。下方 `_txtAllocatedEngineer` y=80 有 11px gap → 安全 | PASS |
| 4 | `src/Basescape/PurchaseState.cpp` | 64-66 | 3 widgets **h 9→11, y -1 折衷**（不用 13 因 `_cbxCategory` y=36 與 `_txtCost` y=44 緊鄰）。接受 1px overshoot | PASS |
| 5 | `src/Basescape/SellState.cpp` | 68-75 | 6 widgets h 9→13, y -2 (Sales/Funds/SpaceUsed/Quantity/Sell/Value 全升)；`_lstItems` y 54→58, h 120→116。`_cbxCategory` 與 `_txtSales` 預計 1px gap 而非撞 | PASS |
| 6 | `src/Basescape/ManufactureState.cpp` | 51-60 | row1/row2 (Available/Allocated/Space/Funds) h 9→13, y -2；row3 多行 widget (Engineers/Produced/Cost/TimeLeft) y 44→46 整段下移 2px；`_txtItem` 也升 h=13 y 52→54；`_lstManufacture` y 80→82, h 88→86 | PASS |
| 7 | `src/Basescape/ResearchState.cpp` | 50-56 | row1/row2 (Available/Allocated/Space) h 9→13, y -2；row3 (Project/Scientists/Progress) y 44→46，`_txtProgress` 也升 h=13；`_lstResearch` y 62→64, h 112→110 | PASS |

**全 7/7 Linux incremental build PASS**，無 compile error，無 link fail。

---

## 設計決策

### 1. PurchaseState 用 h=11 而非 13
Audit doc #1 明確警告：「下方 `_cbxCategory` y=36 撞」、「`_txtCost` y=44 撞」。實算 h=13 y=22 底邊 35，與 `_cbxCategory` y=36 只剩 1px gap，但 `_txtSpaceUsed` h=13 y=32 底邊 45 必撞 `_txtCost` y=44。採 audit 折衷方案 h=11 y -1，接受字身底切 1px（破壞度減半，「金」字底橫保留大部分）。

### 2. SellState 用 h=13 全升 + cbxCategory 1px gap
重新計算 audit 表時發現 h=13 y=22 底邊 35，與 `_cbxCategory` y=36 實際還有 1px gap（非撞）。Row2 `_txtSpaceUsed` y=32 底邊 45 與 row3 `_txtSell` y=44 有 1px overlap，但 z-order 後 add 的 `_txtSell` 覆蓋上層，視覺由 row3 為主。`_lstItems` 同步 y 54→58 (audit 推薦)。

### 3. ManufactureState / ResearchState 採「row3 整段下移」策略
這兩個畫面 row2 (`_txtSpace`/`_txtFunds`) 升 h=13 後底邊 45 撞 row3 多行 widget (`_txtProject`/`_txtEngineers` h=17/18 在 y=44)。把 row3 整段 y +2 比把 row2 h=11 折衷更乾淨——row3 多行 widget 本身高度已夠 CJK 顯示，下移不會影響清晰度。連動 list y 也 +2 保持間距。

### 4. ManufactureInfoState 沒升 `_txtAllocatedEngineer` / `_txtUnitToProduce`
這兩個多行 widget (h=32/48 @ y=80/64) 不在 audit doc patch list；本身高度已 CJK-safe。未動。

---

## 須 user 視覺 review 的畫面

優先級高到低：

1. **PurchaseState (Patch 4)** — 採 h=11 折衷，字身底 1px 仍會切。Review 點：「目前資金」「採購成本」「占用空間」字底是否可接受。若仍嫌切，**只能**動 `_cbxCategory` y 36→38 或拉整個 row2 下移（連動 `_lstItems` y），下一輪處理。
2. **SellState (Patch 5)** — row2 與 row3 有 1px z-order overlap。Review 點：「占用空間」/「出售」上下兩列若視覺髒，可加 `_txtSpaceUsed` y -1 = y=31 把底邊壓回 44。
3. **ManufactureState (Patch 6)** — row3 下移 2px，`_txtEngineers/Produced` 等英文 column header 是否與下方 list 仍有 visible gap。`_lstManufacture` h 88→86 損失最後 2px 顯示，看是否截到 list 最後一列。
4. **ResearchState (Patch 7)** — 同 Patch 6 結構，需檢查 list 最後一列是否被 `_btnNew` y=176 截掉。
5. **FundingState (Patch 2)** — `_lstCountries` y 40→44 list 高度 136→132，少顯示半列國家。Review 點：18 國全列出是否還在框內。
6. **ManufactureInfoState (Patch 3)** — gap 11px 充裕，理論安全。低優先。
7. **BasescapeState (Patch 1)** — 23px gap 充裕，理論安全。低優先。

---

## 不確定 / 風險

- **Z-order 1px overlap (Patch 5, ManufactureState row2)** — 依賴 z-order 後 add 蓋前 add。OpenXcom `State::add()` 順序就是 surface render 順序，邏輯正確；但若某 widget 有透明 / 半透明背景則 overlap 視覺仍會洩。建議實際截圖確認。
- **TextList 截行風險** — Patch 5/6/7 都縮 list h 4 或 2px，最差情形是最後一列被部分截。若 list 內容只到第 N-1 列就沒事；滿載時需截圖檢查。
- **PurchaseState h=11 折衷** — Audit doc 與我都同意「字底仍切 1px，破壞度減半」。若 user 對「金」字底要求 100% 復原，需動 layout (排 v2.22 與 BaseInfoState/MonthlyReport 一起做)。

---

## 對齊 audit doc 的 deviation

| audit 表內推薦 | 實際採用 | 原因 |
|---|---|---|
| Patch 5: 改 4 widgets (Sales/Funds/SpaceUsed/Sell) | 改 6 widgets (加 Quantity/Value) | row3 三個 widget 同 y，只升 Sell 不升其他會視覺不齊 |
| Patch 6: 改 5 widgets | 改 5 widgets，但加 _txtItem h 升 13 | 「物品」也是 CJK 受影響，順手修 |
| Patch 7: 改 4 widgets | 改 4 widgets，加 row3 整段 y +2 | row2 升 13 後底邊 45 撞 row3 y=44，必須下移 |

無 audit doc 拒絕的改動。

---

## Build 統計

- 全 7 patches PASS（7/7 = 100%）
- 0 compile error
- 0 link error
- 1 個 clock skew warning（WSL/Windows 檔案時間差，無功能影響）
- 預估改動共 ~25 個 `new Text(...)` 呼叫，5 個 `TextList(...)` 呼叫

---

## 下一步

1. User 手動跑 Linux binary（`/tmp/openxcom-linux-build/bin/openxcom`）視覺 review 7 畫面
2. 若全 OK → user 手動 git commit（agent 不 commit per 任務指令）
3. v2.22 處理 BaseInfoState / MonthlyReportState / GeoscapeCraftState 大重排
