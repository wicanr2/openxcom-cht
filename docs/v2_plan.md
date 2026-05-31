# OpenXcom 繁中化 v2 設計文件

> 範圍：規劃 v2.0–v2.3 字型、UI、翻譯整體路線。  
> 基準：vanilla master `v1.0.1edb0a5a2-dirty`，build 在 `build-win64-release/bin/Release/openxcom.exe`。  
> 字源：WQY Zen Hei Sharp (Apache 2.0)。  
> 路徑均相對於 `D:\openxcom\OpenXcom\`。

---

## 0. 程式碼面已確認事實（影響後續決策）

- [Font.cpp:193](src/Engine/Font.cpp:193) `Font::getHeight()` 回傳 `_images[0].height` —— **per-image override 對 line step 無效**，line step 永遠用第一張 image（多半是英文 `FontBig.png` / `FontSmall.png`）的高度。
- [Font.cpp:50](src/Engine/Font.cpp:50) `Font::load` 接受 `images[].width/height/spacing` 個別 override（已在 [Font.dat:16-18,37-40](bin/common/Language/Font.dat) 用上）。
- [Text.cpp:333](src/Interface/Text.cpp:333) 與 [Text.cpp:405](src/Interface/Text.cpp:405) push `font->getCharSize('\n').h` 到 `_lineHeight`；`\n` 是 non-printable，走 [Font.cpp:236](src/Engine/Font.cpp:236) 的 `getHeight() + getSpacing()` 分支 → 結論：**line step 等於 global height**。
- [State.cpp:138,204](src/Engine/State.cpp:138) 所有 State 預設 `initText(FONT_BIG, FONT_SMALL)`。只有 Geoscape 主畫面按鈕和 Globe label 改用 FONT_GEO_BIG/SMALL（[GeoscapeState.cpp:231](src/Geoscape/GeoscapeState.cpp:231) 起 12 次、[Globe.cpp:1284,1312](src/Geoscape/Globe.cpp:1284)）。
- 其餘 Battlescape / Inventory / ActionMenu / ModList / OptionsAdvanced 等只是 override 局部 widget，**主字流仍是 FONT_BIG/SMALL**。

---

## 1. 各 UI screen 字型策略

| Screen | 主要 Font | 次要 Font | 文字密度 | 建議 zh-TW cell |
|---|---|---|---|---|
| Main menu | FONT_BIG | FONT_SMALL | 低（每鍵 2–3 字） | Big 18×18 / Small 16×16 |
| Geoscape 主畫面（時鐘、按鈕、月份/星期） | FONT_GEO_BIG / FONT_GEO_SMALL | — | 極低（每鍵 2–4 字） | GeoBig 9×11 / GeoSmall 8×9 |
| Geoscape 地名 label（Globe） | FONT_BIG | FONT_SMALL | 中（國家/城市名） | 同 Big 18×18 |
| Battlescape HUD + ActionMenu | FONT_BIG | FONT_SMALL | 中高（彈藥/動作） | Big 16×16 / Small 14×14（密） |
| Inventory | FONT_BIG | FONT_SMALL | 中 | 同 Battlescape |
| Basescape 各子畫面 | FONT_BIG | FONT_SMALL | 高（表格） | Big 16×16 / Small 14×14 |
| Briefing / Debriefing | FONT_BIG | FONT_SMALL | 高（長段落） | Big 16×16 / Small 14×14，需 line spacing 修 |
| Ufopedia | FONT_BIG | FONT_SMALL | 高（多行解說） | 同 Briefing |
| Options / SaveLoad / ModList | FONT_BIG | FONT_SMALL | 中 | 同 Basescape |

策略：Geoscape 那 12 顆速度/功能按鈕 + 月份/星期是**唯一**需要單獨設計 zh-TW GEO 字型的地方；其他地方共用 BIG/SMALL 即可。

---

## 2. 最終 font cell 推薦

考慮 [Font.cpp:193](src/Engine/Font.cpp:193) 的 global height 限制，**所有 zh-TW image 的 height 不可超過該 font global height 太多**，否則 line step 偏小、字會相疊。

| Image | width | height | spacing | 備註 |
|---|---|---|---|---|
| FontBig_zh-TW.png | 18 | 18 | 0 | 跟 global 16 差 +2，line step 略擠但可接受；title sprite area 不會破 |
| FontSmall_zh-TW.png | 14 | 14 | 0 | global 9，差 +5；多行 dialog 必撞 → 必須搭配 §5 修法 |
| FontGeoBig_zh-TW.png | 9 | 11 | 1 | global 9，差 +2 |
| FontGeoSmall_zh-TW.png | 8 | 9 | 1 | global 7，差 +2 |

權衡：FontSmall 是最痛的 trade-off —— 9px 高放不下任何可讀中文，14px 又會撞 line step。**v2.0 先用 14×14 + 接受 single-line 場合最佳**，多行 dialog 同步上 §5 修法。

WQY Zen Hei Sharp embedded bitmap 範圍：12/13/15px 最銳利；14px、16px 落在 outline rasterize，需在 `make_fonts_zhtw.py` 加 hinting fallback。**18px Big 用 outline 沒問題**（X-COM 風格本就有反鋸齒邊緣），14px Small 建議**改抓 13px embedded bitmap 放進 14×14 cell 並 center**，避免 clip warning。

---

## 3. 翻譯範圍規劃

**來源策略**：拉 OXCE nightly 的 `zh-TW.yml` 作 baseline（社群已有人開過頭，估約 60–80% 覆蓋率），然後 cherry-pick key 進 vanilla master；vanilla 自己沒有 Transifex zh-TW slot，手寫補洞。

**Key 數估算**（依 `en-US.yml` 區段抽樣，~3000 keys total）：

| 階段 | 範圍 | 估 key 數 | 估工時 (含 QA) |
|---|---|---|---|
| v2.0 (現況) | 8 key（main menu 一小部分） | 8 | done |
| v2.1 | Main menu 全套 + Options + SaveLoad + ModList + Geoscape menu/時鐘/月份/星期 | ~200 | 1–2 週 |
| v2.2 | Battlescape (action menu/命中率/受傷/迷霧) + Inventory + Basescape (facility/personnel/store) | ~600 | 3–4 週 |
| v2.3 | Ufopedia 全條目 + Research + Manufacturing + Briefing/Debriefing + 各事件文字 | ~2000+ | 6–10 週 |
| v2.4 | 國家/城市/外星生物名 + 武器名（玩家可能想保留英文） | ~200 | 1 週，**做可選 toggle** |

QA 卡點：每階段 ship 前要在 base 320 + base 640 + xBRZ 三路徑跑一輪 smoke test。

---

## 4. 解析度 / scaler 路線

| Path | 字相對大小 | sprite 品質 | UI 完整性 | click 穩定 | build 工序 | 綜合 |
|---|---|---|---|---|---|---|
| **A. base 320×200, display 1280×800** | 中文 Big 18px 對應 sprite 等比放大後約 72px → 過大、超出 title sprite | 4× nearest，硬邊像素 | 中文 overflow title area（已驗） | OK | 0 改動 | C |
| **B. base 640×480, display 1280×800** | 中文 Big 18px 對應 36px → 仍偏大但 title sprite 同步放大 → 比例對 | 2× nearest | 中文超出 title 比 A 更明顯（已驗 `game_base640_mainmenu.png`） | OK | 改 options.cfg | C+ |
| **C. base 320×200 + xBRZ 4× filter** | 中文 18px 經 xBRZ 4× → 約 72px 平滑 | xBRZ 平滑邊緣，最佳 | 同 A，但中文 anti-aliased 較柔（已驗 `game_xbrz_mainmenu.png`） | **broken**（前次 click 不到 New Game） | 改 options.cfg | D（unless click fix） |
| **D. base 320×200 + nearest 1× (window 320×200)** | 18px 中文塞滿小視窗 | 原 pixel art | 中文超出更嚴重 | OK | window 太小不實用 | F |

**推薦 v2.0–v2.1：Path A (base 320, display 1280×800, xBRZ off)**——同 user 目前設定，是唯一已知 click stable 路徑。  
**v2.2 起調研 Path C** —— 先解 xBRZ click broken（懷疑 [Screen.cpp] 32bpp 模式 mouse coord scale 在 SDL 1.2 + xBRZ 路徑算錯，需 patch；非本 v2 必要 deliverable）。  
**Path B 放棄**：base 640 雖然字 sprite 比例對，但 vanilla 原 sprite asset 是 320 寬，放大後反而模糊；且中文 overflow title 並沒改善（已驗）。

---

## 5. Line step bug 修法

**Root cause**：[Font.cpp:193](src/Engine/Font.cpp:193) 回傳 `_images[0].height`，跟字實際 cell 不符。

**修法 A（侵入小，推薦 v2.1 ship）**：改 [Font.cpp:193](src/Engine/Font.cpp:193) `getHeight()` 回傳 `_images` 中最大 height：

```
int Font::getHeight() const {
    int h = _images[0].height;
    for (auto &i : _images) if (i.height > h) h = i.height;
    return h;
}
```

- 影響：所有語言的 line step 等於該語言 image 的最高那張。對 en-US/en-GB 無影響（只有一張），對 zh-TW 會把 line step 從 9 推到 14（FontSmall）/ 16→18（FontBig）。Dialog 自動讓開。
- 風險：英文+日文混排（jp 那張）的 jp 玩家也會被推高 line step；可加 lang filter 但不必要。
- 等同改 1 行，diff 最小。

**修法 B（中等侵入）**：在 [Text.cpp:333,405](src/Interface/Text.cpp:333) 改成 `_lineHeight.push_back(std::max(big->getHeight(), small->getHeight()) + spacing)`，根據實際當前 image 動態算。複雜，不推薦。

**規避策略（v2.0 立即可行）**：font cell 不超過 global +50%（Big 16→24、Small 9→13 為上限）。但 14×14 中文 Small 在 9px global 下 +56% 已超標，視覺仍會疊 —— 不夠用，因此 **v2.1 一定要上修法 A**。

---

## 6. Ship 路線圖

**v2.0（now → 1 週）**

1. 確認當前 16×16 / 18×18 Big + Small cell 在 base 320 main menu 可讀（已驗 `game_options_v2.png` OK）。
2. zh-TW.yml 鎖在現有 8 key，標記為「字型驗證版」。
3. 寫 README 註明限制（cell 大、line step 未修、僅主選單）。
4. tag `v2.0-fontcheck`、build SFX portable。

**v2.1（+ 2 週）**

1. 上修法 A（[Font.cpp:193](src/Engine/Font.cpp:193) 改 max-height），smoke test 三 screen。
2. 補翻 ~200 key（main menu / options / saveload / modlist / Geoscape menu + 月份星期）。
3. 從 OXCE nightly cherry-pick zh-TW.yml 中可用 key。
4. tag `v2.1-menu`、ship portable。

**v2.2（+ 1 個月）**

1. Battlescape / Inventory / Basescape 翻譯 ~600 key。
2. 用 `tools/make_fonts_zhtw.py` 補產 missing glyph。
3. 驗 line spacing 在 Basescape 表格密集處 OK。
4. tag `v2.2-tactical`。

**v2.3（+ 2 個月）**

1. Ufopedia / Research / Manufacturing / Briefing 全翻 ~2000 key。
2. 玩 1 場完整 playthrough QA。
3. tag `v2.3-complete`、ship 1.0 final。

---

## 7. 風險與已知限制

1. **X-COM 1994 原版 sprite 320×200 不可放大**：title sprite area 是寫死的 sprite 位元，中文超出無法靠 OpenXcom 修；只能讓中文短一點或接受溢出。OXCE 有部分 hi-res mod 處理但本 v2 不走 OXCE 路線。
2. **xBRZ click broken 不在 v2 修**：要動 [Screen.cpp] 32bpp mouse mapping，屬於 upstream-level bug，回報 vanilla 但本地 portable 走 Path A。
3. **WQY 14px embedded bitmap 沒覆蓋所有 BIG5 字**：罕用字（碁/翊/罕等）會 fallback outline，視覺與常用字不一致。可接受。
4. **FONT_SMALL 9px global 與中文 14px 的根本衝突**：修法 A 把 line step 推到 14，所有英文用 FONT_SMALL 的地方行距也跟著放大 —— 在 base 320 表格密集 screen（Basescape personnel list、Geoscape funding）會顯得鬆。**權衡接受**，否則要做 per-lang line step（複雜度高，不在 v2 範圍）。
5. **沒做 OXCE compatibility**：本 v2 走 vanilla master 路線；OXCE 用戶不適用。若要 ship OXCE 版需重做 Font.dat（OXCE 有 customizable font slot）。
6. **WQY 授權 Apache 2.0**：商業/重新散布 OK，但 SFX portable 要附 LICENSE 文字。已在 fontsrc/ 留 license，ship 時別忘了打包進去。
7. **Steam X-COM data 依賴**：本中文化 patch 只動 OpenXcom 本體和 Font.dat / zh-TW.yml，不重新散布 X-COM 1994 資料；玩家須自備正版 Steam X-COM UFO Defense。
## Glossary 實測表 (auto-extracted from xcom1/zh-TW.yml)

來源檔: `bin/standard/xcom1/Language/zh-TW.yml` — 1101 keys, 102% coverage.

以下為實際使用譯名 (round1 agent 採用), 取代 v2_plan §1.3 早期規劃表中部份未落地的譯名 (e.g. 賽克托人/穆頓人/浮空人 -> 腦蟲/蠻牛/浮游者)。Deep validator 報的 22 GLOSS warnings 來自舊 glossary 表; 以本表為準。

| 原文 | 實際譯名 (zh-TW.yml) | STR key | 英文原文 |
|---|---|---|---|
| Sectoid | 腦蟲 | `STR_SECTOID` | Sectoid |
| Snakeman | 蛇人 | `STR_SNAKEMAN` | Snakeman |
| Ethereal | 靈體 | `STR_ETHEREAL` | Ethereal |
| Floater | 浮游者 | `STR_FLOATER` | Floater |
| Muton | 巨型怪 | `STR_MUTON` | Muton |
| Chryssalid | 蟹形蟲 | `STR_CHRYSSALID` | Chryssalid |
| Cyberdisc | 電腦碟 | `STR_CYBERDISC` | Cyberdisc |
| Reaper | 收割者 | `STR_REAPER` | Reaper |
| Sectopod | 腦機甲 | `STR_SECTOPOD` | Sectopod |
| Silacoid | 矽生物 | `STR_SILACOID` | Silacoid |
| Celatid | 盲蟲 | `STR_CELATID` | Celatid |
| Zombie | 喪屍 | `STR_ZOMBIE` | Zombie |
| Interceptor | 攔截機 | `STR_INTERCEPTOR` | INTERCEPTOR |
| Skyranger | 天空遊俠 | `STR_SKYRANGER` | SKYRANGER |
| Lightning | 閃電 | `STR_LIGHTNING` | LIGHTNING |
| Avenger | 復仇者 | `STR_AVENGER` | AVENGER |
| Firestorm | 風暴 | `STR_FIRESTORM` | FIRESTORM |
| Hangar | 機庫 | `STR_HANGAR` | Hangar |
| Workshop | 工坊 | `STR_WORKSHOP` | Workshop |
| Living Quarters | 宿舍 | `STR_LIVING_QUARTERS` | Living Quarters |
| Laboratory | 實驗室 | `STR_LABORATORY` | Laboratory |
| General Stores | 一般倉庫 | `STR_GENERAL_STORES` | General Stores |
| Alien Containment | 外星人收容 | `STR_ALIEN_CONTAINMENT` | Alien Containment |
| Psionic Lab | 心靈實驗室 | `STR_PSIONIC_LABORATORY` | Psionic Laboratory |
| Access Lift | 進入升降梯 | `STR_ACCESS_LIFT` | Access Lift |
| Mind Shield | 心靈護盾 | `STR_MIND_SHIELD` | Mind Shield |
| Hyper-wave Decoder | 超波解碼器 | `STR_HYPER_WAVE_DECODER` | Hyper-wave Decoder |
| Cydonia | 賽多尼亞 | `STR_CYDONIA` | CYDONIA |
| Plasma | 電漿手槍 | `STR_PLASMA_PISTOL` | Plasma Pistol |
| Time Units | 時間單位 | `STR_TIME_UNITS` | TIME UNITS |
| Blaster Bomb | 爆破彈 | `STR_BLASTER_BOMB` | Blaster Bomb |
| Stun Rod | 電擊棒 | `STR_STUN_ROD` | Stun Rod |
| Medi-Kit | 醫療包 | `STR_MEDI_KIT` | Medi-Kit |
| Motion Scanner | 動作掃描器 | `STR_MOTION_SCANNER` | Motion Scanner |
| Psi-Amp | 心靈增幅器 | `STR_PSI_AMP` | Psi-Amp |
| UFO | 幽浮 | `STR_UFO` | UFO |
| Small Scout | 小型偵察艇 | `STR_SMALL_SCOUT` | Small Scout |
| Medium Scout | 中型偵察艇 | `STR_MEDIUM_SCOUT` | Medium Scout |
| Large Scout | 大型偵察艇 | `STR_LARGE_SCOUT` | Large Scout |
| Harvester | 採集者 | `STR_HARVESTER` | Harvester |
| Abductor | 綁架者 | `STR_ABDUCTOR` | Abductor |
| Terror Ship | 恐怖艦 | `STR_TERROR_SHIP` | Terror ship |
| Battleship | 戰艦 | `STR_BATTLESHIP` | Battleship |
| Supply Ship | 補給艦 | `STR_SUPPLY_SHIP` | Supply ship |

備註:
- Phase B (round2): 保持 round1 譯名一致 (1101 keys internal consistency), 不回頭改動。
- v2_plan §1.3 原表「賽克托人/穆頓人/浮空人」屬早期規劃名, 已被 round1 替換: Sectoid→腦蟲、Floater→浮游者。
- **Muton 實際譯名為「巨型怪」** (非 v2_review §1.3 / round2 任務描述所說的「蠻牛」)。Round1 採「巨型怪」貼合 Muton 外型 (大型肌肉人形), 維持不改。
- Deep validator GLOSS warnings 來自 hardcoded GLOSSARY dict (`tools/wsl_deep_validate.py`); 如要消除應更新 validator 字典而非翻譯。建議將 validator 內 `"Muton": "蠻牛"` 改為 `"Muton": "巨型怪"`。
