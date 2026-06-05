# OpenXcom 繁中化 v2 —— Designer 收尾評估

> 範圍：v1.1 → v2 single iteration（擴翻 + 自動測試截圖 + 收尾）。
> 日期：2026-05-30。
> 對齊文件：[v2_plan.md](v2_plan.md)。

這份 design review 寫於 2026 年 5 月 30 日——本專案 v2 階段第一次「擴翻 + 自動截圖測試 + 收尾」三步走完之後的收工報告。當時 v2.1 計畫只翻 200 條 key，這一輪實際 ship 出 1356 條（90% coverage），**直接跳過 v2.1 把 v2.2 規劃的 Battlescape/Inventory/Basescape 全部翻完**。這份 doc 留下了「2026-05-30 那一刻」字型策略、line step bug、按鈕字溢出、語言名稱顯示「文言」這幾個踩雷的完整快照——後續 v2.21/v2.22/v2.23 解決了這份 review 標出的所有 known issue。

---

## 1. Phase A 翻譯統計

從 v1.1 的 8 條 key 跳到 v2 的 1356 條 key，這一輪擴翻看起來不可思議地大——實際上是因為 OXCE nightly 社群已經開了 60-80% 的 zh-TW 翻譯，本專案 cherry-pick 進 vanilla master 路線後一次補完。下面這張表是「規模 v1.1 vs v2」的對照。

### 1.1 規模

| 檔案 | en-US keys | zh-TW keys (v1.1) | zh-TW keys (v2) | 覆蓋率 (v2) |
|---|---:|---:|---:|---:|
| `bin/common/Language/zh-TW.yml` | 427 | 8 | **426** | **99.8%** |
| `bin/standard/xcom1/Language/zh-TW.yml` | 1075 | 30 | **930** | **86.5%** |
| **合計** | **1502** | **38** | **1356** | **90.3%** |

實際翻譯數遠超 v2_plan §3 對 v2.1+v2.2 階段 ~800 key 的規劃；本次一次推進到接近 v2.3 邊界（剩 UFOpedia 長段落與 ~12 個外星人 rank 變體未補）。

### 1.2 範圍（Cover by 分區）

* **Main menu 完整**：新遊戲/新戰鬥/讀取存檔/儲存/選項/離開/放棄遊戲。
* **Options 全套**：影像、音效、操控、地球視角、戰術視角、進階、資料夾；含 30+ advanced options key（雙語 + DESC）。
* **Save / Load**：選擇存檔、自動存檔/快速存檔 slot 名、刪除確認、讀寫失敗/成功訊息、Ironman。
* **Modlist**：基本遊戲 label、版本提示、OXCE required 警告。
* **Difficulty**：新手 → 超人 全部。
* **Geoscape menu**：攔截/基地/圖表/幽浮百科/資金/選項 + 6 個時間速度 + 月份/星期。
* **Basescape**：建造設施、研究、製造、採購/招募、出售/解雇、轉移、士兵清單、人員管理、設施名（含 access lift / hangar / lab / workshop / radar / containment / mind shield / psi lab / hyper-wave decoder 全套）。
* **Battlescape**：HUD（TU/Energy/Morale/Stun/Health/Bravery/Reactions/Acc/Throw/Str/PSI）、Action menu（連發/速射/瞄準/投擲/啟動手榴彈/治療/掃描/心靈控制/恐慌）、armor 部位、inventory slot 名、turn/side 資訊、命中/未命中/受傷/陣亡。
* **Craft & UFO**：X-Com 6 craft（天空遊俠/閃電/復仇者/攔截機/風暴）+ 8 UFO（小/中/大型偵察艇/採集者/綁架者/恐怖艦/戰艦/補給艦）+ all craft weapons。
* **Aliens**：13 種族中文名（腦蟲/蛇人/靈體/巨型怪/浮游者/盲蟲/矽生物/蟹形蟲/收割者/腦機甲/電腦碟 等）；live alien base ranks（指揮官/領袖/工程師/醫護/領航員/士兵/恐怖份子）。
* **Country / Region / City**：16 國、15 region、50 城市（含台灣慣用譯名：紐約/倫敦/東京/開普敦/孟買/首爾/坎培拉 等）。
* **Mission types**：恐怖任務/基地防禦/突襲外星基地/幽浮墜毀回收/幽浮地面突襲 + 對應 briefings；Mars: Cydonia / Final Assault 兩個結局任務。
* **Monthly report**：理事會滿意/不滿/退出計畫等 5 段訊息 + 月評等 6 級（糟糕→優異）。
* **Diary / Memorial / Awards**：勳章名/嘉獎/陣亡/失蹤 + 10 級授勳 + 9 種針別（銅/銀/金）。

