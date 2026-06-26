import Foundation

enum ToolCategory: String, CaseIterable, Identifiable {
    case time
    case radix
    case coding
    case network
    case quick
    case other

    var id: String { rawValue }

    var title: String {
        title(language: .zhHans)
    }

    func title(language: AppLanguage) -> String {
        switch language.resolved {
        case .zhHans, .system:
            switch self {
            case .time:
                "时间工具"
            case .radix:
                "进制工具"
            case .coding:
                "编码工具"
            case .network:
                "网络工具"
            case .quick:
                "快捷工具"
            case .other:
                "其他用量"
            }
        case .english:
            switch self {
            case .time:
                "Time"
            case .radix:
                "Radix"
            case .coding:
                "Coding"
            case .network:
                "Network"
            case .quick:
                "Quick"
            case .other:
                "Other"
            }
        }
    }

    var iconName: String {
        switch self {
        case .time:
            "clock"
        case .radix:
            "number"
        case .coding:
            "curlybraces"
        case .network:
            "network"
        case .quick:
            "bolt"
        case .other:
            "ellipsis.circle"
        }
    }
}

enum ToolID: String, CaseIterable, Identifiable {
    case timeConverter
    case calendarNotes
    case radixConverter
    case urlCoding
    case base64Coding
    case hexDecode
    case jsonYamlConverter
    case jsonFormatter
    case caseConvert
    case networkSummary
    case wifiPassword
    case networkDiagnostics
    case networkSpeedTest
    case screenTools
    case openApp
    case fileShelf
    case uuidGenerator

    var id: String { rawValue }

    var title: String {
        title(language: .zhHans)
    }

    func title(language: AppLanguage) -> String {
        switch language.resolved {
        case .zhHans, .system:
            switch self {
            case .timeConverter:
                "时间转换"
            case .calendarNotes:
                "日历备注"
            case .radixConverter:
                "进制转换"
            case .urlCoding:
                "URL"
            case .base64Coding:
                "Base64"
            case .hexDecode:
                "Hex 解码"
            case .jsonYamlConverter:
                "JSON / YAML"
            case .jsonFormatter:
                "JSON"
            case .caseConvert:
                "大小写"
            case .networkSummary:
                "本机网络"
            case .wifiPassword:
                "Wi-Fi 密码"
            case .networkDiagnostics:
                "网络诊断"
            case .networkSpeedTest:
                "网络测速"
            case .screenTools:
                "屏幕工具"
            case .openApp:
                "打开 App"
            case .fileShelf:
                "文件暂存"
            case .uuidGenerator:
                "UUID"
            }
        case .english:
            switch self {
            case .timeConverter:
                "Time Converter"
            case .calendarNotes:
                "Calendar Notes"
            case .radixConverter:
                "Radix Converter"
            case .urlCoding:
                "URL"
            case .base64Coding:
                "Base64"
            case .hexDecode:
                "Hex Decode"
            case .jsonYamlConverter:
                "JSON / YAML"
            case .jsonFormatter:
                "JSON"
            case .caseConvert:
                "Case"
            case .networkSummary:
                "Local Network"
            case .wifiPassword:
                "Wi-Fi Password"
            case .networkDiagnostics:
                "Network Diagnostics"
            case .networkSpeedTest:
                "Speed Test"
            case .screenTools:
                "Screen Tools"
            case .openApp:
                "Open App"
            case .fileShelf:
                "Text Shelf"
            case .uuidGenerator:
                "UUID"
            }
        }
    }

    var category: ToolCategory {
        switch self {
        case .timeConverter, .calendarNotes:
            .time
        case .radixConverter:
            .radix
        case .urlCoding, .base64Coding, .hexDecode, .jsonFormatter, .jsonYamlConverter, .caseConvert:
            .coding
        case .networkSummary, .wifiPassword, .networkDiagnostics, .networkSpeedTest:
            .network
        case .screenTools, .openApp, .fileShelf, .uuidGenerator:
            .quick
        }
    }

    var iconName: String {
        switch self {
        case .timeConverter:
            "clock.arrow.circlepath"
        case .calendarNotes:
            "calendar"
        case .radixConverter:
            "number.circle"
        case .urlCoding:
            "link"
        case .base64Coding:
            "textformat.abc"
        case .hexDecode:
            "number"
        case .jsonYamlConverter:
            "arrow.left.arrow.right.square"
        case .jsonFormatter:
            "curlybraces.square"
        case .caseConvert:
            "textformat"
        case .networkSummary:
            "wifi.router"
        case .wifiPassword:
            "key"
        case .networkDiagnostics:
            "dot.radiowaves.left.and.right"
        case .networkSpeedTest:
            "speedometer"
        case .screenTools:
            "camera.viewfinder"
        case .openApp:
            "app.badge"
        case .fileShelf:
            "tray.full"
        case .uuidGenerator:
            "number.square"
        }
    }
}

struct CalendarNote: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    var date: Date
    var title: String
    var note: String
    let createdAt: Date
    var updatedAt: Date

    init(id: UUID = UUID(), date: Date, title: String, note: String, createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.date = date
        self.title = title
        self.note = note
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

struct ToolUsage: Identifiable {
    let id = UUID()
    let tool: ToolID?
    let category: ToolCategory
    let title: String
    let date: Date
}

struct ToolDefinition: Identifiable {
    let id: ToolID
    let title: String
    let iconName: String
    let category: ToolCategory
}

func toolDefinitions(language: AppLanguage = .zhHans) -> [ToolDefinition] {
    ToolID.allCases.map {
        ToolDefinition(id: $0, title: $0.title(language: language), iconName: $0.iconName, category: $0.category)
    }
}
