# Brave Android 定制浏览器

最新候选交付：**105（1.98.0-adblock2-rc1 / ARM64 Release）**，非 Brave 官方发行版。

- [下载候选版 105](https://github.com/lirui831221/brave-android-phase0/releases/tag/android-1.98.0-dcheckoff-105)
- [完整说明、验收结果和已知限制](docs/releases/android-1.98.0-dcheckoff-105/README.md)
- [构建与文件校验信息](docs/releases/android-1.98.0-dcheckoff-105/build-manifest.json)

本轮关闭原生开发检查，安装包缩小约 24%，启动后指定时点的菜单点击检查 12/12 通过。尚未证实稳定的掉帧改善，Safe Browsing 实际告警与完整安全更新验收仍未完成，因此以预发布提供。

以下保留早期 Phase 0 的历史记录；其中的“零源码修改”、包名、架构和测试结论仅适用于 Phase 0，不代表当前候选版。

## 历史记录：Phase 0

基于 [Brave](https://github.com/brave/brave-core) 官方开源代码构建的独立 Android 浏览器项目。

**Phase 0 状态：✅ 完成**（官方原版编译验证，零源码修改）

## 构建产物

| 项目 | 值 |
|---|---|
| APK | 568 MiB（arm / Debug） |
| SHA-256 | `5eb9c7fb017c385bf73716824e68eda5b5fa2ac8a923e67e64c83ea57f218777` |
| applicationId | `com.brave.browser_default`（与官方正式版共存） |
| versionName / Code | 1.98.0 / 429800000 |

APK 见 [Releases](../../releases)，完整测试报告见 [docs/BRAVE_ANDROID_PHASE0_REPORT.md](docs/BRAVE_ANDROID_PHASE0_REPORT.md)。

## 源码基线

- **brave-core**：v1.98.43 @ `26101b8d`，分支 [`android-custom-browser`](https://github.com/lirui831221/brave-core/tree/android-custom-browser)（fork 自 brave/brave-core master）
- **Chromium**：tag 155.0.8059.16 @ `eb81d1e9a7da`（googlesource 与 GitHub 双源核对一致）
- **源码改动**：零（禁改清单全部合规——未动内核/Shields/广告引擎/网络栈/sandbox/证书验证/安全策略/Rewards/UI）

## 验证结论

- **BUILD=PASS**：92,942 编译步骤，5h22m，构建机为 Debian 12 x86_64
- **BRAVE_SHIELDS_PRESENT=YES / AD_BLOCKING_PRESENT=YES / TRACKER_BLOCKING_PRESENT=YES**
- **ANDROID_INSTALL_TEST=PASS**：Redmi 真机（MIUI），`adb push` + `pm install`
- **BROWSER_SMOKE_TEST=PASS**：启动 / HTTPS / 多标签页 / Shields 开关 / 设置页 / 零崩溃
- 广告拦截实测（adblock-tester.com）：Google AdSense、Yandex Direct、Google Analytics、Hotjar、Yandex.Metrica 全部拦截

## 仓库结构

```
docs/         Phase 0 完整报告
scripts/      构建环境脚本（代理/种源/git 配置）
verification/ 构建成功日志摘要
```

## 构建环境要点（详见 scripts/）

1. Debian 12 x86_64 + Node 24 + pnpm 11 + git 2.45 + g++（macOS 无法构建 Chromium Android，官方限制）
2. **Chromium 种源三跳**：代理会掐断 googlesource 大 pack 下载 → 海外 VPS 浅克隆 tag → 内网传输 → git alternates 本地接入（`scripts/chromium-seed-setup.sh`）
3. 依赖：`install-build-deps.sh --android --no-prompt`（`--no-prompt` 必须，否则交互确认卡死）
4. 编译：`pnpm run build Debug --target_os=android --target_arch=arm --target_android_output_format=apk --gn=treat_warnings_as_errors:false`

## 后续

Phase 1（产品定制）将基于 `android-custom-browser` 分支进行。
