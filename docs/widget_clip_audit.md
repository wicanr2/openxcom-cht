# OpenXcom 繁中 widget clip audit — CJK 12px 字身被 SDL clip rect 切底

**Audit date**: 2026-05-31
**Scope**: `src/Basescape/`, `src/Geoscape/`, `src/Battlescape/` (`*.cpp`)
**Reference fix**: GeoscapeState.cpp 時鐘 widget (v2.14) — h=8 → h=12，相鄰 y 同步補正。
**Audit only**: 本 doc 不改任何 source、不 build、不 commit。

---

## 1. Grep 結果統計

| Pattern | 範圍 | Hits |
|---|---|---|
| `new Text(W, 8\|9\|10, X, Y)` | `src/**/*.cpp` 全樹 | **338** |
| 同 pattern in `Basescape/` | 一級災區 | ~140 |
| 同 pattern in `Geoscape/` | 二級災區 | ~40 |
| 同 pattern in `Battlescape/` | 三級災區 (DebriefingState 一個就 18) | ~70 |

絕大多數 `_num*`/數字 widget (`_numSoldiers`、`_numTimeUnits` …) 雖然 h=9 但內容全 ASCII 數字，**不切**（h=9 對 9px ASCII 剛好），列入 **B 級** 風險。

真正受害是 **label widget** — 內容來自 `tr("STR_*")` 翻譯，渲染時 SDL `setClipRect(0, 0, w, 9)` 把 12px CJK 字身底 3 px 切掉。

---

## 2. Worst offenders — 高頻畫面 Top 10

下表按「玩家停留時間 × 中文 label 數量 × 視覺破壞度」排序。Patch 範例使用同 v2.14 GeoscapeState 手法：**h: 9→13, y: -2**（向上補回中心，避免覆蓋下方 widget 上緣）。

