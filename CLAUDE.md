# CLAUDE.md

## 项目说明

WoodTools 是一个 macOS SwiftUI 菜单栏工具应用，使用 Swift Package Manager 管理项目。应用通过 AppKit `NSStatusItem` 提供系统状态栏入口，主体界面使用 SwiftUI，支持 Popover 和独立窗口两种打开方式。

## 技术栈

- Swift 6
- macOS 14+
- SwiftUI
- AppKit
- Swift Package Manager
- Yams

## 常用命令

构建项目：

```bash
swift build
```

运行项目：

```bash
swift run WoodTools
```

打包 app：

```bash
scripts/package_app.sh
```

安装到 `/Applications`：

```bash
scripts/package_app.sh --install
```

打包 DMG：

```bash
scripts/package_dmg.sh
```

## 目录约定

- `Sources/WoodTools/AppDelegate.swift`
  - AppKit 生命周期
  - 系统状态栏图标
  - Popover
  - 独立窗口
  - 应用菜单
- `Sources/WoodTools/ContentView.swift`
  - 主要 SwiftUI UI
  - 工具面板
  - 设置页
  - 主题样式
- `Sources/WoodTools/Models.swift`
  - `ToolCategory`
  - `ToolID`
  - 工具定义
  - 轻量数据模型
- `Sources/WoodTools/WoodToolsState.swift`
  - 全局状态
  - UserDefaults 持久化
  - 常用 App、日历备注、文件暂存等状态操作
- `Sources/WoodTools/ToolActions.swift`
  - 纯转换逻辑
  - 系统命令调用
  - 网络、编码、时间等工具动作
- `Resources/`
  - `AppIconWood.png`
  - `WoodTools.icns`
  - `MenuBarTemplate.png`
  - `DmgBackground.png`
- `scripts/`
  - 打包脚本

## 开发规则

- 默认使用中文沟通和说明。
- 保持改动最小化，不做与当前任务无关的重构。
- 优先复用已有组件和状态模式。
- 新增工具时同步更新：
  - `Models.swift` 中的 `ToolID`
  - `ToolID.title(language:)`
  - `ToolID.category`
  - `ToolID.iconName`
  - `ContentView.swift` 中对应分类的实际视图
- 新增纯转换逻辑优先放在 `ToolActions.swift`。
- 新增需要持久化的小型数据，优先复用 `WoodToolsState` 中的 `Codable + UserDefaults.data` 模式。
- 修改 SwiftUI UI 时，尽量复用已有：
  - `ToolPanel`
  - `ActionBar`
  - `AdaptiveTwoPaneLayout`
  - `LabeledInputBox`
  - `LabeledOutputBox`
  - `ResultBox`
- 不要提交构建产物：`.build/`、`dist/`、DMG、日志文件。

## 验证要求

- 修改 Swift 源码后运行：

```bash
swift build
```

- 修改 app bundle、资源文件或图标后运行：

```bash
scripts/package_app.sh
```

- 修改 DMG 脚本或背景后运行：

```bash
scripts/package_dmg.sh
```

## 注意事项

- `Info.plist` 由 `scripts/package_app.sh` 在打包时生成，不是独立源文件。
- DMG 背景由 Finder 使用静态图片展示，不能真正随窗口缩放自动拉伸；设计时应保证默认窗口大小下清晰可读。
- 菜单栏应用默认使用 `.accessory` activation policy；以独立窗口打开时会临时切换到 `.regular`，窗口关闭后需要恢复 `.accessory`。
