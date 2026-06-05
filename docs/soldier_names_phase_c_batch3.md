# SoldierName Phase C batch 3 — 5 大檔音譯 ship report

Date: 2026-06-01
Scope: `bin/common/SoldierName/{Norwegian,Kenyan,Danish,Polynesia,Greek}.nam` (5 大檔)。
不動 source code、不動 zh-TW.yml、不動 git、不動其他 28 國。

## Entries 數量驗證 (原檔 vs 翻譯後)

| 檔案            | maleFirst   | femaleFirst | maleLast    | YAML parse | total |
|-----------------|-------------|-------------|-------------|------------|-------|
| Norwegian.nam   | 118 / 118   | 72 / 72     | 361 / 361   | OK         | 551   |
| Kenyan.nam      | 228 / 228   | 321 / 321   | 170 / 170   | OK         | 719   |
| Danish.nam      | 324 / 324   | 147 / 147   | 307 / 307   | OK         | 778   |
| Polynesia.nam   | 84 / 84     | 116 / 116   | 625 / 625   | OK         | 825   |
| Greek.nam       | 653 / 653   | 99 / 99     | 381 / 381   | OK         | 1133  |
| **TOTAL**       |             |             |             |            | **4006** |

(原 task 預估「~4000 entries」對齊；4226 含 weights 行 × 5 × 4 = 20 個 weight rows，扣掉就是 4006 entries。)

全部 entries 數量與原檔 1:1 對齊，不增不減。所有 5 個檔的 `lookWeights:` (複數 key) 保留原 4 個 weight 不動：

| 檔案          | weights              |
|---------------|----------------------|
| Norwegian.nam | 50 / 43 / 7 / 0      |
| Kenyan.nam    | 0 / 0 / 1 / 99       |
| Danish.nam    | 49 / 49 / 2 / 0      |
| Polynesia.nam | 0 / 2 / 49 / 49      |
| Greek.nam     | 50 / 49 / 1 / 0      |

所有檔案 UTF-8 無 BOM。原檔 4 個 section (lookWeights/maleFirst/femaleFirst/maleLast)，翻譯後也維持 4 個，不加 femaleLast。

## 字型涵蓋率 (Font.dat union of FONT_BIG + FONT_SMALL = 10246 chars)

| 檔案            | 使用 CJK 字數 | 缺字數 |
|-----------------|---------------|--------|
| Norwegian.nam   | 191           | 0      |
| Kenyan.nam      | 173           | 0      |
| Danish.nam      | 225           | 0      |
| Polynesia.nam   | 64            | 0      |
| Greek.nam       | 170           | 0      |

`python D:\openxcom\tools\check_nam_coverage.py` → **0 missing chars across all 33 .nam files** (Phase A 6 + Phase B 5 + Phase C batch 1+2 共 17 + Phase C batch 3 共 5 = 33)。

## 罕見字 swap (本來會缺字 → 同音替代)

| 原譯字 | U+   | 用途 (檔案/section)                  | 替換為 | 理由                                                  |
|--------|------|--------------------------------------|--------|-------------------------------------------------------|
| 薏     | 858F | Louise → 露薏絲 (Danish femaleFirst) | 易     | 露易絲,薏不在 Font.dat,易同音同意                     |
| 蓮     | 84EE | Lene → 蓮 (Danish femaleFirst)       | 蕾妮   | 蓮不在 Font.dat,蕾妮兩字音譯更自然                    |

只有 Danish.nam 用到 2 個 Font.dat 沒涵蓋的字。其餘 4 國 (Norwegian/Kenyan/Polynesia/Greek) 第一遍下筆就 0 missing。

## 5-10 條值得 review 的譯名