| # | 檔案:行號 | Widget | 當前 (w,h,x,y) | 顯示內容 | 切到什麼字 | 建議 patch | 下方淨距 | 風險 |
|---|---|---|---|---|---|---|---|---|
| **1** | `Basescape/PurchaseState.cpp:64-66` | `_txtFunds`,<br>`_txtPurchases`,<br>`_txtSpaceUsed` | (150,9,10,24)<br>(150,9,160,24)<br>(150,9,160,34) | 「目前資金: $X」<br>「採購成本: $X」<br>「占用空間: X」 | 「資/金/購/間」底部橫筆 | h 9→13, y 24→22 / 34→32 | 下方 `_cbxCategory` y=36，34→32+13=45 **撞 y=44 _txtCost**；改 y=32+11=43 也撞 → **需先把 cost 列下移到 y=46**，或縮 h→11 折衷 | **中**：兩列堆疊區 |
| **2** | `Basescape/SellState.cpp:68-73` | `_txtSales`,<br>`_txtFunds`,<br>`_txtSpaceUsed`,<br>`_txtSell` | (150,9,10,24)<br>(150,9,160,24)<br>(150,9,160,34)<br>(96,9,190,44) | 「銷售總值」<br>「目前資金」<br>「占用空間」<br>「出售/解職」 | 「金/間/職」底切；「售」最痛 | h 9→13, y -2；`_txtSell` h→13 但 x,y 不動測試 list header 重疊 | 同 PurchaseState；`_lstItems` y=54 距 44+13=57 → **必撞 list 第 1 列**，須把 `_lstItems` y 54→58 | **中** |
| **3** | `Geoscape/FundingState.cpp:49-51` | `_txtCountry`,<br>`_txtFunding`,<br>`_txtChange` | (100,9,32,30)<br>(100,9,140,30)<br>(72,9,240,30) | 「國家」<br>「補助金」<br>「變動」 | 「家/金/動」底切 | h 9→13, y 30→28 | `_lstCountries` y=40，28+13=41 → **撞 list 第 1 列上緣**，須調 `_lstCountries` y 40→44 | **低**：純 popup, 上下都有 margin |
| **4** | `Basescape/BaseInfoState.cpp:60-101` | 26 個 widget — `_txtPersonnel/Soldiers/Engineers/Scientists/Space/Quarters/Stores/Laboratories/Workshops/Containment/Hangars/Defense/ShortRange/LongRange` | 全 `(W,9,8,Y)` 11 px 間距 | 「人員可用/總數」、「士兵」、「工程師」、「科學家」、「空間使用/可用」、「住宿/倉儲/實驗室/工坊/外星收容/機庫/防禦/短程偵測/長程偵測」 | 「員/兵/師/學/可/用/宿/倉/實/坊/容/機/禦/程/測」幾乎全切 | h 9→11 (擠不下 13)，**全表行距須改 11→13**：所有 y 重算遞增 | 6 個 `_bar*` widget 緊跟同一 y+2，**必須同步下移 _bar y** | **高**：26 widget 連動，最需謹慎；最廣破壞最廣畫面 |
| **5** | `Basescape/ManufactureState.cpp:51-55` | `_txtAvailable`,<br>`_txtAllocated`,<br>`_txtSpace`,<br>`_txtFunds`,<br>`_txtItem` | (150,9,8,24)<br>(150,9,160,24)<br>(150,9,8,34)<br>(150,9,160,34)<br>(80,9,10,52) | 「工程師可用」<br>「工程師分配」<br>「工坊空間」<br>「目前資金」<br>「物品」 | 「師/配/間/金/品」底切 | h 9→13, y -2 (24→22, 34→32) | `_txtEngineers/Cost/TimeLeft` 跨高 widget h=18/27 在 y=44，34→32+13=45 撞 → 須拉 row2 整列下移 | **中** |
| **6** | `Basescape/ResearchState.cpp:50-55` | `_txtAvailable`,<br>`_txtAllocated`,<br>`_txtSpace`,<br>`_txtProgress` | (150,9,10,24)<br>(150,9,160,24)<br>(300,9,10,34)<br>(84,9,226,44) | 「科學家可用」<br>「科學家分配」<br>「實驗室空間」<br>「進度」 | 「家/配/間/度」底切 | h 9→13, y -2 | row2 (`_txtProject`/`_txtScientists` h=17 @ y=44) 須下移 2 px；`_lstResearch` y=62 還有 4 px gap → 不撞 | **中** |
| **7** | `Geoscape/MonthlyReportState.cpp:59-63` | `_txtMonth`,<br>`_txtRating`,<br>`_txtIncome`,<br>`_txtMaintenance`,<br>`_txtBalance` | (130,9,16,24)<br>(160,9,146,24)<br>(300,9,16,32)<br>(130,9,16,40)<br>(160,9,146,40) | 「月份」<br>「評分」<br>「收入」<br>「維護費」<br>「結餘」 | 「份/分/入/護/餘」全切 | h 9→13, y -2 (24→22, 32→30, 40→38) | 行距 8 px 太擠，13 px 必撞下行；**必須拉行距 8→13**，整段 `_txtDesc` (y=48, h=132) 須往下 + 縮高，否則 footer 區擠掉。最差情況：報表為玩家月底唯一強制 popup，**多人會盯著看** | **高**：行距重排 |
| **8** | `Basescape/BasescapeState.cpp:70-71` | `_txtLocation`,<br>`_txtFunds` | (126,9,194,16)<br>(126,9,194,24) | 「地點: XX」<br>「資金: $X」 | 「點/金」底切（**正是用戶提到的「資金」變「資余」**） | h 9→13, y -2 (16→14, 24→22) | y=22+13=35，下方 `_btnNewBase` y=58 還有 23 px gap → **無風險**。最容易修。 | **低**：base 主畫面右側資訊欄，獨立區域 | 
| **9** | `Basescape/ManufactureInfoState.cpp:79-81` | `_txtAvailableEngineer`,<br>`_txtAvailableSpace`,<br>`_txtMonthlyProfit` | (160,9,16,50)<br>(160,9,16,60)<br>(160,9,168,50) | 「工程師可用」<br>「工坊空間可用」<br>「月利潤」 | 「師/間/潤」底切 | h 9→13, y -2 (50→48, 60→58) | `_txtAllocatedEngineer` h=32 @ y=80 還有 11 px gap → 不撞 | **低** |
| **10** | `Geoscape/GeoscapeCraftState.cpp:63-72` | `_txtBase`,<br>`_txtSpeed`,<br>`_txtMaxSpeed`,<br>`_txtAltitude`,<br>`_txtFuel`,<br>`_txtDamage`,<br>`_txtW1Name`/`_txtW2Name`,<br>`_txtSoldier`,<br>`_txtHWP` | 全 (W,9,X,Y) y=52..108 行距 8 | 「基地: XX」<br>「速度/最高速度」<br>「高度/燃料/損傷」<br>「武器1名稱/彈藥」<br>「武器2…」<br>「乘員」<br>「重武器」 | 「地/度/料/傷/器/藥/員/重」全切 | h 9→13, y -2 (整段 -2) | popup 行距 8 px，**13 px 必撞下行**；須行距 8→11 或 8→13 整段重排到 y=128 上方還剩 20 px buffer | **高**：高頻 — 玩家點 craft 必看 |

---

## 3. 次要候選 (Tier 2 — 可後續補)

