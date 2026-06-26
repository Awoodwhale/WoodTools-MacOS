import AppKit
import SwiftUI
import UniformTypeIdentifiers

enum TimestampUnit: String, CaseIterable, Identifiable {
    case seconds = "秒"
    case milliseconds = "毫秒"

    var id: String { rawValue }

    var usesMilliseconds: Bool { self == .milliseconds }

    func title(language: AppLanguage) -> String {
        switch language.resolved {
        case .english:
            self == .seconds ? "Seconds" : "Milliseconds"
        case .system, .zhHans:
            rawValue
        }
    }
}

enum ConverterLayoutMode: String, CaseIterable, Identifiable {
    case vertical = "上下"
    case horizontal = "左右"

    var id: String { rawValue }

    func title(language: AppLanguage) -> String {
        switch language.resolved {
        case .english:
            self == .vertical ? "Vertical" : "Horizontal"
        case .system, .zhHans:
            rawValue
        }
    }
}

struct AppThemePalette {
    let background: Color
    let backgroundAccent: Color
    let toolbarBackground: Color
    let panelBackground: Color
    let controlBackground: Color
    let controlPressedBackground: Color
    let border: Color
    let primaryText: Color
    let secondaryText: Color
    let accent: Color
    let selectedForeground: Color
    let error: Color
    let shadow: Color
}

extension AppTheme {
    var preferredColorScheme: ColorScheme? {
        switch self {
        case .light, .githubLight, .wood:
            return .light
        case .dark, .dracula, .githubDark, .oneDarkPro:
            return .dark
        }
    }

    var palette: AppThemePalette {
        switch self {
        case .light:
            return AppThemePalette(
                background: Color(hex: 0xFFFFFF),
                backgroundAccent: Color(hex: 0xF8FAFC),
                toolbarBackground: Color(hex: 0xFFFFFF).opacity(0.96),
                panelBackground: Color(hex: 0xFFFFFF).opacity(0.94),
                controlBackground: Color(hex: 0xF8FAFC),
                controlPressedBackground: Color(hex: 0xEEF2F7),
                border: Color(hex: 0xD8DEE7),
                primaryText: Color(hex: 0x111827),
                secondaryText: Color(hex: 0x57606A),
                accent: Color(hex: 0x8B5E34),
                selectedForeground: .white,
                error: Color(hex: 0xCF222E),
                shadow: Color.black.opacity(0.035)
            )
        case .dark:
            return AppThemePalette(
                background: Color(hex: 0x050505),
                backgroundAccent: Color(hex: 0x111111),
                toolbarBackground: Color(hex: 0x0B0B0B).opacity(0.98),
                panelBackground: Color(hex: 0x141414),
                controlBackground: Color(hex: 0x1F1F1F),
                controlPressedBackground: Color(hex: 0x2A2A2A),
                border: Color(hex: 0x333333),
                primaryText: Color(hex: 0xF5F5F5),
                secondaryText: Color(hex: 0xA3A3A3),
                accent: Color(hex: 0xA78BFA),
                selectedForeground: .white,
                error: Color(hex: 0xF87171),
                shadow: .clear
            )
        case .dracula:
            return AppThemePalette(
                background: Color(hex: 0x282A36),
                backgroundAccent: Color(hex: 0x1E1F29),
                toolbarBackground: Color(hex: 0x21222C).opacity(0.98),
                panelBackground: Color(hex: 0x21222C),
                controlBackground: Color(hex: 0x343746),
                controlPressedBackground: Color(hex: 0x44475A),
                border: Color(hex: 0x44475A),
                primaryText: Color(hex: 0xF8F8F2),
                secondaryText: Color(hex: 0xC7C7BD),
                accent: Color(hex: 0xBD93F9),
                selectedForeground: Color(hex: 0x282A36),
                error: Color(hex: 0xFF5555),
                shadow: .clear
            )
        case .githubLight:
            return AppThemePalette(
                background: Color(hex: 0xFFFFFF),
                backgroundAccent: Color(hex: 0xF6F8FA),
                toolbarBackground: Color(hex: 0xF6F8FA).opacity(0.98),
                panelBackground: Color(hex: 0xFFFFFF),
                controlBackground: Color(hex: 0xF6F8FA),
                controlPressedBackground: Color(hex: 0xEAEEF2),
                border: Color(hex: 0xD0D7DE),
                primaryText: Color(hex: 0x24292F),
                secondaryText: Color(hex: 0x57606A),
                accent: Color(hex: 0x0969DA),
                selectedForeground: .white,
                error: Color(hex: 0xCF222E),
                shadow: Color.black.opacity(0.035)
            )
        case .githubDark:
            return AppThemePalette(
                background: Color(hex: 0x0D1117),
                backgroundAccent: Color(hex: 0x010409),
                toolbarBackground: Color(hex: 0x161B22).opacity(0.98),
                panelBackground: Color(hex: 0x161B22),
                controlBackground: Color(hex: 0x0D1117),
                controlPressedBackground: Color(hex: 0x21262D),
                border: Color(hex: 0x30363D),
                primaryText: Color(hex: 0xE6EDF3),
                secondaryText: Color(hex: 0x8B949E),
                accent: Color(hex: 0x2F81F7),
                selectedForeground: .white,
                error: Color(hex: 0xFF7B72),
                shadow: .clear
            )
        case .oneDarkPro:
            return AppThemePalette(
                background: Color(hex: 0x282C34),
                backgroundAccent: Color(hex: 0x21252B),
                toolbarBackground: Color(hex: 0x21252B).opacity(0.98),
                panelBackground: Color(hex: 0x2C313A),
                controlBackground: Color(hex: 0x21252B),
                controlPressedBackground: Color(hex: 0x343A46),
                border: Color(hex: 0x3E4451),
                primaryText: Color(hex: 0xABB2BF),
                secondaryText: Color(hex: 0x7F848E),
                accent: Color(hex: 0x61AFEF),
                selectedForeground: Color(hex: 0x1F2329),
                error: Color(hex: 0xE06C75),
                shadow: .clear
            )
        case .wood:
            return AppThemePalette(
                background: Color(hex: 0xFFF7E6),
                backgroundAccent: Color(hex: 0xF1D6A8),
                toolbarBackground: Color(hex: 0xFFF1D6).opacity(0.98),
                panelBackground: Color(hex: 0xFFF8EA).opacity(0.96),
                controlBackground: Color(hex: 0xF6E3C1),
                controlPressedBackground: Color(hex: 0xEBCB95),
                border: Color(hex: 0xC99655),
                primaryText: Color(hex: 0x3D2814),
                secondaryText: Color(hex: 0x73502A),
                accent: Color(hex: 0xA45A20),
                selectedForeground: Color(hex: 0xFFF8EA),
                error: Color(hex: 0xB42318),
                shadow: Color.black.opacity(0.04)
            )
        }
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0
        )
    }
}

struct ContentView: View {
    @EnvironmentObject private var state: WoodToolsState

    var body: some View {
        VStack(spacing: 0) {
            TopToolBarView()
            Divider()
                .overlay(state.settings.theme.palette.border)
            MainContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(
            minWidth: WoodToolsState.popoverWidthRange.lowerBound,
            idealWidth: state.settings.popoverWidth,
            minHeight: WoodToolsState.popoverHeightRange.lowerBound,
            idealHeight: state.settings.popoverHeight
        )
        .background(AppBackgroundView())
        .preferredColorScheme(state.settings.theme.preferredColorScheme)
        .tint(state.settings.theme.palette.accent)
        .overlay(alignment: .bottom) {
            if let message = state.transientMessage {
                ToastView(message: message)
                    .task(id: message) {
                        try? await Task.sleep(for: .seconds(1.2))
                        state.transientMessage = nil
                    }
            }
        }
    }
}

struct AppBackgroundView: View {
    @EnvironmentObject private var state: WoodToolsState

    var body: some View {
        let palette = state.settings.theme.palette

        ZStack {
            palette.background
            LinearGradient(
                colors: [palette.background, palette.backgroundAccent],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

struct TopToolBarView: View {
    @EnvironmentObject private var state: WoodToolsState

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 8) {
                BrandHeaderView()
                AddressBarField()
                    .frame(maxWidth: .infinity)
                OpenWindowTopButton()
                SettingsTopButton()
                UsageTopButton()
            }

            CategoryPillBarView()
        }
        .padding(.horizontal, 12)
        .padding(.top, 10)
        .padding(.bottom, 9)
        .background(state.settings.theme.palette.toolbarBackground)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(state.settings.theme.palette.border)
                .frame(height: 1)
        }
    }
}

struct BrandHeaderView: View {
    @EnvironmentObject private var state: WoodToolsState

