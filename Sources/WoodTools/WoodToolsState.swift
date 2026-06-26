import AppKit
import Foundation

extension Notification.Name {
    static let woodToolsOpenMainWindow = Notification.Name("woodToolsOpenMainWindow")
    static let woodToolsWindowSizeDidChange = Notification.Name("woodToolsWindowSizeDidChange")
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

struct WoodToolsSettings {
    var theme: AppTheme
    var converterLayoutMode: ConverterLayoutMode
    var searchEngine: SearchEngine
    var browserTarget: BrowserTarget
    var startupCategory: StartupCategory
    var language: AppLanguage
    var timeFormatMode: TimeFormatMode
    var customTimeFormat: String
    var popoverWidth: Double
    var popoverHeight: Double
}

struct FavoriteApp: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let name: String
    let path: String

    init(id: UUID = UUID(), name: String, path: String) {
        self.id = id
        self.name = name
        self.path = path
    }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case zhHans
    case english

    var id: String { rawValue }

    var resolved: AppLanguage {
        switch self {
        case .system:
            if Locale.preferredLanguages.first?.lowercased().hasPrefix("zh") == true {
                return .zhHans
            }
            return .english
        case .zhHans, .english:
            return self
        }
    }

    var title: String {
        switch self {
        case .system:
            "System"
        case .zhHans:
            "中文"
        case .english:
            "English"
        }
    }
}

enum TimeFormatMode: String, CaseIterable, Identifiable {
    case standard
    case isoLike
    case dateOnly
    case slash
    case custom

    var id: String { rawValue }

    var format: String? {
        switch self {
        case .standard:
            "yyyy-MM-dd HH:mm:ss"
        case .isoLike:
            "yyyy-MM-dd'T'HH:mm:ss"
        case .dateOnly:
            "yyyy-MM-dd"
        case .slash:
            "yyyy/MM/dd HH:mm:ss"
        case .custom:
            nil
        }
    }

    var title: String {
        switch self {
        case .standard:
            "Standard"
        case .isoLike:
            "ISO Like"
        case .dateOnly:
            "Date Only"
        case .slash:
            "Slash"
        case .custom:
            "Custom"
        }
    }
}

enum AppTheme: String, CaseIterable, Identifiable {
    case light
    case dark
    case dracula
    case githubLight
    case githubDark
    case oneDarkPro
    case wood

    var id: String { rawValue }

    var title: String {
        switch self {
        case .light:
            "Light"
        case .dark:
            "Dark"
        case .dracula:
            "Dracula"
        case .githubLight:
            "GitHub Light"
        case .githubDark:
            "GitHub Dark"
        case .oneDarkPro:
            "One Dark Pro"
        case .wood:
            "Wood"
        }
    }
}

enum SearchEngine: String, CaseIterable, Identifiable {
    case baidu = "百度"
    case google = "Google"
    case bing = "Bing"

    var id: String { rawValue }

    func title(language: AppLanguage) -> String {
        switch language.resolved {
        case .english:
            switch self {
            case .baidu:
                "Baidu"
            case .google:
                "Google"
            case .bing:
                "Bing"
            }
        case .system, .zhHans:
            rawValue
        }
    }

    func searchURL(for query: String) -> URL? {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }

        switch self {
        case .baidu:
            return URL(string: "https://www.baidu.com/s?wd=\(encoded)")
        case .google:
            return URL(string: "https://www.google.com/search?q=\(encoded)")
        case .bing:
            return URL(string: "https://www.bing.com/search?q=\(encoded)")
        }
    }
}

enum BrowserTarget: String, CaseIterable, Identifiable {
    case systemDefault = "系统默认浏览器"
    case safari = "Safari"
    case googleChrome = "Google Chrome"
    case microsoftEdge = "Microsoft Edge"

    var id: String { rawValue }

