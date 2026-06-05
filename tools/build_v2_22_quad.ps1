# v2.22 quad-pack builder (Win ZIP × 2 + AppImage × 2 via separate WSL script)
$ErrorActionPreference = "Stop"
$Build = "D:\openxcom\OpenXcom\build-win64-release\bin\Release"
$Bin   = "D:\openxcom\OpenXcom\bin"
$Out   = "D:\openxcom\dist"
$Tmp   = "$Out\_v2_22_staging"
if (Test-Path $Tmp) { Remove-Item $Tmp -Recurse -Force }

function Build-Variant {
    param([string]$Variant, [string]$ModId, [string]$GameDataDir)
    Write-Host ("==> v2.22 " + $Variant + " (mod=" + $ModId + ")") -ForegroundColor Cyan
    $Pkg = "$Tmp\OpenXcom-CHT-v2.22-$Variant-portable"
    New-Item -ItemType Directory -Path "$Pkg\data" -Force | Out-Null
    New-Item -ItemType Directory -Path "$Pkg\user" -Force | Out-Null
    Copy-Item "$Build\openxcom.exe" $Pkg -Force
    Get-ChildItem $Build -Filter "*.dll" |
        Where-Object { $_.Name -notmatch "d\.dll$" } |
        Copy-Item -Destination $Pkg -Force
    @("MSVCP140.dll", "VCRUNTIME140.dll", "VCRUNTIME140_1.dll") | ForEach-Object {
        Copy-Item "C:\Windows\System32\$_" $Pkg -Force
    }
    Copy-Item "$Bin\common"   "$Pkg\data\" -Recurse -Force
    Copy-Item "$Bin\standard" "$Pkg\data\" -Recurse -Force
    Copy-Item "$Bin\$GameDataDir" "$Pkg\data\" -Recurse -Force
    "@echo off`r`ncd /d `"%~dp0`"`r`nstart `"`" `"%~dp0openxcom.exe`" -data `"%~dp0data`" -user `"%~dp0user`" -config `"%~dp0user`"" |
        Set-Content "$Pkg\OpenXcom-CHT.cmd" -Encoding ASCII
    $optsContent = "mods:`n  - active: true`n    id: $ModId`noptions:`n  language: zh-TW`n  displayWidth: 1280`n  displayHeight: 800`n  fullscreen: false`n  borderless: false`n  keepAspectRatio: true`n  useScaleFilter: false`n  useHQXFilter: false`n  useXBRZFilter: false`n  useOpenGL: false`n  soundVolume: 64`n  musicVolume: 64`n  uiVolume: 42`n  playIntro: true`n"
    [System.IO.File]::WriteAllText("$Pkg\user\options.cfg", $optsContent, (New-Object System.Text.UTF8Encoding $false))
    $tmplName = "D:\openxcom\tools\README_v220_$Variant.txt"
    if (Test-Path $tmplName) { Copy-Item $tmplName "$Pkg\README.txt" -Force }
    $ZipPath = "$Out\OpenXcom-CHT-v2.22-$Variant-portable.zip"
    if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }
    Compress-Archive -Path $Pkg -DestinationPath $ZipPath -CompressionLevel Optimal
    $ZipMB = [math]::Round((Get-Item $ZipPath).Length / 1MB, 2)
    Write-Host ("  -> " + $ZipPath + " (" + $ZipMB + " MB)") -ForegroundColor Green
}

Build-Variant -Variant "UFO"  -ModId "xcom1" -GameDataDir "UFO"
Build-Variant -Variant "TFTD" -ModId "xcom2" -GameDataDir "TFTD"
Remove-Item $Tmp -Recurse -Force
Write-Host ""
Get-ChildItem "$Out\OpenXcom-CHT-v2.22-*" | Select-Object Name, @{N='MB';E={[math]::Round($_.Length/1MB,2)}} | Format-Table -AutoSize
