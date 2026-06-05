# SoldierName Phase C Batch 2 — 6 國音譯 ship report

Date: 2026-06-01
Scope: `bin/common/SoldierName/` 中 Bulgarian / Slovak / Turkish / Nigerian / Czech / Hungarian 共 6 國。
Phase A / B / C-batch1 已完成的 22 國（American/British/Chinese/Russian/German/French/Japanese/Korean/Spanish/Portuguese/Italian/Arabic/Hindi/Dutch/Irish/Belgium/Swedish/Romanian 等）**本次未動**。

## Entries 數量驗證 (翻譯後 vs upstream HEAD)

| 檔案           | maleFirst   | femaleFirst | maleLast    | femaleLast | YAML parse | lookWeight key |
|----------------|-------------|-------------|-------------|------------|------------|-----------------|
| Bulgarian.nam  | 65 / 65     | 59 / 59     | 59 / 59     | 74 / 74    | OK         | `lookWeights`   |
| Slovak.nam     | 38 / 38     | 35 / 35     | 64 / 64     | 38 / 38    | OK         | `lookWeights`   |
| Turkish.nam    | 155 / 155   | 81 / 81     | 156 / 156   | — / —      | OK         | `lookWeights`   |
| Nigerian.nam   | 103 / 103   | 181 / 181   | 118 / 118   | — / —      | OK         | `lookWeight` *  |
| Czech.nam      | 167 / 167   | 125 / 125   | 107 / 107   | 33 / 33    | OK         | `lookWeights`   |
| Hungarian.nam  | 100 / 100   | 140 / 140   | 243 / 243   | — / —      | OK         | `lookWeights`   |

\* Nigerian 原檔本來就拼 `lookWeight` (單數)，跟 Japanese / Portuguese 同款雜亂；保留原 key 名避免破壞 vanilla data。

全部 entries 數量與原檔 HEAD 一致，不增不減。lookWeight(s) 數值保留原值不動（Bulgarian 50/50/0/0, Slovak 45/55/0/0, Turkish 8/16/8/1, Nigerian 0/0/0/100, Czech 50/50/0/0, Hungarian 50/50/0/0）。所有檔案 UTF-8 無 BOM。Turkish / Nigerian / Hungarian 原檔本來就沒 femaleLast section，翻譯後維持不加。

合計新增翻譯 entries: 65+59+59+74 + 38+35+64+38 + 155+81+156 + 103+181+118 + 167+125+107+33 + 100+140+243 = **2141 entries**。

## 字型涵蓋率 (Font.dat FONT_BIG + FONT_SMALL union = 10246 chars)

| 檔案           | 使用 CJK 字數 | 缺字數 |
|----------------|---------------|--------|
| Bulgarian.nam  | 115           | 0      |
| Slovak.nam     | 132           | 0      |
| Turkish.nam    | 154           | 0      |
| Nigerian.nam   | 175           | 0      |
| Czech.nam      | 192           | 0      |
| Hungarian.nam  | 204           | 0      |

`python D:\openxcom\tools\check_nam_coverage.py` →
**0 missing chars across all 33 .nam files** (Phase A 6 + Phase B 5 + Phase C batch1 7 + Phase C batch2 6 + 4 個尚未翻 = 28 個有 CJK 內容；Kenyan/Danish/Polynesia/Greek 4 個還是英文不在本批範圍)。

## 罕見字 swap (本批)

| 原譯字 | U+   | 用途                              | 替換為 | 理由                                       |
|--------|------|-----------------------------------|--------|--------------------------------------------|
| 婭     | 5A6D | Rabia → 拉比婭 (Turkish femaleFirst) | 亞     | 拉比亞 (Phase A 已 swap 過,沿用 -婭→-亞 規則) |

只有 Turkish 一處踩到 Phase A 已 swap 過的字。Bulgarian / Slovak / Nigerian / Czech / Hungarian 5 國第一遍下筆就 0 missing。