| 檔案:行號 | Widget | 顯示 | 備註 |
|---|---|---|---|
| `Basescape/ManageAlienContainmentState.cpp:72-74` | `_txtAvailable`/`_txtUsed`/`_txtItem` | 「空間可用/已用/外星生物」 | 中頻；改法同 PurchaseState |
| `Basescape/MonthlyCostsState.cpp:49-55` | `_txtCost`/`Quantity`/`Total`/`Rental`/`Salaries`/`Income`/`Maintenance` | 「成本/數量/總計/租金/薪資/收入/維護」 | 跨行 40/80/146/154 — y 距已硬塞 list，**沒空間**，只能 h=9→11 緩解 |
| `Basescape/ManufactureStartState.cpp:54-58` | `_txtManHour/Cost/WorkSpace/RequiredItemsTitle` | 「工時/成本/工坊/所需特殊材料」 | popup, 中頻；y=50/60/70/84 行距 10 → 改 h=11 安全 |
| `Basescape/ResearchInfoState.cpp:72-73` | `_txtAvailableScientist/Space` | 「科學家可用/實驗室空間」 | popup, 行距 10 → h=11 安全 |
| `Geoscape/ConfirmNewBaseState.cpp:53-54` | `_txtCost/Area` | 「成本/區域」 | popup, 中低頻 |
| `Battlescape/DebriefingState.cpp:94-115` | `_txtItem/Quantity/Score/Recovery/Rating` + 12 個 stat header (`_txtSoldier`~`_txtPsiSkill`) | 「物品/數量/分數/回收/評分」+ 兵員第二頁欄首 | 任務結算畫面，玩家停留長；stat header w=18 太窄，CJK 直接被截字寬，**這個應該已經是 ASCII-only label 不切**（如 「TU」、「ST」 …），verify 後再決定 |
| `Geoscape/InterceptState.cpp:56-58` | `_txtCraft/Status/Base` | 「機種/狀態/基地」 | popup |
| `Geoscape/ItemsArrivingState.cpp:59-61` | `_txtItem/Quantity/Destination` | 「物品/數量/目的地」 | popup |
| `Basescape/TransfersState.cpp:48-50` | `_txtItem/Quantity/ArrivalTime` | 「物品/數量/抵達時間」 | popup |
| `Basescape/SoldierInfoState.cpp:85-147` | 29 個 widget — `_txtRank/Missions/Kills/Craft/Recovery/Psionic/Dead` + 11 個 stat label | 「軍階/任務/擊殺/載具/復原/通靈/陣亡」+ 11 個能力名 | row distance 11 px buffer 還 OK；可改 h=11 全表 |
| `Battlescape/UnitInfoState.cpp:68-154` | 24 個 widget (戰場單兵屬性表) | 全中文能力名 | 行距 = `Bar::yPos += step` 動態，須順 step 升 |

---

## 4. 安全名單 (B 級風險 — h=9 但內容 ASCII，不切)

這些雖然 grep 中招但顯示**純數字或英文符號**，可保留：

- 所有 `_num*` widget (`_numSoldiers`, `_numTimeUnits`, `_numHangars` …) — 顯示 `15/25`、`100%`，無 CJK
- `Geoscape/DogfightState.cpp:261-266` `_txtAmmo1/Ammo2/Distance` — 顯示 `12`, `5km` 等
- `Geoscape/GeoscapeState.cpp:161` `_txtSec` — 秒數 `00`-`59`
- `Geoscape/GeoscapeState.cpp:172` `_txtFunds` (geoscape 角落) — 金額 `$1,234`，但仍含 `$` 符號 → 安全
- `Battlescape/InventoryState.cpp:83-88` `_txtTus/Weight/FAcc/React/PSkill/PStr` — 顯示 `TUs:42` 等，header 也 ASCII
- `Battlescape/Map.cpp:112` `_txtAccuracy` — `42%`
- `Battlescape/MedikitState.cpp:144-145` — 醫療部位數字
- `Battlescape/InventoryState.cpp:89` `_txtItem` (140,9,128,140) — **顯示物品 tr 名稱**，是 CJK → **應該升級到 Tier 1**，但 inventory 畫面整體已塞滿，沒空間動，先列觀察
- `Basescape/SoldierInfoState.cpp:91` `_txtDead` (130,33) — 「陣亡」訊息，但 widget 占整個 `_btnArmor` 區域覆蓋，特殊處理

---

## 5. 已修案例 (對照組 — 不要再動)

