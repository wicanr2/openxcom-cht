# OpenXcom v2.22 T5 — Mod 列表 i18n

## 目標
讓「模組」(ModListState) 畫面以 zh-TW 顯示中文 mod 名稱，
而不是 metadata.yml 內 hard-code 的英文 literal (例如
`Aliens_Pick_Up_Weapons` → `外星人撿武器`)。

## Patch 總覽

### 1. Source patch — `src/Menu/ModListState.cpp`

加一個 file-scope helper `_localizedModName(Game*, const ModInfo*)`：

- 用 `mod->getId()` 拼出 key `STR_MOD_<id>`
- 呼叫 `_game->getLanguage()->getString(key)`
- 若回傳 == key (代表 `Language::getString` 找不到) 或為空 → fallback 回 `modInfo->getName()` (metadata.yml 英文 literal)
- 否則回傳翻譯字串

替換點 (兩處)：

| 行 (新版) | 原 | 新 |
|---|---|---|
| 126 (主控 combo box) | `masterNames.push_back(modInfo->getName());` | `masterNames.push_back(_localizedModName(_game, modInfo));` |
| 237 (mod 列表 row) | `std::string modName = modInfo.getName();` | `std::string modName = _localizedModName(_game, &modInfo);` |

主控 combo box 涵蓋 xcom1 / xcom2 主 mod；mod 列表涵蓋全部 sub-mod。
沒有動 `ModInfo.cpp` 本體 — metadata.yml 仍是英文 fallback，遊戲在 en-US 下行為 100% 不變。

### 2. Translation — `bin/common/Language/zh-TW.yml`

在檔尾 (line 455 之後) 加 `# === Mod display names (v2.22 T5) ===` 區塊，共 **42** 個 `STR_MOD_<mod_id>` keys：

- 2 個主控 (xcom1, xcom2)
- 40 個 sub-mod (Aliens_Pick_Up_Weapons 與其 _TFTD 變體、Demigod_Difficulty、XcomUtil 全套、UFOextender 全套、TFTD/XCOM_Damage、PSX_Static_Cydonia_Map、StrategyCore、OpenXCom_Unlimited_Waypoints …)

Mod id 清單跟 `D:/openxcom/OpenXcom/bin/standard/` 目錄一對一核過，總共 43 個目錄 — 全收。

只有 append，沒動任何既有 key。

## Linux build verify

```
cp /mnt/d/openxcom/OpenXcom/src/Menu/ModListState.cpp /tmp/openxcom-src/src/Menu/ModListState.cpp
cd /tmp/openxcom-linux-build && make openxcom -j8
```

結果：
```
[  0%] Building CXX object src/CMakeFiles/openxcom.dir/Menu/ModListState.cpp.o
[  1%] Linking CXX executable ../bin/openxcom
[100%] Built target openxcom
```

clean (無 warning)。

## Char coverage

跑 `D:/openxcom/tools/check_mod_chars.py` (新加, 仿 check_char.py 風格)：

```
Font.dat covers 10250 unique chars
ALL CJK chars in mod translations are covered by Font.dat
```

42 條 mod 譯名所用的 CJK 字全部落在 Font.dat 涵蓋的 WQY Sharp 12px subset 內，無需替換同義字。

## 5-10 條值得 review 的譯名

| Mod id | 譯名 | 備註 |
|---|---|---|
| `UFOextender_*` | `UFOextender` 直接保留原英文專案名 | UFOextender 是社群 patcher 名 (1999 年 fan project)，不譯比強譯 (「幽浮擴充器」?) 清楚；類似 OXCE 我們也不譯 |
| `XcomUtil_*` | `XcomUtil` 直接保留原英文 | 同上：是工具集名，玩家社群慣用，硬譯反而難辨識 |
| `StrategyCore_Swap_Small_USOs_TFTD` | `StrategyCore 小型 USO 替換 (TFTD)` | `StrategyCore` 是論壇名 (strategycore.co.uk)，保留；`USO` (Unidentified Submerged Object) 保英文，TFTD 圈內慣用 |
| `Demigod_Difficulty` | `天神難度` | "Demigod" 直譯「半神」嫌弱，「天神」對應中文 RPG 困難等級用語 (天神 / 地獄 / 噩夢) |
| `XcomUtil_Skyranger_Weapon_Slot` | `XcomUtil 運兵機武器掛點` | Skyranger 是 xcom1 運兵機型號，直翻「天空遊俠」失去語境；「運兵機」對應功能；對比 Triton (TFTD 對應載具) 用「海神號」音譯 |
| `XcomUtil_Triton_Weapon_Slot` | `XcomUtil 海神號武器掛點` | Triton (希臘海神) 用「海神號」音意兼譯，避免「特里同」外行 |
| `PSX_Static_Cydonia_Map` | `PSX 版固定賽多尼亞地圖` | Cydonia (火星地名) 沿用「賽多尼亞」音譯 (NASA 中文資料常用) |
| `OpenXCom_Unlimited_Waypoints` | `無限路徑點` | "Waypoints" 在 xcom 是飛行軌跡規劃點，譯「路徑點」對應 RTS 慣用 |
| `XcomUtil_Statstrings` | `XcomUtil 數值字串` | "Statstrings" 是 XcomUtil 自訂的兵員稱號功能 (例「神射手」)，直譯「狀態字串」太抽象；可考慮「兵員稱號」 |
| `UFOextender_Psionic_Line_Of_Fire` | `UFOextender 心靈視線檢查` | "Line of fire" 在心靈攻擊語境是「視線需通暢」，譯「視線檢查」比直翻「射擊線」清楚 |

主要的「不譯」決策：UFOextender、XcomUtil、StrategyCore、OXCE 這四個是社群專案名 / 工具集名，保英文比強譯更友善。其餘 vehicle / location 名稱 (Skyranger / Triton / Cydonia / USO) 走「中文慣用對應 + 必要時加 (TFTD) 標籤區分版本」原則。

## 檔案異動

- `D:/openxcom/OpenXcom/src/Menu/ModListState.cpp` — 加 helper + 改 2 處
- `D:/openxcom/openxcom-cht/bin/common/Language/zh-TW.yml` — append 42 keys 到尾端
- `D:/openxcom/tools/check_mod_chars.py` — 新增 coverage 檢查工具 (給後續 mod 譯名變動快檢)

## 預估 vs 實際

- 預估：2-3 hr (source patch 1hr + 翻譯 verify 1hr)
- 實際：約 30 min。`ModListState.cpp` 兩個 hot spot 一眼可見、`Language::getString` 已有現成 fallback semantics，沒踩雷。

## 後續 (out of scope)

- 若主 session 要 ship，需把 `openxcom-cht/bin/common/Language/zh-TW.yml` 同步打進 v2.22 Linux & Windows 包
- 若有玩家社群另裝第三方 mod (非 `standard/` 內建)，會 fallback 顯示英文 — 預期行為，不算 bug
