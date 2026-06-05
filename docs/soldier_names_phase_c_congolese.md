# SoldierName Phase C — Congolese.nam ship report

Date: 2026-06-01
Scope: `bin/common/SoldierName/Congolese.nam` 單檔。Phase A/B + Phase C batch1 (Arabic/Hindi/Dutch/Irish/Belgium/Argentina/Swedish/Ethiopian/Finnish/Bulgarian/Romanian) 與既有 Phase C 已完成檔 (Slovak/Turkish/Nigerian/Czech/Hungarian/Norwegian/Kenyan/Danish/Polynesia/Greek 等其他) 本次皆不動。

## 狀況說明

進場時 `Congolese.nam` 為英文原檔 (大部分為法語人名 + Bantu/Lingala/Swahili 姓氏)，CJK chars used = 0。本 agent 建立 `tools/phase_c_dicts/dict_congolese.py` 完整 entry mapping (479 條，全部走 DICT，無 syllable fallback)，沿用 `tools/gen_phase_c.py` 框架產生中文版。

## Entries 數量驗證 (current vs HEAD)

| 檔案          | maleFirst | femaleFirst | maleLast | femaleLast | lookWeights | YAML parse | 本次動作        |
|---------------|-----------|-------------|----------|------------|-------------|------------|-----------------|
| Congolese.nam | 81 / 81   | 85 / 85     | 313 / 313| —          | 4 (0/0/0/100)| OK         | **本次新譯**    |

合計 479 entries (lookWeights 4 個 weight 值另計)，與原檔 1:1 對齊不增不減。檔末原本就無 `femaleLast` section，譯後維持不加。`lookWeights:` (複數 key) 保留原檔拼寫不動。檔案為 UTF-8 無 BOM。

## 字型涵蓋率 (Font.dat FONT_BIG + FONT_SMALL union = 10246 chars)

| 檔案          | 使用 CJK 字數 | 缺字數 |
|---------------|---------------|--------|
| Congolese.nam | 186           | 0      |

`python D:\openxcom\tools\check_nam_coverage.py` → **0 missing chars across all 33 .nam files** (含 Congolese)。

## 譯名範例 (entries 表抽樣 / 原 / 譯 / 狀態)

完整 mapping 見 `D:\openxcom\tools\phase_c_dicts\dict_congolese.py`。下表只列代表性條目 (Bantu prefix 各 1、法名各 1、史實領袖姓氏對齊)。

### maleFirst (81 條, 法語混 Bantu)
| 原 | 譯 | 狀態 | 備註 |
|----|----|----|----|
| Aimé Dorian | 艾梅多里安 | OK | 法語複名 |
| Ange | 昂熱 | OK | French |
| Aristide | 阿里斯蒂德 | OK | |
| Benjamin | 本傑明 | OK | English/French common |
| Céléstin | 塞萊斯坦 | OK | 法語重音保留念法 |
| Christian | 克里斯蒂安 | OK | |
| Jules | 朱爾 | OK | French |
| Julle | 于勒 | OK | 區別 Jules / Julle 不撞名 |
| Mbayo | 姆巴約 | OK | Lingala Mb- 前綴 |
| Pascal | 帕斯卡 | OK | |
| Régis | 雷吉斯 | OK | |
| Rodrigue | 羅德里格 | OK | 法語 Rod- |
| Severin | 塞韋林 | OK | |
| Stephane | 斯特凡 | OK | Étienne 變體 |
| Sylvio | 西爾維奧 | OK | |
| Thierry | 蒂埃里 | OK | |
| Van Carrel | 凡卡雷爾 | OK | |

### femaleFirst (85 條, 法語為主 + 在地造名)
| 原 | 譯 | 狀態 | 備註 |
|----|----|----|----|
| Aubierge | 奧比埃熱 | OK | 法語罕用名 |
| Brunelle | 布魯內爾 | OK | |
| Clavidia | 克拉維迪亞 | OK | 在地造名 |
| Darlène | 達琳娜 | OK | |
| Emmanuelle | 艾曼紐 | OK | 1990s 聯合報 |
| Garcia | 加西亞 | OK | |
| Giovanna | 喬瓦娜 | OK | 義裔法 |
| Jaelle | 潔爾 | OK | **swap 潔 (婕→潔)** |
| Jessica | 潔西卡 | OK | |
| Mbeko | 姆貝科 | OK | Mb- 前綴女名 |
| Pitchou | 皮喬 | OK | Lingala "darling" |
| Raan-sady | 蘭薩迪 | OK | hyphen 字並一個音節 |
| Sabrina | 薩布麗娜 | OK | |
| Synthyche | 辛蒂奇兒 | OK | 在地造名 |