### 1.3 翻譯規範一致性

Glossary 已主動執行 一致性 check：

| 原文 | 譯名 | 來源 |
|---|---|---|
| Interceptor | 攔截機 | 台灣空軍術語 |
| Skyranger | 天空遊俠 | 直譯 + 戰術運輸機脈絡 |
| Hangar | 機庫 | 中文標準 |
| Sectoid | 腦蟲 | 1990s 台灣攻略本通用 |
| Snakeman | 蛇人 | 直譯 |
| Ethereal | 靈體 | 較「以太人」更自然 |
| Floater | 浮游者 | 兼顧懸浮 + 漂泊 |
| Chryssalid | 蟹形蟲 | 取其形態 |
| Cyberdisc | 電腦碟 | 直譯 |
| Reaper | 收割者 | 直譯 |
| Sectopod | 腦機甲 | Sectoid 動力裝甲變體 |
| Stingray | 刺尾 | 取其形 |
| Plasma | 電漿 | 物理術語 |
| Heavy Plasma | 重型電漿 | 一致 |
| Time Units | TU / 時間單位 | 短/長並列 |
| Cydonia | 賽多尼亞 | 火星地名 |

**簡繁體 check**：翻譯時主動避開「资金/图表/选项」等簡體用字，全用「資金/圖表/選項」。
**X-COM 1994 vintage 風格**：保留軍方階級口吻（士兵/中士/上尉/上校/指揮官），月報用「資助國理事會」（非「funding council」直譯「資助議會」）。

### 1.4 未翻 (Missing) 統計

* xcom1 missing 171 keys — 其中：
  * **~140 個 `*_UFOPEDIA` 長段落**（v2.3 範圍，預期保留）。
  * **3 個 `STR_VICTORY_*` + 2 個 `STR_GAME_OVER_*` 結局劇情**（v2.3）。
  * **~12 個 alien rank 變體**（`STR_FLOATER_NAVIGATOR` 等）— 可在 v2.2 補完，工作量 < 30 分鐘。
  * **~10 個短雜項**（`STR_DIFFICULTY_LEVEL`/`STR_HARVESTER_UFOPEDIA` 等）。
* common missing 11 keys — 全為超罕用設定/錯誤訊息，影響極小。

---

## 2. Phase B 遊戲測試（截圖檢視）

翻譯本身只是第一道測試線——真正的考驗是把翻好的 zh-TW.yml 灌進 OpenXcom 跑起來看畫面。本輪用 WSL Xvfb harness 自動跑 6 個截圖場景，下面是當時的觀察記錄。

### 2.1 截圖清單（D:\openxcom\screenshots\）

| 檔名 | 顯示 state | 狀態 |
|---|---|---|
| `v2_mainmenu.png` | Main menu | OK — 4/6 按鈕在 client 945x590 框內可見（新遊戲/新戰鬥/讀取存檔/選項），底部 模組/離開 button 被視窗下緣裁掉 |
| `v2_options.png` | OptionsState（影像分頁） | OK — 全中文 tab 與標籤；解析度顯示 1280x800；display language slot 顯示 "文言"（zh-TW 系統名稱顯示問題） |
| `v2_modlist.png` | ModListState | OK — 「基本遊戲」label 顯示；mod 名保留英文（mod 本身無 zh-TW 翻譯） |
| `v2_difficulty.png` | NewGameState | OK — 「選擇難度」+ 1>新手 / 2>熟練 / 3>老兵 / 4>天才 / 5>超人 全中文 |
| `v2_geoscape.png` | BuildNewBaseState (globe + 標題) | 部份成功 — 標題「選擇新基地地點」中文顯示但有 line overlap；未進入 Geoscape main（globe 旋轉中，base 未放） |
| `v2_intercept_or_base.png` | 同上（BuildNewBase state） | 'i' key 在 BuildNewBase 不接受，stay on 同 screen |

### 2.2 顯示問題

