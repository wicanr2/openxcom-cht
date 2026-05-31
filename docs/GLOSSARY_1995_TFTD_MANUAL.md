# 1995 第三波官方中文手冊 譯名對照表（TFTD / 深海出擊）

> 來源：`docs/DDSC-J-00121-遊戲手冊：幽浮２－深海出擊.pdf`
> 出版：第三波文化事業股份有限公司（台灣，1995 / 民國 84 年）
> 編譯：維京工作室
> 原著：MicroProse, _X-COM: Terror from the Deep_ (1995)
> 數位化：DDSC (Documents Digitize Service Center), 2009-02-28
> PDF 頁數：53 頁；pdftotext 萃取 470 行

本文件比對 **1995 年第三波官方中文手冊** 與 **本專案現行 `bin/standard/xcom2/Language/zh-TW.yml`** 的譯名差異，
作為 TFTD 翻譯一致性與歷史參考的依據。配套文件：`GLOSSARY_1994_MANUAL.md`（UFO Defense 一代）。

---

## 一、版權與引用說明

1995 中文手冊版權屬第三波 / MicroProse 所有，本 PDF 經 DDSC 於 2009 年數位化、
標示為「非商業流傳或私人資料用」。本專案僅在 `docs/` 收錄 **作為翻譯參考文獻**，
不對手冊內容做任何修改、不主張任何衍生權利。

> 「本文件版權屬原輸出公司、出版社、圖書公司或原著作人所有，作商業用途者請自行洽上述公司，
> 本文件僅可在非商業上流傳或供私人收集資料用。」
> — DDSC 文件版權宣告

---

## 二、翻譯策略

對照後採四種處理：

| 標籤 | 含義 |
|---|---|
| **沿用 1995** | 1995 譯名與本專案一致，繼續維持 |
| **歷史參考** | 1995 譯名屬時代用語，本專案採現代或社群慣例譯法，但於 UFOPEDIA 描述中可酌情引用 |
| **建議改回** | 1995 譯名更貼合遊戲機制 / 更精準，後續版本可考慮回歸 |
| **修正錯譯** | 1995 譯名為誤譯或音譯失誤，本專案採正確譯名（多半同 1994 校正規則）|

> **TFTD 手冊先天限制**：1995 手冊結構複製 1994 版（仍是「英文速查表」），
> 詞表 90% 與一代重疊，僅補充 **7 個 TFTD-only 物種名** + **2 個載具/物質**，
> 對 TFTD 大量新增的武器、設施、任務、海軍題材幾乎沒著墨。
> 因此本對照表的「TFTD 獨家詞條」遠少於 1994 對照表。

---

## 三、核心譯名對照

### 3.1 TFTD 獨家：外星種族 / Aliens（最重要的部分）

| 英文 | 1995 第三波 | 本專案 zh-TW | 結論 |
|---|---|---|---|
| AQUATOID | **水族人** | 水生人 | **歷史差異** — 1995「水族人」更貼近 humanoid 構詞（-OID）；現行「水生人」較口語但失去「類人型生物」語感。可考慮 v2.18+ 改回 |
| GILL MAN | **鰓型人** | 魚鰓人 | **歷史差異** — 1995「鰓型人」直譯 GILL+MAN，「魚鰓人」加上「魚」字較生動；兩者皆通 |
| LOBSTERMAN | **龍蝦人** | 龍蝦人 | **沿用 1995** |
| TENTACULAT | **觸鬚人** | 觸手怪 | **歷史參考** — 1995「觸鬚人」保留 -ULAT 觸鬚感且更貼近原文洛夫克拉夫特氛圍；現行「觸手怪」較直白但失去恐怖意境。可考慮 v2.18+ 改回 |
| CALCINITE | **石灰人** | 鈣化體 | **歷史差異** — CALCIN- 字根本義是「鈣化／焚化」；1995「石灰人」生動但化學不正確（石灰=CaO，鈣化=Ca 沉積）；現行「鈣化體」科學精準。維持現行 |
| DEEP ONE | **深海一號** | 深淵者 | **修正錯譯** — 1995「深海一號」是 **誤譯**（把「深淵之子」誤讀為編號「Deep One」=深海#1）；正確語源是洛夫克拉夫特小說《Dagon》/《The Shadow over Innsmouth》的「深潛者 / 深淵者」族群。**現行「深淵者」更正確** |
| TASOTH | （未列） | 塔索斯 | — |
| BIODRONE / BIO-DRONE | （未列） | 生物無人機 | — |
| TRISCENE | （未列） | 三角龍 | — |
| HALLUCINOID | （未列） | 幻象生物 | — |
| XARQUID | （未列） | 薩奎 | — |

