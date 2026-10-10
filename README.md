# OPPO Find X7 Ultra — AERA Recovery

非官方 **r14 Alpha 预发布（2026-10-10）**，仅面向 **OPPO Find X7 Ultra PHY110 / project 22111**。存在已知问题，不是稳定版。

## 实机验证

- r13 完整重启后触摸、菜单、锁屏解密、内部存储目录及 Wi-Fi 正常；之前已验证亮度和锁屏/唤醒。
- 浏览器首页、HTTPS 页面、Google/YouTube 链接、普通百度页面链接及哔哩哔哩链接能够使用。
- 中文正文与弹幕显示已修复。默认内部存储为 `/data/media/0`，系统下载目录为 `/sdcard/Download`。
- 存储容量与未挂载 USB/NAS 显示、旧命令超时问题已修正。MTP 双向摘要、100 MiB Recovery 备份、逻辑分区只读挂载在早期修订验证通过。
- r14 核心和浏览器 worker 已在实机 RAM 中运行；发布镜像完成格式、AVB hash footer、ELF 依赖和资源摘要检查。**r14 打包镜像尚未刷入并完整重启验证**，最近完成整镜像冷启动的是 r13。

## 已知问题

1. 百度搜索框弹出的建议关键词仍无法点击选中并搜索。词条变色、键盘收起，但没有完成搜索。普通页面链接可点击。r14 修正了一个键盘焦点变化时丢失松手事件的问题，相关主机测试通过，但实机建议词条问题仍未解决。
2. 部分哔哩哔哩视频一直加载，显示“网络状况异常 / 错误码 4004”，其他视频能够播放。原因未确定，不能宣称所有编码或网站视频兼容。
3. **发布镜像尚未自动启用原厂音频后端。**扬声器提示音和浏览器视频声音在本次 Recovery 启动的临时音频调试中已由用户确认正常，但该启动流程尚未固化。重新进入 Recovery 后不能据此保证有声音。
4. 早期短时音频客户端退出时出现过一次崩溃；修订客户端连续三次静音播放退出没有新增崩溃，但尚未完成冷启动及长时间验证。
5. 主界面使用软件渲染；厂商辅助服务及浏览器日志仍有告警。调试时使用 permissive SELinux；USB Recovery 调试不提供认证，网络 ADB 默认关闭。

恢复、清除/格式化、文件系统修复、ZIP 刷写、fastbootd/sideload、OTG、NAS 和长期稳定性未完整验证。正常 Android 启动曾在 r2 验证，本次 r14 未复测。

## 镜像

Release 附件：`AERA-PHY110-20261010-r14-alpha.img`，**104857600 字节（100 MiB）**。

```text
e2b4183e2912677cf75c6cdc7a0316a9166ca1e3dfc75d7d3207e96ce051493a
```

仅供已解锁且确认型号、固件及当前槽位的 PHY110 使用。备份自己的原 Recovery，并确认刷写目标。此前实机验证使用 B 槽 `recovery_b`，A 槽保持原内容；这不代表其他手机都应写 B 槽。本项目不提供跨机型通用刷写脚本。

## 源码与构建

仓库作为 AERA 源码根目录中的 `device/oppo/phy110`；产品为 `twrp_phy110-bp2a-eng`。锁定来源见 `source-lock.json` 与 `build-record/resolved-manifest.xml`，适配补丁在 `patches/`，构建说明见 [BUILD.md](BUILD.md)。音频原型及限制见 [experimental/audio/README.md](experimental/audio/README.md)。

各文件原有版权与许可证保留。厂商二进制及固件不因发布而改授开源许可，参见 [NOTICE.md](NOTICE.md)。公开资料不含用户备份、原始手机日志、锁屏密码或网络凭据。