## 5-10 條值得 review 的譯名

1. **Bulgarian femaleLast: -ova → -娃** — 沿用 Phase A Russian 的「-夫 ↔ -娃」配對規則。原檔 femaleLast 多了 13 項看起來是俄羅斯姓 (Petrova, Popova, Romanova, Semyonova, Smirnova, Sokolova, Solovyova, Stepanova, Vasilyeva, Volkova, Vorobyova, Yakovleva, Zaitseva, Zaharova) — 這是 vanilla 原檔的 quirk，可能 SSI 當年把保俄混在一起，照原檔忠實翻譯，不剔除。

2. **Slovak maleLast: Slovak → 斯洛伐克 / Szabo → 薩波** — 原檔姓氏池真的有 `Slovak` 這個字 (羅曼語族常見「族裔即姓」現象)，照字面音譯。`Szabo` 是匈牙利字源 (Szabó = 裁縫) 跟 Hungarian.nam 同字異譯統一為「薩波」。

3. **Turkish maleFirst: Timur → 帖木兒** — 突厥語名 Timur 在中文歷史脈絡裡就是「帖木兒」(明朝史料用法)，不音譯成「提穆爾」。同理 Cengiz → 成吉茲 (但保留 Cengiz 是現代名而非歷史人物，所以不譯「成吉思汗」)。

4. **Turkish femaleFirst: Rabia → 拉比亞** — 阿語源女名 Rābia (رابعة),Phase A 已用「亞」取代「婭」,此處沿用。

5. **Nigerian maleFirst: Olu- 字根** — Yoruba 語常見 Olu- 前綴 (= 神),音譯統一為「歐魯-」(歐魯費米/歐魯巴拉/歐魯吉米...),約 18 個名字共用此前綴。雖然中文讀來重複,但保留語言學特徵。

6. **Nigerian femaleFirst: Natashenka → 娜塔申卡** — 原檔混入俄文暱稱 (Natasha 的暱稱形 -shenka),放奈及利亞女名池上下文奇怪,保留原檔意圖照譯。

7. **Czech maleFirst: Vaclav → 瓦茨拉夫 / maleLast: Dvorak → 德弗札克** — Václav 是捷克國慶人物 (聖瓦茨拉夫),Dvořák 是音樂家德弗札克 — 兩位都有台灣標準譯法,本譯直接套用維基中文。

8. **Hungarian maleLast: Kodaly → 高大宜** — Kodály Zoltán (柯大宜) 是匈牙利音樂教育家,台灣音樂界慣用「柯大宜」或「高大宜」,本譯選後者 (與《音樂之友》辭典一致)。

9. **Hungarian maleLast: Petofi → 裴多菲** — 詩人 Petőfi Sándor (裴多菲),魯迅譯介後成中文標準譯法,不另音譯。

10. **Hungarian femaleFirst: ZsaZsa → 莎莎** — 原檔大小寫怪 (Zsa Zsa Gabor),譯成「莎莎」對應 1990s 台灣八卦版對她的稱呼。

## 翻譯風格備註

### Bulgarian (斯拉夫語族)
- maleLast -ov / femaleLast -ova: 「-夫 / -娃」配對 (Petrov → 彼得羅夫 / Petrova → 彼得羅娃)。
- Bulgarian 西里爾 → 拉丁化拼寫的 zh / sh / ts 對應「日 / 什 / 茨」(Zhivko → 日夫科, Tsvetan → 茨維坦)。
- 雙名 Borislav / Vladislav 之類有 -slav 結尾,統一「-斯拉夫」。

### Slovak
- 跟 Czech 接近但 háček (š/č/ř) 處理一致 (Kovač → 科瓦奇,Novák → 諾瓦克)。
- 男姓 -sky 結尾 →「-斯基」(Bosansky → 波山斯基)。
- 女姓 -ová 結尾「-娃」(Banasova → 巴納索娃)。

