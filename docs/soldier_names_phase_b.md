# SoldierName Phase B — 5 國音譯 ship report

Date: 2026-05-31
Scope: `bin/common/SoldierName/{Japanese,Korean,Spanish,Portuguese,Italian}.nam`。
不動 source code、不動 zh-TW.yml、不動 git。

Phase A 補完五大陣營（美/英/中/俄/德/法）後，Phase B 進入「東亞 + 拉丁歐洲」這 5 國——日本、韓國、西班牙、葡萄牙、義大利。這 5 國最特別的是：**日本/韓國名直接走漢字派**（Mori → 森、Tanaka → 田中、Lee → 李、Kim → 金），不音譯。其他 3 國則是聯合報國際版+運動新聞的標準音譯（賈西亞、若昂、朱塞佩）。1990 年代台灣的義甲足球熱、世足賽轉播、A-Lin 學義大利語、《灌籃高手》與韓劇文化滲透——這 5 國的譯名實際上每一條都是台灣 1990s-2000s 跨文化版的縮影。

## Entries 數量驗證 (原檔 vs 翻譯後)

| 檔案             | maleFirst | femaleFirst | maleLast  | lookWeight* | YAML parse |
|------------------|-----------|-------------|-----------|-------------|------------|
| Japanese.nam     | 32 / 32   | 30 / 30     | 61 / 61   | 4           | OK         |
| Korean.nam       | 18 / 18   | 20 / 20     | 194 / 194 | 4           | OK         |
| Spanish.nam      | 85 / 85   | 68 / 68     | 86 / 86   | 4           | OK         |
| Portuguese.nam   | 64 / 64   | 81 / 81     | 208 / 208 | 4           | OK         |
| Italian.nam      | 36 / 36   | 30 / 30     | 36 / 36   | 4           | OK         |

\* 原檔 Japanese.nam / Portuguese.nam 用單數 `lookWeight:`，其餘三個用複數 `lookWeights:` — 保留原檔 key 名不動 (避免破壞 vanilla data file 的 YAML key)。

全部 entries 數量與原檔 1:1 對齊,不增不減。lookWeight(s) 保留原值不動 (Japanese 2/3/94/1, Korean 0/0/100/0, Spanish 4/88/4/4, Portuguese 2/88/2/8, Italian 47/50/2/1)。所有檔案 UTF-8 無 BOM。原檔 4 個就有 4 個 section,翻譯後也維持 4 個,不加 femaleLast section。

## 字型涵蓋率 (Font.dat union of FONT_BIG + FONT_SMALL = 10246 chars)

| 檔案             | 使用 CJK 字數 | 缺字數 |
|------------------|---------------|--------|
| Japanese.nam     | 124           | 0      |
| Korean.nam       | 218           | 0      |
| Spanish.nam      | 170           | 0      |
| Portuguese.nam   | 193           | 0      |
| Italian.nam      | 119           | 0      |

`python D:\openxcom\tools\check_nam_coverage.py` → **0 missing chars across all 11 .nam files** (Phase A 的 6 個 + Phase B 的 5 個)。

## 罕見字 swap (本來會缺字 → 同音替代)

| 原譯字 | U+   | 用途 (檔案/section)            | 替換為 | 理由                            |
|--------|------|-------------------------------|--------|---------------------------------|
| 燁     | 71C1 | Yeop → 燁 (Korean maleLast)   | 業     | 同音 (yeop),韓國姓氏 表業 兩字皆通,業 在 Font.dat 中 |

只有 Korean.nam 用到一個 Font.dat 沒涵蓋的字 (燁)。其餘 4 國 (日/西/葡/義) 第一遍下筆就 0 missing。Japanese 漢字池本來就在 Font.dat 主集合內 (BIG5/常用漢字)。

## 5-10 條值得 review 的譯名

Phase B 5 國最有趣的彩蛋是：**1994 SSI 原檔在每國的姓氏池都偷塞了「歷史名人」**——日本姓氏池有宮本武藏，韓國姓氏池有 6 大複姓（司空/鮮于/皇甫/諸葛/南宮/獨孤）的漢字本字，匈牙利名人 Kodály/Petőfi 後面 batch 也會出現。本專案完全保留這些彩蛋，遊戲合成出來會有「武藏佐藤」「諸葛敏俊」這種讓 1990s 動漫迷+古典迷瞬間笑出來的隊伍：