    var body: some View {
        Button {
            state.goHome()
        } label: {
            HStack(spacing: 8) {
                WoodToolIconView(size: 22)
                Text("WoodTools")
                    .font(.headline.weight(.semibold))
                    .lineLimit(1)
            }
            .frame(minWidth: 108, alignment: .leading)
        }
        .buttonStyle(.plain)
        .help(state.localized("回到默认工具", "Back to default tool"))
    }
}

struct WoodToolIconView: View {
    let size: CGFloat

    var body: some View {
        Group {
            if let image = NSImage(named: "AppIconWood") {
                Image(nsImage: image)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFill()
            } else {
                fallbackIcon
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.28, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: size * 0.28, style: .continuous).stroke(.white.opacity(0.12), lineWidth: 1))
        .accessibilityHidden(true)
    }

    private var fallbackIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.93, green: 0.72, blue: 0.46), Color(red: 0.58, green: 0.32, blue: 0.13)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            ForEach(0..<3, id: \.self) { index in
                Ellipse()
                    .stroke(Color(red: 0.38, green: 0.20, blue: 0.08).opacity(0.72), lineWidth: 1.1)
                    .frame(width: size * (0.38 + CGFloat(index) * 0.18), height: size * (0.22 + CGFloat(index) * 0.11))
            }
        }
    }
}

struct AddressBarField: View {
    @EnvironmentObject private var state: WoodToolsState

    var body: some View {
        let palette = state.settings.theme.palette

        HStack(spacing: 7) {
            Image(systemName: "globe")
                .font(.caption.weight(.semibold))
                .foregroundStyle(palette.secondaryText)

            TextField(state.localized("输入网址或搜索关键词", "Enter URL or search"), text: $state.addressText)
                .textFieldStyle(.plain)
                .foregroundStyle(palette.primaryText)
                .onSubmit {
                    state.openAddressOrSearch()
                }

            if !state.addressText.isEmpty {
                Button {
                    state.addressText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(palette.secondaryText)
                }
                .buttonStyle(.plain)
                .help(state.localized("清空地址栏", "Clear address bar"))
            }
        }
        .padding(.horizontal, 10)
        .frame(height: 32)
        .background(palette.controlBackground, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(palette.border))
    }
}

struct OpenWindowTopButton: View {
    @EnvironmentObject private var state: WoodToolsState

    var body: some View {
        Button {
            NotificationCenter.default.post(name: .woodToolsOpenMainWindow, object: nil)
        } label: {
            Label(state.localized("窗口", "Window"), systemImage: "macwindow")
                .labelStyle(.iconOnly)
                .frame(width: 32, height: 32)
        }
        .buttonStyle(GlassIconButtonStyle(isSelected: false))
        .help(state.localized("以窗口打开", "Open as window"))
    }
}

struct SettingsTopButton: View {
    @EnvironmentObject private var state: WoodToolsState

    var body: some View {
        Button {
            state.openSettings()
        } label: {
            Label(state.localized("设置", "Settings"), systemImage: "gearshape")
                .labelStyle(.iconOnly)
                .frame(width: 32, height: 32)
        }
        .buttonStyle(GlassIconButtonStyle(isSelected: state.showingSettings))
        .help(state.localized("设置", "Settings"))
    }
}

struct UsageTopButton: View {
    @EnvironmentObject private var state: WoodToolsState

    var body: some View {
        Button {
            state.openUsage()
        } label: {
            Label(state.localized("统计", "Stats"), systemImage: "chart.bar.xaxis")
                .labelStyle(.iconOnly)
                .frame(width: 32, height: 32)
        }
        .buttonStyle(GlassIconButtonStyle(isSelected: state.showingUsage))
        .help(state.localized("今日使用", "Today stats"))
    }
}

struct QuickEntrancesView: View {
    private let quickTools: [ToolID] = [.timeConverter, .urlCoding, .networkSummary]

    var body: some View {
        HStack(spacing: 5) {
            ForEach(quickTools) { tool in
                QuickEntranceButton(tool: tool)
            }
        }
    }
}

struct QuickEntranceButton: View {
    @EnvironmentObject private var state: WoodToolsState
    let tool: ToolID

    var body: some View {
        Button {
            state.openCategory(tool.category)
        } label: {
            Image(systemName: tool.iconName)
                .frame(width: 32, height: 32)
        }
        .buttonStyle(GlassIconButtonStyle(isSelected: !state.showingUsage && state.selectedCategory == tool.category))
        .help(tool.title)
    }
}

struct CategoryPillBarView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                ForEach(ToolCategory.allCases.filter { $0 != .other }) { category in
                    CategoryPillButton(category: category)
                }
            }
            .padding(.vertical, 1)
        }
    }
}

struct CategoryPillButton: View {
    @EnvironmentObject private var state: WoodToolsState
    let category: ToolCategory

    var body: some View {
        Button {
            state.openCategory(category)
        } label: {
            Label(category.title(language: state.settings.language), systemImage: category.iconName)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 11)
                .frame(height: 29)
        }
        .buttonStyle(GlassPillButtonStyle(isSelected: !state.showingUsage && state.selectedCategory == category))
    }
}

struct MainContentView: View {
    @EnvironmentObject private var state: WoodToolsState

    var body: some View {
        VStack(spacing: 0) {
            ContentTitleBar(title: title, subtitle: subtitle)

            if state.showingSettings {
                SettingsView()
            } else if state.showingUsage {
                UsageView()
            } else {
                CategoryWorkspaceView(category: state.selectedCategory)
            }
        }
    }

    private var trimmedSearchText: String {
        state.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var title: String {
        if state.showingSettings { return state.localized("设置", "Settings") }
        if state.showingUsage { return state.localized("今日使用", "Today") }
        return state.selectedCategory.title(language: state.settings.language)
    }

    private var subtitle: String {
        if state.showingSettings { return state.localized("统一配置主题、布局、语言和时间格式", "Configure theme, layout, language, and time format") }
        if state.showingUsage { return state.localized("详细统计只在这里展示", "Detailed stats live here") }
        return state.localized("更少卡片，更直接的双向处理", "Focused tools with direct two-pane workflows")
    }
}

struct ContentTitleBar: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.top, 10)
        .padding(.bottom, 8)
    }
}

struct SearchResultsView: View {
    @EnvironmentObject private var state: WoodToolsState

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                if state.filteredToolsByCategory.isEmpty {
                    EmptySearchResultView()
                } else {
                    ForEach(state.filteredToolsByCategory, id: \.0.id) { category, tools in
                        SearchResultSection(category: category, tools: tools)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
    }
}

struct SearchResultSection: View {
    @EnvironmentObject private var state: WoodToolsState
    let category: ToolCategory
    let tools: [ToolDefinition]

    var body: some View {
        ToolPanel(title: category.title(language: state.settings.language), iconName: category.iconName) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 154), spacing: 8)], spacing: 8) {
                ForEach(tools) { tool in
                    SearchToolCard(tool: tool)
                }
            }
        }
    }
}

struct SearchToolCard: View {
    @EnvironmentObject private var state: WoodToolsState
    let tool: ToolDefinition

    var body: some View {
        Button {
            state.openCategory(tool.category)
        } label: {
            HStack(spacing: 9) {
                Image(systemName: tool.iconName)
                    .foregroundStyle(.white)
                    .frame(width: 26, height: 26)
                    .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                VStack(alignment: .leading, spacing: 1) {
                    Text(tool.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(tool.category.title(language: state.settings.language))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
            }
            .padding(9)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(SearchToolCardButtonStyle())
    }
}

struct EmptySearchResultView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.title2)
                .foregroundStyle(.secondary)
            Text("No matching tools")
                .font(.headline)
            Text("Try URL, time, JSON, Ping, or other keywords")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .glassPanel(cornerRadius: 16)
    }
}

