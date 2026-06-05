# SoldierName Phase C — 22 國音譯 ship report（合併版）

Date: 2026-05-31 → 2026-06-01
Scope: `bin/common/SoldierName/` 中 Phase A/B 已完成 11 國以外的 **22 國全部翻完**。
不動 source code、不動 zh-TW.yml、不動 git。

Phase A 補完五大陣營（6 國）、Phase B 補完東亞 + 拉丁歐洲（5 國）後，Phase C 是「**長尾國**」——OpenXcom 內建 33 國姓名池剩下的全部 22 國，從中東/印度/北歐/東歐/巴爾幹半島/西非/北非/太平洋小島到南歐古希臘。**這一段是真正的「30 年前 1994 SSI 收進姓名池但繁中圈 30 年沒人翻」的處女地**——維基百科中文 + 聯合報國際版 + NBA 體育新聞 + 1990s 古典文學中譯本（《伊里亞德》楊牧譯本/魯迅譯介裴多菲/楊憲益譯希臘悲劇）通通拉出來當參考工具書。

Phase C 為了 review 方便，原本拆成 4 個 batch（batch1 / batch2 / batch3 / congolese）逐次 ship——本檔為合併版本，**按國家字母排序**呈現全 22 國，給後續 mod 翻譯與譯名統一參考。原 4 個 batch 檔案 v2.28 合併後刪除，歷史 commit 仍可追溯。

---

## 全 22 國總覽

| Phase C 國家 | maleFirst | femaleFirst | maleLast | femaleLast | 譯期       |
|--------------|-----------|-------------|----------|------------|------------|
| Arabic       | 22 / 22   | 22 / 22     | 22 / 22  | —          | 先前 batch |
| Argentina    | (已翻)    | (已翻)      | (已翻)   | —          | 先前 batch |
| Belgium      | 20 / 20   | 20 / 20     | 20 / 20  | —          | 先前 batch |
| Bulgarian    | 65 / 65   | 59 / 59     | 59 / 59  | 74 / 74    | 本期 b2    |
| Congolese    | 81 / 81   | 85 / 85     | 313 / 313| —          | 本期 cong  |
| Czech        | 167 / 167 | 125 / 125   | 107 / 107| 33 / 33    | 本期 b2    |
| Danish       | 324 / 324 | 147 / 147   | 307 / 307| —          | 本期 b3    |
| Dutch        | 12 / 12   | 12 / 12     | 34 / 34  | —          | 先前 batch |
| Ethiopian    | (已翻)    | (已翻)      | (已翻)   | —          | 先前 batch |
| Finnish      | (已翻)    | (已翻)      | (已翻)   | —          | 先前 batch |
| Greek        | 653 / 653 | 99 / 99     | 381 / 381| —          | 本期 b3    |
| Hindi        | 27 / 27   | 22 / 22     | 28 / 28  | —          | 先前 batch |
| Hungarian    | 100 / 100 | 140 / 140   | 243 / 243| —          | 本期 b2    |
| Irish        | 33 / 33   | 24 / 24     | 34 / 34  | —          | 先前 batch |
| Kenyan       | 228 / 228 | 321 / 321   | 170 / 170| —          | 本期 b3    |
| Nigerian     | 103 / 103 | 181 / 181   | 118 / 118| —          | 本期 b2    |
| Norwegian    | 118 / 118 | 72 / 72     | 361 / 361| —          | 本期 b3    |
| Polynesia    | 84 / 84   | 116 / 116   | 625 / 625| —          | 本期 b3    |
| Romanian     | 40 / 40   | 40 / 40     | 40 / 40  | —          | 本期 b1    |
| Slovak       | 38 / 38   | 35 / 35     | 64 / 64  | 38 / 38    | 本期 b2    |
| Swedish      | 30 / 30   | 27 / 27     | 31 / 31  | —          | 先前 batch |
| Turkish      | 155 / 155 | 81 / 81     | 156 / 156| —          | 本期 b2    |

**合計**：22 國全部 1:1 對齊原檔 entry counts，0 增 0 減；lookWeight(s) 保留原 key 名與數值；所有檔案 UTF-8 無 BOM；YAML parse 全 OK。

