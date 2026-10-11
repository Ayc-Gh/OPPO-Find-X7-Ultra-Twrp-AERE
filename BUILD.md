# r18 构建说明

使用 build-record/resolved-manifest.xml 中的固定 AERA Android 16 源码及 source-lock.json 中的核心提交。将本设备树置于 device/oppo/phy110，**仅应用 patches/phy110-r18-adaptation.patch**。它包含此前四项补丁及 r15–r18 变更，不要再叠加历史补丁。

产品 twrp_phy110-bp2a-eng；build-tools/build-aera.sh 是完整构建入口。预编译兼容 worker 位于 recovery/root/system/etc/aera-browser/phy110-worker，核心校验其摘要。本次实际采用 r17 镜像增量打包，只重编 aera-browser-jail 并增加 OpenH264，重新生成 unsigned AVB hash footer；没有重新执行全量构建。

OpenH264 固定源码、压缩包摘要、SONAME 和动态依赖见 build-tools/browser/phy110-libraries.json；许可证见该目录 licenses。prepare_openh264_r18.py 和 build_openh264_r18.py 是实际构建参考，默认 /aera/work-browser，依赖已准备的 Alpine aarch64 musl sysroot、GCC 15.2 C++ 头文件和 Android Clang r547379。它们不是从空白环境自动安装依赖的脚本。使用发布树自带摘要一致的库，或在同环境重建后更新校验信息。

Mesa Turnip 26.2.2 的设备补丁和 Meson 参考配置同在 build-tools/browser；该配置脚本的宿主路径需要按自身环境调整。最终两个 GPU 静态寄存器跳过补丁以 phy110-turnip-r16.patch 为准。原下载引擎保持完整，启动器只读绑定可信设备库，浏览器继续 UID 99090、无 capabilities、NoNewPrivs 和 seccomp。

音频启动器及当前槽只读依赖准备已放入 Recovery；必须依赖匹配的原机 vendor/system/system_ext/ODM/DSP/固件。不卸载或解绑活跃 TFA 驱动，不重启活跃 ADSP。实验源码见 experimental/audio，实际启动脚本见 recovery/root/system/bin/aera-audio-bootstrap。

诊断 harness、诊断 worker 和详细日志开关不打包。镜像及新增库校验见 validation。现有测试和构建记录保留，历史版本记录不代表 r18 已完成全部功能实测。
