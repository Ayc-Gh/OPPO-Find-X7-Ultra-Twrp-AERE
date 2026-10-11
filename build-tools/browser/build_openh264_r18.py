from pathlib import Path
import subprocess,hashlib,json
base=Path('/aera/work-browser');sysroot=base/'sysroot';runtime=base/'runtime'
root=base/'openh264-1a0073f0322c8b74cbcb75ca1bb1c3d19d75538d'
clang=Path('/aera/prebuilts/clang/host/linux-x86/clang-r547379/bin')
flags=f'--target=aarch64-alpine-linux-musl --sysroot={sysroot} -fuse-ld=lld'
cflags='-O2 -fPIC -DNDEBUG'
cppflags=cflags+f' -nostdinc++ -isystem {sysroot}/usr/include/c++/15.2.0 -isystem {sysroot}/usr/include/c++/15.2.0/aarch64-alpine-linux-musl'
ldflags=f'-nostdlib -L{runtime}/usr/lib -L{runtime}/lib -l:libstdc++.so.6 -l:libgcc_s.so.1 -l:ld-musl-aarch64.so.1'
args=['make','-j4','OS=linux','ARCH=arm64',f'CC={clang}/clang {flags}',f'CXX={clang}/clang++ {flags}',f'AR={clang}/llvm-ar',f'CFLAGS={cflags}',f'CXXFLAGS={cppflags}',f'LDFLAGS={ldflags}','libopenh264.so']
with (base/'r18-openh264-build.log').open('w') as log:
 p=subprocess.run(args,cwd=root,stdout=log,stderr=subprocess.STDOUT)
print('Pinned upstream OpenH264 build:',p.returncode,flush=True)
if p.returncode:raise SystemExit(p.returncode)
library=(root/'libopenh264.so').resolve()
subprocess.run([str(clang/'llvm-strip'),'--strip-unneeded',str(library)],check=True)
out=base/'phy110-openh264-r18.so'
out.write_bytes(library.read_bytes())
print(json.dumps({'sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'size':out.stat().st_size}),flush=True)