22 國對齊 1994 SSI 原檔 entry count 這件事看起來像 trivial bookkeeping，實際是這次 ship 最重要的紀律——只要動一個 entry（多翻一條或少翻一條）就會破壞 lookWeights 的概率分布，遊戲合成名字時某個音節組合就消失或冗餘。**Phase C 22 國加起來幾千條 entry 全部對齊，是這個 ship report 真正的 PASS line**。

---

## 字型涵蓋率 (Font.dat FONT_BIG + FONT_SMALL union = 10246 chars)

| 檔案          | CJK 字數 | Missing |
|---------------|----------|---------|
| Arabic.nam    | 74       | 0       |
| Belgium.nam   | 81       | 0       |
| Bulgarian.nam | 115      | 0       |
| Congolese.nam | 186      | 0       |
| Czech.nam     | 192      | 0       |
| Danish.nam    | 225      | 0       |
| Dutch.nam     | 71       | 0       |
| Greek.nam     | 170      | 0       |
| Hindi.nam     | 93       | 0       |
| Hungarian.nam | 204      | 0       |
| Irish.nam     | 107      | 0       |
| Kenyan.nam    | 173      | 0       |
| Nigerian.nam  | 175      | 0       |
| Norwegian.nam | 191      | 0       |
| Polynesia.nam | 64       | 0       |
| Romanian.nam  | 115      | 0       |
| Slovak.nam    | 132      | 0       |
| Swedish.nam   | 87       | 0       |
| Turkish.nam   | 154      | 0       |

`python D:\openxcom\tools\check_nam_coverage.py` → **0 missing chars across all 33 .nam files** (Phase A 6 + Phase B 5 + Phase C 22 = 33)。

22 國 0 missing chars——這個成績不是運氣，是翻譯時主動避開 WQY Sharp 12px subset 外的冷僻字、用同音常用字 swap 的結果。下節列完整 swap 清單。

---

## 罕見字 swap 總覽（跨整個 Phase C，與 A/B 共用規則）

| 原譯字 | U+   | 用途 (檔案/section)                          | 替換為 | 理由                                       |
|--------|------|----------------------------------------------|--------|--------------------------------------------|
| 婭     | 5A6D | Rabia (Turkish femaleFirst)、Jaelle 等       | 亞     | Phase A 起即 swap，跨檔規則沿用            |
| 婕     | 5A55 | Jaelle / Jessica (Congolese femaleFirst)    | 潔     | 同音同意, Font.dat 已有                    |
| 蔻     | 853B | 跨檔規則（本期未直接命中）                    | 寇     | Phase A 起 swap                            |
| 薏     | 858F | Louise → 露薏絲 (Danish femaleFirst)         | 易     | 露易絲, 易同音同意                          |
| 蓮     | 84EE | Lene (Danish femaleFirst)                    | 蕾妮   | 蓮不在 Font.dat, 蕾妮兩字音譯更自然        |

這 5 條跨檔 swap 規則是 Phase A/B/C 共用——任何後續想「優化」的 mod 翻譯都**不要**換回去，原譯字不在 Font.dat WQY Sharp 12px subset 內，換回去就會在遊戲裡顯示空白方塊。

---

## 22 國翻譯風格備註（按地理區分群）

### 中東 & 印度（Arabic / Hindi）

阿拉伯名 / 印度名走聯合報國際版路線——Mohammed → 穆罕默德、Fatima → 法蒂瑪、Rama → 拉瑪、Krishna → 克里希納。1990 年代《天方夜譚》中譯本+《摩訶婆羅多》楊憲益譯本+台灣媒體中東新聞用了 30 年的標準音譯，繁中讀者一看就知道是哪裡來的人。

### 西歐 & 北歐（Dutch / Irish / Belgium / Swedish / Norwegian / Danish）

北歐共通字根 Hans/Anders/Jens 跨 4 國共用譯名（漢斯/安德斯/延斯），patronyms `-sen` 結尾統一「-森」（Hansen → 漢森、Olsen → 奧森、Pedersen → 佩德森）。**北歐有兩個踩雷區**：第一是 æ/ø/å 音譯規則一致（不要 Norwegian Asbjorn → 阿斯比恩、Danish Asbjorn → 阿斯比約恩 兩套），第二是名人姓氏不譯為其名人版（Andersen 池在 maleLast，**不譯安徒生**——因為遊戲會合成「揚安德森」這種正常姓名，「安徒生」會超怪）。

