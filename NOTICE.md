# 来源与许可说明

本项目适配 AERA Recovery，沿用锁定的 PHY110 设备树，包含对应厂商预编译文件。各源码文件的版权、SPDX 和许可说明保留；不能把所有预编译库、固件或混合许可证文件统一声明为 Apache-2.0。源码基线与修改见 source-lock.json、build-record/resolved-manifest.xml 和 patches/。

厂商二进制文件仍属于各自权利人；本仓库未提供其额外再许可。公开资料不包含用户备份、原始手机日志、锁屏凭据或网络配置。

浏览器 worker 基于 AERA 核心同名源文件和 WPE WebKit 2.52.6 公共 API，保留 Apache-2.0 标记；动态依赖来自用户原始签名浏览器插件，未把更改的插件伪装成原签名包。API 源码地址及工具包摘要在 build-tools/browser/build-dependencies.json。

音频原型参考 AERA Waffle 音频桥（https://github.com/AERA-Recovery/android_device_oneplus_waffle-AERA），保留源文件版权标记。PHY110 原型通过 PAL 客户端调用原厂 HAL，未分发原厂音频分区。

字体复用 AERA 原带 WenQuanYi Micro Hei，遵循其原有许可。AERA 核心及浏览器插件中的其他第三方文件继续受各自原许可证约束。

OpenH264 新增库编译自 Cisco 固定官方提交，保留其 BSD 2-Clause LICENSE 于 build-tools/browser/licenses/OpenH264-LICENSE。上游源码下载 URL 和压缩包摘要见 phy110-libraries.json；此处库为本项目编译版本。Mesa Turnip 的许可和设备修改单独保留，不更改厂商文件许可。

OpenH264 新增库编译自 Cisco 固定官方提交，保留其 BSD 2-Clause LICENSE 于 build-tools/browser/licenses/OpenH264-LICENSE。上游源码下载 URL 和压缩包摘要见 phy110-libraries.json；此处库为本项目编译版本。Mesa Turnip 的许可和设备修改单独保留，不更改厂商文件许可。
