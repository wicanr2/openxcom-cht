# make_portable.ps1
# 把 build 好的 openxcom.exe + 全部 DLL + 翻譯資產 + 原版 X-COM 1 資料
# 打成 portable ZIP（可在任意 Windows 10/11 64-bit 雙擊執行）
#
# 用法：
#   .\make_portable.ps1 -BuildDir D:\openxcom\OpenXcom\build-win64-release\bin\Release `
#                       -DataDir  D:\openxcom\OpenXcom\bin `
#                       -OutDir   D:\openxcom\dist
#
# 需求：
#   - 已 build 好 openxcom.exe (走方式 B 的 cmake build)
#   - bin\UFO\ 已有 9 個子目錄 (GEODATA / GEOGRAPH / MAPS / ROUTES /
#     SOUND / TERRAIN / UFOGRAPH / UFOINTRO / UNITS) — Steam X-COM 1 內容
#
# 產出：
#   $OutDir\OpenXcom-CHT-v2.18-portable\        ← 解開的目錄
#   $OutDir\OpenXcom-CHT-v2.18-portable.zip     ← 打包的 ZIP

param(
    [string]$BuildDir = "D:\openxcom\OpenXcom\build-win64-release\bin\Release",
    [string]$DataDir  = "D:\openxcom\OpenXcom\bin",
    [string]$OutDir   = "D:\openxcom\dist",
    [string]$Version  = "v2.18"
)

$ErrorActionPreference = "Stop"
$PkgName = "OpenXcom-CHT-$Version-portable"
$Pkg = Join-Path $OutDir $PkgName

Write-Host "==> Cleaning $Pkg"
if (Test-Path $Pkg) { Remove-Item $Pkg -Recurse -Force }
New-Item -ItemType Directory -Path $Pkg -Force | Out-Null
New-Item -ItemType Directory -Path "$Pkg\data" -Force | Out-Null
New-Item -ItemType Directory -Path "$Pkg\user" -Force | Out-Null

Write-Host "==> Copying openxcom.exe + DLLs from $BuildDir"
Copy-Item "$BuildDir\openxcom.exe" $Pkg -Force
Get-ChildItem $BuildDir -Filter "*.dll" |
    Where-Object { $_.Name -notmatch "d\.dll$" } |  # skip debug DLLs
    Copy-Item -Destination $Pkg -Force

Write-Host "==> Copying MSVC runtime DLLs"
@("MSVCP140.dll", "VCRUNTIME140.dll", "VCRUNTIME140_1.dll") | ForEach-Object {
    $src = "C:\Windows\System32\$_"
    if (Test-Path $src) {
        Copy-Item $src $Pkg -Force
        Write-Host "    + $_"
    } else {
        Write-Warning "    !! $_ not found in System32 — install VC++ 2022 Redist first"
    }
}

Write-Host "==> Copying game data (common / standard / UFO) from $DataDir"
foreach ($d in @("common", "standard", "UFO")) {
    $src = Join-Path $DataDir $d
    if (Test-Path $src) {
        Copy-Item $src "$Pkg\data\" -Recurse -Force
        Write-Host "    + data\$d"
    } else {
        Write-Warning "    !! $src not found"
    }
}

Write-Host "==> Writing OpenXcom-CHT.cmd launcher"
@'
@echo off
REM OpenXcom 繁中版 portable launcher
cd /d "%~dp0"
start "" "%~dp0openxcom.exe" -data "%~dp0data" -user "%~dp0user" -config "%~dp0user"
'@ | Set-Content "$Pkg\OpenXcom-CHT.cmd" -Encoding ASCII

Write-Host "==> Writing user\options.cfg (zh-TW + 1280x800)"
@'
mods:
  - active: true
    id: xcom1
options:
  language: zh-TW
  displayWidth: 1280
  displayHeight: 800
  fullscreen: false
  borderless: false
  keepAspectRatio: true
  useScaleFilter: false
  useHQXFilter: false
  useXBRZFilter: false
  useOpenGL: false
  soundVolume: 64
  musicVolume: 64
  uiVolume: 42
  playIntro: true
'@ | Set-Content "$Pkg\user\options.cfg" -Encoding UTF8

Write-Host "==> Computing ZIP"
$Zip = "$Pkg.zip"
if (Test-Path $Zip) { Remove-Item $Zip -Force }
Compress-Archive -Path $Pkg -DestinationPath $Zip -CompressionLevel Optimal

$ZipMB = [math]::Round((Get-Item $Zip).Length / 1MB, 2)
$DirMB = [math]::Round(((Get-ChildItem $Pkg -Recurse -File | Measure-Object Length -Sum).Sum) / 1MB, 1)

Write-Host ""
Write-Host "================================================================"
Write-Host "  $PkgName 已建立"
Write-Host "================================================================"
Write-Host "  Unzipped: $Pkg  ($DirMB MB)"
Write-Host "  ZIP:      $Zip  ($ZipMB MB)"
Write-Host ""
Write-Host "  測試：解到任意路徑、雙擊 OpenXcom-CHT.cmd"
Write-Host "  log 應顯示：Display set to 1280x800x8 + Language loaded successfully"
Write-Host "================================================================"
