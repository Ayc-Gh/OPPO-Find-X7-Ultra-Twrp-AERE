# 构建说明

1. 使用 Linux/WSL，按 `build-record/resolved-manifest.xml` 锁定 AERA Android 16 源码。
2. 将本仓库放入 `device/oppo/phy110`，应用 `patches/` 内四个核心补丁；`build-tools/build-aera.sh` 包含应用顺序和构建入口。不要把此设备树用于其他型号。
3. 资源受限主机可应用 `build-record/` 中的 Soong 内存和 Blueprint 并发限制补丁。
4. 产品：`twrp_phy110-bp2a-eng`。完整构建使用 `m adbd recoveryimage`。本轮 r14 只增量重编 Recovery 与浏览器 worker，再从 r13 重打包，并重新生成 unsigned AVB hash footer；不是重新完成全量构建。
5. `tests/` 保留设备初始化测试。镜像检查结果在 `validation/`。r14 核心/worker 实机 RAM 测试与整镜像冷启动是不同验证范围，详见 README。

浏览器兼容 worker 的当前源码随核心补丁提供，预编译文件位于 `recovery/root/system/etc/aera-browser/phy110-worker`，其摘要受 Recovery 校验。它只覆盖指定摘要的原始签名引擎在 RAM 中的准备结果，不更改用户安装的签名插件，也不会覆盖未知的新引擎版本。中文字体复用 AERA 自带文件。

`build-tools/browser/` 提供这次 worker 编译/链接参考命令及工具包摘要。API 头文件来自 WPE WebKit 2.52.6，交叉头文件环境曾有模板替换与命名空间链接步骤；目前未整理成完全自动化的 worker 环境准备程序，不能保证单独执行参考命令即可从空目录重建 worker。完整设备构建可使用已校验的 worker 预编译文件。

诊断开关只由 Recovery 内的 root 文件启用；发布镜像不包含该开关，默认关闭详细浏览器诊断。不要公开原始诊断日志。

音频原型不安装到发布镜像。不要卸载/解绑正在运行的 TFA 扬声器驱动：此设备此前在热解绑测试中发生过冻结。

GPU 来源摘要见 `gpu-additions.json`。镜像为测试密钥配置、unsigned AVB hash footer；`security/` 仅包含公开验证材料，没有私有签名密钥。完整重建可能因工具、时间戳与生成字段产生不同镜像摘要。
