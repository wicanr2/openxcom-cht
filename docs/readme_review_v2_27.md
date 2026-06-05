# README v2.27 一致性 Audit + 修改紀錄

> 對 `D:\openxcom\openxcom-cht\README.md`（1232 行、17 章 + TFTD 8 子目錄）做全文 review，輸出問題清單 + in-place 修改。
> Audit 日期：2026-06-06。對應 v2.27 voice/transition pass。

---

## 1. 全文結構速覽

| 區段 | 行號 | Voice |
|---|---|---|
| TOC | 13-39 | 中性 |
| Hero「致老幽浮迷的一封信」| 43-81 | **第一人稱「我」**（user 親自定稿，不動）|
| Quick Start | 84-131 | 中性「你」 |
| 為何要漢化（why） | 134-149 | 編輯人聲（中性偏溫情）|
| X-COM 戰史 | 152-178 | **冷靜列點**（待升級為雜誌風）|
| 戰役流程 | 181-228 | 冷靜列點 + ASCII 流程圖 |
| 兵種軍階 | 231-259 | **冷靜列表**（待升級）|
| 武器階層 | 262-309 | **冷靜列表**（待升級）|
| 外星人圖鑑 | 312-342 | **冷靜列表**（待升級）|
| 世界地理 | 345-376 | **冷靜列表**（待升級）|
| v2.21+v2.22 widget clip | 378-413 | 工程文 |
| v2.22 mod 列表中文化 | 417-445 | 工程文 |
| TFTD overview（v2.20）| 448-515 | 編輯人聲（partial）|
| TFTD origin | 517-549 | **TFTD v2 雜誌風**（已定稿，不動）|
| TFTD species | 552-602 | **TFTD v2 雜誌風**（已定稿，不動）|
| TFTD weapons | 604-680 | **TFTD v2 雜誌風**（已定稿，不動）|
| TFTD craft | 683-711 | **TFTD v2 雜誌風**（已定稿，不動）|
| TFTD tech tree | 713-772 | **TFTD v2 雜誌風**（已定稿，不動）|
| TFTD battles | 774-812 | **TFTD v2 雜誌風**（已定稿，不動）|
| TFTD vs UFO | 814-844 | **TFTD v2 雜誌風**（已定稿，不動）|
| TFTD 1995 manual | 847-908 | **TFTD v2 雜誌風**（已定稿，不動）|
| `---` `---` 雙分隔（孤兒）| 910-911 | bug |
| 士兵名 CJK | 913-962 | 列表 |
| 截圖 | 965-1003 | 列表 |
| 1994 先行者 | 1005-1045 | 編輯人聲（短）|
| Technical Deep Dive | 1048-1151 | 工程文 |
| Upstream | 1154-1172 | 工程文 |
| License & Credits | 1175-1232 | 工程文 |

---

## 2. Issue 清單（依類別）

### Issue A. Voice / register 不一致（high）

| # | 行號 | 問題 | 嚴重度 | 修法 |
|---|---|---|---|---|
| A1 | 152-178 | X-COM 戰史四紀全用「1994 / 1995 / 1997」列點 + 表格，沒有 1990s 編輯人聲，跟 TFTD origin 對照顯得乾 | high | 加 1-2 段 prose（第三波那個時代台灣怎麼看 X-COM 系列 + Apocalypse 為何沒人記得）|
| A2 | 231-259 | 兵種軍階只有表格 + 一條注解，沒交代「下士 / 中士」這套軍階體系在 1990s 中華軍制下的玩家共同記憶 | high | 加 1 段 prose（玩家第一次看到「指揮官」軍階的故事 + 1994 譯本選擇兵 vs 中士的折衷）|
| A3 | 262-309 | 武器階層三代純列表，沒有「來福槍時期那個月」「電漿步槍解鎖那一瞬間」的玩家記憶 | high | 加 1-2 段 prose（第一代來福、第二代雷射、第三代電漿的玩家節奏 + STINGRAY 黃貂魚那個典故）|
| A4 | 312-342 | 外星人圖鑑七大種族純列表，沒有 1994 玩家碰到 SECTOID / CHRYSSALID 的恐懼記憶 | high | 加 1-2 段 prose（蟹形蟲 + 巨型怪夢魘 + 1994 時代 BBS 討論氛圍）|
| A5 | 345-376 | 世界地理五大洲純列表 + 基地選址列點，沒有 1994 玩家畫地圖選基地的記憶 | high | 加 1-2 段 prose（基地選址玩家儀式感、北極/南極策略地位）|