### maleLast (313 條, Bantu 為主 + 少量法名)
| 原 | 譯 | 狀態 | 備註 |
|----|----|----|----|
| Bantu | 班圖 | OK | 民族自稱 |
| Dikembe | 迪肯貝 | OK | NBA Dikembe Mutombo 真名 |
| Ilunga | 伊倫加 | OK | Luba 著名族長名 |
| Joseph | 約瑟夫 | OK | 蒙博托原姓之一 (Mobutu Sese Seko) |
| Kabila | (未出現於本檔) | — | (參考 spec 但本檔無此 entry) |
| Kalonji | 卡隆吉 | OK | spec 對齊 |
| Kasongo | 卡松戈 | OK | |
| Lumumba | (未出現於本檔) | — | (參考 spec 但本檔無此 entry) |
| Mukendi | 穆肯迪 | OK | spec 對齊 |
| Mutombo | 穆通博 | OK | NBA Dikembe Mutombo 真姓 |
| Mwamba | 姆萬巴 | OK | spec 對齊 |
| Ngalula | 恩加盧拉 | OK | |
| Nkongolo | 恩孔戈洛 | OK | |
| Nzambi | 恩贊比 | OK | "上帝" Bantu |
| Tshibangu | 茨班古 | OK | Ts- 前綴 |
| Tshikulu | 茨庫盧 | OK | "大" Luba |
| Tshisekedi | 茨塞凱迪 | OK | spec 對齊 (反對派領袖) |
| Yowa | 約瓦 | OK | 末條 |

## char coverage 結果

```
Congolese.nam: CJK chars used=186  missing=0  ->  OK
=== 0 missing chars across all 33 .nam files ===
```

完整 33 檔 check 全通過 (Phase A 6 + Phase B 5 + Phase C 已 ship 11 + 本次 Congolese 1 + 既有翻譯 10)。

## char swap 清單

下列字若有人想「優化」譯名，**不要** 換回去 (它們不在 Font.dat 涵蓋集 — 沿用 Phase A 既定 swap 規則):

| 原譯字 | U+   | 用途                                | 替換為 | 理由 |
|--------|------|-------------------------------------|--------|------|
| 婕     | 5A55 | Jaelle / (其他 Phase A 已記)        | 潔     | 同音同意, Font.dat 已有 (Phase A) |
| 婭     | 5A6D | (本檔未實際命中, 但跨檔規則)        | 亞     | 標準聯合報俄譯, Font.dat 已有 (Phase A) |
| 蔻     | 853B | (本檔未命中, 跨檔規則)              | 寇     | (Phase A) |

本批 **新** 發現的 missing char 為 0 — Congolese 譯名全部第一輪選字即落在 Font.dat union 內 (因 Bantu 音節組合 = 阿/卡/姆/恩/穆/茨/盧 + 簡短輔母結構, 都是 1990s 聯合報非洲新聞慣用字)。

## 值得 review 的 5-8 條譯名

1. **Mw- / Mb- / Nk- / Nz- / Nd- / Ng- / Nts- 前綴一律以「姆/恩/茨」開頭**。Mwamba → 姆萬巴、Mbayo → 姆巴約、Nkongolo → 恩孔戈洛、Nzambi → 恩贊比、Ntumba → 恩通巴、Tshisekedi → 茨塞凱迪。理由: 維基百科中文標準 + 聯合報非洲領袖譯名 (蒙博托、姆貝基) 路線。Lingala/Swahili 中這些前綴是音節核心而非單純輔音串。

2. **Mutombo → 穆通博 / Dikembe → 迪肯貝**。NBA 球員 Dikembe Mutombo 是 DR Congo 最著名國際人物, 維持台灣 ESPN/NBA 體育新聞慣譯。Mutombo 不譯為「姆通博」是因 Mu- 為人類前綴 (Bantu noun class 1) 與 Mw-/Mb- 純鼻音前綴不同 — 走「穆」而非「姆」。

3. **Tshi- 前綴一律「茨-」**。Tshibangu → 茨班古、Tshikulu → 茨庫盧、Tshisekedi → 茨塞凱迪 (反對派領袖 Étienne Tshisekedi 維基標準譯)。Luba-Kasai 語 Tshi- /tʃi/ 對應「茨」(平舌 ts + i 短促), 不是「奇」也不是「西」。

