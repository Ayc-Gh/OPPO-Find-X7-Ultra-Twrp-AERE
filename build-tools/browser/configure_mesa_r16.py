from pathlib import Path
import zipfile,subprocess,os,urllib.request
b=Path('/aera/work-browser');h=Path(os.environ.get('PHY110_BROWSER_TOOLS','/aera/device/oppo/phy110/build-tools/browser'))
tools=b/'mesa-tools';tools.mkdir(exist_ok=True)
with zipfile.ZipFile(h/'meson-1.9.1-py3-none-any.whl') as z:z.extractall(tools)
import shutil
shutil.copyfile(b/'runtime/usr/lib/libgcc_s.so.1',b/'sysroot/usr/lib/libgcc_s.so.1')
shutil.copyfile(b/'runtime/usr/lib/libz.so.1',b/'sysroot/usr/lib/libz.so.1')
zlink=b/'sysroot/usr/lib/libz.so'
zlink.unlink(missing_ok=True); zlink.symlink_to('libz.so.1')
compat=b/'mesa-compat-include'; compat.mkdir(exist_ok=True)
# Android's bundled Clang header targets bionic. Use upstream LLVM's built-in
# atomic implementation for the Alpine musl target, without changing Clang.
atomic=urllib.request.urlopen('https://raw.githubusercontent.com/llvm/llvm-project/llvmorg-20.1.8/clang/lib/Headers/stdatomic.h').read().decode()
(compat/'stdatomic.h').write_text(atomic.replace('#if __STDC_HOSTED__ &&','#if 0 &&'))
cross=b/'mesa-phy110-cross.ini'
cross.write_text('''[binaries]
c = ['/aera/prebuilts/clang/host/linux-x86/clang-r547379/bin/clang', '--target=aarch64-alpine-linux-musl', '--sysroot=/aera/work-browser/sysroot', '--gcc-toolchain=/aera/work-browser/sysroot/usr', '-fuse-ld=lld']
cpp = ['/aera/prebuilts/clang/host/linux-x86/clang-r547379/bin/clang++', '--target=aarch64-alpine-linux-musl', '--sysroot=/aera/work-browser/sysroot', '--gcc-toolchain=/aera/work-browser/sysroot/usr', '-fuse-ld=lld', '-isystem', '/aera/work-browser/sysroot/usr/include/c++/15.2.0', '-isystem', '/aera/work-browser/sysroot/usr/include/c++/15.2.0/aarch64-alpine-linux-musl']
ar = '/aera/prebuilts/clang/host/linux-x86/clang-r547379/bin/llvm-ar'
strip = '/aera/prebuilts/clang/host/linux-x86/clang-r547379/bin/llvm-strip'
pkg-config = '/usr/bin/pkg-config'
[host_machine]
system = 'linux'
cpu_family = 'aarch64'
cpu = 'armv8-a'
endian = 'little'
[properties]
needs_exe_wrapper = true
sys_root = '/aera/work-browser/sysroot'
pkg_config_libdir = '/aera/work-browser/sysroot/usr/lib/pkgconfig'
''')
text=cross.read_text().replace(", '-fuse-ld=lld'", "")
text=text.replace("[host_machine]", "[built-in options]\nc_link_args = ['-fuse-ld=lld']\ncpp_link_args = ['-fuse-ld=lld']\n[host_machine]")
cross.write_text(text)
env=os.environ.copy();env['PYTHONPATH']=str(tools)
command=['python3','-m','mesonbuild.mesonmain','setup',str(b/'mesa-build-r16'),str(b/'mesa-26.2.2'),'--cross-file',str(cross),'--buildtype=release','-Dplatforms=[]','-Dvulkan-drivers=freedreno','-Dfreedreno-kmds=kgsl','-Dgallium-drivers=[]','-Dllvm=disabled','-Degl=disabled','-Dglx=disabled','-Dopengl=false','-Dgles1=disabled','-Dgles2=disabled','-Dzlib=disabled','-Dzstd=disabled','-Dexpat=disabled','-Dshader-cache=disabled','-Dspirv-tools=disabled','-Dperfetto=false','-Db_lto=false']
command=[x.replace('mesa-build-r16','mesa-build-r16b') for x in command]
command=[x.replace('-Dzlib=disabled','-Dzlib=enabled') for x in command]
command += ['-Dc_args=-I'+str(compat),'-Dcpp_args=-I'+str(compat)]
if (b/'mesa-build-r16b/meson-private/coredata.dat').exists(): command.insert(4,'--reconfigure')
with (b/'mesa-r16-configure.log').open('w') as log:
 p=subprocess.run(command,cwd=b,env=env,stdout=log,stderr=subprocess.STDOUT)
print('Meson configure exit',p.returncode,flush=True)
print((b/'mesa-r16-configure.log').read_text()[-2500:])
raise SystemExit(p.returncode)