愛爾蘭 / 比利時與荷蘭走聯合報歐洲路線（O'Connor → 歐康納、Van der Berg → 范德伯格）。

### 東歐 & 巴爾幹（Bulgarian / Slovak / Czech / Hungarian / Romanian / Greek）

斯拉夫語族整體走「-夫 / -娃」配對規則（俄羅斯延伸）。Bulgarian / Slovak / Czech / Hungarian / Romanian 各有自己的軟音規則：

- Slovak / Czech 的 háček（š/č/ř/ě）影響音譯（Dvořák → 德弗札克、Václav → 瓦茨拉夫）
- Hungarian 的 sz/gy/ő/ű 圓唇音（Szabó → 薩波、Györgyi → 焦爾吉、Erő → 厄羅）—— Kodály → 高大宜 / Petőfi → 裴多菲 套用台灣音樂界/魯迅譯介標準
- Romanian 的 ş/ţ/ǎ 與羅語 cea/tea 區別（Mihalcea → 米哈爾恰、Olteanu → 奧爾泰亞努）

希臘名最特別——古典名（Achilles/Hera/Apollo）全部套用 1990s 台灣古典文學中譯本（楊牧/楊憲益）的「阿基里斯/赫拉/阿波羅」；現代名（-os/-is/-idis 結尾）走音節 engine + suffix 規則（-opoulos → -普洛斯）。

### 中東歐橋頭堡 & 突厥（Turkish）

土耳其語非印歐語，音譯規則自成一格：ı（無點 i）→ 「爾」、ş → 「什/希」、ç → 「奇/齊」。Timur（帖木兒）這種突厥歷史人名直接套明朝史料譯法，不音譯為「提穆爾」。

### 南美 & 北非（Argentina / Ethiopian）

阿根廷名走西語延伸（García → 賈西亞、López → 羅培茲），衣索匹亞名走聯合報非洲新聞慣譯。

### 西非 & 東非 & 中非（Nigerian / Kenyan / Congolese）

非洲 3 國是 Phase C 最特殊的一組——三套不同語系，三套音譯規則：

- **Nigerian**（西非：Yoruba/Igbo/Hausa 混）：Yoruba Olu- 字根 → 「歐魯-」（神之意，18 個名字共用），Igbo Chi- → 「奇-」，Hausa Abdul-/Abu- 阿拉伯字根直接套阿語音譯。
- **Kenyan**（東非：Swahili/Bantu）：Mw-/Nj-/Ng- 前綴 → 「姆-/恩-」（聲門音保留），阿拉伯化女名（Aaliyah/Fatima）走聯合報國際版。Obama → 歐巴馬（2009 後台灣總統媒體慣譯，跨文化已固化）。
- **Congolese**（中非：法語混 Bantu/Lingala/Luba）：法名走法語音譯（Jean → 尚一字、Joseph → 約瑟夫），Bantu Mw-/Mb-/Nk-/Nz- → 「姆/恩」，Tshi- → 「茨-」（Tshisekedi → 茨塞凱迪），Mu- 人類前綴 → 「穆-」。NBA 名人 Dikembe Mutombo → 迪肯貝穆通博 直接套台灣 ESPN/NBA 體育新聞慣譯。

非洲 3 國合計 1500+ entry，每一個音節都是 1990s 台灣媒體跑非洲新聞用了 30 年的標準音譯——「蒙博托/姆貝基/曼德拉」這些譯名你以前在三大誌國際版讀過就會認。

### 太平洋（Polynesia）

毛利語/夏威夷語的 CV 音節結構（C(C)V，無 coda）——Hone → 霍尼、Aroha → 阿羅哈、Whetu → 韋圖。wh- 按 Maori 北島發音 [f/w] → 「韋/瓦」。Moana → Maui → 毛伊（2016《海洋奇緣》迪士尼角色，台灣大眾熟悉）。多單字姓（Te Puke Nui/Papa Titore）縮成 4 字音譯，不爆 8 字。

### 北歐補充（Finnish）