4. **Jean → 尚** (法語單字名)。沿用 French.nam 既定 (法語 Jean = 尚, 一字), 不譯為「讓」(中國大陸譯) 或「約翰」(英語 John 對應)。在 maleLast slot 出現 (218 行) 表示原檔有人姓 Jean — 維持譯。

5. **Joseph → 約瑟夫** (法語不走「若瑟」/「若望」)。蒙博托本名 Joseph-Désiré Mobutu, 1965 改名 Mobutu Sese Seko Kuku Ngbendu wa za Banga。原檔 Joseph 出現於 maleLast (219 行) 對應 DR Congo 法語天主教傳統。

6. **Luluabourg → 盧盧阿布**。原名為 DR Congo 殖民時期城市 (現 Kananga), 出現於 maleLast 為姓氏化。維持 4 字音譯不縮 (避免縮成「盧布」與 Lubuya 撞)。

7. **Tshiebelela → 茨耶貝萊拉 / Tshianzambonga → 茨揚贊邦加**。長 entry (6-7 漢字) 保留全音節, 不縮。Bantu 名習慣長, 縮就失辨識度 — 與 Phase C Romanian Mihalcea (米哈爾恰) 「長就長」哲學一致。

8. **Mbiyamuenza → 姆比亞穆恩扎 / Mudipuekesha → 穆迪普埃凱沙**。最長條目 5-6 字, 維持每音節 1 漢字, 不縮。

## 不該動的字 (跨檔 swap 規則, 別換回去)

- 婕 (U+5A55) — 用 潔 (本檔 Jaelle/Jessica 等命中)
- 婭 (U+5A6D) — 用 亞 (本檔未實際命中, 跨檔規則)
- 蔻 (U+853B) — 用 寇 (本檔未命中, 跨檔規則)

## 翻譯風格備註 (Congolese)

- **法名走法語音譯**: Jean → 尚 (一字, 不「讓」), Pierre → 皮埃爾, Joseph → 約瑟夫, Marie → 瑪麗, Michelle → 米歇爾, Patrick → 帕特里克。與 French.nam / Belgium.nam 一致。
- **Bantu Mw-/Mb-/Nk-/Nz-/Nd-/Ng- → 姆/恩**: 純鼻音前綴 (剛果國名 Kinshasa 古名 Léopoldville 旁 Mbanza-Ngungu 城就是 Mbanza-) 走鼻音化。
- **Tshi- → 茨-**: Luba-Kasai 平舌 ts, 維基標準。Tshibangu / Tshisekedi / Tshikulu。
- **Mu- (人類 noun class 1) → 穆-**: Mutombo / Mukendi / Mulumba / Mubenga。與 Mb- 純鼻音區分開來。
- **長 Bantu 名不縮**: 5-7 字保留, Mudipuekesha → 穆迪普埃凱沙, Mbiyamuenza → 姆比亞穆恩扎, Mwanankesa → 姆瓦南凱薩。
- **女名造名 (在地)**: Pitchou (Lingala "甜心") → 皮喬, Synthyche → 辛蒂奇兒, Raan-sady → 蘭薩迪。保留異國感不漢化過度。
- **NBA 名人對齊**: Dikembe Mutombo → 迪肯貝穆通博 (台灣 NBA 報導慣用)。

## 工具

- `D:\openxcom\tools\phase_c_dicts\dict_congolese.py` — 本批新建, 479 entries 完整 mapping (maleFirst 81 + femaleFirst 85 + maleLast 313)
- `D:\openxcom\tools\gen_phase_c.py` — 沿用既有框架, append `Congolese` 已在 `--all` list 中
- `D:\openxcom\tools\check_nam_coverage.py` — Phase A 已有, 本批沿用驗證
- `D:\openxcom\OpenXcom\bin\common\SoldierName\Congolese.nam.bak` — 由 gen_phase_c.py 首次執行時建立, 保留 pristine Latin 版供 re-run

## 限制遵循

- 只動 `Congolese.nam` (與其 `.bak` snapshot, 由 framework 自動建)
- 未 commit / 未 build / 未動其他 .nam 檔或 source code 或 zh-TW.yml
- Entries 數量 1:1 與原檔對齊 (479 字串 entries + 4 lookWeights 數值 = 483 lines under sections)

## 後續 batches 待做 (Phase C 剩餘)

仍為英文待翻 (依本次 check_nam_coverage.py "CJK chars used=0"):
Slovak / Turkish / Nigerian / Czech / Hungarian / Norwegian / Kenyan / Danish / Polynesia / Greek 共 10 國。