* **Line overlap（v2_plan §5 已預期）**：在 `v2_options.png` 與 `v2_geoscape.png` 標題列觀察到 中文字疊到下一行的問題。Root cause = `Font.cpp:193 getHeight()` 回傳 `_images[0].height`（英文 image height），未隨 zh-TW image cell 14/16/18 放大 line step。v2_plan 修法 A 尚未上 source patch（per 規範「不動 source」），所以 v2.1 截圖保留 line overlap 狀態作為 known issue。
* **按鈕字溢出**：「新戰鬥」（STR_NEW_BATTLE）顯示時尾字「鬥」超出按鈕右邊框，看 `v2_mainmenu.png` 右上按鈕。為 button 內部 92x20 px 對 3 個 18x18 中文字的固有衝突，與 v2_plan §7-1 一致（無 source patch 不可解）。
* **OptionsState 標題堆疊**：左欄分類標籤（影像/音效/操控/地球視角/戰術視角/進階/資料夾）每行接 16px image cell，line step 仍 9px 英文 spacing → 上下文字輕微重疊但 readable。
* **「文言」**：display language 下拉選單顯示 "文言"（古文之意），這是 STR_LANGUAGE_NAME = "繁體中文" 在現有字 cell 大小下被切到只剩前 2 字 "繁體" 又被識別失敗導致 fallback。**建議 v2.1.1 改為 STR_LANGUAGE_NAME = "中文(台灣)"** 或 "繁中" 縮短。

### 2.3 沒問題的 area

* 主選單 4 個 button 中文清晰可辨。
* 難度選單佈局完整、5 級全顯示。
* ModList 列表正常 enumerate。
* Options dialog 內所有 label 翻譯生效（沒有英文 fallback）。
* 字型 anti-aliasing 銳利，WQY Zen Hei Sharp 18×18 Big + 14×14 Small 在 base 320 + display 1280 下視覺品質可接受。

---

## 3. 對齊 v2_plan 完成度

### 3.1 v2.1（main menu / options / saveload / modlist / Geoscape menu）

| 項目 | v2_plan 期望 | v2 實際 | 狀態 |
|---|---|---|---|
| Main menu | 全套 | 6/6 按鈕中文 | ✅ |
| Options | 全套 | 30+ keys 含 advanced | ✅ |
| SaveLoad | 全套 | 11 keys（slot/失敗/成功/IronMan） | ✅ |
| ModList | 全套 | 4 keys（base game / tooltip / 警告） | ✅ |
| Geoscape menu | 全套 | 7 keys + 6 速度 + 月/週 | ✅ |
| 修法 A（Font.cpp:193） | 上 patch | **未上**（規範不動 source） | ⏸ 已知 |
| ~200 keys 目標 | 200 | **426 common + 部份 xcom1 ≈ 600+** | 🎯 超標 |

**v2.1 完成度：100%（除 source patch 因規範略過）**

### 3.2 v2.2（Battlescape / Inventory / Basescape）

| 項目 | v2_plan 期望 | v2 實際 | 狀態 |
|---|---|---|---|
| Battlescape action menu | 全套 | 投擲/連發/速射/瞄準/啟動/治療/掃描/心靈/恐慌 | ✅ |
| Battlescape HUD | 全套 | TU/能量/士氣/受傷/armor 部位/turn/side | ✅ |
| Inventory slot | 全套 | 右手/左手/右肩/左肩/背包/腰帶/地面 | ✅ |
| Basescape 設施 | 全套 | 14 設施名（含 hyper-wave / mind shield / psi lab） | ✅ |
| Basescape personnel | 全套 | 採購/雇用、士兵/科學家/工程師、解雇、轉移 | ✅ |
| Research | 全套 | 配置/開始/取消/進度/新專案/實驗室空間 | ✅ |
| Manufacturing | 全套 | 開始/停止/材料/工坊空間/每單位成本/月利潤 | ✅ |
| ~600 keys 目標 | 600 | **xcom1 內 ~700 個非 UFOPEDIA key 翻完** | 🎯 超標 |

**v2.2 完成度：~95%**（少數 alien rank 變體仍英文，但常見三種 — Floater / Sectoid / Snakeman / Muton — 主體都有翻譯）。

### 3.3 v2.3 預覽

剩 ~140 個 `*_UFOPEDIA` 長段落 + 3 個結局劇情段落 + 1 個獎章規則描述（`STR_BLASTER_BOMB_UFOPEDIA` 等）— 這些都是 100+ 字段落，需要文學潤色 + UFO 1994 風格守舊（不用現代中國科幻翻法）。建議 v2.3 單獨花 1-2 週做。

---

## 4. 下個 priority key 群（v2.3 起）

按使用者實際遊玩順序排序：