    func title(language: AppLanguage) -> String {
        switch language.resolved {
        case .english:
            switch self {
            case .systemDefault:
                "System Default"
            case .safari:
                "Safari"
            case .googleChrome:
                "Google Chrome"
            case .microsoftEdge:
                "Microsoft Edge"
            }
        case .system, .zhHans:
            rawValue
        }
    }

    var appName: String? {
        switch self {
        case .systemDefault:
            return nil
        case .safari:
            return "Safari"
        case .googleChrome:
            return "Google Chrome"
        case .microsoftEdge:
            return "Microsoft Edge"
        }
    }
}

enum StartupCategory: String, CaseIterable, Identifiable {
    case time
    case radix
    case coding
    case network
    case quick

    var id: String { rawValue }

    func title(language: AppLanguage) -> String {
        toolCategory.title(language: language)
    }

    var toolCategory: ToolCategory {
        switch self {
        case .time:
            return .time
        case .radix:
            return .radix
        case .coding:
            return .coding
        case .network:
            return .network
        case .quick:
            return .quick
        }
    }
}

@MainActor
final class WoodToolsState: ObservableObject {
    @Published var selectedCategory: ToolCategory
    @Published var showingUsage = false
    @Published var showingSettings = false
    @Published var searchText = ""
    @Published var addressText = ""
    @Published var settings: WoodToolsSettings
    @Published var fileShelfText: String
    @Published private(set) var favoriteApps: [FavoriteApp]
    @Published private(set) var calendarNotes: [CalendarNote]
    @Published private(set) var usages: [ToolUsage] = []
    @Published var transientMessage: String?
    private var favoriteAppIconCache: [UUID: NSImage] = [:]

    private enum DefaultsKey {
        static let theme = "woodtools.theme"
        static let converterLayoutMode = "woodtools.converterLayoutMode"
        static let searchEngine = "woodtools.searchEngine"
        static let browserTarget = "woodtools.browserTarget"
        static let startupCategory = "woodtools.startupCategory"
        static let language = "woodtools.language"
        static let timeFormatMode = "woodtools.timeFormatMode"
        static let customTimeFormat = "woodtools.customTimeFormat"
        static let popoverWidth = "woodtools.popoverWidth"
        static let popoverHeight = "woodtools.popoverHeight"
        static let favoriteApps = "woodtools.favoriteApps"
        static let calendarNotes = "woodtools.calendarNotes"
    }

    static let defaultPopoverWidth = 480.0
    static let defaultPopoverHeight = 420.0
    static let popoverWidthRange = 360.0...1200.0
    static let popoverHeightRange = 320.0...1000.0

    private let pasteboard = NSPasteboard.general
    private let defaults = UserDefaults.standard

    init() {
        let loadedSettings = WoodToolsSettings(
            theme: Self.loadTheme(key: DefaultsKey.theme, defaultValue: .wood),
            converterLayoutMode: Self.load(ConverterLayoutMode.self, key: DefaultsKey.converterLayoutMode, defaultValue: .horizontal),
            searchEngine: Self.load(SearchEngine.self, key: DefaultsKey.searchEngine, defaultValue: .baidu),
            browserTarget: Self.load(BrowserTarget.self, key: DefaultsKey.browserTarget, defaultValue: .systemDefault),
            startupCategory: Self.load(StartupCategory.self, key: DefaultsKey.startupCategory, defaultValue: .time),
            language: Self.load(AppLanguage.self, key: DefaultsKey.language, defaultValue: .system),
            timeFormatMode: Self.load(TimeFormatMode.self, key: DefaultsKey.timeFormatMode, defaultValue: .standard),
            customTimeFormat: UserDefaults.standard.string(forKey: DefaultsKey.customTimeFormat) ?? "yyyy-MM-dd HH:mm:ss",
            popoverWidth: Self.loadClampedDouble(key: DefaultsKey.popoverWidth, defaultValue: Self.defaultPopoverWidth, range: Self.popoverWidthRange),
            popoverHeight: Self.loadClampedDouble(key: DefaultsKey.popoverHeight, defaultValue: Self.defaultPopoverHeight, range: Self.popoverHeightRange)
        )
        settings = loadedSettings
        selectedCategory = loadedSettings.startupCategory.toolCategory
        fileShelfText = Self.loadFileShelfText()
        favoriteApps = Self.loadFavoriteApps(key: DefaultsKey.favoriteApps)
        calendarNotes = Self.loadCalendarNotes(key: DefaultsKey.calendarNotes)
    }

