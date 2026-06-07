#!/bin/bash
# v2.29 dual AppImage builder
set -e
EXE=/tmp/openxcom-linux-build/bin/openxcom
BIN=/mnt/d/openxcom/OpenXcom/bin
APPIMG_TOOL=/tmp/appimg/appimagetool
OUT=/mnt/d/openxcom/dist
mkdir -p $OUT
test -f $EXE || { echo "missing Linux EXE"; exit 1; }
if [ ! -f $APPIMG_TOOL ]; then
  mkdir -p /tmp/appimg
  wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O $APPIMG_TOOL
  chmod +x $APPIMG_TOOL
fi

build_variant() {
  local VARIANT=$1 MOD_ID=$2 DATA_DIR=$3
  echo "==> v2.29-$VARIANT (mod=$MOD_ID)"
  local AD=/tmp/appimg/OpenXcom-CHT-v2.29-$VARIANT.AppDir
  rm -rf $AD
  mkdir -p $AD/usr/{bin,lib,share/openxcom,share/applications,share/icons/hicolor/256x256/apps,share/icons/hicolor/48x48/apps}
  cp $EXE $AD/usr/bin/openxcom
  strip $AD/usr/bin/openxcom 2>/dev/null || true
  local LIBS=$(ldd $EXE | awk '/=>/ && $3!="" {print $3}')
  for lib in $LIBS; do
    base=$(basename "$lib")
    case "$base" in
      libc.so.*|libdl.so.*|libm.so.*|libpthread.so.*|libstdc++.so.*|libgcc_s.so.*|librt.so.*) ;;
      libGL.so.*|libGLX*|libEGL*|libGLdispatch*|libOpenGL*) ;;
      libX11*|libxcb*|libXext*|libXrender*|libXrandr*|libXi*|libXcursor*|libXfixes*|libXinerama*) ;;
      libwayland*|libdrm*|libgbm*|libxkbcommon*) ;;
      libsystemd*|libudev*|libcap*|libapparmor*|libdbus*) ;;
      libnsl*|ld-linux*) ;;
      *) cp -L "$lib" $AD/usr/lib/ 2>/dev/null ;;
    esac
  done
  cp -r $BIN/common   $AD/usr/share/openxcom/
  cp -r $BIN/standard $AD/usr/share/openxcom/
  cp -r $BIN/$DATA_DIR $AD/usr/share/openxcom/
  cat > $AD/AppRun << APPRUN_EOF
#!/bin/bash
HERE="\$(dirname "\$(readlink -f "\$0")")"
export LD_LIBRARY_PATH="\$HERE/usr/lib:\${LD_LIBRARY_PATH}"
DATA="\$HERE/usr/share/openxcom"
USER_DIR="\${XDG_DATA_HOME:-\$HOME/.local/share}/openxcom-cht-$VARIANT"
CFG_DIR="\${XDG_CONFIG_HOME:-\$HOME/.config}/openxcom-cht-$VARIANT"
mkdir -p "\$USER_DIR" "\$CFG_DIR"
if [ ! -f "\$CFG_DIR/options.cfg" ]; then
  cat > "\$CFG_DIR/options.cfg" << CFG_EOF
mods:
  - active: true
    id: $MOD_ID
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
CFG_EOF
fi
exec "\$HERE/usr/bin/openxcom" -data "\$DATA" -user "\$USER_DIR" -config "\$CFG_DIR" "\$@"
APPRUN_EOF
  chmod +x $AD/AppRun
  cat > $AD/openxcom-cht-$VARIANT.desktop << DESKTOP_EOF
[Desktop Entry]
Type=Application
Name=OpenXcom CHT $VARIANT
Exec=openxcom
Icon=openxcom-cht-$VARIANT
Terminal=false
Categories=Game;StrategyGame;
DESKTOP_EOF
  python3 << PY_EOF
from PIL import Image
src = Image.open('$BIN/common/Resources/signature_pang.png').convert('RGBA')
face = src.crop((0, 0, 24, 24))
for sz, path in [(256, '$AD/openxcom-cht-$VARIANT.png'),
                 (48,  '$AD/usr/share/icons/hicolor/48x48/apps/openxcom-cht-$VARIANT.png')]:
    face.resize((sz, sz), Image.NEAREST).save(path)
PY_EOF
  cp $AD/openxcom-cht-$VARIANT.png $AD/usr/share/icons/hicolor/256x256/apps/
  cp $AD/openxcom-cht-$VARIANT.desktop $AD/usr/share/applications/
  local OUT_NAME="OpenXcom-CHT-v2.29-$VARIANT-x86_64.AppImage"
  ARCH=x86_64 $APPIMG_TOOL --appimage-extract-and-run $AD $OUT/$OUT_NAME 2>&1 | tail -3
  if [ -f "$OUT/$OUT_NAME" ]; then
    chmod +x $OUT/$OUT_NAME
    echo "  -> $OUT/$OUT_NAME ($(du -sh $OUT/$OUT_NAME | cut -f1))"
  fi
}

build_variant UFO  xcom1 UFO
build_variant TFTD xcom2 TFTD
echo ""
ls -lh $OUT/OpenXcom-CHT-v2.29-*