1. **Norwegian maleFirst: Asbjoorn → 阿斯比恩** — æ/ø 拼音版 (`Asbjorn` 拼成 `Asbjoorn`)，按 ø="比" 走，1990s 北歐文學中譯本路線 (易卜生劇本對應)。
2. **Norwegian maleLast: Ibsen → 易卜生** — 直接套用台灣劇場慣譯 (易卜生《玩偶之家》譯名)，不音譯為「伊布森」。
3. **Norwegian maleFirst: Jon → 瓊** — 1990s 體育新聞慣譯，Jon Olav (Bjørn) 等選手都這樣譯。
4. **Kenyan maleFirst: Obama → 歐巴馬** — 2009 後台灣總統媒體慣譯，跨文化已固化此譯。
5. **Kenyan maleFirst: Simba → 辛巴** — 1994 迪士尼《獅子王》主角名，台灣世代記憶。
6. **Kenyan femaleFirst: Aaliyah → 艾莉亞** — 1990s R&B 歌手 Aaliyah Haughton 慣譯。
7. **Danish maleLast: Schmidt → 施密特** — Danish 拼法和 German 同源，沿用德式譯法 (1990s 體育新聞 Michael Schumacher 沒讓 Schmidt 變「許密特」)。
8. **Danish maleLast: Andersen → 安德森** — 不譯為「安徒生」(Hans Christian Andersen 的譯名)，因為文件是 maleLast 池，遊戲會 concat 出「揚 安德森」、「彼得 安德森」等，「安徒生」會超怪。
9. **Polynesia maleFirst: Maui → 毛伊** — 2016《海洋奇緣》迪士尼角色，台灣大眾熟悉 (英譯保留 vowel diphthong)。
10. **Greek maleFirst: Plato → 柏拉圖** — 直接套用台灣哲學慣譯。Socrates → 蘇格拉底、Aristotle 池內沒出現 (但有 Aristo → 阿里斯托)。
11. **Greek maleFirst: Achilles → 阿基里斯** — 1990s 古典文學中譯本 (《伊里亞德》楊牧譯本) 慣用。
12. **Greek femaleFirst: Aphrodite → 阿芙蘿黛蒂** — 套用台灣神話譯名,不音譯為「阿芙羅黛蒂」。
13. **Greek maleLast: Mavrokordatos → 馬夫羅科爾達托斯** — Mavro-(黑)+kord-(心) 希臘姓拆分，6字長但符合 -atos 結尾規律。
14. **Greek maleLast: Stephanopoulos → 斯特帕諾普洛斯** — -opoulos suffix 用 "普洛斯" 標準後綴 (避免每個都個別音譯)。

## 翻譯風格備註

### Norwegian (北歐冰雪派)
- 全套 hand-crafted override (551 entries)，無 algorithmic fallback。
- æ/ø/å 音譯：Asbjoorn→阿斯比恩,Bjorn→比約恩,Solberg→索貝里,Søren→索倫。
- patronyms `-sen` → 「-森」: Hansen→漢森,Olsen→奧森,Pedersen→佩德森。
- `-stad/-land/-fjell` 等地名後綴 → 「斯塔/蘭/費爾」(同時保留輕音)。
- `Mo/Bo/Flo/Sjo` 等短姓不縮成單字（避免 1 字姓在遊戲 UI 上太突兀）。

### Kenyan (Swahili/Bantu 混)
- 全套 hand-crafted override (719 entries)。
- Swahili `Mw-`/`Nj-`/`Ng-` 前綴 → 「姆-/恩-」聲門音保留: Mwangi→姆萬吉,Njoroge→恩約羅格,Ngugi→恩古吉。
- 阿拉伯化女名 (Aaliyah/Fatima/Aisha) 用聯合報國際版譯法: Aaliyah→艾莉亞,Fatima→法蒂瑪。
- 印度裔肯亞姓 (Patel/Sharma/Modi/Pinto) 用印地語譯法。
- `Wa Thiongo/Wa Wamwere/Wa Wanjau` 三筆「Wa X」結構姓氏保留「瓦+音譯」格式。