    var filteredToolsByCategory: [(ToolCategory, [ToolDefinition])] {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let definitions = toolDefinitions(language: settings.language)
        let filtered = definitions.filter { definition in
            keyword.isEmpty
                || definition.title.lowercased().contains(keyword)
                || definition.category.title(language: settings.language).lowercased().contains(keyword)
        }

        return ToolCategory.allCases
            .filter { $0 != .other }
            .compactMap { category in
                let tools = filtered.filter { $0.category == category }
                return tools.isEmpty ? nil : (category, tools)
            }
    }

    func openCategory(_ category: ToolCategory) {
        selectedCategory = category
        showingUsage = false
        showingSettings = false
        searchText = ""
        recordOther(title: localized("打开\(category.title(language: settings.language))", "Open \(category.title(language: settings.language))"))
    }

    func openUsage() {
        showingUsage = true
        showingSettings = false
        searchText = ""
        recordOther(title: localized("查看今日使用", "View today's usage"))
    }

    func openSettings() {
        showingSettings = true
        showingUsage = false
        searchText = ""
        addressText = ""
        recordOther(title: localized("打开设置", "Open settings"))
    }

    func goHome() {
        selectedCategory = settings.startupCategory.toolCategory
        showingUsage = false
        showingSettings = false
        searchText = ""
        addressText = ""
    }

    func updateTheme(_ theme: AppTheme) {
        settings.theme = theme
        defaults.set(theme.rawValue, forKey: DefaultsKey.theme)
    }

    func updateConverterLayoutMode(_ mode: ConverterLayoutMode) {
        settings.converterLayoutMode = mode
        defaults.set(mode.rawValue, forKey: DefaultsKey.converterLayoutMode)
    }

    func updateSearchEngine(_ engine: SearchEngine) {
        settings.searchEngine = engine
        defaults.set(engine.rawValue, forKey: DefaultsKey.searchEngine)
    }

    func updateBrowserTarget(_ browser: BrowserTarget) {
        settings.browserTarget = browser
        defaults.set(browser.rawValue, forKey: DefaultsKey.browserTarget)
    }

    func updateStartupCategory(_ category: StartupCategory) {
        settings.startupCategory = category
        defaults.set(category.rawValue, forKey: DefaultsKey.startupCategory)
    }

    func updateLanguage(_ language: AppLanguage) {
        settings.language = language
        defaults.set(language.rawValue, forKey: DefaultsKey.language)
    }

    func updateTimeFormatMode(_ mode: TimeFormatMode) {
        settings.timeFormatMode = mode
        defaults.set(mode.rawValue, forKey: DefaultsKey.timeFormatMode)
    }

    func updateCustomTimeFormat(_ format: String) {
        settings.customTimeFormat = format
        defaults.set(format, forKey: DefaultsKey.customTimeFormat)
    }

    func updatePopoverWidth(_ width: Double) {
        let clamped = width.clamped(to: Self.popoverWidthRange)
        settings.popoverWidth = clamped
        defaults.set(clamped, forKey: DefaultsKey.popoverWidth)
        NotificationCenter.default.post(name: .woodToolsWindowSizeDidChange, object: nil)
    }

    func updatePopoverHeight(_ height: Double) {
        let clamped = height.clamped(to: Self.popoverHeightRange)
        settings.popoverHeight = clamped
        defaults.set(clamped, forKey: DefaultsKey.popoverHeight)
        NotificationCenter.default.post(name: .woodToolsWindowSizeDidChange, object: nil)
    }