> **特別注意**：DEEP ONE 是 1995 手冊最具代表性的錯譯，**勿據此回退**。
> 編譯者「維京工作室」可能不熟洛夫克拉夫特典故，將其音/形錯解為「Deep One = 深海的第一艘 / 深海一號」。

### 3.2 TFTD 獨家：載具 / Craft

| 英文 | 1995 第三波 | 本專案 zh-TW | 結論 |
|---|---|---|---|
| TRITON | **海神號運兵機** | 海神號 | **沿用 1995（簡化）** — 1995 帶「運兵機」後綴明示用途，現行省略；可考慮 UFOPEDIA 描述補回「運兵機」 |
| BARRACUDA | **梭魚號攔截機** | 梭魚號 | **沿用 1995（簡化）** — 同上 |
| MANTA | （未列） | 曼塔號 | — |
| HAMMERHEAD | （未列） | 槌鯊號 | — |
| LEVIATHAN | （未列） | 巨鯨號 | — |
| HWP / SWS | **重裝武器載具** / **坦克(SWS)** | HWP / SWS | 維持英文縮寫，UFOPEDIA 描述補充「重裝武器載具」 |

### 3.3 TFTD 獨家：物質 / Materials

| 英文 | 1995 第三波 | 本專案 zh-TW | 結論 |
|---|---|---|---|
| ZRBITE | **外星化學物品** | Z元素 | **歷史參考** — 1995 用「外星化學物品」純描述功能（迴避音譯難題）；現行「Z元素」對應一代「元素 115」的命名邏輯。建議維持現行 |
| AQUA PLASTICS | （未列） | 水中塑膠 | — |
| ALIEN SUB CONSTRUCTION | （未列） | 外星潛艇結構 | — |
| ELERIUM | **稀有元素** | 元素 115 | （延續 1994 規則）|
| ARTEFACTS | 加工物、合成品 | 加工物 | **沿用 1995** |

### 3.4 武器 / Weapons（TFTD 新增系列）

> 1995 手冊僅零星出現詞素（如 GAUSS=高斯、SONIC=音速、TORPEDO=魚雷），未列完整武器名。
> 本表為 zh-TW.yml 現行譯名 + 對應 1995 手冊詞素的綜合對照。

| 英文 | 1995 第三波 | 本專案 zh-TW | 結論 |
|---|---|---|---|
| GAUSS（詞素）| **高斯** | 高斯 | **沿用 1995** |
| GAUSS PISTOL / RIFLE / CANNON | （未列）| 高斯手槍 / 高斯步槍 / 高斯加農 | 延續 1995 詞素 |
| SONIC（詞素）| **音速** | 聲波 | **修正用語** — 1995「音速」誤把 SONIC（聲學）當 supersonic（音速）；現行「聲波」是物理學正確用法 |
| SONIC PISTOL / CANNON / OSCILLATOR | （未列）| 聲波手槍 / 聲波加農 / 聲波振盪器 | 維持現行 |
| TORPEDO | **魚雷** | 魚雷 | **沿用 1995** |
| THERMAL TAZER | （未列）| 冷凍電擊棒 | **建議檢討** — THERMAL=熱、TAZER=電擊器，原文意義是「熱能電擊棒」（破解低溫水中防禦）；「冷凍電擊棒」似乎方向相反。本譯應為承襲自社群錯譯，待 v2.18+ 確認 |
| THERMIC LANCE | （未列）| 熱熔長矛 | **沿用社群慣例** |
| HEAVY THERMIC LANCE | （未列）| 重型熱熔長矛 | **沿用** |
| JET HARPOON | （未列）| 噴射魚叉 | **沿用** |
| HYDRO-JET CANNON | （未列）| 水噴流加農 | **沿用** |
| GAS CANNON | （未列）| 瓦斯加農 | **歷史延續** — GAS=瓦斯（1995 「GAS=瓦斯」沿用），但現代物理學更傾向「氣體加農」；維持現行 |
| DYE GRENADE | （未列）| 染料煙幕彈 | **沿用** |
| PARTICLE DISTURBANCE GRENADE | （未列）| 粒子擾動感應雷 | **沿用** |
| VIBRO BLADE | （未列）| 震動刃 | **沿用** |
| DRILL / DISRUPTOR PULSE LAUNCHER | （未列）| 干擾脈衝發射器 | **沿用** |
| PWT CANNON | （未列）| 脈波魚雷加農 | **沿用** |
| AJAX TORPEDOES | （未列）| 阿賈克斯魚雷 | **沿用** |

### 3.5 基地設施 / Base Facilities

