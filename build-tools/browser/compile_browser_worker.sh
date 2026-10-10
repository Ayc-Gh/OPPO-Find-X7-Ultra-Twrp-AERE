#!/bin/bash
set -euo pipefail
cd /aera
base=/aera/work-browser
for dir in wpe wpe/headless jsc webkit webkit2 wpe-platform; do
  mkdir -p "$base/include/$dir"
  for header in "$base"/headers/*.h; do ln -sfn "$header" "$base/include/$dir/$(basename "$header")"; done
done
cat > "$base/header-config.h" <<'EOF'
#define PLATFORM(x) PLATFORM_##x
#define PLATFORM_WPE 1
#define PLATFORM_GTK 0
#define USE(x) USE_##x
#define USE_GTK4 0
#define ENABLE(x) ENABLE_##x
#define ENABLE_2022_GLIB_API 1
#define ENABLE_WPE_PLATFORM 1
#define WEBKIT_API_VERSION_STRING "2.0"
EOF
prebuilts/clang/host/linux-x86/clang-r547379/bin/clang++ \
 --target=aarch64-alpine-linux-musl --sysroot="$base/sysroot" --gcc-toolchain="$base/sysroot/usr" \
 -std=c++17 -Os -g0 -Wall -Wextra -Werror -include "$base/header-config.h" \
 -isystem "$base/sysroot/usr/include/c++/15.2.0" -isystem "$base/sysroot/usr/include/c++/15.2.0/aarch64-alpine-linux-musl" \
 -I"$base/include" -I"$base/sysroot/usr/include/glib-2.0" -I"$base/sysroot/usr/lib/glib-2.0/include" \
 -I"$base/sysroot/usr/include/gio-unix-2.0" \
 -I"$base/sysroot/usr/include/libsoup-3.0" \
 -I/aera/frameworks/native/opengl/include \
 bootable/recovery/aeraui/features/browser/worker.cpp \
 -c -o "$base/worker.o"
