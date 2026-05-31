#!/bin/bash
# Build OpenXcom-CHT-v2.19-x86_64.AppImage
set -e

APPIMG=/tmp/appimg
AD=$APPIMG/OpenXcom-CHT-v2.19.AppDir
EXE=/tmp/openxcom-linux-build/bin/openxcom
GAMEDATA=/mnt/d/openxcom/OpenXcom/bin

echo "==> AppDir: $AD"
test -f $EXE || { echo "missing EXE"; exit 1; }
test -d $GAMEDATA/UFO || { echo "missing UFO data"; exit 1; }

# 1. Copy EXE
cp $EXE $AD/usr/bin/openxcom
strip $AD/usr/bin/openxcom 2>/dev/null || true
echo "  + openxcom $(stat -c%s $AD/usr/bin/openxcom) bytes"

# 2. Bundle non-system .so deps
echo "==> bundling .so deps"
LIBS=$(ldd $EXE | awk '/=>/ && $3!="" {print $3}')
BUNDLED=0
for lib in $LIBS; do
  base=$(basename "$lib")
  case "$base" in
    libc.so.*|libdl.so.*|libm.so.*|libpthread.so.*|libstdc++.so.*|libgcc_s.so.*|librt.so.*)
      ;;
    libGL.so.*|libGLX*|libEGL*|libGLdispatch*|libOpenGL*)
      ;;
    libX11*|libxcb*|libXext*|libXrender*|libXrandr*|libXi*|libXcursor*|libXfixes*|libXinerama*)
      ;;
    libwayland*|libdrm*|libgbm*|libxkbcommon*)
      ;;
    libsystemd*|libudev*|libcap*|libapparmor*|libdbus*)
      ;;
    libnsl*|ld-linux*)
      ;;
    *)
      cp -Lv "$lib" $AD/usr/lib/ 2>/dev/null && BUNDLED=$((BUNDLED+1))
      ;;
  esac
done
echo "  bundled $BUNDLED libs, total $(du -sh $AD/usr/lib | cut -f1)"

# 3. Copy game data
echo "==> copying game data"
for d in common standard UFO; do
  cp -r $GAMEDATA/$d $AD/usr/share/openxcom/
  echo "  + $d ($(du -sh $AD/usr/share/openxcom/$d | cut -f1))"
done

# 4. AppRun + .desktop already in $APPIMG, move into AppDir
cp $APPIMG/AppRun $AD/AppRun
chmod +x $AD/AppRun
cp $APPIMG/openxcom-cht.desktop $AD/openxcom-cht.desktop

# 5. Icon (256x256 + 48x48)
echo "==> generating icons from signature_pang.png"
python3 << 'PYEOF'
from PIL import Image
src = Image.open('/mnt/d/openxcom/OpenXcom/bin/common/Resources/signature_pang.png').convert('RGBA')
# trim to left half (just chibi face), scale up with NEAREST for pixel art look
face = src.crop((0, 0, 24, 24))
for sz, path in [(256, '/tmp/appimg/openxcom-cht.png'),
                 (48,  '/tmp/appimg/openxcom-cht-48.png')]:
    icon = face.resize((sz, sz), Image.NEAREST)
    icon.save(path)
    print(f"  icon {sz}x{sz}: {path}")
PYEOF
cp /tmp/appimg/openxcom-cht.png $AD/openxcom-cht.png
cp /tmp/appimg/openxcom-cht.png $AD/usr/share/icons/hicolor/256x256/apps/openxcom-cht.png
cp /tmp/appimg/openxcom-cht-48.png $AD/usr/share/icons/hicolor/48x48/apps/openxcom-cht.png
cp $AD/openxcom-cht.desktop $AD/usr/share/applications/

echo
echo "==> AppDir tree:"
ls -la $AD
echo "==> Total size:"
du -sh $AD

# 6. Run appimagetool
echo
echo "==> packing AppImage"
OUT=/mnt/d/openxcom/dist/OpenXcom-CHT-v2.19-x86_64.AppImage
mkdir -p /mnt/d/openxcom/dist
# Use --appimage-extract-and-run because fuse not available in WSL
ARCH=x86_64 /tmp/appimg/appimagetool --appimage-extract-and-run "$AD" "$OUT" 2>&1 | tail -20

if [ -f "$OUT" ]; then
  chmod +x "$OUT"
  echo
  echo "================================================================"
  echo "  AppImage built: $OUT"
  echo "  Size: $(du -sh $OUT | cut -f1)"
  echo "================================================================"
else
  echo "FAILED — no output AppImage"
  exit 1
fi