    func resetSettingsToDefaults() {
        settings.theme = .wood
        settings.converterLayoutMode = .horizontal
        settings.searchEngine = .baidu
        settings.browserTarget = .systemDefault
        settings.startupCategory = .time
        settings.language = .system
        settings.timeFormatMode = .standard
        settings.customTimeFormat = "yyyy-MM-dd HH:mm:ss"
        settings.popoverWidth = Self.defaultPopoverWidth
        settings.popoverHeight = Self.defaultPopoverHeight

        defaults.set(settings.theme.rawValue, forKey: DefaultsKey.theme)
        defaults.set(settings.converterLayoutMode.rawValue, forKey: DefaultsKey.converterLayoutMode)
        defaults.set(settings.searchEngine.rawValue, forKey: DefaultsKey.searchEngine)
        defaults.set(settings.browserTarget.rawValue, forKey: DefaultsKey.browserTarget)
        defaults.set(settings.startupCategory.rawValue, forKey: DefaultsKey.startupCategory)
        defaults.set(settings.language.rawValue, forKey: DefaultsKey.language)
        defaults.set(settings.timeFormatMode.rawValue, forKey: DefaultsKey.timeFormatMode)
        defaults.set(settings.customTimeFormat, forKey: DefaultsKey.customTimeFormat)
        defaults.set(settings.popoverWidth, forKey: DefaultsKey.popoverWidth)
        defaults.set(settings.popoverHeight, forKey: DefaultsKey.popoverHeight)
        selectedCategory = settings.startupCategory.toolCategory
        transientMessage = localized("已恢复默认设置", "Settings restored")
        NotificationCenter.default.post(name: .woodToolsWindowSizeDidChange, object: nil)
    }

    var effectiveTimeFormat: String {
        settings.timeFormatMode.format ?? settings.customTimeFormat
    }

    var effectiveLanguage: AppLanguage {
        settings.language.resolved
    }

    var popoverSize: CGSize {
        CGSize(width: settings.popoverWidth, height: settings.popoverHeight)
    }

    func localized(_ zhHans: String, _ english: String) -> String {
        effectiveLanguage == .english ? english : zhHans
    }

    func saveFileShelfText(_ text: String) {
        fileShelfText = text
        do {
            let url = try Self.fileShelfURL()
            try text.write(to: url, atomically: true, encoding: .utf8)
            transientMessage = localized("暂存已保存", "Shelf saved")
        } catch {
            transientMessage = error.localizedDescription
        }
    }

    func revealFileShelf() {
        do {
            let url = try Self.fileShelfURL()
            NSWorkspace.shared.activateFileViewerSelecting([url])
            recordOther(title: localized("定位文件暂存", "Reveal shelf file"))
        } catch {
            transientMessage = error.localizedDescription
        }
    }

    func addFavoriteApp(url: URL) {
        let app = FavoriteApp(name: url.deletingPathExtension().lastPathComponent, path: url.path)
        if !favoriteApps.contains(where: { $0.path == app.path }) {
            favoriteApps.append(app)
            favoriteAppIconCache[app.id] = NSWorkspace.shared.icon(forFile: app.path)
            saveFavoriteApps()
        }
        transientMessage = localized("已添加 App", "App added")
    }

    func removeFavoriteApp(_ app: FavoriteApp) {
        favoriteApps.removeAll { $0.id == app.id }
        favoriteAppIconCache[app.id] = nil
        saveFavoriteApps()
        transientMessage = localized("已移除 App", "App removed")
    }

    func moveFavoriteApp(_ source: FavoriteApp, before target: FavoriteApp, persist: Bool = true) {
        guard source.id != target.id,
              let sourceIndex = favoriteApps.firstIndex(of: source),
              let targetIndex = favoriteApps.firstIndex(of: target) else {
            return
        }
        let app = favoriteApps.remove(at: sourceIndex)
        let adjustedTargetIndex = sourceIndex < targetIndex ? targetIndex - 1 : targetIndex
        favoriteApps.insert(app, at: adjustedTargetIndex)
        if persist {
            saveFavoriteApps()
        }
    }