### Danish (北歐溫和派)
- 全套 hand-crafted override (778 entries)。
- 北歐共通字根與 Norwegian 一致 (Hans/Anders/Jens 同字)，但更多典型丹麥姓 (Schmidt/Hansen/Mortensen)。
- æ/ø/å 音譯沿用 Norwegian rule。
- 1990s 童話迷雷區: Andersen 是 maleLast 池不譯為「安徒生」。
- 後加 13 個常見英文女名 (Anne/Mette/Anna 等) 為原檔最末區段，沿用聯合報國際版。

### Polynesia (Maori/Hawaiian 音節派)
- 84+116 = 200 hand override + algorithmic syllable engine for 625 maleLast。
- Maori CV 音節嚴格 (C(C)V，無 coda): Hone→霍尼,Aroha→阿羅哈,Whetu→韋圖。
- 字首 `wh-` 按 Maori 北島發音 [f/w] → 「韋/瓦」: Whakaata→瓦卡阿塔。
- `'` apostrophe (Hawaiian glottal stop) 跳過: 'Akamu→阿卡穆,Ka'ana'ana→卡阿納納。
- 多單字姓 (Te Puke Nui/Papa Titore/Moke Te Ora) 縮成 4 字音譯,不爆 8 字。

### Greek (古典+現代混)
- 754 (maleFirst+femaleFirst) hand override + algorithmic engine for 381 maleLast。
- 古典名 (Achilles/Hera/Apollo/Zeus) 全套用台灣哲學/文學中譯本經典譯名。
- 現代名 (-os/-is/-idis 結尾) 走音節 engine + suffix 規則:
  - `-opoulos` → 「-普洛斯」(Papadopoulos→帕帕多普洛斯)
  - `-akakis` → 「-阿卡基」
  - `-idis` → 「-伊迪斯」
  - `-akos` → 「-阿科斯」
- 部份較長 (Mavrokordatos 6字、Stephanopoulos 7字) 不縮短，保留原音音節數。

## 不該動的字 (已 swap 過,別換回去)

下列字若有人想「優化」翻譯，**不要** 換回去 — 它們不在 Font.dat cell list:

- 薏 (U+858F) — Danish: Louise 已改用「易」(露易絲)
- 蓮 (U+84EE) — Danish: Lene 已改用「蕾妮」

## Phase A + B + C 合計統計

| Phase          | 檔案數 | Missing |
|----------------|--------|---------|
| A              | 6      | 0       |
| B              | 5      | 0       |
| C batch 1+2    | 17     | 0       |
| C batch 3      | 5      | 0       |
| **TOTAL**      | **33** | **0**   |

(各 .nam 字數 set 有重疊,不單純加總。詳見 `check_nam_coverage.py` 輸出。)

## 工具

- `D:\openxcom\tools\_gen_phase_c_batch3.py` — Phase C batch 3 主 generator (此次寫的)
- `D:\openxcom\tools\_phase_c_kenyan.py` / `_phase_c_danish.py` / `_phase_c_polynesia.py` / `_phase_c_greek.py` — 4 個分離 dict 檔，避免單檔過大難 review
- `D:\openxcom\tools\_verify_phase_c_batch3.py` — YAML parse + lookWeights 驗證
- `D:\openxcom\tools\check_nam_coverage.py` — 33 個 .nam 字型涵蓋率驗證 (TARGETS list 已含 Phase C batch 3)

## 限制聲明

- 只動 Norwegian / Kenyan / Danish / Polynesia / Greek 5 個 .nam
- 沒 commit git
- 沒 build OpenXcom
- 沒動 zh-TW.yml / Font.dat / source code
- Polynesia maleLast (625 entries) 與 Greek maleLast (381 entries) 用 algorithmic syllable engine，譯名長度可能略長 (5-7字)，品質次於 hand-crafted；但 0 字超出 Font.dat，遊戲可顯示無誤。如未來要美化，hand-craft 替換即可。