### Turkish (突厥語族,非印歐)
- ı (無點 i) 多譯「爾」(Demir → 德米爾, Yılmaz → 伊爾馬茲)。
- ş /ʃ/ →「什 / 希」(Tahsin → 塔赫辛)。
- ç /tʃ/ →「奇 / 齊」(Çenk → 真克)。
- 帶 H 阿語源名統一用「赫 / 哈」(Halil → 哈利勒, Hayri → 海里)。

### Nigerian (西非多語系: Yoruba/Igbo/Hausa)
- Yoruba Olu- (= 神) →「歐魯-」(統一)。
- Igbo Chi- (= 神,個人保護神) →「奇-」(Chioma → 奇奧瑪)。
- Hausa Abdul- / Abu- 阿拉伯字根 →「阿卜杜 / 阿布」音譯。
- Nwa- (Igbo 男孩) →「恩瓦-」(Nwabudike → 恩瓦布迪克)。

### Czech (西斯拉夫)
- háček (š/č/ř/ě) 體現音譯: Václav → 瓦茨拉夫 (V- 不軟化), Dvořák → 德弗札克 (ř 不用「日」用「札」)。
- maleLast -ek / -ka 結尾 →「-克 / -卡」(Janecek → 雅內切克, Hruska → 赫魯斯卡)。
- 名人姓氏直接用台灣標準譯法 (Dvořák → 德弗札克, Kafka 不在池內但同理)。

### Hungarian (馬扎爾語,非印歐)
- 母音 á/é/í/ó/ú 譯為長音節 (Árpád → 阿爾帕德)。
- sz /s/ → 「斯」(Szabó → 薩波, 不譯「茲」)。
- gy /ɟ/ → 「久 / 焦」(Györgyi → 焦爾吉, György → 焦爾吉)。
- ő/ű 圓唇音 → 「厄 / 烏」(Erő → 厄羅, Tűz → 圖茲)。
- 名人 Kodály / Petőfi / Liszt 用慣用譯法 (高大宜/裴多菲)。

## 不該動的字 (已 swap 過,別換回去)

- 婭 (U+5A6D) — Phase A 起就 swap 為「亞」。Turkish Rabia 用此規則 (拉比亞)。

## Phase A + B + C-batch1 + C-batch2 合計 28 個檔 char coverage 統計

| Phase   | 檔案數 | 累計 entries | Missing |
|---------|--------|--------------|---------|
| A       | 6      | ~ 1099 chars | 0       |
| B       | 5      | ~ 824 chars  | 0       |
| C-bat1  | 7      | (1 新譯)     | 0       |
| C-bat2  | 6      | 2141 entries | 0       |
| Total   | 24     | -            | 0       |

(各檔字數 set 有重疊,不單純加總。`check_nam_coverage.py` 顯示 33 個 .nam 全 0 missing — Kenyan/Danish/Polynesia/Greek 4 個目前 CJK chars=0 表示尚為英文,不在本 batch 範圍。)

## 後續 batches 待做 (Phase C 剩餘)

仍為英文待翻 (依 check_nam_coverage.py "CJK chars used=0"):
**Congolese 已在本次 coverage check 顯示 chars used=186 — 此檔不在本 agent 任務列表但已被先前 batch 翻完。** 同樣 Argentina / Ethiopian / Finnish / Norwegian 顯示已翻完。

真正剩 4 國: **Kenyan / Danish / Polynesia / Greek**。

## 工具

驗證工具 (Phase A 已有,本 batch 沿用):
- `D:\openxcom\tools\check_nam_coverage.py` — 33 個 .nam 字型涵蓋率驗證 (TARGETS list 已含 Phase C 全部)
- `D:\openxcom\tools\_fontchars.txt` — Font.dat 涵蓋字 set dump,翻譯期間 pre-check 用

本批未新增 production 腳本。
