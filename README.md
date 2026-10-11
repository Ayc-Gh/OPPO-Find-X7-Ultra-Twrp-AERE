# OPPO Find X7 Ultra — AERA Recovery

非官方 **r18 Alpha 预发布（2026-10-11）**，仅面向 **OPPO Find X7 Ultra PHY110 / project 22111**。

## 本版变化

- 加入固定官方提交的新 OpenH264 解码库，SONAME 8；由可信 Recovery 启动器在非特权浏览器中只读覆盖。重新准备或安装已兼容的浏览器引擎可继续使用，原签名插件保持完整。
- 保留 r15–r17 修复：百度搜索建议点击、中文字体、当前槽原厂音频自动初始化、PHY110 Turnip/KGSL 兼容、WLAN IPA 禁用及保存网络重连等待。
- 本版基于已验证 r17 重打包，仅更换启动器并新增解码库；Recovery 核心、内核、触摸、Wi-Fi 和音频资产不变。

## 验证范围

离线 H.264 样本在原始库和新库各 5 次测试中均解出 100 帧、0 错误，同线程数像素摘要一致。新库实际网页短时播放未出现原来的参考帧错误，但网络失败限制了测试覆盖，**不能认定解码错误已彻底修复**。本版已刷入并完整读回校验，冷启动后 Data、Wi-Fi、可信新库映射与浏览器隔离正常；用户确认 YouTube 等触摸、网页、画面和声音完全正常。详细结果见 [validation/r18-summary.json](validation/r18-summary.json)。

r17 已验证解密、触摸菜单、保存 Wi-Fi 重连、YouTube 画面及声音；GPU AHB/faultcount 为 0，网络收发错误为 0，短静音音频接口创建/退出测试通过。百度搜索建议修复已获用户确认。

## 已知问题

部分哔哩哔哩视频仍显示 4004：视频分段 CDN 有 HTTP 403 拒绝响应；原始解码库还曾出现 PrefetchPic 参考帧错误。新库并不解决服务器拒绝。用户报告过浏览器偶发退出，本轮未复现，长期稳定性仍待验证。

IPA 禁用初始化仍有两条 invalid instance，厂商辅助服务及浏览器仍有部分告警。调试配置沿用 permissive SELinux、无认证 USB Recovery ADB；网络 ADB 默认关闭。

恢复、清除/格式化、文件系统修复、ZIP 刷写、fastbootd/sideload、OTG/NAS 未完整验证。正常 Android 启动仅在早期 r2 验证。本版不宣称稳定或通用适配。

## 下载与刷写

Release 镜像：`AERA-PHY110-20261011-r18-alpha.img`，104857600 字节（100 MiB）。

SHA256：`22387b39ff2367ade14d9e25af59e207fcd84f7796ce3b546633b45178b9033c`

确认 PHY110、已解锁、兼容固件以及实际当前槽后，先备份自己的 Recovery，再写入相应 recovery 分区。不要照搬开发手机的槽位。内部存储 `/data/media/0`，系统下载目录 `/sdcard/Download`。

## 源码

设备树放入 AERA 的 `device/oppo/phy110`。核心基线、完整适配补丁及新库来源见 [BUILD.md](BUILD.md)、[source-lock.json](source-lock.json)、[NOTICE.md](NOTICE.md)。原始日志、网络凭据和用户备份不在发布材料中。
