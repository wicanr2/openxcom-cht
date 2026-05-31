#!/bin/bash
# Build OpenXcom Linux EXE in WSL using the Windows-side source tree.
# Output goes to /tmp/openxcom-linux-build/ so we don't pollute /mnt/d/.

set -e

SRC=/mnt/d/openxcom/OpenXcom
BUILD=/tmp/openxcom-linux-build

# Copy source to /tmp for build perf (cross-mount build is painfully slow in WSL2)
if [ ! -d /tmp/openxcom-src ]; then
  echo "=== copying source to /tmp/openxcom-src ==="
  cp -a "$SRC" /tmp/openxcom-src
fi

mkdir -p "$BUILD"
cd "$BUILD"

echo "=== cmake generate ==="
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DDEV_BUILD=OFF -DBUILD_PACKAGE=OFF /tmp/openxcom-src

echo "=== make -j$(nproc) ==="
make -j"$(nproc)" 2>&1 | tail -50

echo "=== artifacts ==="
ls -la bin/ 2>/dev/null
ls -la *openxcom* 2>/dev/null
find . -name 'openxcom' -type f -executable 2>/dev/null | head -5
echo "=== done ==="