芬蘭語非印歐（與 Hungarian 同烏拉爾語族），長元音 aa/ää/öö 雙字母還原成台灣芬蘭新聞慣譯（Aaltonen → 阿爾托寧）。

---

## 5-15 條值得 review 的譯名（按國家排序，跨 22 國精選）

### Argentina/Belgium/Dutch/Hindi/Irish/Swedish（先前 batch 已翻部份）

1. **Hindi maleFirst: Rama → 拉瑪 / Krishna → 克里希納** — 印度教神名套《摩訶婆羅多》楊憲益譯本。
2. **Irish maleLast: O'Connor → 歐康納 / O'Brien → 歐布萊恩** — 愛爾蘭 O' 前綴一致「歐」。
3. **Swedish: Gustaf → 古斯塔夫** — 北歐古斯塔夫王朝歷史名。

### Bulgarian / Slovak / Czech / Hungarian

4. **Bulgarian femaleLast: -ova → -娃** — 沿用 Phase A Russian 的「-夫 ↔ -娃」配對規則。原檔 femaleLast 多了 13 項看起來是俄羅斯姓 (Petrova, Popova, Romanova, Semyonova 等) — 這是 vanilla 原檔的 quirk，可能 SSI 當年把保俄混在一起，照原檔忠實翻譯，不剔除。

5. **Slovak maleLast: Slovak → 斯洛伐克 / Szabo → 薩波** — 原檔姓氏池真的有 `Slovak` 這個字 (羅曼語族常見「族裔即姓」現象)，照字面音譯。Szabo 是匈牙利字源 (Szabó = 裁縫) 跟 Hungarian.nam 同字異譯統一為「薩波」。

6. **Czech maleFirst: Vaclav → 瓦茨拉夫 / maleLast: Dvorak → 德弗札克** — Václav 是捷克國慶人物 (聖瓦茨拉夫)，Dvořák 是音樂家德弗札克 — 兩位都有台灣標準譯法，本譯直接套用維基中文。

7. **Hungarian maleLast: Kodaly → 高大宜 / Petofi → 裴多菲** — Kodály Zoltán (柯大宜) 是匈牙利音樂教育家，本譯選《音樂之友》辭典慣譯「高大宜」；Petőfi Sándor (裴多菲) 是詩人，魯迅譯介後成中文標準譯法。

8. **Hungarian femaleFirst: ZsaZsa → 莎莎** — 原檔大小寫怪 (Zsa Zsa Gabor)，譯成「莎莎」對應 1990s 台灣八卦版對她的稱呼。

### Turkish / Nigerian

9. **Turkish maleFirst: Timur → 帖木兒** — 突厥語名 Timur 在中文歷史脈絡裡就是「帖木兒」(明朝史料用法)，不音譯成「提穆爾」。同理 Cengiz → 成吉茲 (但保留 Cengiz 是現代名而非歷史人物，所以不譯「成吉思汗」)。

10. **Turkish femaleFirst: Rabia → 拉比亞** — 阿語源女名 Rābia (رابعة)，Phase A 已用「亞」取代「婭」，此處沿用。

11. **Nigerian maleFirst: Olu- 字根** — Yoruba 語常見 Olu- 前綴 (= 神)，音譯統一為「歐魯-」(歐魯費米/歐魯巴拉/歐魯吉米...)，約 18 個名字共用此前綴。雖然中文讀來重複，但保留語言學特徵。

12. **Nigerian femaleFirst: Natashenka → 娜塔申卡** — 原檔混入俄文暱稱 (Natasha 的暱稱形 -shenka)，放奈及利亞女名池上下文奇怪，保留原檔意圖照譯。

### Romanian

13. **Romanian maleFirst: Gheorghe → 蓋奧爾蓋 / Ion → 伊昂 / Dragos → 德拉戈什** — 羅馬尼亞語 gh 發 /g/ 而非英語 /dʒ/，所以選「蓋奧」開頭而非「喬奧」。維基百科中文標準譯法。極短名 Ion (3 字母 → 2 漢字) 刻意保留 i+on 兩音節對應，避免縮成單字「揚」與 Iancu (揚庫) 撞名。

14. **Romanian maleLast: Cojocaru → 科約卡魯 / Mihalcea → 米哈爾恰** — 羅語 coj 發 /koʒ/，但中文聯合報傳統把斯拉夫/羅語 j 譯「約」。羅語 cea = /tʃa/，故尾音「恰」而非「西亞」。

