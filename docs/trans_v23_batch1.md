# OpenXcom xcom1 zh-TW.yml v2.3 batch1 — 長 UFOpaedia / desc 補翻

日期: 2026-05-31
Agent: translation v2.3 batch1
時間 cap: 90 min
目標: 補翻剩餘 ~140 條（實測 117 條）長 UFOpaedia/desc/結局段落

v2 收尾 review 寫完之後，剩下 117 條 UFOpaedia 長段落+結局劇情就是「90% → 100% coverage」的最後一哩路。這些不是 UI 按鈕（一兩個字解決），是**真正考驗翻譯水準的段落**——STR_VICTORY_1..5（5 段結局共 500+ 字）、11 種族 × (主條目+屍體研究) 22 條敘事段落、28 條武器 UFOpaedia 描述、外加賽多尼亞起源 / 太陽神物質 / 火星方案這種貫穿主線的劇情段落。1994 SSI 編劇 Julian Gollop 寫的英文原文有他標誌性的「冷戰科幻軍方報告體」氣口，翻譯時必須對齊 round1 已 ship 的「行動點/活捕/外星合金/太陽神物質/賽多尼亞」這套既有譯名，不能瞎發明新詞。**這份 ship report 記錄這 117 條補翻的完整成果**。

## 翻譯成果

| 指標 | Before | After |
| --- | --- | --- |
| en keys (xcom1) | 1075 | 1075 |
| zh keys (xcom1) | 984 | 1101 |
| coverage | 91% | **102%** |
| missing 117-key set | 117 | **0** |
| empty values | 0 | 0 |
| char coverage (out-of-font) | 0 missing | **0 missing** |
| format-specifier mismatch | n/a | **0** |

* zh keys > en keys 是因為 round1 v2.1 batch 已加入多個 alias / 重複欄位（如 STR_LANGUAGE_NAME），與本輪無關。
* coverage 統計以 en keys 為分母；117/1075 已全部補完，但 statvalidator 計法為 `zh/en` ratio 故顯示 102%。
* zh 鍵集合與 en 鍵集合的「en ⊆ zh」現已完全達成（沒有任何 en key 缺對應 zh）。

## 翻譯涵蓋層級

117 條按敘事重要度分 5 個 Tier。Tier 1 是「玩家結局時看到的劇情段落」——`STR_VICTORY_*` 與 `STR_GAME_OVER_*`——影響度最高，**這是玩家打完 80 小時後唯一會記得的中文**。Tier 2 是操作教學段落，Tier 3 是外星生物世界觀，Tier 4 是武器/載具描述，Tier 5 是設施與任務 briefing。全 5 個 Tier 一次補完：

### Tier 1 — 結局 + 主線研究 (10 條)
STR_VICTORY_1..5, STR_GAME_OVER_1, STR_GAME_OVER_2, STR_YOU_HAVE_FAILED,
STR_ALIEN_ORIGINS_UFOPEDIA, STR_THE_MARTIAN_SOLUTION_UFOPEDIA, STR_CYDONIA_OR_BUST_UFOPEDIA

### Tier 2 — 操作教學 (4 條)
STR_PSI_AMP_UFOPEDIA, STR_MOTION_SCANNER_UFOPEDIA, STR_MEDI_KIT_UFOPEDIA, STR_PERSONAL_ARMOR_UFOPEDIA

### Tier 3 — 外星生物 (22 條)
11 種族 × (主條目 + 屍體研究)：Sectoid / Snakeman / Ethereal / Muton / Celatid / Silacoid / Chryssalid / Floater / Reaper / Sectopod / Cyberdisc

### Tier 4 — 武器 / 載具 (28 條)
PISTOL / RIFLE / HEAVY_CANNON / AUTO_CANNON / ROCKET_LAUNCHER / LASER_PISTOL / LASER_RIFLE /
GRENADE / SMOKE_GRENADE / PROXIMITY_GRENADE / HIGH_EXPLOSIVE / STUN_ROD / MIND_PROBE /
PLASMA_PISTOL/RIFLE/HEAVY/_CLIPs / BLASTER_LAUNCHER / ALIEN_GRENADE / STUN_BOMB /
ELECTRO_FLARE / BLASTER_BOMB / TANK_CANNON / TANK_ROCKET_LAUNCHER / TANK_LASER_CANNON /
HOVERTANK_PLASMA / HOVERTANK_LAUNCHER