### Issue B. Transition 突兀（high）

| # | 行號 | 問題 | 嚴重度 | 修法 |
|---|---|---|---|---|
| B1 | 39 → 43 | TOC 結束 `---` 直接接 Hero `🛸 OpenXcom 繁中版`，缺橋接 | low | 不動（TOC 後 Hero 是合理跳轉，user 定稿 Hero 開頭已自含 voice 設定）|
| B2 | 82 → 84 | Hero 結尾「能玩」「30 年後給每一位老幽浮迷的回信」「現在你可以用母語再玩一次了」之後直接接 Quick Start 表格 — **落差太大** | high | 加 1 句橋接（「下面是怎麼玩到」短語）|
| B3 | 132 → 134 | Quick Start 方式 B 結束 → `## 為何要漢化` 是合理跳轉，但缺一句承接 | med | Why 章節開頭加半句承上啟下（不只是「能玩」更是「為什麼」）|
| B4 | 148-149 → 152 | Why 結尾引言 → X-COM 戰史，硬切 | med | 加 1 句橋接（「先把時間線拉開」之類）|
| B5 | 909-913 | TFTD 1995 manual 結尾 → 孤兒 `---` `---` → 士兵名章節，雙分隔符是 bug | high | 改成 1 個 `---` + 1 句橋接（從 TFTD 翻譯議題接到士兵名譯名）|
| B6 | 962 → 965 | 士兵名章節結尾 `詳見 docs/...` → 直接接 `## 實機截圖`，硬切 | low | 截圖章節開頭加 1 句（「文字校對講完了，剩下用眼睛驗證」）|

### Issue C. 重複內容（med）

| # | 行號 | 問題 | 嚴重度 | 修法 |
|---|---|---|---|---|
| C1 | 74 + 913-962 | 「34 國 CJK 全音譯 v2.22」在 ship statistics 表 + 士兵名章節各講一次 | low | 保留兩處 — 一處 stats、一處 detail，不重複（OK）|
| C2 | 491 + 884-892 | 「5 條譯名警告」在 TFTD species (577-583) + 1995 manual (884-892) 各列一次 | med | TFTD species 處用清單（戰術重點），1995 manual 處保留完整表 + 文獻依據 — **保留兩處**，但加 cross-ref |
| C3 | 491 + 866-880 | 「1995 第三波手冊」在 TFTD overview (484-491) + 1995 manual 章節 (847+) 重複介紹 | low | TFTD overview 那段已是 summary，1995 manual 章節是 full doc，互補不算冗餘 |
| C4 | 4 + 73 + 74 | Hero badge / ship stats 兩處列「2 700+ keys」「common 102% / xcom1 102% / xcom2 84%」等同類數字 | low | 不動（Hero badge 是 hook、stats 表是 detail）|
| C5 | 866-880 (1995 妙譯) + 1024 (1994 通用譯名) | 1995 / 1994 妙譯各一表，但 SKYRANGER 出現在 TFTD craft (688 提) + 1994 對照表 (1034) | low | 保留 — 各章節獨立語境 |

### Issue D. TOC vs 實際章節 sync（med）