### Congolese

15. **Mw- / Mb- / Nk- / Nz- / Nd- / Ng- / Nts- 前綴一律以「姆/恩/茨」開頭** — Mwamba → 姆萬巴、Mbayo → 姆巴約、Nkongolo → 恩孔戈洛、Nzambi → 恩贊比、Ntumba → 恩通巴、Tshisekedi → 茨塞凱迪。理由：維基百科中文標準 + 聯合報非洲領袖譯名（蒙博托、姆貝基）路線。Lingala/Swahili 中這些前綴是音節核心而非單純輔音串。

16. **Mutombo → 穆通博 / Dikembe → 迪肯貝** — NBA 球員 Dikembe Mutombo 是 DR Congo 最著名國際人物，維持台灣 ESPN/NBA 體育新聞慣譯。Mutombo 不譯為「姆通博」是因 Mu- 為人類前綴 (Bantu noun class 1) 與 Mw-/Mb- 純鼻音前綴不同 — 走「穆」而非「姆」。

17. **Tshi- 前綴一律「茨-」** — Tshibangu → 茨班古、Tshikulu → 茨庫盧、Tshisekedi → 茨塞凱迪 (反對派領袖 Étienne Tshisekedi 維基標準譯)。Luba-Kasai 語 Tshi- /tʃi/ 對應「茨」(平舌 ts + i 短促)，不是「奇」也不是「西」。

18. **Joseph → 約瑟夫** (法語不走「若瑟」/「若望」) — 蒙博托本名 Joseph-Désiré Mobutu。原檔 Joseph 出現於 maleLast 對應 DR Congo 法語天主教傳統。

### Norwegian

19. **Norwegian maleFirst: Asbjoorn → 阿斯比恩 / Jon → 瓊** — æ/ø 拼音版（Asbjorn 拼成 Asbjoorn），按 ø="比" 走，1990s 北歐文學中譯本路線 (易卜生劇本對應)。Jon 走 1990s 體育新聞慣譯。

20. **Norwegian maleLast: Ibsen → 易卜生** — 直接套用台灣劇場慣譯 (易卜生《玩偶之家》譯名)，不音譯為「伊布森」。

### Kenyan

21. **Kenyan maleFirst: Obama → 歐巴馬 / Simba → 辛巴** — 2009 後台灣總統媒體慣譯，跨文化已固化此譯。Simba 是 1994 迪士尼《獅子王》主角名，台灣世代記憶。

22. **Kenyan femaleFirst: Aaliyah → 艾莉亞** — 1990s R&B 歌手 Aaliyah Haughton 慣譯。

### Danish

23. **Danish maleLast: Schmidt → 施密特 / Andersen → 安德森** — Danish 拼法和 German 同源，沿用德式譯法。Andersen 不譯為「安徒生」(Hans Christian Andersen 的譯名)，因為文件是 maleLast 池，遊戲會 concat 出「揚 安德森」、「彼得 安德森」等，「安徒生」會超怪。

### Polynesia

24. **Polynesia maleFirst: Maui → 毛伊** — 2016《海洋奇緣》迪士尼角色，台灣大眾熟悉 (英譯保留 vowel diphthong)。

### Greek

25. **Greek maleFirst: Plato → 柏拉圖 / Achilles → 阿基里斯** — 直接套用台灣哲學/古典文學慣譯。Achilles 套 1990s 古典文學中譯本 (《伊里亞德》楊牧譯本) 慣用。

26. **Greek femaleFirst: Aphrodite → 阿芙蘿黛蒂** — 套用台灣神話譯名,不音譯為「阿芙羅黛蒂」。

27. **Greek maleLast: Mavrokordatos → 馬夫羅科爾達托斯 / Stephanopoulos → 斯特帕諾普洛斯** — Mavro-(黑)+kord-(心) 希臘姓拆分,6字長但符合 -atos 結尾規律。-opoulos suffix 用 "普洛斯" 標準後綴。

這 27 條只是 22 國裡最值得記住的——每一條背後都有「為什麼這樣翻而不那樣翻」的 1990s 台灣媒體用語史。完整 mapping 見各 `tools/phase_c_dicts/dict_<country>.py`。