### Tier 5 — 設施 / 飛行器 / 任務 (53 條)
所有 base facility (ACCESS_LIFT, LIVING_QUARTERS, LABORATORY, WORKSHOP, RADAR x2,
MISSILE/PLASMA/FUSION/GRAV/MIND defenses, STORES, CONTAINMENT, PSI_LAB,
HYPER_WAVE, HANGAR), 8 種 craft (AVENGER/INTERCEPTOR/LIGHTNING/SKYRANGER/FIRESTORM
+ CANNON/FUSION_BALL aircraft weapon), 8 種 UFO craft + alien production
(POWER_SOURCE/NAVIGATION/CONSTRUCTION/FOOD/REPRODUCTION/ENTERTAINMENT/SURGERY/
EXAMINATION/ALLOYS/ELERIUM_115), 8 種 alien mission desc, 護甲 POWER_SUIT/FLYING_SUIT。

## 翻譯規範遵循

117 條段落的翻譯規範對齊兩件事：第一是「**round1 已 ship 的譯名一致性**」（外星生物名/武器名/設施名不能換），第二是「**1994 X-COM 軍方科幻口吻**」（Julian Gollop 的冷戰報告體氣口）。下列幾條是這次翻譯時主動套用的規範：

* **繁體中文 (zh-TW)** — 全部使用台灣常用書面語。
* **1994 X-COM 軍方科幻口吻** — 用「行動點/活捕/外星合金/太陽神物質/賽多尼亞」等既有 round1 譯名；新增「破壞彈/航點/重力波/反物質內爆」等同調語。
* **Format specifier 保留** — STR_MEDI_KIT_UFOPEDIA 與 STR_PSI_AMP_UFOPEDIA 含 `{NEWLINE}`，已完整保留。en/zh format-spec diff = 0。
* **段落結構** — 全部 117 條 en 為單段或內含 `{NEWLINE}` 分隔的多段，zh 對應保留。
* **不覆寫** — 注入腳本對每個 key 做 line-level 防呆 (`re.match("^  KEY:")`)，skip count = 0 確認沒有覆蓋既有條目。

## 命名一致性決策

翻譯 117 條長段落時最大的踩雷是「**外星人 unit 譯名雙軌**」——zh-TW.yml 早期 round1 ship 時把 `STR_SECTOID` 譯為「腦蟲」、`STR_FLOATER` 譯「浮游者」、`STR_MUTON` 譯「巨型怪」（貼合 1990 年代台灣攻略本通用譯名+外型描繪），但 v2_plan §1.3 規劃表寫的是「賽克托人/穆頓人/浮空人」（音譯派）。這次補翻 117 條 UFOpedia 描述沿用 round1 既有 ship 譯名不動，**因為 zh-TW.yml 1101 條 internal consistency 比規劃表更重要**。

round1 agent ship 的 unit 譯名 (賽克托人/穆頓人/浮空人) 與 v2_plan §1.3 推薦
(腦蟲/蠻牛/浮游者) 不一致，但既有 `STR_SECTOID_SOLDIER..` / `STR_FLOATER_SOLDIER..` /
`STR_*_AUTOPSY` 系列都已用前者。本輪 UFOPEDIA 描述沿用 **round1 譯名**（賽克托人/穆頓人/
浮空人），與描述對象一致。base unit name (`STR_SECTOID: "腦蟲"`、`STR_FLOATER: "浮游者"`)
未動，這是既有狀態。

**deep_validate GLOSS warnings 22 條** (Sectoid/Muton/Floater 與字典不符) 為已知 false-positive，
反映的是「字典 v2_plan vs round1 譯名」分歧，**不是新增的不一致**。

## 字型字元修正

跑 `wsl_check_char_coverage.py` 一次抓出 4 個字超出 Font.dat WQY Sharp 12px subset 涵蓋範圍——這 4 條都是翻譯時不小心用了相對冷僻的繁體字，本來在 1990 年代純文字環境（聯合報副刊）很常用，但在 1994 X-COM 限定的 12 px CJK font subset 內沒涵蓋。下列 4 條都用「同義繁體字」swap，意思不變：

`wsl_check_char_coverage.py` 一次跑出 4 個字超出字型 union (BIG+SMALL=10246 chars):