| 英文 | 1995 第三波 | 本專案 zh-TW | 結論 |
|---|---|---|---|
| PEN | **潛艇修理塢** | （需查驗 STR_ALIEN_SUB_PEN） | **建議沿用 1995** — 「潛艇修理塢」是 1995 對 sub PEN 的精準翻譯（"penitentiary 潛艇修理塢"），比直譯「潛艇圍欄」好 |
| M.C. LAB | （未列；M.C.=Molecular Control）| M.C. 實驗室 | **沿用現行** |
| M.C. READER | （未列）| M.C. 讀取器 | **沿用** |
| M.C. DISRUPTOR | （未列）| M.C. 干擾器 | **沿用** |
| SONAR | **聲納** | （未對應到設施 key，但詞素用此）| **沿用 1995** |
| SONIC DETECTOR | （未列）| （查驗中，可能 STR_SONIC_DETECTOR）| 建議「聲波偵測器」 |
| TRANSMISSION RESOLVER | （未列）| 傳輸解析器 | **沿用** |
| MAGNETIC NAVIGATION | （未列）| 磁力導航 | **沿用** |
| ION BEAM ACCELERATORS | （未列）| 離子束加速器 | **沿用** |
| LABORATORIES | **實驗室** | 實驗室 | **沿用 1995** |
| GENERAL STORES | **一般用途**（儲藏）| 一般倉庫 | 現行更精準 |
| LIVING QUARTERS | **居住**（空間）| 宿舍 | 現行更精準 |
| WORKSHOP | **工作室、工廠** | 工作室 | **沿用 1995** |
| HANGARS | **停機棚** | 機庫 | **歷史參考** |

### 3.6 戰士 / Soldiers

| 英文 | 1995 第三波 | 本專案 zh-TW | 結論 |
|---|---|---|---|
| AQUANAUTS | **水兵** | 水兵 | **沿用 1995** ✓ 完全一致 |
| SEAMAN | **海軍士兵** / **海員** | （需查驗）| — |
| SQUADDIE | **班兵** | 水兵 | TFTD 階級在 zh-TW.yml 統一作「水兵」（SQUADDIE→水兵），有別於 1994 風格 |
| ROOKIE | **新兵、見習生、菜鳥** | 新兵 | **沿用 1995** |
| SERGENT(sic.) | **士官** | （TFTD 階級鏈見 yml）| — |
| CAPTAIN | **尉官** | — | — |
| COLONEL | **校官** | — | — |
| COMMANDER | **指揮官** | 指揮官 | **沿用 1995** |

### 3.7 任務 / Missions

> 1995 手冊**完全未列**任務名稱（PORT ATTACK、CARGO SHIP、CRUISE LINER、ALIEN COLONY 等），
> 此區域全部沿用社群慣例或現行 zh-TW.yml。

| 英文 | 1995 第三波 | 本專案 zh-TW | 結論 |
|---|---|---|---|
| PORT TERROR / PORT ATTACK | （未列）| 外星人攻擊港口 | **沿用** |
| CARGO SHIP MISSION | （未列）| 貨輪第一/第二部分 | **沿用** |
| CRUISE LINER | （未列）| （查驗中）| — |
| CULT OF SIRIUS | （未列）| （查驗中，可能未翻譯或保留）| 建議「天狼星教派」/「天狼星邪教」 |
| ALIEN COLONY | （未列）| 外星殖民地 | **沿用** |
| ARTEFACT SITE | **加工物**（詞素）| （查驗中）| 建議「外星加工物地點」 |
| TERROR SITE | （未列）| 恐怖地點 | **沿用** |

---

## 四、值得追加的 1995 風味

下列譯名 **1995 手冊獨有**，雖未列入本專案，但可作為 UFOPEDIA 描述的潤色參考或回退選項：

- **「水族人」**（AQUATOID）— 比「水生人」更接近 -OID humanoid 構詞語感；**v2.18+ 候選**
- **「觸鬚人」**（TENTACULAT）— 比「觸手怪」更貼近洛夫克拉夫特恐怖氛圍；**v2.18+ 候選**
- **「鰓型人」**（GILL MAN）— 比「魚鰓人」更直譯，無多餘修飾；歷史參考
- **「潛艇修理塢」**（ALIEN SUB PEN）— 精準翻譯 penitentiary→sub PEN 的雙關，建議查驗 STR_ALIEN_SUB_PEN 是否需要套用此譯
- **「運兵機」/「攔截機」後綴**（TRITON / BARRACUDA）— UFOPEDIA 描述可保留功能說明
- **「外星化學物品」**（ZRBITE）— 描述式翻譯避免音譯困難，可作為 UFOPEDIA 描述語

---

## 五、值得警惕的 1995 錯譯（**不要回退**）

