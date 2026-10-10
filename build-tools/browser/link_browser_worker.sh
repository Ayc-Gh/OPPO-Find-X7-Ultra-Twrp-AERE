#!/bin/bash
set -euo pipefail
cd /aera
base=/aera/work-browser
prebuilts/clang/host/linux-x86/clang-r547379/bin/clang++ \
 --target=aarch64-alpine-linux-musl -fuse-ld=lld -nostdlib -pie \
 -Wl,--dynamic-linker,/lib/ld-musl-aarch64.so.1 -Wl,-z,relro,-z,now -Wl,--no-undefined \
 "$base/sysroot/usr/lib/Scrt1.o" "$base/sysroot/usr/lib/crti.o" "$base/worker.o" \
 -L"$base/runtime/usr/lib" -L"$base/runtime/lib" \
 -l:libWPEWebKit-2.0.so.1 -l:libgio-2.0.so.0 -l:libgobject-2.0.so.0 -l:libglib-2.0.so.0 \
 -l:libepoxy.so.0 -l:libstdc++.so.6 -l:libgcc_s.so.1 -l:ld-musl-aarch64.so.1 \
 "$base/sysroot/usr/lib/crtn.o" -o "$base/aera-browser-worker"
prebuilts/clang/host/linux-x86/clang-r547379/bin/llvm-strip --strip-unneeded "$base/aera-browser-worker"