struct SettingsView: View {
    @EnvironmentObject private var state: WoodToolsState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ToolPanel(title: state.localized("外观", "Appearance"), iconName: "paintpalette") {
                    SettingsPickerRow(title: state.localized("主题", "Theme")) {
                        Picker(state.localized("主题", "Theme"), selection: themeBinding) {
                            ForEach(AppTheme.allCases) { theme in
                                Text(theme.title).tag(theme)
                            }
                        }
                        .labelsHidden()
                    }
                    SettingsPickerRow(title: state.localized("语言", "Language")) {
                        Picker(state.localized("语言", "Language"), selection: languageBinding) {
                            ForEach(AppLanguage.allCases) { language in
                                Text(language.title).tag(language)
                            }
                        }
                        .labelsHidden()
                    }
                }

                ToolPanel(title: state.localized("布局", "Layout"), iconName: "rectangle.split.2x1") {
                    SettingsPickerRow(title: state.localized("转换器布局", "Converter layout")) {
                        Picker(state.localized("转换器布局", "Converter layout"), selection: layoutBinding) {
                            ForEach(ConverterLayoutMode.allCases) { mode in
                                Text(mode.title(language: state.settings.language)).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                        .frame(width: 140)
                    }
                }

                ToolPanel(title: state.localized("地址栏", "Address Bar"), iconName: "globe") {
                    SettingsPickerRow(title: state.localized("搜索源", "Search engine")) {
                        Picker(state.localized("搜索源", "Search engine"), selection: searchEngineBinding) {
                            ForEach(SearchEngine.allCases) { engine in
                                Text(engine.title(language: state.settings.language)).tag(engine)
                            }
                        }
                        .labelsHidden()
                    }
                    SettingsPickerRow(title: state.localized("浏览器", "Browser")) {
                        Picker(state.localized("浏览器", "Browser"), selection: browserBinding) {
                            ForEach(BrowserTarget.allCases) { browser in
                                Text(browser.title(language: state.settings.language)).tag(browser)
                            }
                        }
                        .labelsHidden()
                    }
                }

                ToolPanel(title: state.localized("启动", "Startup"), iconName: "arrow.forward.circle") {
                    SettingsPickerRow(title: state.localized("默认打开", "Default category")) {
                        Picker(state.localized("默认打开", "Default category"), selection: startupBinding) {
                            ForEach(StartupCategory.allCases) { category in
                                Text(category.title(language: state.settings.language)).tag(category)
                            }
                        }
                        .labelsHidden()
                    }
                }

                ToolPanel(title: state.localized("时间格式", "Time Format"), iconName: "calendar.badge.clock") {
                    SettingsPickerRow(title: state.localized("输出格式", "Output format")) {
                        Picker(state.localized("输出格式", "Output format"), selection: timeFormatBinding) {
                            ForEach(TimeFormatMode.allCases) { mode in
                                Text(mode.title).tag(mode)
                            }
                        }
                        .labelsHidden()
                    }

                    if state.settings.timeFormatMode == .custom {
                        LabeledInputBox(
                            title: state.localized("自定义格式", "Custom format"),
                            text: customTimeFormatBinding,
                            placeholder: "yyyy-MM-dd HH:mm:ss",
                            minHeight: 42
                        )
                    }

                    ResultBox(text: formattedNow(format: state.effectiveTimeFormat), isError: false, minHeight: 38)
                }

                ToolPanel(title: state.localized("窗口尺寸", "Window Size"), iconName: "rectangle.resize") {
                    SizeSliderRow(title: state.localized("宽度", "Width"), value: popoverWidthBinding, range: WoodToolsState.popoverWidthRange)
                    SizeSliderRow(title: state.localized("高度", "Height"), value: popoverHeightBinding, range: WoodToolsState.popoverHeightRange)
                    ActionBar {
                        Button(state.localized("恢复出厂设置", "Restore Defaults"), role: .destructive) {
                            state.resetSettingsToDefaults()
                        }
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
    }

    private var themeBinding: Binding<AppTheme> {
        Binding(
            get: { state.settings.theme },
            set: { state.updateTheme($0) }
        )
    }

    private var layoutBinding: Binding<ConverterLayoutMode> {
        Binding(
            get: { state.settings.converterLayoutMode },
            set: { state.updateConverterLayoutMode($0) }
        )
    }

    private var languageBinding: Binding<AppLanguage> {
        Binding(
            get: { state.settings.language },
            set: { state.updateLanguage($0) }
        )
    }

    private var searchEngineBinding: Binding<SearchEngine> {
        Binding(
            get: { state.settings.searchEngine },
            set: { state.updateSearchEngine($0) }
        )
    }

    private var browserBinding: Binding<BrowserTarget> {
        Binding(
            get: { state.settings.browserTarget },
            set: { state.updateBrowserTarget($0) }
        )
    }

    private var startupBinding: Binding<StartupCategory> {
        Binding(
            get: { state.settings.startupCategory },
            set: { state.updateStartupCategory($0) }
        )
    }

    private var timeFormatBinding: Binding<TimeFormatMode> {
        Binding(
            get: { state.settings.timeFormatMode },
            set: { state.updateTimeFormatMode($0) }
        )
    }

    private var customTimeFormatBinding: Binding<String> {
        Binding(
            get: { state.settings.customTimeFormat },
            set: { state.updateCustomTimeFormat($0) }
        )
    }

    private var popoverWidthBinding: Binding<Double> {
        Binding(
            get: { state.settings.popoverWidth },
            set: { state.updatePopoverWidth($0) }
        )
    }

    private var popoverHeightBinding: Binding<Double> {
        Binding(
            get: { state.settings.popoverHeight },
            set: { state.updatePopoverHeight($0) }
        )
    }
}

struct SettingsPickerRow<Control: View>: View {
    let title: String
    @ViewBuilder let control: Control

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.subheadline)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(minWidth: 92, maxWidth: 150, alignment: .leading)
            Spacer(minLength: 0)
            control
                .frame(maxWidth: 220, alignment: .trailing)
        }
    }
}

struct SizeSliderRow: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        SettingsPickerRow(title: title) {
            HStack(spacing: 8) {
                Slider(value: $value, in: range, step: 10)
                    .frame(width: 150)
                Text("\(Int(value))")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .frame(width: 38, alignment: .trailing)
            }
        }
    }
}

struct CategoryWorkspaceView: View {
    @EnvironmentObject private var state: WoodToolsState
    let category: ToolCategory

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                switch category {
                case .time:
                    TimeConverterView()
                    CalendarNotesView()
                case .radix:
                    RadixConverterView()
                case .coding:
                    BidirectionalTextToolView(
                        title: state.localized("URL 编码 / 解码", "URL Encode / Decode"),
                        iconName: "link",
                        leftTitle: state.localized("原文", "Plain Text"),
                        rightTitle: state.localized("URL 编码", "URL Encoded"),
                        leftPlaceholder: "https://example.com?q=hello",
                        rightPlaceholder: "https%3A%2F%2Fexample.com%3Fq%3Dhello",
                        forwardTitle: "Encode →",
                        backwardTitle: "← Decode",
                        forward: encodeURL,
                        backward: decodeURL
                    )
                    BidirectionalTextToolView(
                        title: state.localized("Base64 编码 / 解码", "Base64 Encode / Decode"),
                        iconName: "textformat.abc",
                        leftTitle: state.localized("原文", "Plain Text"),
                        rightTitle: "Base64",
                        leftPlaceholder: state.localized("在这里粘贴文本", "Paste text here"),
                        rightPlaceholder: state.localized("Base64 内容", "Base64 content"),
                        forwardTitle: "Encode →",
                        backwardTitle: "← Decode",
                        forward: { encodeBase64($0) },
                        backward: decodeBase64
                    )
                    HexDecodeView()
                    JSONYAMLConverterView()
                    JSONToolView()
                    CaseConvertView()
                case .network:
                    NetworkSummaryView()
                    InstantResultToolView(title: state.localized("Wi-Fi 密码", "Wi-Fi Password"), iconName: "key", actionTitle: state.localized("显示密码", "Show Password"), autoRun: false, resultProvider: wifiPasswordSummary)
                    NetworkDiagnosticsView()
                    NetworkSpeedTestView()
                case .quick:
                    FavoriteAppsView()
                    FileShelfView()
                    QuickActionsGridView()
                    UUIDGeneratorView()
                case .other:
                    EmptyView()
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
    }
}

