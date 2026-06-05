# SoldierName Phase C Batch 1 — 7 國音譯 ship report

Date: 2026-05-31
Scope: `bin/common/SoldierName/` 中 Arabic / Hindi / Dutch / Irish / Belgium / Swedish / Romanian 共 7 國。
Phase A/B 已完成 11 國 (American/British/Chinese/Russian/German/French/Japanese/Korean/Spanish/Portuguese/Italian)，本批不動。

## 狀況說明

進場時發現 Arabic / Hindi / Dutch / Irish / Belgium / Swedish 6 個檔 **已被 Phase B / 先前 batch 翻譯完畢** (CJK chars 都已就位、entry count 與 upstream HEAD 一致、coverage 全 OK)。本 agent 因此只翻譯尚為英文的 **Romanian.nam** (40+40+40 = 120 entries)，並對其他 6 國執行 entry-count 與 char-coverage 驗證。

## Entries 數量驗證 (current vs upstream HEAD)

| 檔案         | maleFirst | femaleFirst | maleLast | femaleLast | YAML parse | 本次動作   |
|--------------|-----------|-------------|----------|------------|------------|------------|
| Arabic.nam   | 22 / 22   | 22 / 22     | 22 / 22  | —          | OK         | 驗證 (未動) |
| Hindi.nam    | 27 / 27   | 22 / 22     | 28 / 28  | —          | OK         | 驗證 (未動) |
| Dutch.nam    | 12 / 12   | 12 / 12     | 34 / 34  | —          | OK         | 驗證 (未動) |
| Irish.nam    | 33 / 33   | 24 / 24     | 34 / 34  | —          | OK         | 驗證 (未動) |
| Belgium.nam  | 20 / 20   | 20 / 20     | 20 / 20  | —          | OK         | 驗證 (未動) |
| Swedish.nam  | 30 / 30   | 27 / 27     | 31 / 31  | —          | OK         | 驗證 (未動) |
| Romanian.nam | 40 / 40   | 40 / 40     | 40 / 40  | —          | OK         | **本次新譯** |

全部 entries 數量與原檔 HEAD 一致，不增不減。所有檔案 UTF-8 無 BOM。Romanian 原檔本來就沒 femaleLast section，翻譯後維持。Swedish.nam 維持原檔 `lookWeight` (單數，無 s) 拼寫不動。

## 字型涵蓋率 (Font.dat FONT_BIG + FONT_SMALL union = 10246 chars)

| 檔案         | 使用 CJK 字數 | 缺字數 |
|--------------|---------------|--------|
| Arabic.nam   | 74            | 0      |
| Hindi.nam    | 93            | 0      |
| Dutch.nam    | 71            | 0      |
| Irish.nam    | 107           | 0      |
| Belgium.nam  | 81            | 0      |
| Swedish.nam  | 87            | 0      |
| Romanian.nam | 115           | 0      |

`python D:\openxcom\tools\check_nam_coverage.py` → **0 missing chars across all 33 .nam files**

## 罕見字 swap (Romanian 翻譯期間)

Romanian 譯名規劃時 pre-check 字型涵蓋，無需任何 swap — 所有 115 個 CJK chars 第一輪選字即落在 Font.dat union 內。其他 6 國檔由先前 batch 完成，未在本 agent 範圍內變動。

## 5-8 條值得 review 的譯名 (Romanian)

1. **Gheorghe → 蓋奧爾蓋** (maleFirst slot 18)。羅馬尼亞語 `gh` 發 /g/ 而非英語 /dʒ/，所以選「蓋奧」開頭而非「喬奧」。維基百科中文標準譯法。
2. **Ion → 伊昂** (maleFirst slot 20)。極短名（3 字母 → 2 漢字）刻意保留 i+on 兩音節對應，避免縮成單字「揚」與 Iancu (揚庫) 撞名。
3. **Dragos → 德拉戈什** (maleFirst slot 11)。原檔英化拼寫脫掉了 ş diacritic，但羅語標準發音是 `Dragoş` → /draɡoʃ/，本譯保留 ş 的「什」尾。
4. **Cojocaru → 科約卡魯** (maleLast slot 4)。羅語 `coj` 發 /koʒ/，但中文聯合報傳統把斯拉夫/羅語 j 譯「約」（如 Cojocaru = 製皮匠）。
5. **Mihalcea → 米哈爾恰** (maleLast slot 20)。羅語 `cea` = /tʃa/，故尾音「恰」而非「西亞」。同理 Olteanu → 奧爾泰亞努 (`tea` = /tea/, 與 cea 不同)。
6. **Stefan / Stefania → 斯特凡 / 斯特凡妮亞**。原檔是英化拼寫，正字為 `Ştefan`，發音 /ʃtefan/ — 保留羅語 sh 起首譯「斯特」而非「史蒂」，與聯合報東歐人名（如「斯特凡諾維奇」）一致。
7. **Sabau → 薩鮑** (maleLast slot 32)。羅語 `Săbău` 發 /səbəw/，au 二合元音 → 鮑。
8. **Iulia → 尤莉雅** (femaleFirst slot 24)。羅語 Iulia = 拉丁 Julia，譯法與其他歐語 Julia (尤莉雅) 對齊，便於跨國名單一致。

## 工具

本 batch 使用之輔助腳本（皆可拋棄，無 production 依賴）：
- `D:\openxcom\tools\_count_phase_c.py` — 統計 7 國 entry 數
- `D:\openxcom\tools\_verify_phase_c.py` — 與 HEAD upstream 對比 entry counts
- `D:\openxcom\tools\_check_chars_phase_c.py` — 候選字型 coverage pre-check
- `D:\openxcom\tools\_gen_romanian.py` — Romanian.nam 生成器（hard-coded MALE_FIRST / FEMALE_FIRST / MALE_LAST dict + Font.dat coverage gate）

驗證工具 (production)：
- `D:\openxcom\tools\check_nam_coverage.py` — Phase A 已有，本 batch 沿用

## 後續 batches 待做 (Phase C 剩餘)

仍為英文待翻 (依 check_nam_coverage.py "CJK chars used=0")：
Bulgarian / Slovak / Turkish / Nigerian / Czech / Congolese / Hungarian / Norwegian / Kenyan / Danish / Polynesia / Greek 共 12 國。