| # | TOC 條目 | 行號 | 實際 | 修法 |
|---|---|---|---|---|
| D1 | 「10. 🌊 深海戰場 — TFTD 二代漢化」 | 24 | line 448 `<a name="tftd">` ✓ | OK |
| D2 | 「11. TFTD 深度知識庫 8 子目錄」 | 25-33 | line 517-908 ✓ 全在 | OK |
| D3 | 「12. 士兵名稱 CJK 化」 | 34 | line 913 `<a name="soldiers">` ✓ | OK |
| D4 | **TOC 缺**「Widget 字身切底修復 v2.21+v2.22」 | — | line 378-413 實有此章 | **add to TOC** |
| D5 | **TOC 缺**「Mod 列表中文化 v2.22」 | — | line 417-445 實有此章 | **add to TOC** |
| D6 | 「17. License & Credits」 | 39 | line 1175 ✓ | OK |
| D7 | TOC item 11 sub-title 用「📚 1995 第三波手冊：那個年代的奧義」| 33 | line 847 實標題對 | OK |

→ TOC 需要新增 2 個章節（widget clip / mod 列表中文化），總章節從 17 變 19；補入 between item 9 和 10。

### Issue E. 節奏 / 視覺斷裂（low-med）

| # | 行號 | 問題 | 嚴重度 | 修法 |
|---|---|---|---|---|
| E1 | 910-911 | 雙重 `---` `---` 孤兒分隔符 | high | 砍掉一個 |
| E2 | 4 | Hero subtitle 一行塞「雙作 2700+ 翻譯鍵 ✦ WQY Sharp 12px 點陣字型 ✦ 17 個 source patch ✦ 1994/1995...」連 4 個 ✦ 分隔，過密 | low | 不動（user 親自定稿 Hero subtitle 區塊）|
| E3 | 414-415 | widget clip 章節結尾 `完整 audit 推導見 [docs/...]` 之後 `---` 接下一章節，缺收尾 | low | 不動（工程章節合理） |
| E4 | 1042-1044 | 1994 pioneers 章節「匿名 PDF 掃描者」段落只有兩句，節奏短 | low | 不動 |
| E5 | 1226 | 文末「PR / issue welcome — 特別是 v2.4 TFTD 長 narrative 補翻...」過期（v2.4 已過，現 v2.22）| med | 改成「v2.27 後續方向」|

---

## 3. 修改執行清單

按執行順序：

- [x] 0. 寫 audit doc（本檔）
- [x] 1. TOC 同步：插入 widget clip + mod 列表 兩條
- [x] 2. Hero → Upstream/Quick Start 橋接：加 1 句承接（B2）
- [x] 3. Quick Start → Why 橋接（B3）
- [x] 4. Why → X-COM 戰史 橋接（B4）
- [x] 5. **A1：X-COM 戰史**升級為雜誌風（加 prose）
- [x] 6. **A2：兵種軍階**升級為雜誌風
- [x] 7. **A3：武器階層**升級為雜誌風
- [x] 8. **A4：外星人圖鑑**升級為雜誌風
- [x] 9. **A5：世界地理**升級為雜誌風
- [x] 10. B5 孤兒 `---` 砍掉 + 加橋接（TFTD manual → 士兵名）
- [x] 11. B6 士兵名 → 截圖橋接
- [x] 12. E5 文末 PR welcome 改寫
- [x] 13. C2 5 條警告 cross-ref（TFTD species 處保留簡列、加 1 句指向 1995 manual 章節）

---

## 4. 升級 prose 風格 reference（取自 TFTD v2 章節）

從 TFTD species（line 557 起）萃取的 prose 風格特徵，用來指導 5 章升級：

1. **編輯人聲 first-person plural / 偶用「我那時候」**：「1995 年我當時在這關卡了 30 個小時」、「我們今天能做的不是批判」
2. **1990s 文化錨點**：BBS、《電腦玩家》、第三波手冊、光華商場、CRT 螢幕、14 吋螢幕
3. **具體場景而非概念**：「你第一次在水下任務開門撞見龍蝦人那一刻，你會記一輩子」
4. **編輯後記式自省**：「維京工作室 1995 年那批譯者並不是不努力——他們手上沒有...」
5. **單句感嘆收束**：「**這不是設定誇飾，是字面意思**」、「**1995 西方社群為這個設計吵了 20 年**」
6. **加粗點睛詞**：每段約 1-2 個 `**word**` 強調關鍵概念
7. **不毀表格**：表格保留作橫向對照，prose 插在表格前後（多為前）