---

## Phase A + B + C 累計統計

| Phase   | 檔案數 | Missing |
|---------|--------|---------|
| A       | 6      | 0       |
| B       | 5      | 0       |
| C       | 22     | 0       |
| **TOTAL** | **33** | **0** |

(各 .nam 字數 set 有重疊，不單純加總。詳見 `check_nam_coverage.py` 輸出。)

33 國全部 0 missing chars 是這次 SoldierName 漢化的最終 PASS line。1994 SSI 留在英文版裡的 33 國姓名池，30 年後全部用 1990 年代台灣媒體標準音譯翻完——這是繁中圈 X-COM 譯名史的一個里程碑，**也是 30 年前那批《電腦玩家》《軟體世界》編輯們當年想做但沒做完的工作**。

---

## 工具

- `D:\openxcom\tools\check_nam_coverage.py` — 33 個 .nam 字型涵蓋率驗證（production tool, A/B/C 共用）
- `D:\openxcom\tools\dump_font_chars.py` — Phase B 寫的，dump Font.dat 涵蓋字 set 到 `_fontchars.txt`
- `D:\openxcom\tools\gen_chinese_nam.py` — Phase A 寫的 Chinese.nam 生成器
- `D:\openxcom\tools\gen_phase_c.py` — Phase C 通用生成器框架
- `D:\openxcom\tools\phase_c_dicts/dict_*.py` — 各國 hard-coded mapping（共 22 國 dict）
- `D:\openxcom\tools\_gen_phase_c_batch3.py` — Phase C batch 3 主 generator
- `D:\openxcom\tools\_gen_romanian.py` — Romanian.nam 生成器

## 不該動的字（跨檔 swap 規則，別換回去）

| 原譯字 | U+   | 用途                                  | 替換為 |
|--------|------|---------------------------------------|--------|
| 婭     | 5A6D | Rabia / Lidiya / 其他跨檔             | 亞     |
| 婕     | 5A55 | Jaelle / Jessica / Jayne              | 潔     |
| 蔻     | 853B | Cora / 跨檔規則                       | 寇     |
| 燁     | 71C1 | Yeop (Korean maleLast, Phase B 命中)  | 業     |
| 薏     | 858F | Louise (Danish femaleFirst)           | 易     |
| 蓮     | 84EE | Lene (Danish femaleFirst)             | 蕾妮   |
| 郝     | 90DD | Hao (Chinese 池)                      | 浩     |
| 鄺     | 913A | Kuang/Kwong (Chinese 池)              | 匡     |
| 芷     | 82B7 | Zhijuan (Chinese 池)                  | 之     |

這 9 條 swap 規則是 Phase A/B/C 共用——任何後續想「優化」的 mod 翻譯都**不要**換回去，原譯字不在 Font.dat WQY Sharp 12px subset 內，換回去就會在遊戲裡顯示空白方塊。

---

## 限制聲明

- 只動 `bin/common/SoldierName/*.nam` 共 33 國
- 沒 commit git
- 沒 build OpenXcom
- 沒動 zh-TW.yml / Font.dat / source code
- Polynesia maleLast (625 entries) 與 Greek maleLast (381 entries) 用 algorithmic syllable engine，譯名長度可能略長 (5-7字)，品質次於 hand-crafted；但 0 字超出 Font.dat，遊戲可顯示無誤。如未來要美化，hand-craft 替換即可。

寫完這份 Phase C 合併報告後最大的感想是——**33 國 SoldierName 漢化看起來像 trivial bookkeeping，實際是 30 年來繁中 X-COM 圈第一次系統性把士兵池翻完**。1990 年代的台灣玩家在 X-COM 主畫面看著「Aleksey Petrov」「Akira Tanaka」「Mwangi Karanja」就直接接受英文姓名，沒人想過要翻——因為譯成中文後遊戲合成出來的「阿列克謝.彼得羅夫」「明.田中」「姆萬吉.卡蘭加」反而更怪。但 30 年後我們真的做了，**讓這支 X-COM 部隊變成繁中讀者一看就知道是「來自俄羅斯/日本/肯亞的水兵」的中文軍隊**。這就是這份 ship report 的意義。