- `Geoscape/GeoscapeState.cpp:164` `_txtWeekday` — 已 h=12（v2.14 patched, 註解明確）
- `Geoscape/GeoscapeState.cpp:169-171` `_txtMonth/Day/Year` — 已 h=12（v2.14 patched）
- `Geoscape/GeoscapeState.cpp:161,172` `_txtSec/_txtFunds` — **仍 h=8**，但內容 ASCII 不切，可保留

---

## 6. 通用建議 patch pattern

```cpp
// before (ASCII 假設 9px 字身):
_txtFunds = new Text(150, 9, 10, 24);

// after (適配 12px CJK，補回中心):
_txtFunds = new Text(150, 13, 10, 22);   // h 9→13, y 24→22
                                          // 上下各補 2 px = 13-9=4 / 2

// 若下方 widget 行距僅 10 px (=10 不夠 13 容下)，折衷:
_txtFunds = new Text(150, 11, 10, 23);   // h 9→11, y 24→23 (只補 1 px)
                                          // 仍會切「金」最底 1 px 但破壞度減半
```

**選擇規則**：
- **行距 ≥ 14 px** (BaseInfoState 11 px 是例外)：直接 h=9→13, y -2
- **行距 10-13 px**：折衷 h=11, y -1，僅補 1 px 字身
- **行距 ≤ 9 px** (MonthlyReportState 8px)：**需重排整段 y**，risk **高**

---

## 7. 修改順序建議 (低風險到高風險)

1. **BasescapeState.cpp** (#8) — 主畫面 + 獨立區域 + 23 px gap → 零風險試水溫
2. **FundingState.cpp** (#3) — popup，下方就一個 list，調 list y=40→44 即可
3. **ManufactureInfoState.cpp** (#9) — popup, gap 11 px
4. **PurchaseState.cpp** (#1) / **SellState.cpp** (#2) — 平行畫面，patch 一個另一個套
5. **ManufactureState.cpp** (#5) / **ResearchState.cpp** (#6) — 結構類似 1+2
6. **GeoscapeCraftState.cpp** (#10) — 高頻但行距 8，需整段重排
7. **MonthlyReportState.cpp** (#7) — 月末強制 popup，行距 8，要動 `_txtDesc` h
8. **BaseInfoState.cpp** (#4) — 26 widget 連動，最大工程量；建議**最後**做且需專門一輪 ux verify

---

## 8. 意外發現

1. **`_numSoldiers` 等 28 個 `_num*` widget 全 h=9，內容只是數字**。Grep pattern 抓到大半都不會切，**真正 worst case ~ 80-100 個** label widget，不是 338。
2. **`Battlescape/DebriefingState.cpp` 第二頁 stat header** (`_txtTU/Stamina/Health/…`) **w=18** 太窄，原始即會切**寬度**（中文 「時間單位」 4 字 = 48 px，塞不進 18 px 框）— 這比切高更難解，可能要降到單字 「時/體/血/勇/反/射/擲/格/力/通/技」 用單字 abbr。本次 audit 不處理寬度問題，但需 flag。
3. **`Geoscape/GeoscapeState.cpp:161` `_txtSec` 仍 h=8** — v2.14 patch 留 ASCII 不動是對的，**驗證 audit 邏輯 OK**。
4. **`BaseInfoState.cpp` 行距僅 11 px** — 連 h=13 都塞不下，只能升 h=11，但這正好讓 11 px 等於行距 = 緊貼但不切。**這是個甜蜜點**，可能比 13 安全。
5. **ManufactureState 第二列** `_txtEngineers/Cost/TimeLeft` h 已經是 18/27（多行 widget），這些**不在 audit 範圍**，已天然 CJK-safe。
6. **`_lstItems`/`_lstResearch` TextList y 起始位置** 往往緊貼最後一個 label，**任何 patch 都得連 list y 一起動**，否則 list 第一列被 label 蓋住。這是 patch 真正的風險源，不是 widget 本身。

---

## 9. 結論

- 338 grep hits → 約 100 個真正中文 label widget 受影響
- **Top 10 worst offenders** 集中在 Purchase/Sell/Manufacture/Research/BaseInfo/MonthlyReport/Funding/GeoscapeCraft/Basescape — 涵蓋 8 個高頻畫面
- 最低風險先試：**BasescapeState 主畫面右側資金欄**（用戶原始抱怨點，#8）
- 最大工程：**BaseInfoState** (26 widgets 連動)、**MonthlyReportState** (行距 8 px 需重排)
- **不要動**：`_num*` 數字 widget、`_txtSec`、GeoscapeState 已 patched 區、ASCII-only DOM
- **flag 待解**：DebriefingState 第二頁 stat header 寬度太窄（不在本 audit scope）

Audit 完成，待 review 確認動工順序。