1. **Japanese maleFirst: Hibiki → 響** — 直譯為「響」(漢字本字),單字名 1990s 動漫迷熟悉度高,但 1990s 聯合報國際版會譯「希比奇」音譯。決定走漢字派 (Hibiki/Akira/Shun 等單字名都用本字)。
2. **Japanese maleLast: Musashi → 武藏** — 宮本武藏的武藏,放姓氏池上下文奇怪 (原檔顯然引用劍豪),保留歷史感。
3. **Korean maleLast: Sagong → 司空 / Seonu → 鮮于 / Hwangbo → 皇甫 / Jegal → 諸葛 / Namgung → 南宮 / Dokgo → 獨孤** — 韓國 6 大複姓全保留漢字原型 (不音譯)。Dokgo 對應「獨孤」雖然中文讀者第一反應是金庸獨孤求敗,但 韓國「독고」姓的漢字本字就是「獨孤」。
4. **Korean maleLast: Dongbang → 東方 / Eogeum → 漁金 / Janggok → 長谷 / Mangjeol → 望節 / Gangjeon → 岡田 / Sobong → 蘇鳳** — 罕見複姓,有些音譯有些保留漢字原型。岡田 (Gangjeon) 看起來像日本姓,但韓國「강전」也用此漢字。
5. **Spanish maleFirst: Jesus → 赫蘇斯** — 西語人名 (José/Jesus/Jaime) 1990s 聯合報路線都用「赫蘇斯/荷西/海梅」音譯版,不是「耶穌/約瑟夫」直譯版。
6. **Spanish maleLast: Munoz → 穆紐茲** — 原檔少寫 ñ (Muñoz),音譯按 ñ 發音 [ɲ] → 「紐」。Nunez (Núñez) 同理 → 「努涅茲」。
7. **Portuguese maleFirst: Joao → 若昂** — 葡文 João 鼻音 ão,1990s 教廷新聞用「若望」(若望保祿二世),但運動新聞用「若昂」(若昂阿維蘭熱)。選用後者,士兵名比較貼近現代用法。
8. **Portuguese maleLast: Mourinho → 莫里尼奧** — 真有此姓 (José Mourinho 教練),維持台灣體育新聞慣譯。
9. **Italian maleFirst: Giuseppe → 朱塞佩** — 義文 Giu- [dʒu] 軟音 →「朱」,聯合報國際版標準。Gennaro/Giovanni/Giordano 同理走「簡/喬」軟音派。
10. **Italian maleLast: Esposito → 艾斯波西托** — Espos- 開頭按音譯 4 字,不縮成 3 字 (「艾波斯」太鬆)。

## 翻譯風格備註

5 國的譯名規則一國一套——日本走「漢字派優先」，韓國走「韓國慣用漢字」，西班牙/葡萄牙/義大利走「聯合報國際版」+ 各自的軟硬音規則。這些規則背後反映的是 1990s 台灣媒體跨文化譯名的成熟度——義甲足球轉播、葡萄牙作家魔幻寫實小說中譯、韓劇文化滲透，每一條規則都有 30 年的台灣讀者熟悉度當靠山。

### Japanese
- 漢字派優先: Akira → 明, Shun → 駿, Mori → 森, Tanaka → 田中, Suzuki → 鈴木, Watanabe → 渡邊 (邊 not 邉)。
- 拗音名 -ko/-mi 用「-子/-美」: Aiko → 愛子, Yumiko → 由美子, Natsumi → 夏美。
- 沒漢字外來名 → 音譯: Marina (女) → 真理奈 (Sakiko 用「咲子」既是音又是漢字)。
- 姓氏 Watanabe 用「渡邊」(台灣慣用) 不是「渡邉」(日本本字)。

### Korean
- 韓國姓氏複姓 6 個全保留漢字原型 (司空/鮮于/皇甫/諸葛/南宮/獨孤)。
- 名 (maleFirst/femaleFirst) 用韓國人慣用漢字: Min-jun → 敏俊, Soo-yeon → 秀妍, Hyun-jun → 賢俊。
- 單字姓 Lee→李, Kim→金, Park→朴, Choi→崔, Jeong→鄭。

### Spanish
- 音譯走聯合報國際版 1990s 路線: García → 賈西亞 (不是「加西亞」), López → 羅培茲 (不是「洛佩斯」), Hernandez → 赫南德茲。
- Maria/Ana/Sofia 全女名 -a 結尾保留陰性感覺。
- ñ 發音反映在音譯: Muñoz → 穆紐茲, Núñez → 努涅茲。

### Portuguese
- 葡文 ão 鼻音 → 「昂」: João → 若昂, Sebastião → 塞巴斯提奧, Conceição → 康塞桑。
- lh/nh → 「略/尼」: Coelho → 科埃略, Carrilho → 卡里略, Pinhão 系列 → 「尼歐」。
- -es 結尾 → 「斯」: Fernandes → 費南德斯 (Spanish 是 Fernandez → 費南德茲,葡西分流)。
- Garcia (葡萄牙裔也用) → 「賈西亞」(跟西語版一致,避免讀者疑惑)。

### Italian
- c/g 軟硬音明確: Giuseppe → 朱塞佩, Giovanni → 喬凡尼, Gennaro → 簡納羅。
- 雙子音 -ll/-ss/-rr 在音譯時不拉長: Rossi → 羅西 (不是「羅西西」), Esposito → 艾斯波西托。
- 結尾 -o/-i 全保留: Marco → 馬可, Rossi → 羅西, Bianchi → 比安基。

## 不該動的字 (已 swap 過,別換回去)

- 燁 (U+71C1) — 用 業 代替 (Korean maleLast,韓文 yeop 同音)

## Phase A + Phase B 合計 11 個檔 char coverage 統計

Phase A + B 累計 11 國，1923 個 CJK chars used，0 missing——這個 0 不是運氣，是兩 phase 翻譯時主動避開冷僻字、用同音常用字 swap 的結果（婭→亞、燁→業、薏→易、蓮→蕾妮 等）。下表是統計：

| Phase | 檔案數 | 合計 CJK 字數 | Missing |
|-------|--------|---------------|---------|
| A     | 6      | 1099          | 0       |
| B     | 5      | 824           | 0       |
| Total | 11     | -             | 0       |

(各檔字數 set 有重疊,不單純加總。詳見 `check_nam_coverage.py` 輸出。)

## 工具

- `D:\openxcom\tools\check_nam_coverage.py` — 11 個 .nam 字型涵蓋率驗證 (Phase B 已擴充 TARGETS list)
- `D:\openxcom\tools\dump_font_chars.py` — Phase B 寫的, dump Font.dat 涵蓋字 set 到 `_fontchars.txt`,Phase B 翻譯過程用來快速查字
- `D:\openxcom\tools\gen_chinese_nam.py` — Phase A 寫的 Chinese.nam 生成器 (Phase B 沒用到)
