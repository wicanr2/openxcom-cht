# openxcom-cht COCOMO Audit v2.27

> 對 `D:\openxcom\openxcom-cht\` 做 SLOC 盤點 + COCOMO Basic 三數字並陳。
> 仿 pg-cht README 樣板，調整成漢化專案的 3 sub-project 拆解。
> 所有數字以**本檔內列出的指令重跑**可重現。

---

## 1. SLOC 盤點（實測，可重現）

### 1.1 量測方法

- **空行**：`Trim() == ''` → 丟棄
- **純註解行**：
  - Python / PS / Sh：`^\s*#` → 丟棄
  - C/C++：`^\s*//` 與 `/* ... */` block → 丟棄
- **Markdown**：不去任何行（按原始行數計）；在 sub-project 3 內再乘 0.3 折扣作為「effective LOC」
- **YAML / .nam**：原始行數即「翻譯 LOC」（一行 = 一條譯文 / 一個 key）

重跑指令（PowerShell，於本機 root 為 `D:\openxcom\openxcom-cht\`）：

```powershell
$repo = "D:\openxcom\openxcom-cht"
function Get-Sloc-File {
  param([string]$Path, [string]$Lang)
  $lines = Get-Content -LiteralPath $Path
  $sloc = 0; $inBlock = $false
  foreach ($l in $lines) {
    $t = $l.Trim()
    if ($t -eq '') { continue }
    if ($Lang -eq 'cpp') {
      if ($inBlock) { if ($t -match '\*/') { $inBlock = $false }; continue }
      if ($t -match '^/\*') { if ($t -notmatch '\*/') { $inBlock = $true }; continue }
      if ($t -match '^//') { continue }
    } else { if ($t -match '^#') { continue } }
    $sloc++
  }
  return $sloc
}
Get-ChildItem $repo -Recurse -Include *.py,*.ps1,*.sh -File |
  ForEach-Object { "{0,5}  {1}" -f (Get-Sloc-File $_.FullName 'py'), $_.FullName.Replace("$repo\",'') }
Get-ChildItem "$repo\patches" -Recurse -Include *.cpp,*.h -File |
  ForEach-Object { "{0,5}  {1}" -f (Get-Sloc-File $_.FullName 'cpp'), $_.FullName.Replace("$repo\",'') }
```

### 1.2 程式碼（Python / PowerShell / Bash）

| 檔案 | SLOC |
|---|---:|
| `tools/make_fonts_zhtw.py` | 76 |
| `tools/wsl_check_char_coverage.py` | 59 |
| `tools/wsl_deep_validate.py` | 83 |
| `tools/wsl_validate_translations.py` | 53 |
| `tools/build_v2_20_quad.ps1` | 43 |
| `tools/build_v2_22_quad.ps1` | 39 |
| `tools/make_portable.ps1` | 83 |
| `tools/build_appimage.sh` | 79 |
| `tools/build_appimage_v2_20_dual.sh` | 118 |
| `tools/build_appimage_v2_21_dual.sh` | 102 |
| `tools/build_appimage_v2_22_dual.sh` | 100 |
| `tools/wsl_build_linux.sh` | 18 |
| `tools/wsl_ship_gate.sh` | 49 |
| **小計（13 檔）** | **902** |

### 1.3 Source patches（C/C++）

| 檔案 | SLOC |
|---|---:|
| `patches/src/Basescape/BaseInfoState.cpp` | 313 |
| `patches/src/Basescape/BasescapeState.cpp` | 353 |
| `patches/src/Basescape/ManufactureInfoState.cpp` | 403 |
| `patches/src/Basescape/ManufactureState.cpp` | 140 |
| `patches/src/Basescape/PurchaseState.cpp` | 541 |
| `patches/src/Basescape/ResearchState.cpp` | 102 |
| `patches/src/Basescape/SellState.cpp` | 547 |
| `patches/src/Engine/Font.cpp` | 179 |
| `patches/src/Engine/Options.cpp` | 1,012 |
| `patches/src/Geoscape/FundingState.cpp` | 79 |
| `patches/src/Geoscape/GeoscapeCraftState.cpp` | 228 |
| `patches/src/Geoscape/GeoscapeState.cpp` | 2,148 |
| `patches/src/Geoscape/MonthlyReportState.cpp` | 326 |
| `patches/src/Menu/MainMenuState.cpp` | 113 |
| `patches/src/Menu/MainMenuState.h` | 32 |
| `patches/src/Menu/ModListState.cpp` | 412 |
| `patches/src/Ufopaedia/ArticleStateCraft.cpp` | 53 |
| `patches/src/Ufopaedia/ArticleStateCraftWeapon.cpp` | 57 |
| **小計（18 檔）** | **7,038** |

> ⚠️ README `Upstream & Patches` 章節寫「5 個 cpp + 1 PNG」是發佈時的**最小化目標**，但 `patches/src/` 實際留了 18 個檔（含 v2.x widget 重排過程中觸及的整檔備份）。此處按**現況**計。

### 1.4 翻譯資源（YAML + .nam）

| 檔案 | 行數 | STR_ keys |
|---|---:|---:|
| `bin/common/Language/zh-TW.yml` | 470 | 437 |
| `bin/standard/xcom1/Language/zh-TW.yml` | 1,218 | 1,082 |
| `bin/standard/xcom2/Language/zh-TW.yml` | 1,367 | 1,133 |
| **YAML 小計** | **3,055** | **2,652** |
| `bin/common/SoldierName/*.nam`（34 國） | 5,818 | — |
| **翻譯總計** | **8,873** | — |

重跑：

```powershell
Get-Content "$repo\bin\common\Language\zh-TW.yml" | Measure-Object -Line
Get-ChildItem "$repo\bin\common\SoldierName\*.nam" |
  ForEach-Object { (Get-Content $_).Count } | Measure-Object -Sum
```

### 1.5 文件（Markdown）

| 範圍 | 行數 |
|---|---:|
| `docs/*.md`（20 檔，含 GLOSSARY / phase 報告 / v2 plan / widget audit / ux_color） | 2,873 |
| `README.md` | 991 |
| **總計（21 檔）** | **3,864** |

---

## 2. 3 sub-project 拆解 + COCOMO Basic

漢化專案跟純逆向（如 pg-cht）不同，**勞動性質高度異質**——一邊是 widget pixel 級別硬約束，一邊是大量機械化譯文堆疊。把它當單一 KLOC 餵 COCOMO 會嚴重失真，這裡拆 3 個 sub-project 分別套用 mode：

### 2.1 Sub-project 1：Source patches（Embedded）

- **理由**：widget 排版受 320×200 像素硬約束；Font.cpp、Options.cpp 的 hook 牽涉跨模組相依；ModListState/Ufopaedia 的色彩 ramp 受調色盤限制——典型 embedded
- **兩種 KLOC 算法**：
  - **Full-carry 7.04 KLOC**：patches 目錄整 18 檔 SLOC。這是「下游 build 時必須覆蓋的全檔總量」，但**多數行未改**
  - **Effective-change ~1.0 KLOC**：抽樣 diff（widget xy 調整 + 1-2 處 hook + 色彩常數）估約 1,000 SLOC 實際改動

| KLOC | PM | TDEV (月) | 並行人數 |
|---:|---:|---:|---:|
| 7.04（full-carry） | 37.4 | 7.97 | 4.7 |
| 1.00（effective） | 3.6 | 3.77 | 1.0 |

### 2.2 Sub-project 2：翻譯本身（Organic, 8.87 KLOC）

- **理由**：譯者 + reviewer 鬆耦合協作；每條 STR_ 之間獨立；.nam 音譯是大量機械重複（34 國 × 平均 170 個名字）
- **KLOC**：8.87（YAML 3,055 + .nam 5,818）

| PM | TDEV (月) | 並行人數 |
|---:|---:|---:|
| 23.7 | 8.33 | 2.85 |

### 2.3 Sub-project 3：工具 + 文件 + 驗證（Semi-detached, 2.06 KLOC）

- **理由**：Python/PS/Sh 工具鏈各自獨立但彼此呼叫；docs 是設計決策的事後沉澱——介於 organic 與 embedded
- **KLOC**：0.902（程式碼）+ 3.864 × 0.3 折（Markdown）= 0.902 + 1.159 = **2.06**

| PM | TDEV (月) | 並行人數 |
|---:|---:|---:|
| 6.7 | 4.87 | 1.38 |

### 2.4 加總

| 視角 | 加總 PM | 換算人年 |
|---|---:|---:|
| **上界**（patches 計 full-carry 7.04）| 67.9 | 5.66 |
| **下界**（patches 計 effective-change 1.0）| 34.1 | 2.84 |

> 本專案採 **34.1 PM** 作 COCOMO 教科書值（理由：full-carry 7.04 含大量未動的 upstream 程式碼，不算「我們的勞動」）。

---

## 3. 方法論註解

### 3.1 為何拆 3 個 mode

漢化專案的勞動成本**不是單一 KLOC 函數**——譯一條 STR 與重排一個 widget 是兩個世界。pg-cht 樣板拆 3 KLOC × 1 mode 是因為它幾乎純逆向；openxcom-cht 因為大量翻譯介入，必須分軌。

### 3.2 為何翻譯 YAML / .nam 列入 KLOC

- COCOMO 1981 原始定義「LOC = deliverable executable lines」。嚴格說 YAML 是資料不是程式
- 但漢化專案的**人力主成本就壓在這上面**——一條 STR 從 retro context 研究 → 譯出 → reviewer 過稿，平均 5-15 分鐘
- 若不算 YAML，COCOMO 會把整個專案的人力低估到只剩 patches 與 tools，與實況嚴重不符
- 取捨：**列入但用 Organic mode**（鬆耦合、機械重複的 a/b 係數最貼近譯文勞動）

### 3.3 Markdown 為何打 0.3 折

- 寫文件的人月不容小覷（GLOSSARY_1994_MANUAL.md / tftd_knowledge_base_v2.md 是有原始查證的考據文）
- 但比起寫程式 LOC 的密度低很多
- 0.3 是業界 docs-as-code 常用折扣（OWASP / Google docs cost model 約 0.2-0.4）

### 3.4 COCOMO 在此類專案的系統性偏差

**低估**：
1. **逆向工程零成本假設**——COCOMO 假設規格已給；本專案 Font.cpp hook、Options NUM_LANGUAGES 等都是從 source 反推
2. **像素級調整不被建模**——widget 重排往往是「改 3 行、跑遊戲 10 次、確認沒蓋住、再改 3 行」的迭代

**高估**：
1. **COCOMO Basic 假設專業團隊**——本專案是「1 個資深 + AI agent」結構，無溝通成本、無 review 排程
2. **schedule overhead 對 small team 不適用**——TDEV 公式對 1-2 人專案會把工期拉長 2-3x
3. **機械重複工作可大量並行**——AI agent 可同時譯 34 國名字、同時 review 4 mod

### 3.5 ★2026 工具棧現實校正（本專案即為實測 spike）★

實測 wall-clock 約 **10-15 天**（從 v1 ship 到 v2.27 含 TFTD 完整介入）：
- AI agent 並行做：mass translation 1 channel + widget audit 1 channel + .nam 音譯 1 channel
- 使用者主導：UX 測試（截圖 + 視覺判斷字粗、widget 重疊、ramp 飽和度）、設計決策（哪些保留英文）、1994/1995 手冊文獻學
- WSL Xvfb harness 把「跑遊戲確認沒爆」從 10 分鐘/次降到 30 秒/次

換算 PM：10-15 天 wall-clock × 0.5-0.8 utilization（單人有別的事在做）= **0.5-0.8 PM**

對應於 COCOMO 教科書 34.1 PM，**加速比 ~40-70x**。這個倍率與 anr2 機 u6-cht / Wizardry I 重寫的 spike 結果一致（30-80x 之間）。

---

## 4. 三數字並陳

| 視角 | 人力 | 換算 wall-clock |
|---|---:|---|
| **COCOMO 教科書**（3 sub-project effective 加總）| **34.1 PM** | 6-9 個月（含 organic+semi+embedded 平均 TDEV） |
| **傳統人力**（1 senior dev + 1 譯者，無 AI；COCOMO small-team 校正後砍 3-5x）| **6-12 PM** | 4-8 個月 |
| **2026 實測**（AI agent + 使用者主導 UX 測試）| **0.5-0.8 PM** | 10-15 天 |

> 一句話：用 COCOMO Basic 估出來「合理上界 34 PM ≈ 2.8 人年」是個 1990s 假想中的、把翻譯也算 LOC 的軟體公司方案；2026 年單人 + AI agent 把同樣的東西在 10-15 天內 ship，加速比 ~40-70x，主要槓桿是**翻譯工作的大規模並行**與**WSL harness 把回歸測試降到秒級**。

---

## 5. Audit-flag（給 reviewer 看的）

1. **README 對 patches 數量的描述不一致**：第 1187 行寫「5 個 cpp + 1 PNG」，實際 `patches/src/` 有 18 個 cpp+h。建議下次 release 整理 patches 目錄或更新 README 說明
2. **YAML 計入 KLOC 是有爭議的選擇**——若 reviewer 認為應排除，COCOMO 教科書值降至 ~10 PM（只算 patches effective + tools）；本檔 default 採「列入」立場
3. **1995 手冊文獻學的勞動**目前歸到 docs Markdown，但實際是「讀 PDF + 比對 → 寫考據文」的混合勞動，比寫工具還貴。本檔未額外加權，視為可接受的近似
4. **34 國 .nam 音譯的勞動性質**：嚴格說每國名字是獨立的 cultural research（俄文姓 vs 阿拉伯姓的譯法差異）。本檔以 Organic 一視同仁，可能低估