struct TimeConverterView: View {
    @EnvironmentObject private var state: WoodToolsState
    @State private var timestamp = ""
    @State private var formattedTime = ""
    @State private var timestampUnit: TimestampUnit = .seconds
    @State private var lastResult = ""
    @State private var errorMessage: String?

    var body: some View {
        ToolPanel(title: state.localized("时间转换", "Time Converter"), iconName: "clock.arrow.circlepath") {
            HStack(spacing: 8) {
                TimeChip(title: state.localized("当前时间戳", "Current Timestamp"), value: currentTimestamp())
                Button(state.localized("刷新", "Refresh")) {
                    timestamp = timestampUnit.usesMilliseconds ? currentMillisecondTimestamp() : currentTimestamp()
                    formattedTime = formattedNow(format: state.effectiveTimeFormat)
                    lastResult = timestamp
                    errorMessage = nil
                }
            }

            AdaptiveTwoPaneLayout(minHeight: 92) {
                LabeledInputBox(title: state.localized("时间戳", "Timestamp"), text: $timestamp, placeholder: "1716888888 / 1716888888123", minHeight: 92)
            } right: {
                LabeledInputBox(title: state.localized("格式化时间", "Formatted Time"), text: $formattedTime, placeholder: "2026-05-28 18:30:00", minHeight: 92)
            }

            HStack(spacing: 8) {
                Picker(state.localized("输出单位", "Output Unit"), selection: $timestampUnit) {
                    ForEach(TimestampUnit.allCases) { unit in
                        Text(unit.title(language: state.settings.language)).tag(unit)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 120)

                Button(state.localized("时间戳 → 时间", "Timestamp → Time")) {
                    runTimestampToTime()
                }
                .buttonStyle(.borderedProminent)

                Button(state.localized("时间 → 时间戳", "Time → Timestamp")) {
                    runTimeToTimestamp()
                }

                Button(state.localized("复制", "Copy")) {
                    state.copy(lastResult, title: state.localized("复制时间", "Copy time"))
                }
                .disabled(lastResult.isEmpty)

                Button(state.localized("清空", "Clear")) {
                    timestamp = ""
                    formattedTime = ""
                    lastResult = ""
                    errorMessage = nil
                }
            }
            .controlSize(.small)

            if let errorMessage {
                ResultBox(text: errorMessage, isError: true, minHeight: 44)
            }
        }
    }

    private func runTimestampToTime() {
        do {
            formattedTime = try timestampToFormattedTime(timestamp, format: state.effectiveTimeFormat)
            lastResult = formattedTime
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func runTimeToTimestamp() {
        do {
            timestamp = try formattedTimeToTimestamp(formattedTime, milliseconds: timestampUnit.usesMilliseconds)
            lastResult = timestamp
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct TimeChip: View {
    @EnvironmentObject private var state: WoodToolsState
    let title: String
    let value: String

    var body: some View {
        let palette = state.settings.theme.palette

        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(palette.secondaryText)
            Text(value)
                .font(.caption.monospacedDigit())
                .foregroundStyle(palette.primaryText)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(palette.controlBackground, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(palette.border))
    }
}

struct CalendarNotesView: View {
    @EnvironmentObject private var state: WoodToolsState
    @State private var selectedDate = Date()
    @State private var title = ""
    @State private var note = ""
    @State private var editingNote: CalendarNote?

    var body: some View {
        let notes = state.calendarNotes(on: selectedDate)

        ToolPanel(title: state.localized("日历备注", "Calendar Notes"), iconName: "calendar") {
            DatePicker(state.localized("日期", "Date"), selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)

            AdaptiveTwoPaneLayout(minHeight: 108) {
                VStack(alignment: .leading, spacing: 8) {
                    TextField(state.localized("重要日子标题", "Important date title"), text: $title)
                        .textFieldStyle(.roundedBorder)
                    TextEditor(text: $note)
                        .font(.system(.body, design: .rounded))
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 74)
                        .padding(8)
                        .background(state.settings.theme.palette.controlBackground, in: RoundedRectangle(cornerRadius: 11, style: .continuous))
                        .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous).stroke(state.settings.theme.palette.border))
                }
            } right: {
                VStack(alignment: .leading, spacing: 8) {
                    Text(state.localized("当天备注", "Notes on this day"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if notes.isEmpty {
                        ResultBox(text: state.localized("这一天还没有备注", "No notes for this day"), isError: false, minHeight: 74)
                    } else {
                        ForEach(notes) { calendarNote in
                            CalendarNoteRow(note: calendarNote) {
                                startEditing(calendarNote)
                            } onDelete: {
                                if editingNote?.id == calendarNote.id {
                                    resetForm()
                                }
                                state.deleteCalendarNote(calendarNote)
                            }
                        }
                    }
                }
            }

            ActionBar {
                Button(editingNote == nil ? state.localized("添加备注", "Add Note") : state.localized("保存修改", "Save Changes")) {
                    save()
                }
                .buttonStyle(.borderedProminent)

                Button(state.localized("取消编辑", "Cancel Edit")) {
                    resetForm()
                }
                .disabled(editingNote == nil && title.isEmpty && note.isEmpty)
            }
        }
    }

    private func save() {
        if let editingNote {
            state.updateCalendarNote(editingNote, title: title, note: note, date: selectedDate)
        } else {
            state.addCalendarNote(date: selectedDate, title: title, note: note)
        }
        resetForm()
    }

    private func startEditing(_ calendarNote: CalendarNote) {
        editingNote = calendarNote
        selectedDate = calendarNote.date
        title = calendarNote.title
        note = calendarNote.note
    }

    private func resetForm() {
        editingNote = nil
        title = ""
        note = ""
    }
}

struct CalendarNoteRow: View {
    @EnvironmentObject private var state: WoodToolsState
    let note: CalendarNote
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        let palette = state.settings.theme.palette

        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 8) {
                Text(note.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Spacer(minLength: 0)
                Button(state.localized("编辑", "Edit"), action: onEdit)
                Button(state.localized("删除", "Delete"), role: .destructive, action: onDelete)
            }
            if !note.note.isEmpty {
                Text(note.note)
                    .font(.caption)
                    .foregroundStyle(palette.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(10)
        .background(palette.controlBackground, in: RoundedRectangle(cornerRadius: 11, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous).stroke(palette.border))
    }
}

struct RadixConverterView: View {
    @EnvironmentObject private var state: WoodToolsState
    @State private var input = ""
    @State private var result = ""
    @State private var preview = ""
    @State private var errorMessage: String?
    @State private var sourceRadix = 10
    @State private var targetRadix = 16

    private let radices = [2, 8, 10, 16]

    var body: some View {
        ToolPanel(title: state.localized("进制转换", "Radix Converter"), iconName: "number.circle") {
            if state.settings.converterLayoutMode == .horizontal {
                AdaptiveTwoPaneLayout(minHeight: 154) {
                    VStack(alignment: .leading, spacing: 10) {
                        LabeledInputBox(title: state.localized("输入数字", "Input Number"), text: $input, placeholder: "255 / FF / 11111111", minHeight: 96)
                        HStack(spacing: 10) {
                            RadixPicker(title: state.localized("输入", "Input"), selection: $sourceRadix, radices: radices)
                            RadixPicker(title: state.localized("输出", "Output"), selection: $targetRadix, radices: radices)
                        }
                    }
                } right: {
                    VStack(alignment: .leading, spacing: 10) {
                        LabeledOutputBox(title: state.localized("结果", "Result"), text: result, placeholder: state.localized("结果会显示在这里", "Result appears here"), minHeight: 48)
                        ResultBox(text: preview.isEmpty ? state.localized("转换后会显示全部进制预览", "All radix previews appear here") : preview, isError: false, minHeight: 80)
                    }
                }
            } else {
                LabeledInputBox(title: state.localized("输入数字", "Input Number"), text: $input, placeholder: "255 / FF / 11111111", minHeight: 56)

                HStack(spacing: 10) {
                    RadixPicker(title: state.localized("输入", "Input"), selection: $sourceRadix, radices: radices)
                    RadixPicker(title: state.localized("输出", "Output"), selection: $targetRadix, radices: radices)
                }

                if !result.isEmpty {
                    ResultBox(text: result, isError: false, minHeight: 46)
                }

                ResultBox(text: preview.isEmpty ? state.localized("转换后会显示全部进制预览", "All radix previews appear here") : preview, isError: false, minHeight: 98)
            }

            ActionBar {
                Button(state.localized("转换", "Convert")) {
                    run()
                }
                .buttonStyle(.borderedProminent)

                Button(state.localized("交换进制", "Swap Radix")) {
                    swap(&sourceRadix, &targetRadix)
                    run()
                }

                Button(state.localized("复制", "Copy")) {
                    state.copy(result, title: state.localized("复制结果", "Copy result"))
                }
                .disabled(result.isEmpty)

                Button(state.localized("清空", "Clear")) {
                    input = ""
                    result = ""
                    preview = ""
                    errorMessage = nil
                }
            }

            if let errorMessage {
                ResultBox(text: errorMessage, isError: true, minHeight: 44)
            }
        }
    }

    private func run() {
        do {
            result = try convertRadix(input, from: sourceRadix, to: targetRadix)
            preview = try radixPreview(input, sourceRadix: sourceRadix)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct RadixPicker: View {
    let title: String
    @Binding var selection: Int
    let radices: [Int]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Picker(title, selection: $selection) {
                ForEach(radices, id: \.self) { radix in
                    Text("\(radix)").tag(radix)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct BidirectionalTextToolView: View {
    @EnvironmentObject private var state: WoodToolsState
    let title: String
    let iconName: String
    let leftTitle: String
    let rightTitle: String
    let leftPlaceholder: String
    let rightPlaceholder: String
    let forwardTitle: String
    let backwardTitle: String
    let forward: (String) throws -> String
    let backward: (String) throws -> String
    @State private var leftText = ""
    @State private var rightText = ""
    @State private var errorMessage: String?

    var body: some View {
        ToolPanel(title: title, iconName: iconName) {
            AdaptiveTwoPaneLayout(minHeight: 108) {
                LabeledInputBox(title: leftTitle, text: $leftText, placeholder: leftPlaceholder, minHeight: 108)
            } right: {
                LabeledInputBox(title: rightTitle, text: $rightText, placeholder: rightPlaceholder, minHeight: 108)
            }

            ActionBar {
                Button(forwardTitle) {
                    runForward()
                }
                .buttonStyle(.borderedProminent)

                Button(backwardTitle) {
                    runBackward()
                }

                Button(state.localized("交换", "Swap")) {
                    swap(&leftText, &rightText)
                    errorMessage = nil
                }
                .disabled(leftText.isEmpty && rightText.isEmpty)

                Button(state.localized("复制", "Copy")) {
                    state.copy(rightText.isEmpty ? leftText : rightText, title: state.localized("复制结果", "Copy result"))
                }
                .disabled(leftText.isEmpty && rightText.isEmpty)

                Button(state.localized("清空", "Clear")) {
                    leftText = ""
                    rightText = ""
                    errorMessage = nil
                }
            }

            if let errorMessage {
                ResultBox(text: errorMessage, isError: true, minHeight: 44)
            }
        }
    }

    private func runForward() {
        do {
            rightText = try forward(leftText)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func runBackward() {
        do {
            leftText = try backward(rightText)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct AdaptiveTwoPaneLayout<Left: View, Right: View>: View {
    @EnvironmentObject private var state: WoodToolsState
    let minHeight: CGFloat
    @ViewBuilder let left: Left
    @ViewBuilder let right: Right

    init(minHeight: CGFloat = 96, @ViewBuilder left: () -> Left, @ViewBuilder right: () -> Right) {
        self.minHeight = minHeight
        self.left = left()
        self.right = right()
    }

    var body: some View {
        if state.settings.converterLayoutMode == .horizontal {
            HStack(alignment: .top, spacing: 10) {
                left
                    .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .top)
                right
                    .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .top)
            }
        } else {
            left
            right
        }
    }
}

struct LabeledOutputBox: View {
    let title: String
    let text: String
    let placeholder: String
    var minHeight: CGFloat = 86

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            ResultBox(text: text.isEmpty ? placeholder : text, isError: false, minHeight: minHeight)
        }
    }
}

struct HexDecodeView: View {
    @EnvironmentObject private var state: WoodToolsState
    @State private var input = ""
    @State private var result = ""
    @State private var errorMessage: String?

    var body: some View {
        ToolPanel(title: state.localized("Hex 解码", "Hex Decode"), iconName: "number") {
            AdaptiveTwoPaneLayout {
                LabeledInputBox(title: "Hex", text: $input, placeholder: "48656c6c6f / 48 65 6c 6c 6f", minHeight: 82)
            } right: {
                LabeledOutputBox(title: "UTF-8", text: result, placeholder: state.localized("解码结果会显示在这里", "Decoded text appears here"), minHeight: 82)
            }

            ActionBar {
                Button(state.localized("解码", "Decode")) {
                    run()
                }
                .buttonStyle(.borderedProminent)

                Button(state.localized("复制", "Copy")) {
                    state.copy(result, title: state.localized("复制 Hex 解码结果", "Copy Hex decoded text"))
                }
                .disabled(result.isEmpty)

                Button(state.localized("清空", "Clear")) {
                    input = ""
                    result = ""
                    errorMessage = nil
                }
            }

            if let errorMessage {
                ResultBox(text: errorMessage, isError: true, minHeight: 44)
            }
        }
    }

    private func run() {
        do {
            result = try decodeHex(input)
            errorMessage = nil
        } catch {
            result = ""
            errorMessage = error.localizedDescription
        }
    }
}

struct JSONToolView: View {
    @EnvironmentObject private var state: WoodToolsState
    @State private var input = ""
    @State private var result = ""
    @State private var errorMessage: String?

    var body: some View {
        ToolPanel(title: state.localized("JSON 格式化 / 压缩", "JSON Format / Compact"), iconName: "curlybraces.square") {
            AdaptiveTwoPaneLayout {
                LabeledInputBox(title: "JSON", text: $input, placeholder: "{\"name\":\"WoodTools\"}", minHeight: 90)
            } right: {
                LabeledOutputBox(title: state.localized("结果", "Result"), text: result, placeholder: state.localized("结果会显示在这里", "Result appears here"), minHeight: 90)
            }

            ActionBar {
                Button(state.localized("格式化", "Format")) {
                    run(formatJSON)
                }
                .buttonStyle(.borderedProminent)

                Button(state.localized("压缩", "Compact")) {
                    run(compactJSON)
                }

                Button(state.localized("复制", "Copy")) {
                    state.copy(result, title: state.localized("复制 JSON", "Copy JSON"))
                }
                .disabled(result.isEmpty)

                Button(state.localized("清空", "Clear")) {
                    input = ""
                    result = ""
                    errorMessage = nil
                }
            }

            if let errorMessage {
                ResultBox(text: errorMessage, isError: true, minHeight: 44)
            }
        }
    }

    private func run(_ action: (String) throws -> String) {
        do {
            result = try action(input)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct JSONYAMLConverterView: View {
    @EnvironmentObject private var state: WoodToolsState
    @State private var input = ""
    @State private var result = ""
    @State private var errorMessage: String?
    @State private var isRunning = false

    var body: some View {
        ToolPanel(title: "JSON / YAML", iconName: "arrow.left.arrow.right.square") {
            AdaptiveTwoPaneLayout {
                LabeledInputBox(title: "JSON / YAML", text: $input, placeholder: "name: WoodTools", minHeight: 96)
            } right: {
                LabeledOutputBox(
                    title: state.localized("结果", "Result"),
                    text: isRunning ? state.localized("转换中...", "Converting...") : result,
                    placeholder: state.localized("转换结果会显示在这里", "Converted result appears here"),
                    minHeight: 96
                )
            }

            ActionBar {
                Button("JSON → YAML") {
                    run(jsonToYAML)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isRunning)

                Button("YAML → JSON") {
                    run(yamlToJSON)
                }
                .disabled(isRunning)

                Button(state.localized("复制", "Copy")) {
                    state.copy(result, title: state.localized("复制转换结果", "Copy converted result"))
                }
                .disabled(result.isEmpty || isRunning)

                Button(state.localized("清空", "Clear")) {
                    input = ""
                    result = ""
                    errorMessage = nil
                }
                .disabled(isRunning)
            }

            if let errorMessage {
                ResultBox(text: errorMessage, isError: true, minHeight: 44)
            }
        }
    }

    private func run(_ action: @escaping (String) throws -> String) {
        isRunning = true
        errorMessage = nil
        result = ""
        let value = input
        Task { @MainActor in
            do {
                result = try action(value)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isRunning = false
        }
    }
}

struct CaseConvertView: View {
    @EnvironmentObject private var state: WoodToolsState
    @State private var input = ""
    @State private var mode: CaseMode = .upper
    @State private var result = ""

    var body: some View {
        ToolPanel(title: state.localized("大小写转换", "Case Converter"), iconName: "textformat") {
            Picker(state.localized("模式", "Mode"), selection: $mode) {
                ForEach(CaseMode.allCases) { mode in
                    Text(mode.title(language: state.settings.language)).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            AdaptiveTwoPaneLayout {
                LabeledInputBox(title: state.localized("文本", "Text"), text: $input, placeholder: state.localized("在这里粘贴文本", "Paste text here"), minHeight: 76)
            } right: {
                LabeledOutputBox(title: state.localized("结果", "Result"), text: result, placeholder: state.localized("结果会显示在这里", "Result appears here"), minHeight: 76)
            }

            ActionBar {
                Button(state.localized("转换", "Convert")) {
                    result = convertCase(input, mode: mode)
                }
                .buttonStyle(.borderedProminent)

                Button(state.localized("复制", "Copy")) {
                    state.copy(result, title: state.localized("复制结果", "Copy result"))
                }
                .disabled(result.isEmpty)

                Button(state.localized("清空", "Clear")) {
                    input = ""
                    result = ""
                }
            }

        }
    }
}

struct NetworkSummaryView: View {
    @EnvironmentObject private var state: WoodToolsState
    @State private var result = ""
    @State private var errorMessage: String?

    var body: some View {
        ToolPanel(title: state.localized("本机网络信息", "Local Network Info"), iconName: "wifi.router") {
            ResultBox(text: result.isEmpty ? state.localized("点击按钮获取本机 IP 和 MAC 地址。", "Click the button to get local IP and MAC address.") : result, isError: false, minHeight: 82)
            if let errorMessage {
                ResultBox(text: errorMessage, isError: true, minHeight: 44)
            }
            ActionBar {
                Button(state.localized("获取", "Get")) {
                    run()
                }
                .buttonStyle(.borderedProminent)

                Button(state.localized("复制", "Copy")) {
                    state.copy(result, title: state.localized("复制网络信息", "Copy network info"))
                }
                .disabled(result.isEmpty)
            }
        }
    }

    private func run() {
        do {
            result = try networkSummary()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct NetworkDiagnosticsView: View {
    @EnvironmentObject private var state: WoodToolsState
    @State private var input = ""
    @State private var result = ""
    @State private var errorMessage: String?
    @State private var isRunning = false

    var body: some View {
        ToolPanel(title: state.localized("网络诊断", "Network Diagnostics"), iconName: "dot.radiowaves.left.and.right") {
            AdaptiveTwoPaneLayout {
                LabeledInputBox(title: state.localized("域名或 IP", "Domain or IP"), text: $input, placeholder: "example.com / 8.8.8.8", minHeight: 88)
            } right: {
                LabeledOutputBox(
                    title: state.localized("结果", "Result"),
                    text: isRunning ? state.localized("正在检测，请稍候...", "Checking, please wait...") : result,
                    placeholder: state.localized("结果会显示在这里", "Result appears here"),
                    minHeight: 88
                )
            }

            ActionBar {
                Button("Dig") {
                    runDig()
                }
                .buttonStyle(.borderedProminent)
                .disabled(isRunning)

                Button(isRunning ? state.localized("Ping 中...", "Pinging...") : "Ping") {
                    runPing()
                }
                .disabled(isRunning)

                Button(state.localized("复制", "Copy")) {
                    state.copy(result, title: state.localized("复制诊断结果", "Copy diagnostics result"))
                }
                .disabled(result.isEmpty || isRunning)

                Button(state.localized("清空", "Clear")) {
                    input = ""
                    result = ""
                    errorMessage = nil
                }
                .disabled(isRunning)
            }

            if let errorMessage {
                ResultBox(text: errorMessage, isError: true, minHeight: 44)
            }
        }
    }

    private func runDig() {
        do {
            result = try digDomain(input)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func runPing() {
        result = ""
        errorMessage = nil
        isRunning = true

        Task {
            let pingResult = await pingHostAsync(input)
            await MainActor.run {
                isRunning = false
                if let output = pingResult.output {
                    result = output
                } else {
                    result = ""
                    errorMessage = pingResult.errorMessage ?? state.localized("Ping 失败", "Ping failed")
                }
            }
        }
    }
}

struct NetworkSpeedTestView: View {
    @EnvironmentObject private var state: WoodToolsState
    @State private var result = ""
    @State private var errorMessage: String?
    @State private var isRunning = false

    var body: some View {
        ToolPanel(title: state.localized("网络测速", "Network Speed Test"), iconName: "speedometer") {
            ResultBox(text: isRunning ? state.localized("正在测速，通常需要几十秒...", "Testing speed, this may take a few seconds...") : (result.isEmpty ? state.localized("点击按钮开始测试网络质量。", "Click the button to test network quality.") : result), isError: false, minHeight: 110)

            if let errorMessage {
                ResultBox(text: errorMessage, isError: true, minHeight: 44)
            }

            ActionBar {
                Button(isRunning ? state.localized("测速中...", "Testing...") : state.localized("开始测速", "Start Test")) {
                    run()
                }
                .buttonStyle(.borderedProminent)
                .disabled(isRunning)

                Button(state.localized("复制", "Copy")) {
                    state.copy(result, title: state.localized("复制测速结果", "Copy speed test result"))
                }
                .disabled(result.isEmpty || isRunning)
            }
        }
    }

    private func run() {
        isRunning = true
        errorMessage = nil
        result = ""
        Task {
            let speedResult = await networkSpeedTestAsync()
            await MainActor.run {
                isRunning = false
                if let output = speedResult.output, !output.isEmpty {
                    result = output
                } else {
                    result = ""
                    errorMessage = speedResult.errorMessage ?? state.localized("网络测速失败", "Network speed test failed")
                }
            }
        }
    }
}

struct FavoriteAppsView: View {
    @EnvironmentObject private var state: WoodToolsState
    @State private var isChoosingApp = false
    @State private var draggedApp: FavoriteApp?

    var body: some View {
        ToolPanel(title: state.localized("常用 App", "Favorite Apps"), iconName: "app.badge") {
            if state.favoriteApps.isEmpty {
                ResultBox(text: state.localized("点击“添加 App”选择常用应用，之后可在这里快速打开。", "Click Add App to choose apps, then open them quickly here."), isError: false, minHeight: 48)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 176), spacing: 10)], spacing: 10) {
                    ForEach(state.favoriteApps) { app in
                        FavoriteAppButton(app: app)
                            .opacity(draggedApp?.id == app.id ? 0.55 : 1)
                            .onDrag {
                                draggedApp = app
                                return NSItemProvider(object: app.id.uuidString as NSString)
                            }
                            .onDrop(of: [.text], delegate: FavoriteAppDropDelegate(target: app, draggedApp: $draggedApp, state: state))
                    }
                }
            }

            ActionBar {
                Button(state.localized("添加 App", "Add App")) {
                    isChoosingApp = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .fileImporter(isPresented: $isChoosingApp, allowedContentTypes: [.application], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    state.addFavoriteApp(url: url)
                }
            case .failure(let error):
                state.transientMessage = error.localizedDescription
            }
        }
    }
}

struct FavoriteAppButton: View {
    @EnvironmentObject private var state: WoodToolsState
    let app: FavoriteApp

    var body: some View {
        let palette = state.settings.theme.palette

        Button {
            state.openFavoriteApp(app)
        } label: {
            HStack(spacing: 10) {
                Image(nsImage: state.icon(for: app))
                    .resizable()
                    .frame(width: 34, height: 34)
                Text(app.name)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer(minLength: 0)
                Image(systemName: "line.3.horizontal")
                    .foregroundStyle(palette.secondaryText)
            }
            .padding(.horizontal, 12)
            .frame(height: 56)
        }
        .buttonStyle(SearchToolCardButtonStyle())
        .contextMenu {
            Button(state.localized("打开", "Open")) {
                state.openFavoriteApp(app)
            }
            Button(state.localized("移除", "Remove"), role: .destructive) {
                state.removeFavoriteApp(app)
            }
        }
    }
}

struct FavoriteAppDropDelegate: DropDelegate {
    let target: FavoriteApp
    @Binding var draggedApp: FavoriteApp?
    let state: WoodToolsState

    func dropEntered(info: DropInfo) {
        guard let draggedApp, draggedApp.id != target.id else {
            return
        }
        state.moveFavoriteApp(draggedApp, before: target, persist: false)
    }

    func performDrop(info: DropInfo) -> Bool {
        state.saveFavoriteAppOrder()
        draggedApp = nil
        return true
    }
}

struct FileShelfView: View {
    @EnvironmentObject private var state: WoodToolsState

    var body: some View {
        ToolPanel(title: state.localized("文件暂存", "Text Shelf"), iconName: "tray.full") {
            TextEditor(text: fileShelfBinding)
                .font(.system(.body, design: .monospaced))
                .scrollContentBackground(.hidden)
                .frame(minHeight: 120)
                .padding(8)
                .background(state.settings.theme.palette.controlBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(state.settings.theme.palette.border))

            ActionBar {
                Button(state.localized("复制", "Copy")) {
                    state.copy(state.fileShelfText, title: state.localized("复制暂存文本", "Copy shelf text"))
                }
                .disabled(state.fileShelfText.isEmpty)

                Button(state.localized("在访达中显示", "Show in Finder")) {
                    state.revealFileShelf()
                }
                .buttonStyle(.borderedProminent)

                Button(state.localized("清空", "Clear")) {
                    state.saveFileShelfText("")
                }
                .disabled(state.fileShelfText.isEmpty)
            }
        }
    }

    private var fileShelfBinding: Binding<String> {
        Binding(
            get: { state.fileShelfText },
            set: { state.saveFileShelfText($0) }
        )
    }
}

struct QuickActionsGridView: View {
    @EnvironmentObject private var state: WoodToolsState
    @State private var result = ""
    @State private var errorMessage: String?

    var body: some View {
        ToolPanel(title: state.localized("屏幕工具", "Screen Tools"), iconName: "camera.viewfinder") {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 136), spacing: 8)], spacing: 8) {
                QuickActionButton(title: state.localized("截屏", "Screenshot"), iconName: "camera.viewfinder") {
                    run { try runScreenshot() }
                }
                QuickActionButton(title: state.localized("录屏", "Screen Recording"), iconName: "record.circle") {
                    runScreenRecord()
                }
            }

            ResultBox(text: result.isEmpty ? state.localized("选择一个快捷操作。", "Choose a quick action.") : result, isError: false, minHeight: 58)
            if let errorMessage {
                ResultBox(text: errorMessage, isError: true, minHeight: 44)
            }
        }
    }

    private func run(_ action: () throws -> String) {
        do {
            result = try action()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func runScreenRecord() {
        run {
            try openScreenshotTool()
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                Text(title)
                Spacer(minLength: 0)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(SearchToolCardButtonStyle())
    }
}

struct UUIDGeneratorView: View {
    @EnvironmentObject private var state: WoodToolsState
    @State private var result = ""
    @State private var uppercase = false
    @State private var hyphenated = true

    var body: some View {
        ToolPanel(title: "UUID", iconName: "number.square") {
            HStack(spacing: 14) {
                Toggle(state.localized("大写", "Uppercase"), isOn: $uppercase)
                    .toggleStyle(VisibleCheckboxToggleStyle())
                Toggle(state.localized("保留连字符", "Keep Hyphens"), isOn: $hyphenated)
                    .toggleStyle(VisibleCheckboxToggleStyle())
            }

            ActionBar {
                Button(state.localized("生成", "Generate")) {
                    result = generateUUID(uppercase: uppercase, hyphenated: hyphenated)
                }
                .buttonStyle(.borderedProminent)

                Button(state.localized("复制", "Copy")) {
                    state.copy(result, title: state.localized("复制 UUID", "Copy UUID"))
                }
                .disabled(result.isEmpty)
            }

            ResultBox(text: result.isEmpty ? state.localized("点击生成 UUID", "Click Generate for a UUID") : result, isError: false, minHeight: 54)
        }
    }
}

struct InstantResultToolView: View {
    @EnvironmentObject private var state: WoodToolsState
    let title: String
    let iconName: String
    let actionTitle: String
    var autoRun = true
    let resultProvider: () throws -> String
    @State private var result = ""
    @State private var errorMessage: String?

    var body: some View {
        ToolPanel(title: title, iconName: iconName) {
            ResultBox(text: result.isEmpty ? state.localized("点击按钮获取结果", "Click the button to get the result") : result, isError: false, minHeight: 74)

            if let errorMessage {
                ResultBox(text: errorMessage, isError: true, minHeight: 44)
            }

            ActionBar {
                Button(actionTitle) {
                    run()
                }
                .buttonStyle(.borderedProminent)

                Button(state.localized("复制", "Copy")) {
                    state.copy(result, title: state.localized("复制结果", "Copy result"))
                }
                .disabled(result.isEmpty)
            }
        }
        .onAppear {
            if autoRun {
                run()
            }
        }
    }

    private func run() {
        do {
            result = try resultProvider()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct TextInputToolView: View {
    @EnvironmentObject private var state: WoodToolsState
    let title: String
    let iconName: String
    let placeholder: String
    let primaryTitle: String
    let action: (String) throws -> String
    @State private var input = ""
    @State private var result = ""
    @State private var errorMessage: String?

    var body: some View {
        ToolPanel(title: title, iconName: iconName) {
            LabeledInputBox(title: state.localized("输入", "Input"), text: $input, placeholder: placeholder, minHeight: 58)

            ActionBar {
                Button(primaryTitle) {
                    run()
                }
                .buttonStyle(.borderedProminent)

                Button(state.localized("复制", "Copy")) {
                    state.copy(result, title: state.localized("复制结果", "Copy result"))
                }
                .disabled(result.isEmpty)

                Button(state.localized("清空", "Clear")) {
                    input = ""
                    result = ""
                    errorMessage = nil
                }
            }

            ResultBox(text: result.isEmpty ? state.localized("结果会显示在这里", "Result appears here") : result, isError: false, minHeight: 74)

            if let errorMessage {
                ResultBox(text: errorMessage, isError: true, minHeight: 44)
            }
        }
    }

    private func run() {
        do {
            result = try action(input)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct UsageView: View {
    @EnvironmentObject private var state: WoodToolsState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    MetricView(title: state.localized("总使用次数", "Total Uses"), value: "\(state.todayUsages.count)")
                    MetricView(title: state.localized("最常用工具", "Most Used"), value: state.mostUsedTitle)
                    MetricView(title: state.localized("其他用量", "Other Uses"), value: "\(state.usageCount(for: .other))")
                }

                ToolPanel(title: state.localized("用量分布", "Usage Distribution"), iconName: "chart.bar.xaxis") {
                    ForEach(ToolCategory.allCases) { category in
                        UsageBar(category: category)
                    }
                }

                ToolPanel(title: state.localized("最近记录", "Recent Records"), iconName: "clock.arrow.circlepath") {
                    if state.todayUsages.isEmpty {
                        Text(state.localized("暂无使用记录", "No usage records"))
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(state.todayUsages.prefix(12)) { usage in
                            HStack(spacing: 10) {
                                Image(systemName: usage.category.iconName)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 18)
                                Text(usage.title)
                                Spacer()
                                Text(usage.date, style: .time)
                                    .foregroundStyle(.secondary)
                                    .font(.caption.monospacedDigit())
                            }
                            .font(.subheadline)
                        }
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
    }
}

struct MetricView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .glassPanel(cornerRadius: 13)
    }
}

struct UsageBar: View {
    @EnvironmentObject private var state: WoodToolsState
    let category: ToolCategory

    var body: some View {
        let count = state.usageCount(for: category)
        let total = max(state.todayUsages.count, 1)
        let ratio = Double(count) / Double(total)

        HStack(spacing: 8) {
            Label(category.title(language: state.settings.language), systemImage: category.iconName)
                .font(.caption)
                .frame(width: 82, alignment: .leading)

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(.quaternary)
                    Capsule()
                        .fill(category == .other ? Color.secondary : Color.accentColor)
                        .frame(width: max(count == 0 ? 0 : 4, proxy.size.width * ratio))
                }
            }
            .frame(height: 7)

            Text("\(count)")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(width: 28, alignment: .trailing)
        }
    }
}

struct ToolPanel<Content: View>: View {
    let title: String
    let iconName: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: iconName)
                .font(.subheadline.weight(.semibold))
            content
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassPanel(cornerRadius: 16)
    }
}

struct ActionBar<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 7) {
                content
                Spacer(minLength: 0)
            }
            VStack(alignment: .leading, spacing: 7) {
                content
            }
        }
        .controlSize(.small)
    }
}

struct LabeledInputBox: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let minHeight: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            InputBox(text: $text, placeholder: placeholder, minHeight: minHeight)
        }
    }
}

struct InputBox: View {
    @EnvironmentObject private var state: WoodToolsState
    @Binding var text: String
    let placeholder: String
    let minHeight: CGFloat

    var body: some View {
        let palette = state.settings.theme.palette

        PasteTextEditor(text: $text, placeholder: placeholder, minHeight: minHeight)
            .frame(minHeight: minHeight)
            .background(palette.controlBackground, in: RoundedRectangle(cornerRadius: 11, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous).stroke(palette.border))
    }
}

struct PasteTextEditor: NSViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let minHeight: CGFloat
    private let textInset = NSSize(width: 8, height: 8)

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, textInset: textInset)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSTextView.scrollableTextView()
        scrollView.drawsBackground = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.borderType = .noBorder
        scrollView.contentView.postsBoundsChangedNotifications = true

        guard let textView = scrollView.documentView as? NSTextView else {
            return scrollView
        }

        let font = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        textView.delegate = context.coordinator
        textView.string = text
        textView.font = font
        textView.textColor = .labelColor
        textView.backgroundColor = .clear
        textView.textContainerInset = textInset
        textView.textContainer?.lineFragmentPadding = 0
        textView.textContainer?.widthTracksTextView = true
        textView.isHorizontallyResizable = false
        textView.isRichText = false
        textView.importsGraphics = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.allowsUndo = true
        textView.isEditable = true
        textView.isSelectable = true
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        context.coordinator.placeholder = placeholder
        context.coordinator.placeholderFont = font
        context.coordinator.updatePlaceholder(in: textView)
        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? NSTextView else {
            return
        }

        if textView.string != text {
            textView.string = text
        }

        context.coordinator.text = $text
        context.coordinator.placeholder = placeholder
        context.coordinator.placeholderFont = textView.font
        context.coordinator.updatePlaceholder(in: textView)
    }

    static func dismantleNSView(_ scrollView: NSScrollView, coordinator: Coordinator) {
        (scrollView.documentView as? NSTextView)?.delegate = nil
    }

    @MainActor
    final class Coordinator: NSObject, NSTextViewDelegate {
        var text: Binding<String>
        var placeholder: String = ""
        var placeholderFont: NSFont?
        let textInset: NSSize
        private weak var placeholderLabel: NSTextField?

        init(text: Binding<String>, textInset: NSSize) {
            self.text = text
            self.textInset = textInset
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            text.wrappedValue = textView.string
            updatePlaceholder(in: textView)
        }

        func updatePlaceholder(in textView: NSTextView) {
            let label = placeholderLabel ?? makePlaceholderLabel(in: textView)
            label.stringValue = placeholder
            label.font = placeholderFont ?? textView.font
            label.isHidden = !textView.string.isEmpty
        }

        private func makePlaceholderLabel(in textView: NSTextView) -> NSTextField {
            let label = NSTextField(labelWithString: placeholder)
            label.textColor = .placeholderTextColor
            label.font = placeholderFont ?? textView.font
            label.translatesAutoresizingMaskIntoConstraints = false
            textView.addSubview(label)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: textInset.width),
                label.topAnchor.constraint(equalTo: textView.topAnchor, constant: textInset.height)
            ])
            placeholderLabel = label
            return label
        }
    }

    func sizeThatFits(_ proposal: ProposedViewSize, nsView: NSScrollView, context: Context) -> CGSize? {
        CGSize(width: proposal.width ?? 320, height: minHeight)
    }
}

struct ResultBox: View {
    @EnvironmentObject private var state: WoodToolsState
    let text: String
    let isError: Bool
    var minHeight: CGFloat = 86

    var body: some View {
        let palette = state.settings.theme.palette

        ScrollView {
            Text(text)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(isError ? palette.error : palette.secondaryText)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
                .padding(9)
        }
        .frame(minHeight: minHeight, maxHeight: 170)
        .background(isError ? palette.error.opacity(0.10) : palette.controlBackground, in: RoundedRectangle(cornerRadius: 11, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 11, style: .continuous).stroke(isError ? palette.error.opacity(0.38) : palette.border))
    }
}

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.caption.weight(.medium))
            .padding(.horizontal, 13)
            .padding(.vertical, 8)
            .background(.regularMaterial, in: Capsule())
            .overlay(Capsule().stroke(.quaternary))
            .padding(.bottom, 10)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

struct GlassPanelModifier: ViewModifier {
    @EnvironmentObject private var state: WoodToolsState
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        let palette = state.settings.theme.palette

        content
            .background(palette.panelBackground, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).stroke(palette.border))
            .shadow(color: palette.shadow, radius: 8, x: 0, y: 2)
    }
}

extension View {
    func glassPanel(cornerRadius: CGFloat) -> some View {
        modifier(GlassPanelModifier(cornerRadius: cornerRadius))
    }
}

struct GlassIconButtonStyle: ButtonStyle {
    @EnvironmentObject private var state: WoodToolsState
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        let palette = state.settings.theme.palette

        configuration.label
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isSelected ? palette.selectedForeground : palette.primaryText)
            .background(background(palette: palette, isPressed: configuration.isPressed), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(isSelected ? Color.clear : palette.border))
    }

    private func background(palette: AppThemePalette, isPressed: Bool) -> Color {
        if isSelected { return palette.accent }
        return isPressed ? palette.controlPressedBackground : palette.controlBackground
    }
}

struct GlassPillButtonStyle: ButtonStyle {
    @EnvironmentObject private var state: WoodToolsState
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        let palette = state.settings.theme.palette