---

## 5. 修改紀錄（執行中追記，後段補）

詳見 §6 各 issue 標記 ✓。

## 6. 完成狀態（2026-06-06 ship）

### Issue 統計
- **Voice 不一致 (A1-A5)**：5 個（high）— 全升級 ✓
- **Transition 突兀 (B2-B6)**：5 個（high/med/low）— 全補 prose 橋接 ✓（B1 不動，user 定稿 Hero）
- **重複內容 (C2)**：1 個處理（5 條警告加 cross-ref） ✓；C1/C3/C4/C5 視為合理冗餘不動
- **TOC sync (D4, D5)**：2 個（補入 widget-clip 與 mod-i18n） ✓；TOC 從 17 章 → 19 章
- **節奏 (E1, E5)**：2 個（孤兒 `---` 砍掉、文末 PR welcome 改寫） ✓

### 升級 prose 的 5 章
1. **X-COM 戰史**（line 158）：加 3 段 prose — 開頭框定譯名線、第一紀加 Apocalypse 為何沒人記得、第二紀加光華商場二手店記憶、第三紀加 SupSuper 致敬
2. **兵種軍階**（line 241）：加 2 段 prose — 開頭 COMMANDER 全球唯一/陣亡傳說、後段 1994 中華軍制 vs NATO 軍制的時代背景
3. **武器階層**（line 274）：加 3 段 prose — 開頭三代節奏 + 電漿步槍時刻、第一代手槍對 SECTOID + 火箭發射器誤射梗、STINGRAY 譯名公案
4. **外星人圖鑑**（line 328）：加 2 段 prose — 開頭七大種族的 1980s 西方科幻血統、CHRYSSALID 蟹形蟲心理陰影
5. **世界地理**（line 365）：加 2 段 prose — 開頭基地選址儀式感 + 玩家移民史投書、南極基地邊境前哨美學

### Transition 橋接句總數
- B2 Hero → Quick Start: 1 段（line 84-85）
- B3 Quick Start → Why: 1 句（line 140）
- B4 Why → X-COM 戰史: 1 段（line 161）
- B5 TFTD manual → 士兵名: 1 句 + 孤兒 `---` 移除（line 932-934）
- B6 士兵名 → 截圖: 1 句（line 988）

合計 **5 處 transition 補強** + **5 章升級 prose（共 12 段 narrative）**。

### TOC 同步
- 從 17 章 → 19 章（補入 #10 widget-clip + #11 mod-i18n）
- TFTD 8 子目錄行號從 25-33 → 28-35（內容不變）
- 後續 12-17 章編號往後位移 2（→ 14-19）
- 全部 26 個 `<a name="...">` anchor 與 TOC link 全對齊驗證通過
- `mod-i18n` 章節原本無 anchor，補上 `<a name="mod-i18n"></a>`

### 行數對照
- 修改前：1232 行
- 修改後：1253 行（+21 行 prose / transition 淨增）
- 5 章 prose 升級平均每章 +3-5 行；transition 5 處平均 +2 行；TOC 同步 +2 行；刪除孤兒 `---` -2 行

### 沒動的部分（按指令）
- ✓ Hero「致老幽浮迷的一封信」(line 43-83)
- ✓ TFTD 8 章 v2 雜誌風（line 540-934 主體）
- ✓ 全部 STR_ key
- ✓ 5 條譯名警告（深淵者/聲波/鈣化體/水族人/觸鬚人）
- ✓ ASCII 流程圖（戰役流程 + 科技樹）
- ✓ 全部 glossary 連結與技術 doc 連結
- ✓ 未 commit git