    func saveFavoriteAppOrder() {
        let apps = favoriteApps
        Task.detached(priority: .utility) {
            guard let data = try? JSONEncoder().encode(apps) else {
                return
            }
            UserDefaults.standard.set(data, forKey: DefaultsKey.favoriteApps)
        }
    }

    func icon(for app: FavoriteApp) -> NSImage {
        if let image = favoriteAppIconCache[app.id] {
            return image
        }
        let image = NSWorkspace.shared.icon(forFile: app.path)
        favoriteAppIconCache[app.id] = image
        return image
    }

    func addCalendarNote(date: Date, title: String, note: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let value = CalendarNote(
            date: Calendar.current.startOfDay(for: date),
            title: trimmedTitle.isEmpty ? localized("重要日子", "Important Day") : trimmedTitle,
            note: trimmedNote
        )
        calendarNotes.append(value)
        sortCalendarNotes()
        saveCalendarNotes()
        transientMessage = localized("已添加日历备注", "Calendar note added")
    }

    func updateCalendarNote(_ calendarNote: CalendarNote, title: String, note: String, date: Date) {
        guard let index = calendarNotes.firstIndex(where: { $0.id == calendarNote.id }) else {
            return
        }
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        calendarNotes[index].date = Calendar.current.startOfDay(for: date)
        calendarNotes[index].title = trimmedTitle.isEmpty ? localized("重要日子", "Important Day") : trimmedTitle
        calendarNotes[index].note = note.trimmingCharacters(in: .whitespacesAndNewlines)
        calendarNotes[index].updatedAt = Date()
        sortCalendarNotes()
        saveCalendarNotes()
        transientMessage = localized("已更新日历备注", "Calendar note updated")
    }

    func deleteCalendarNote(_ calendarNote: CalendarNote) {
        calendarNotes.removeAll { $0.id == calendarNote.id }
        saveCalendarNotes()
        transientMessage = localized("已删除日历备注", "Calendar note deleted")
    }

    func calendarNotes(on date: Date) -> [CalendarNote] {
        calendarNotes.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    func openFavoriteApp(_ app: FavoriteApp) {
        do {
            try openApplication(at: URL(fileURLWithPath: app.path))
            recordOther(title: localized("打开 \(app.name)", "Open \(app.name)"))
            transientMessage = localized("已打开 \(app.name)", "Opened \(app.name)")
        } catch {
            transientMessage = error.localizedDescription
        }
    }

    func openAddressOrSearch() {
        let value = addressText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else {
            return
        }

        guard let url = resolveAddress(value) ?? settings.searchEngine.searchURL(for: value) else {
            transientMessage = localized("无法生成搜索地址", "Unable to build search URL")
            return
        }

        do {
            try openURL(url, browser: settings.browserTarget)
            transientMessage = localized("已打开浏览器", "Browser opened")
            recordOther(title: localized("地址栏打开", "Open from address bar"))
        } catch {
            transientMessage = error.localizedDescription
        }
    }

    func record(tool: ToolID, title: String) {
        usages.insert(ToolUsage(tool: tool, category: tool.category, title: title, date: Date()), at: 0)
    }

    func recordOther(title: String) {
        usages.insert(ToolUsage(tool: nil, category: .other, title: title, date: Date()), at: 0)
    }

    func copy(_ value: String, title: String? = nil) {
        let actionTitle = title ?? localized("复制", "Copy")
        pasteboard.clearContents()
        pasteboard.setString(value, forType: .string)
        transientMessage = localized("\(actionTitle)成功", "\(actionTitle) succeeded")
        recordOther(title: actionTitle)
    }

    func usageCount(for category: ToolCategory) -> Int {
        todayUsages.filter { $0.category == category }.count
    }

    var todayUsages: [ToolUsage] {
        usages.filter { Calendar.current.isDateInToday($0.date) }
    }

    var mostUsedTitle: String {
        let grouped = Dictionary(grouping: todayUsages.compactMap(\.tool)) { $0 }
        let mostUsed = grouped.max { $0.value.count < $1.value.count }?.key
        return mostUsed?.title(language: settings.language) ?? localized("暂无", "None")
    }

    private static func load<T: RawRepresentable>(_ type: T.Type, key: String, defaultValue: T) -> T where T.RawValue == String {
        guard let rawValue = UserDefaults.standard.string(forKey: key), let value = T(rawValue: rawValue) else {
            return defaultValue
        }
        return value
    }

    private static func loadClampedDouble(key: String, defaultValue: Double, range: ClosedRange<Double>) -> Double {
        guard UserDefaults.standard.object(forKey: key) != nil else {
            return defaultValue
        }
        return UserDefaults.standard.double(forKey: key).clamped(to: range)
    }

    private static func loadTheme(key: String, defaultValue: AppTheme) -> AppTheme {
        guard let rawValue = UserDefaults.standard.string(forKey: key) else {
            return defaultValue
        }

        switch rawValue {
        case "纯白":
            return .light
        case "黑色":
            return .dark
        case "紫色":
            return .dracula
        default:
            return AppTheme(rawValue: rawValue) ?? defaultValue
        }
    }

    private static func loadFavoriteApps(key: String) -> [FavoriteApp] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        return (try? JSONDecoder().decode([FavoriteApp].self, from: data)) ?? []
    }