        configuration.label
            .foregroundStyle(isSelected ? palette.selectedForeground : palette.primaryText)
            .background(background(palette: palette, isPressed: configuration.isPressed), in: Capsule())
            .overlay(Capsule().stroke(isSelected ? Color.clear : palette.border))
    }

    private func background(palette: AppThemePalette, isPressed: Bool) -> Color {
        if isSelected { return palette.accent }
        return isPressed ? palette.controlPressedBackground : palette.controlBackground
    }
}

struct SearchToolCardButtonStyle: ButtonStyle {
    @EnvironmentObject private var state: WoodToolsState

    func makeBody(configuration: Configuration) -> some View {
        let palette = state.settings.theme.palette

        configuration.label
            .background(configuration.isPressed ? palette.controlPressedBackground : palette.controlBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(palette.border))
    }
}

struct VisibleCheckboxToggleStyle: ToggleStyle {
    @EnvironmentObject private var state: WoodToolsState

    func makeBody(configuration: Configuration) -> some View {
        let palette = state.settings.theme.palette

        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(spacing: 7) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(configuration.isOn ? palette.accent : palette.controlBackground)
                        .frame(width: 16, height: 16)
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .stroke(configuration.isOn ? palette.accent : palette.border, lineWidth: 1.2)
                        .frame(width: 16, height: 16)
                    if configuration.isOn {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(palette.selectedForeground)
                    }
                }

                configuration.label
                    .font(.caption.weight(.medium))
                    .foregroundStyle(palette.primaryText)
            }
            .padding(.horizontal, 9)
            .frame(height: 28)
            .background(palette.controlBackground, in: Capsule())
            .overlay(Capsule().stroke(palette.border))
        }
        .buttonStyle(.plain)
    }
}
