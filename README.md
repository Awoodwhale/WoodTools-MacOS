# WoodTools

WoodTools 是一个 macOS 菜单栏开发者工具应用，使用 Swift Package Manager、AppKit 和 SwiftUI 构建。应用默认以系统状态栏图标运行，支持弹出式工具面板，也可以通过右键菜单或顶部按钮以独立窗口打开。

## 功能概览

- 时间工具
  - 时间戳与格式化时间互转
  - 自定义时间格式
  - 日历备注，可为重要日期记录信息
- 进制工具
  - 二进制、八进制、十进制、十六进制转换
- 编码工具
  - URL 编码 / 解码
  - Base64 编码 / 解码
  - Hex 解码
  - JSON / YAML 转换
  - JSON 格式化 / 压缩
  - 大小写转换
- 网络工具
  - 本机网络信息
  - Wi-Fi 密码读取
  - 网络诊断
  - 网络测速
- 快捷工具
  - 常用 App 快速打开与排序
  - 文件暂存
  - 系统快捷操作
  - UUID 生成
- 个性化设置
  - 多主题，默认 Wood 主题
  - 中英文语言切换
  - 默认入口、搜索源、浏览器、窗口尺寸配置
  - 一键恢复默认设置

## 环境要求

- macOS 14 或更高版本
- Swift 6.0 或更高版本
- Xcode Command Line Tools

## 快速开始

```bash
swift build
swift run WoodTools
```

## 打包 app

生成 `dist/WoodTools.app`：

```bash
scripts/package_app.sh
```

安装到 `/Applications`：

```bash
scripts/package_app.sh --install
```

## 打包 DMG

生成 `dist/WoodTools.dmg`：

```bash
scripts/package_dmg.sh
```

DMG 会使用 `Resources/DmgBackground.png` 作为 Finder 背景，并设置拖拽安装布局。

## 项目结构

```text
Package.swift                 Swift Package 配置
Sources/WoodTools/            应用源码
Resources/                    图标、状态栏图标、DMG 背景资源
scripts/package_app.sh        app bundle 打包脚本
scripts/package_dmg.sh        DMG 打包脚本
```

## 主要源码

- `Sources/WoodTools/main.swift`：应用入口
- `Sources/WoodTools/AppDelegate.swift`：状态栏、Popover、独立窗口和 AppKit 生命周期
- `Sources/WoodTools/Models.swift`：工具分类、工具 ID、数据模型
- `Sources/WoodTools/WoodToolsState.swift`：应用状态、设置和持久化
- `Sources/WoodTools/ContentView.swift`：主要 SwiftUI 界面
- `Sources/WoodTools/ToolActions.swift`：工具执行逻辑和系统命令封装

## 依赖

- [Yams](https://github.com/jpsim/Yams)：JSON / YAML 转换

## 开发约定

- 修改代码后至少运行：

```bash
swift build
```

- 修改打包、资源、图标或 DMG 相关内容后运行：

```bash
scripts/package_app.sh
scripts/package_dmg.sh
```

- 不提交 `.build/`、`dist/`、DMG、日志和系统临时文件。