    private static func loadCalendarNotes(key: String) -> [CalendarNote] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        return ((try? JSONDecoder().decode([CalendarNote].self, from: data)) ?? [])
            .sorted { $0.date < $1.date }
    }

    private func saveFavoriteApps() {
        guard let data = try? JSONEncoder().encode(favoriteApps) else {
            transientMessage = localized("保存 App 列表失败", "Failed to save apps")
            return
        }
        defaults.set(data, forKey: DefaultsKey.favoriteApps)
    }

    private func saveCalendarNotes() {
        guard let data = try? JSONEncoder().encode(calendarNotes) else {
            transientMessage = localized("保存日历备注失败", "Failed to save calendar notes")
            return
        }
        defaults.set(data, forKey: DefaultsKey.calendarNotes)
    }

    private func sortCalendarNotes() {
        calendarNotes.sort { first, second in
            if first.date == second.date {
                return first.createdAt < second.createdAt
            }
            return first.date < second.date
        }
    }

    private static func loadFileShelfText() -> String {
        guard let url = try? fileShelfURL() else {
            return ""
        }
        return (try? String(contentsOf: url, encoding: .utf8)) ?? ""
    }

    private static func fileShelfURL() throws -> URL {
        let folder = try applicationSupportFolder()
        let url = folder.appendingPathComponent("shelf.txt", isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path) {
            try "".write(to: url, atomically: true, encoding: .utf8)
        }
        return url
    }

    private static func applicationSupportFolder() throws -> URL {
        let folder = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("WoodTools", isDirectory: true)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder
    }

    private func resolveAddress(_ value: String) -> URL? {
        if let url = URL(string: value), let scheme = url.scheme, ["http", "https"].contains(scheme.lowercased()) {
            return url
        }

        if value.contains("."), !value.contains(where: { $0.isWhitespace }) {
            return URL(string: "https://\(value)")
        }

        return nil
    }

    private func openURL(_ url: URL, browser: BrowserTarget) throws {
        if let appName = browser.appName {
            let result = runCommand("/usr/bin/open", arguments: ["-a", appName, url.absoluteString])
            guard result.status == 0 else {
                throw ToolError.commandFailed(command: "open -a \(appName) \(url.absoluteString)", status: result.status, stderr: result.error)
            }
            return
        }

        guard NSWorkspace.shared.open(url) else {
            throw ToolError.processingFailed("无法使用系统默认浏览器打开 \(url.absoluteString)")
        }
    }
}