- **「深海一號」**（DEEP ONE）— **誤譯**：DEEP ONE 是洛夫克拉夫特「深淵之子 / 深潛者」族群，非「深海#1」。**現行「深淵者」正確，勿改回**
- **「音速」**（SONIC）— **誤譯**：SONIC=聲學的；音速=supersonic。**現行「聲波」正確，勿改回**
- **「石灰人」**（CALCINITE）— **化學不精準**：CALCIN- 是「鈣化」非「石灰（CaO）」。**現行「鈣化體」科學正確，勿改回**
- **「黃貂魚式飛彈」**（STINGREY，sic.）— 同 1994：STINGRAY 譯名正確，1994 對照表已建議改回（v2.18+ 候選）；TFTD 不涉及

---

## 六、1995 手冊的限制

- 手冊為 **英文速查表結構**（同 1994），不含完整翻譯，畫面字串、UFOPEDIA 描述等仍是英文原版
- 1995 手冊 ~90% 詞表 **複製自 1994 手冊**，僅補：
  - 7 個 TFTD-only 物種詞素（AQUATOID / GILL MAN / LOBSTERMAN / TENTACULAT / CALCINITE / DEEP ONE / TRITON / ZRBITE）
  - 海事相關詞（AQUANAUTS=水兵、SEAMAN=海員、SUB=水面下的、SUBMARINE=潛艇、TORPEDO=魚雷、SONAR=聲納、PEN=潛艇修理塢）
  - 部分 TFTD 武器詞素（GAUSS=高斯、SONIC=音速[sic.]、PULSER=波動）
- **完全未涵蓋**的範圍：
  - TFTD 全部 **任務名**（PORT ATTACK、CARGO SHIP、CRUISE LINER、CULT OF SIRIUS、ARTEFACT SITE 等）
  - TFTD 全部 **武器完整名**（SONIC PISTOL、THERMIC LANCE、JET HARPOON、DISRUPTOR PULSE LAUNCHER 等）
  - TFTD 全部 **設施詳名**（M.C. LAB / READER / DISRUPTOR、TRANSMISSION RESOLVER 等）
  - 5 個 TFTD 物種（TASOTH / BIO-DRONE / TRISCENE / HALLUCINOID / XARQUID）
  - UFOPEDIA 全文、任務 briefings、cutscenes
- 含 OCR / 排版錯字（多為 1994 已有的錯字延續）：STINGREY→STINGRAY、SERGENT→SERGEANT、PANICK→PANIC、UNCONCIOUS→UNCONSCIOUS、BAZIL→BRAZIL、EIRASIA→EURASIA、SCANDINARIA→SCANDINAVIA、NGERIA→NIGERIA、SUBMARISIBLE→SUBMERSIBLE、SUBMAZRRSIBLE→SUBMERSIBLE、PARTIFIC→PARTICLE、AVERAAGE→AVERAGE、CRAAFT→CRAFT、SHOK→SHOT/SHOCK、HGH→HIGH、UNON→UNION、LABORATORS→LABORATORIES、KLLED→KILLED、HRE→HIRE、LOADED「己」（誤打成「己」非「已」）

---

## 七、後續工作

- [ ] v2.18+ 評估 AQUATOID 水生人 → **水族人**（1995 官方，-OID 構詞）
- [ ] v2.18+ 評估 TENTACULAT 觸手怪 → **觸鬚人**（1995 官方，洛夫克拉夫特氛圍）
- [ ] v2.18+ 評估 GILL MAN 魚鰓人 → **鰓型人**（1995 官方，較直譯）— 低優先
- [ ] v2.18+ 查驗 STR_ALIEN_SUB_PEN，若未譯則套用 1995「潛艇修理塢」
- [ ] v2.18+ 查驗 STR_THERMAL_TAZER「冷凍電擊棒」是否誤譯（THERMAL=熱，方向疑似相反）
- [ ] v2.18+ 查驗 STR_CULT_OF_SIRIUS、STR_ARTEFACT_SITE 等 1995 未列的任務名
- [ ] **明確標記**：DEEP ONE 不可回退（深海一號=誤譯）、SONIC 不可回退（音速=誤譯）
- [ ] 評估 TRITON/BARRACUDA UFOPEDIA 描述加入「運兵機/攔截機」後綴
- [ ] 為手冊缺漏的譯名（任務、設施詳名、5 個物種、UFOPEDIA 全文）持續維護 **本專案自有 glossary**

---

## 八、原始文本

完整 pdftotext 萃取結果見 `docs/manual_1995_raw.txt`（470 行，53 頁 A4），
原始 PDF 見 `docs/DDSC-J-00121-遊戲手冊：幽浮２－深海出擊.pdf`。

配套參考：`docs/GLOSSARY_1994_MANUAL.md`（一代 / UFO Defense）。