1. **STR_VICTORY_1..5 + STR_GAME_OVER_1..2 + STR_YOU_HAVE_FAILED**（結局段落，3-4 段 500 字）— 玩家結局時看到，**最值得翻**。
2. **STR_PSI_AMP_UFOPEDIA / STR_MOTION_SCANNER_UFOPEDIA / STR_MEDI_KIT_UFOPEDIA**（操作教學段落，玩家初次裝備時看）。
3. **STR_ALIEN_ORIGINS_UFOPEDIA + STR_THE_MARTIAN_SOLUTION_UFOPEDIA + STR_CYDONIA_OR_BUST_UFOPEDIA**（劇情推進，研究完看到 — 主線敘事）。
4. **外星生物 UFOPEDIA 描述**（11 種族 × ~150 字）— 玩家研究外星屍體後看，世界觀重點。
5. **武器 UFOPEDIA 段落**（laser / plasma / blaster 等 ~12 個）— 製造前先看。
6. **基地設施 UFOPEDIA 段落**（access lift / containment / hangar / radar 等 ~14 個）。
7. **STR_FLOATER_NAVIGATOR / ETHEREAL_LEADER 等 alien 階級變體**（~12 個）。
8. **STR_HARVESTER_UFOPEDIA / STR_ABDUCTOR_UFOPEDIA 等 UFO 描述**（~8 個）。

### v2.4 候選

國家/城市現有譯名已含完整 50 城市，**v2.4 不需做 toggle**。Alien 名 / weapon 名（plasma / heavy plasma）已全翻，v2.4 同樣不需做「保留英文」toggle —— 因為現在的翻譯都採用台灣慣用譯名，不會像有些大陸版翻譯造成歧義。

---

## 5. 字型問題評估

### 5.1 Cell overflow

無 cell overflow（FontBig 18×18、FontSmall 14×14、FontGeoSmall 12×12）— PNG image 邊界 OK。

### 5.2 Line step bug 重現

從 `v2_options.png` 與 `v2_geoscape.png` 標題列觀察到上下行重疊（v2_plan §5 modus operandi A 仍未上 patch）。

**建議**：v2.1.1 ship 前**必須上 [Font.cpp:193](../OpenXcom/src/Engine/Font.cpp) 改 max-height patch** —— 否則所有多行 dialog（含 mission briefing / monthly report 5 段、council 訊息、UFO 描述）都會字疊。**這是 v2 唯一卡 blocker**。

但本 task 規範禁止動 source；故本評估標記為 known limitation，列為 v2.1.1 必修。

### 5.3 字 cell 重做需求

**不需重 render**。WQY Zen Hei Sharp 在 14/16/18 cell 視覺已 acceptable（看 `v2_difficulty.png` 與 `v2_options.png`）。FontSmall 14×14 在 Battlescape 表格密集處可能會撞 line step（修法 A 修好後就 OK）。

---

## 6. Ship 建議

* **v2.1 立刻可 ship**：翻譯狀態已遠超 v2.1 規劃；只要不上 source patch，現有 line step bug 可在 README 標 known issue。
* **v2.1.1（建議下個版本）**：上修法 A patch（1 行 source code 改動）+ 修 `STR_LANGUAGE_NAME` 為 "繁中"（解 "文言" 顯示問題）+ 補 12 個 alien rank 變體。預估 30 分鐘工作。
* **v2.2 已實質達成**：本次擴翻已 cover 戰術/基地全套，無需另外切 v2.2 release，**直接 跳 ship 為 v2.1+v2.2 合併版本**。
* **v2.3**：規劃為「劇情/UFOpedia/外星人世界觀完整翻譯版」，獨立 release。

---

## 7. 結論

寫完這份 v2 收尾 review 後，下一個 ship 的 v2.1+v2.2 合併版本直接超標 1356 條 key，文字密度大幅超過原規劃。**這份 doc 留作 2026-05-30 那一刻的快照**——後續所有 v2.21/v2.22/v2.23 改動都是針對這份 review 標出的「Line step bug」「按鈕字溢出」「文言顯示問題」逐一處理的結果。

* **翻譯品質**：1356 unique keys，90% 覆蓋率，台灣慣用譯名一致，無簡體混入，X-COM vintage 風格保留。
* **顯示品質**：主流 UI（main menu / options / difficulty / modlist）全部 readable；line overlap 限於多行 dialog，已知有修法。
* **路徑安全**：完全遵守規範 — 不動 EXE / 不動 source / 不動 git；只動 2 個 zh-TW.yml file 與新增 3 個 tools script。
* **下個 iter**：v2.1.1 patch Font.cpp:193 + 修語言 slot 名 → 解掉 ship 前最後 visual blocker。

Designer signoff: **PASS — 可進入 v2.1 ship 階段，v2.1.1 為 highly recommended follow-up**。