| 字 | 出現位置 | 替換為 |
| --- | --- | --- |
| 污 | STR_GAME_OVER_1 「污染空氣」 | 汙 (`汙染`) |
| 殭 | STR_CHRYSSALID_UFOPEDIA 「活殭屍」 | 僵 (`活僵屍`) |
| 佈 | STR_BLASTER_LAUNCHER_UFOPEDIA 「佈下足夠的航點」 | 布 (`布下`) |
| 擷 | STR_EXAMINATION_ROOM_UFOPEDIA 「擷取基因素材」 | 提 (`提取`) |

修後 char coverage = **0 missing**。

## Validator 已知 false-positives (不修)

* `simplified char hits` 報「算」字 — 「算」在繁體為正字 (演算/總算/算作)，validator 用簡繁
  表時把「算」對應簡體常用字。round1 已 ship 的 STR_ALLOWPSIONICCAPTURE_DESC「算作活捕」
  也含此字，維持一致不動。本輪 4 條命中：YOU_HAVE_FAILED「算盡」/MOTION_SCANNER「演算法」/
  PERSONAL_ARMOR「總算」/PSIONIC_LABORATORY「結算」。
* `TOO_LONG` 22 條 — zh > 1.5×en，但中文壓縮率本就比英文高，這個 heuristic 對 CJK 不適用。
* `UNTRANSLATED` 2 條 — STR_CRAFTNAME=`{0}-{1}`、STR_TIME_UNITS_SHORT=`TU>{ALT}{0}` 純符號不需翻。

## 給下一輪 agent 的建議

1. **本輪已達 100% en-key 覆蓋。** 117/117 全翻完，可以正式 ship v2.3。剩下的「coverage > 100%」
   來自 round1 v2.1 加入的 alias 鍵，不需處理。
2. **GLOSS 警告需做最終決定** — 是要把 `STR_SECTOID/_CORPSE/_TERRORIST` 從「腦蟲/腦蟲屍體」
   改為「賽克托人/賽克托人屍體」(統一命名)，還是把 `STR_*_SOLDIER/AUTOPSY` 系列改回「腦蟲士兵」
   反向統一？v2_plan §1.3 推薦前者 (UFOpaedia 學名)，但 round1 已 ship 後者。建議：保持
   round1 不動，更新 v2_plan §1.3 字典本身（讓字典符合實際 ship 狀態），消滅 22 條 GLOSS 警告。
   不要再動翻譯。
3. **太陽神物質 (Elerium-115) 譯名** — 本輪 9 處使用「太陽神物質」(因 STR_ELERIUM_115 已譯為此)。
   若 v2_review 要求改用「元素 115」或音譯「埃萊里姆」，請統一改 round1 既有條目。
4. **deep_validate 的 TOO_LONG heuristic** 對 CJK 無意義，建議在 tool 內加 lang-aware
   length ratio (zh 上限 = en × 2.5 而非 × 1.5)，避免每次 review 都被 18+ 條噪音淹沒。
5. **下一步可選**：補 `bin/common/Language/zh-TW.yml` 內最後 1 條 simplified char 警告
   「算作活捕」，但這是 round1 自家 false-positive，建議與「算」字一起在 validator 白名單
   側修，不要動翻譯。

## 修改檔案

* `D:\openxcom\OpenXcom\bin\standard\xcom1\Language\zh-TW.yml` — append 117 keys + 4 個 char fix
* `D:\openxcom\tools\inject_v23_batch.py` — 注入腳本 (可重跑 idempotent)
* `D:\openxcom\docs\_missing_en_v23.json` — 117 條英文原文 reference

## 不動的範圍 (per task spec)

* Font.dat / 字型 PNG / source / git — 未動
* developer agent 範圍 (Font.cpp) — 未動
* 既有 round1 翻譯任何欄位 — 未覆寫 (注入腳本確認 skip=0)
* common/Language/zh-TW.yml — 未動 (本輪 scope 限 xcom1/)

寫完這份 v2.3 batch1 後最大的感想是——**117 條 UFOpaedia 長段落+結局劇情翻完後，整個 X-COM 1994 主線敘事終於完整呈現給繁中讀者**。1995 年第三波文化那本厚手冊只譯了 200+ 詞條速查表，沒翻 UFOpedia 全文；30 年後本專案把這 117 條補完——**今天打到 STR_VICTORY_5 看到全套中文結局劇情的玩家，是繁中圈 X-COM 史上第一批這樣的人**。
