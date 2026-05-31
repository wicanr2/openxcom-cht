# SoldierName Phase A — 6 國音譯 ship report

Date: 2026-05-31
Scope: `bin/common/SoldierName/` (only). `bin/standard/xcom1` 與 `bin/standard/xcom2` 之下無 SoldierName 目錄 — 不需要動。

## Entries 數量驗證 (原檔 vs 翻譯後)

| 檔案           | maleFirst | femaleFirst | maleLast | femaleLast | YAML parse |
|----------------|-----------|-------------|----------|------------|------------|
| American.nam   | 62 / 62   | 57 / 57     | 73 / 73  | —          | OK         |
| British.nam    | 78 / 78   | 84 / 84     | 143 / 143| —          | OK         |
| Chinese.nam    | 425 / 425 | 425 / 425   | 78 / 78  | 68 / 68    | OK         |
| Russian.nam    | 40 / 40   | 41 / 41     | 38 / 38  | 38 / 38    | OK         |
| German.nam     | 27 / 27   | 15 / 15     | 27 / 27  | —          | OK         |
| French.nam     | 53 / 53   | 45 / 45     | 82 / 82  | —          | OK         |

全部 entries 數量與原檔一致,不增不減。lookWeights 保留原值不動。所有檔案 UTF-8 無 BOM。American/British/German/French 原檔本來就沒 femaleLast section,翻譯後也維持不加。

## 字型涵蓋率 (Font.dat union of FONT_BIG + FONT_SMALL = 10246 chars)

| 檔案         | 使用 CJK 字數 | 缺字數 |
|--------------|---------------|--------|
| American.nam | 177           | 0      |
| British.nam  | 199           | 0      |
| Chinese.nam  | 320           | 0      |
| Russian.nam  | 123           | 0      |
| German.nam   | 100           | 0      |
| French.nam   | 180           | 0      |

`python D:\openxcom\tools\check_nam_coverage.py` → **0 missing chars across all 6 .nam files**

## 罕見字 swap (本來會缺字 → 同音替代)

| 原譯字 | U+   | 用途                          | 替換為 | 理由                          |
|--------|------|-------------------------------|--------|-------------------------------|
| 蔻     | 853B | Cora → 蔻拉                   | 寇     | 寇拉,1990s 台灣常見譯法       |
| 婕     | 5A55 | Jayne → 婕恩                  | 潔     | 潔恩,同音同意                 |
| 婭     | 5A6D | Lidiya → 莉迪婭               | 亞     | 莉迪亞,標準聯合報路線         |
| 郝     | 90DD | 拼音 Hao → 郝 (姓氏)          | 浩     | 浩 (同音,Hao 池仍 OK)        |
| 鄺     | 913A | 拼音 Kuang/Kwong → 鄺         | 匡     | 匡 (同音,真實姓氏)           |
| 芷     | 82B7 | Zhijuan → 芷娟                | 之     | 之娟 (同音,音譯仍順)         |

## 5 條值得 review 的譯名

1. **Confucius → 孔丘** (Chinese maleLast slot,原檔混入名人名)。也可改「孔子」但「丘」是孔子本名,保留歷史感。
2. **Lao-Tzu → 老子** (Chinese maleLast 同樣是名人)。`老子+王` 會合成「王老子」感覺怪,但這就是原檔意圖。
3. **Genjo → 玄奘** (Chinese maleLast 唐三藏日譯)。原檔顯然引用日本「玄奘三藏」,放在 Chinese 池有趣。
4. **Sigourney (American) → 雪歌妮**。1990s 台灣對 Sigourney Weaver 的標準譯法,有 cell 涵蓋。
5. **Genji (Chinese femaleLast) → 源氏**。日本《源氏物語》的源氏,放女名池上下文奇怪但保留原檔意圖。

## 不該動的字 (已 swap 過)

下列字若有人想「優化」翻譯,**不要** 換回去 — 它們不在 Font.dat cell list:

- 蔻 (U+853B) — 用 寇 代替
- 婕 (U+5A55) — 用 潔 代替
- 婭 (U+5A6D) — 用 亞 代替
- 郝 (U+90DD) — 用 浩 代替 (Chinese 池 Hao 拼音)
- 鄺 (U+913A) — 用 匡 代替 (Chinese 池 Kuang/Kwong 拼音)
- 芷 (U+82B7) — 用 之 代替 (Chinese 池 Zhijuan)

## 翻譯風格備註

- **American / British**: 聯合報國際版/金庸 1990s 譯法 (約翰/瑪麗/史密斯/瓊斯)。2-4 字。
- **Chinese**: 拼音池 → 每個 syllable 對應 1 個 CJK 字 (歐陽/司徒/Soo Hoo/Au Yeung/Szeto 例外是 2 字複姓)。男 syllable 偏陽剛 (強/勇/志/軍/雷/虎/鵬),女 syllable 偏陰柔 (芳/華/美/麗/嬋/翠/嬌)。遊戲 concat: 王偉 / 李華 / 張明 / 歐陽勇 — 看起來像真名。
- **Russian**: 全名照標準聯合報俄譯,Vladimir→弗拉迪米 (4字 cap),Petrov→彼得羅夫。femaleLast -a 結尾統一 `-夫→-娃` 對應。
- **German**: 短促有力 (克勞斯/漢斯/沃夫岡/穆勒/史密特)。Meyer/Meier 因避重複分別譯邁爾/麥爾。
- **French**: 法文 trailing -s/-t 不發音反映在音譯 (Dupres → 杜普雷),Jean→尚 (一字),Pierre→皮耶。

## 工具

- `D:\openxcom\tools\gen_chinese_nam.py` — Chinese.nam 生成器 (hard-coded SURNAMES/MALE_GIVEN/FEMALE_GIVEN dict)
- `D:\openxcom\tools\check_nam_coverage.py` — 驗證所有 6 個 .nam 字型涵蓋率
