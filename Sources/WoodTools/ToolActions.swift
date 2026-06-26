import AppKit
import Foundation
import Yams

struct CommandResult {
    let output: String
    let error: String
    let status: Int32
}

func formattedNow(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
    formatDate(Date(), format: format)
}

func currentTimestamp() -> String {
    String(Int(Date().timeIntervalSince1970))
}

func currentMillisecondTimestamp() -> String {
    String(Int(Date().timeIntervalSince1970 * 1000))
}

func timestampToFormattedTime(_ input: String, format: String = "yyyy-MM-dd HH:mm:ss") throws -> String {
    let value = input.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !value.isEmpty else {
        throw ToolError.invalidInput("请输入时间戳")
    }

    guard let rawTimestamp = TimeInterval(value) else {
        throw ToolError.invalidInput("请输入有效的秒级或毫秒级时间戳")
    }

    let timestamp = value.count >= 13 ? rawTimestamp / 1000 : rawTimestamp
    let date = Date(timeIntervalSince1970: timestamp)
    return formatDate(date, format: format)
}

func formattedTimeToTimestamp(_ input: String, milliseconds: Bool = false) throws -> String {
    let date = try parseFormattedDate(input)
    if milliseconds {
        return String(Int(date.timeIntervalSince1970 * 1000))
    }
    return String(Int(date.timeIntervalSince1970))
}

func convertTimeInput(_ input: String, format: String = "yyyy-MM-dd HH:mm:ss") throws -> String {
    let value = input.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !value.isEmpty else {
        throw ToolError.invalidInput("请输入时间戳或格式化时间")
    }

    if Double(value) != nil {
        let formatted = try timestampToFormattedTime(value, format: format)
        return "\(formatted)\n\(try formattedTimeToTimestamp(formatted))"
    }

    let timestamp = try formattedTimeToTimestamp(value)
    return "\(formatDate(try parseFormattedDate(value), format: format))\n\(timestamp)"
}

func convertRadix(_ input: String, from sourceRadix: Int, to targetRadix: Int) throws -> String {
    let number = try parseInteger(input, radix: sourceRadix)
    return formatInteger(number, radix: targetRadix)
}

func radixPreview(_ input: String, sourceRadix: Int) throws -> String {
    let number = try parseInteger(input, radix: sourceRadix)
    return """
    BIN  \(formatInteger(number, radix: 2))
    OCT  \(formatInteger(number, radix: 8))
    DEC  \(formatInteger(number, radix: 10))
    HEX  \(formatInteger(number, radix: 16))
    """
}

func convertDecimal(_ input: String) throws -> String {
    try radixPreview(input, sourceRadix: 10)
}

func decimalToBinary(_ input: String) throws -> String {
    let number = try parseDecimal(input)
    return String(number, radix: 2)
}

func decimalToOctal(_ input: String) throws -> String {
    let number = try parseDecimal(input)
    return String(number, radix: 8)
}

func decimalToHex(_ input: String) throws -> String {
    let number = try parseDecimal(input)
    return "0x\(String(number, radix: 16).uppercased())"
}

func encodeURL(_ input: String) throws -> String {
    guard let encoded = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        throw ToolError.processingFailed("URL 编码失败")
    }
    return encoded
}

func decodeURL(_ input: String) throws -> String {
    guard let decoded = input.removingPercentEncoding else {
        throw ToolError.processingFailed("URL 解码失败")
    }
    return decoded
}

func encodeBase64(_ input: String) -> String {
    Data(input.utf8).base64EncodedString()
}

func decodeBase64(_ input: String) throws -> String {
    let value = input.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let data = Data(base64Encoded: value), let decoded = String(data: data, encoding: .utf8) else {
        throw ToolError.invalidInput("Base64 内容无效或不是 UTF-8 文本")
    }
    return decoded
}

func decodeHex(_ input: String) throws -> String {
    let normalized = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .replacingOccurrences(of: "0x", with: "", options: .caseInsensitive)
        .replacingOccurrences(of: "\\x", with: "")
        .filter { !$0.isWhitespace }

    guard !normalized.isEmpty else {
        throw ToolError.invalidInput("请输入 Hex 内容")
    }
    guard normalized.count.isMultiple(of: 2) else {
        throw ToolError.invalidInput("Hex 内容长度必须是偶数")
    }

    var data = Data()
    var index = normalized.startIndex
    while index < normalized.endIndex {
        let nextIndex = normalized.index(index, offsetBy: 2)
        let byteText = normalized[index..<nextIndex]
        guard let byte = UInt8(byteText, radix: 16) else {
            throw ToolError.invalidInput("Hex 内容包含非法字符")
        }
        data.append(byte)
        index = nextIndex
    }

    guard let decoded = String(data: data, encoding: .utf8) else {
        throw ToolError.invalidInput("Hex 内容无效或不是 UTF-8 文本")
    }
    return decoded
}

func convertCase(_ input: String, mode: CaseMode) -> String {
    switch mode {
    case .upper:
        input.uppercased()
    case .lower:
        input.lowercased()
    case .capitalized:
        input.capitalized
    }
}

func formatJSON(_ input: String) throws -> String {
    let object = try parseJSONObject(input)
    let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys])
    guard let result = String(data: data, encoding: .utf8) else {
        throw ToolError.processingFailed("JSON 格式化结果不是 UTF-8 文本")
    }
    return result.replacingOccurrences(of: "\\/", with: "/")
}

func compactJSON(_ input: String) throws -> String {
    let object = try parseJSONObject(input)
    let data = try JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])
    guard let result = String(data: data, encoding: .utf8) else {
        throw ToolError.processingFailed("JSON 压缩结果不是 UTF-8 文本")
    }
    return result.replacingOccurrences(of: "\\/", with: "/")
}

func jsonToYAML(_ input: String) throws -> String {
    let object = try normalizeYAMLCompatibleObject(parseJSONObject(input))
    do {
        return try Yams.dump(object: object)
    } catch {
        throw ToolError.processingFailed("JSON 转 YAML 失败：\(yamlErrorDescription(error))")
    }
}

func yamlToJSON(_ input: String) throws -> String {
    let value = input.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !value.isEmpty else {
        throw ToolError.invalidInput("请输入 YAML 内容")
    }

    do {
        let object = try normalizeJSONCompatibleObject(Yams.load(yaml: value) ?? NSNull())
        guard JSONSerialization.isValidJSONObject(object) else {
            throw ToolError.invalidInput("YAML 内容无法转换为 JSON 对象")
        }
        let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys])
        guard let result = String(data: data, encoding: .utf8) else {
            throw ToolError.processingFailed("JSON 转换结果不是 UTF-8 文本")
        }
        return result.replacingOccurrences(of: "\\/", with: "/")
    } catch let error as ToolError {
        throw error
    } catch {
        throw ToolError.invalidInput("YAML 转 JSON 失败：\(yamlErrorDescription(error))")
    }
}

func generateUUID(uppercase: Bool = false, hyphenated: Bool = true) -> String {
    var value = UUID().uuidString
    if !hyphenated {
        value = value.replacingOccurrences(of: "-", with: "")
    }
    return uppercase ? value.uppercased() : value.lowercased()
}

func networkSummary() throws -> String {
    let ip = try localIPSummary()
    let mac = try macAddressSummary()
    return """
    本机 IP  \(ip)
    MAC      \(mac)
    """
}

func localIPSummary() throws -> String {
    let result = runCommand("/usr/sbin/ipconfig", arguments: ["getifaddr", "en0"])
    if result.status == 0 {
        return result.output.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    let fallback = runCommand("/usr/sbin/ipconfig", arguments: ["getifaddr", "en1"])
    if fallback.status == 0 {
        return fallback.output.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    throw ToolError.commandFailed(command: "ipconfig getifaddr", status: fallback.status, stderr: fallback.error)
}

func macAddressSummary() throws -> String {
    let result = runCommand("/sbin/ifconfig", arguments: ["en0"])
    guard result.status == 0 else {
        throw ToolError.commandFailed(command: "ifconfig en0", status: result.status, stderr: result.error)
    }

    let lines = result.output.split(separator: "\n")
    guard let etherLine = lines.first(where: { $0.trimmingCharacters(in: .whitespaces).hasPrefix("ether ") }) else {
        throw ToolError.processingFailed("未找到 en0 的 MAC 地址")
    }

    return etherLine
        .replacingOccurrences(of: "ether", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .uppercased()
}

func wifiPasswordSummary() throws -> String {
    let network = runCommand("/usr/sbin/networksetup", arguments: ["-getairportnetwork", "en0"])
    guard network.status == 0 else {
        throw ToolError.commandFailed(command: "networksetup -getairportnetwork en0", status: network.status, stderr: network.error)
    }

    let name = network.output
        .replacingOccurrences(of: "Current Wi-Fi Network:", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
    guard !name.isEmpty else {
        throw ToolError.processingFailed("当前未连接 Wi-Fi")
    }

    let password = runCommand("/usr/bin/security", arguments: ["find-generic-password", "-wa", name])
    guard password.status == 0 else {
        throw ToolError.commandFailed(command: "security find-generic-password -wa \(name)", status: password.status, stderr: password.error)
    }

    return "\(name)\n\(password.output.trimmingCharacters(in: .whitespacesAndNewlines))"
}

func digDomain(_ domain: String) throws -> String {
    let value = domain.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !value.isEmpty else {
        throw ToolError.invalidInput("请输入域名")
    }

    let result = runCommand("/usr/bin/dig", arguments: ["+short", value])
    guard result.status == 0 else {
        throw ToolError.commandFailed(command: "dig +short \(value)", status: result.status, stderr: result.error)
    }

    let output = result.output.trimmingCharacters(in: .whitespacesAndNewlines)
    return output.isEmpty ? "没有查询到记录" : output
}

func pingHost(_ host: String) throws -> String {
    let value = host.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !value.isEmpty else {
        throw ToolError.invalidInput("请输入域名或 IP")
    }

    guard isValidPingTarget(value) else {
        throw ToolError.invalidInput("请输入有效域名或 IPv4 地址，例如 example.com 或 8.8.8.8")
    }

    let result = runCommand("/sbin/ping", arguments: ["-c", "1", "-W", "1000", value], timeout: 3)
    guard result.status == 0 else {
        throw ToolError.processingFailed(readablePingError(from: result, target: value))
    }
    return result.output.trimmingCharacters(in: .whitespacesAndNewlines)
}

func pingHostAsync(_ host: String) async -> (output: String?, errorMessage: String?) {
    await withCheckedContinuation { continuation in
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                continuation.resume(returning: (try pingHost(host), nil))
            } catch {
                continuation.resume(returning: (nil, error.localizedDescription))
            }
        }
    }
}

func networkSpeedTestAsync() async -> (output: String?, errorMessage: String?) {
    await withCheckedContinuation { continuation in
        DispatchQueue.global(qos: .userInitiated).async {
            let result = runCommand("/usr/bin/networkQuality", arguments: [], timeout: 90)
            guard result.status == 0 else {
                let message = result.error.trimmingCharacters(in: .whitespacesAndNewlines)
                continuation.resume(returning: (nil, message.isEmpty ? "网络测速失败" : message))
                return
            }
            continuation.resume(returning: (result.output.trimmingCharacters(in: .whitespacesAndNewlines), nil))
        }
    }
}

func runScreenshot() throws -> String {
    let result = runCommand("/usr/sbin/screencapture", arguments: ["-i", "-c"])
    guard result.status == 0 else {
        throw ToolError.commandFailed(command: "screencapture -i -c", status: result.status, stderr: result.error)
    }
    return "截屏已复制到剪贴板"
}

func openScreenshotTool() throws -> String {
    let result = runCommand("/usr/bin/open", arguments: ["-a", "Screenshot"])
    guard result.status == 0 else {
        throw ToolError.commandFailed(command: "open -a Screenshot", status: result.status, stderr: result.error)
    }
    return "已打开系统截图/录屏工具，请选择录制模式"
}

func openApplication(named name: String) throws -> String {
    let value = name.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !value.isEmpty else {
        throw ToolError.invalidInput("请输入 App 名称")
    }

    let result = runCommand("/usr/bin/open", arguments: ["-a", value])
    guard result.status == 0 else {
        throw ToolError.commandFailed(command: "open -a \(value)", status: result.status, stderr: result.error)
    }
    return "已打开 \(value)"
}

func openApplication(at url: URL) throws {
    guard FileManager.default.fileExists(atPath: url.path) else {
        throw ToolError.invalidInput("App 不存在：\(url.path)")
    }

    let configuration = NSWorkspace.OpenConfiguration()
    NSWorkspace.shared.openApplication(at: url, configuration: configuration) { _, error in
        if let error {
            NSLog("Open app failed: %@", error.localizedDescription)
        }
    }
}

func revealTemporaryFolder() throws -> String {
    let folder = FileManager.default.temporaryDirectory.appendingPathComponent("WoodToolsShelf", isDirectory: true)
    try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
    NSWorkspace.shared.activateFileViewerSelecting([folder])
    return folder.path
}

func runCommand(_ executable: String, arguments: [String], timeout: TimeInterval? = nil) -> CommandResult {
    let process = Process()
    let outputPipe = Pipe()
    let errorPipe = Pipe()

    process.executableURL = URL(fileURLWithPath: executable)
    process.arguments = arguments
    process.standardOutput = outputPipe
    process.standardError = errorPipe

    do {
        try process.run()

        if let timeout {
            let deadline = Date().addingTimeInterval(timeout)
            while process.isRunning && Date() < deadline {
                Thread.sleep(forTimeInterval: 0.05)
            }

            if process.isRunning {
                process.terminate()
                process.waitUntilExit()
                return CommandResult(output: "", error: "命令执行超时", status: -2)
            }
        } else {
            process.waitUntilExit()
        }
    } catch {
        return CommandResult(output: "", error: error.localizedDescription, status: -1)
    }

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
    return CommandResult(
        output: String(data: outputData, encoding: .utf8) ?? "",
        error: String(data: errorData, encoding: .utf8) ?? "",
        status: process.terminationStatus
    )
}

func formatDate(_ date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format.isEmpty ? "yyyy-MM-dd HH:mm:ss" : format
    formatter.locale = Locale(identifier: "zh_CN")
    return formatter.string(from: date)
}

private func parseDecimal(_ input: String) throws -> Int {
    let value = input.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let number = Int(value) else {
        throw ToolError.invalidInput("请输入有效的十进制整数")
    }
    return number
}

private func parseFormattedDate(_ input: String) throws -> Date {
    let value = input.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !value.isEmpty else {
        throw ToolError.invalidInput("请输入格式化时间")
    }

    let formats: [String] = [
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd'T'HH:mm:ss",
        "yyyy/MM/dd HH:mm:ss",
        "yyyy-MM-dd"
    ]

    for format in formats {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "zh_CN")
        if let date = formatter.date(from: value) {
            return date
        }
    }

    throw ToolError.invalidInput("无法识别时间格式：\(value)")
}

private func parseInteger(_ input: String, radix: Int) throws -> Int {
    var value = input.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    guard !value.isEmpty else {
        throw ToolError.invalidInput("请输入数字")
    }

    if radix == 16, value.hasPrefix("0X") {
        value.removeFirst(2)
    }

    guard let number = Int(value, radix: radix) else {
        throw ToolError.invalidInput("请输入有效的 \(radix) 进制整数")
    }
    return number
}

private func formatInteger(_ number: Int, radix: Int) -> String {
    let value = String(number, radix: radix).uppercased()
    return radix == 16 ? "0x\(value)" : value
}

private func normalizeYAMLCompatibleObject(_ object: Any) throws -> Any {
    if let dictionary = object as? NSDictionary {
        var result: [String: Any] = [:]
        for (key, value) in dictionary {
            guard let stringKey = key as? String else {
                throw ToolError.invalidInput("JSON 对象键必须是字符串")
            }
            result[stringKey] = try normalizeYAMLCompatibleObject(value)
        }
        return result
    }

    if let dictionary = object as? [String: Any] {
        return try dictionary.mapValues { try normalizeYAMLCompatibleObject($0) }
    }

    if let array = object as? NSArray {
        return try array.map { try normalizeYAMLCompatibleObject($0) }
    }

    if let array = object as? [Any] {
        return try array.map { try normalizeYAMLCompatibleObject($0) }
    }

    if let number = object as? NSNumber {
        if CFGetTypeID(number) == CFBooleanGetTypeID() {
            return number.boolValue
        }
        let double = number.doubleValue
        return double.rounded() == double ? number.intValue : double
    }

    if object is String || object is NSNull {
        return object
    }

    throw ToolError.invalidInput("JSON 内容包含不支持的值")
}

private func normalizeJSONCompatibleObject(_ object: Any) throws -> Any {
    if let dictionary = object as? [String: Any] {
        return try dictionary.mapValues { try normalizeJSONCompatibleObject($0) }
    }

    if let array = object as? [Any] {
        return try array.map { try normalizeJSONCompatibleObject($0) }
    }

    if object is String || object is NSNumber || object is NSNull {
        return object
    }

    if let bool = object as? Bool {
        return bool
    }

    if let int = object as? Int {
        return int
    }

    if let double = object as? Double {
        return double
    }

    throw ToolError.invalidInput("YAML 内容包含无法转换为 JSON 的值")
}

private func yamlErrorDescription(_ error: Error) -> String {
    let description = String(describing: error)
    return description.isEmpty ? error.localizedDescription : description
}

private func parseJSONObject(_ input: String) throws -> Any {
    let value = input.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !value.isEmpty else {
        throw ToolError.invalidInput("请输入 JSON 内容")
    }

    guard let data = value.data(using: .utf8) else {
        throw ToolError.invalidInput("JSON 内容不是 UTF-8 文本")
    }

    do {
        return try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
    } catch {
        throw ToolError.invalidInput("JSON 解析失败：\(error.localizedDescription)")
    }
}

private extension Date {
    func formattedForTool() -> String {
        formatDate(self)
    }
}

private func isValidPingTarget(_ value: String) -> Bool {
    if value == "localhost" {
        return true
    }

    if isValidIPv4(value) {
        return true
    }

    guard value.contains(".") else {
        return false
    }

    let labels = value.split(separator: ".", omittingEmptySubsequences: false)
    guard labels.count >= 2 else {
        return false
    }

    return labels.allSatisfy { label in
        guard !label.isEmpty, label.count <= 63 else {
            return false
        }

        let characters = CharacterSet(charactersIn: String(label))
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-"))
        return allowed.isSuperset(of: characters)
            && label.first != "-"
            && label.last != "-"
    }
}

private func isValidIPv4(_ value: String) -> Bool {
    let parts = value.split(separator: ".", omittingEmptySubsequences: false)
    guard parts.count == 4 else {
        return false
    }

    return parts.allSatisfy { part in
        guard !part.isEmpty, part.allSatisfy(\.isNumber), let number = Int(part) else {
            return false
        }
        return number >= 0 && number <= 255
    }
}

private func readablePingError(from result: CommandResult, target: String) -> String {
    if result.status == -2 {
        return "Ping 超时：\(target)，请检查网络连接或目标地址"
    }

    let message = [result.error, result.output]
        .joined(separator: "\n")
        .trimmingCharacters(in: .whitespacesAndNewlines)

    if message.localizedCaseInsensitiveContains("unknown host")
        || message.localizedCaseInsensitiveContains("cannot resolve") {
        return "无法解析目标地址：\(target)"
    }

    if message.localizedCaseInsensitiveContains("no route to host") {
        return "网络不可达：\(target)"
    }

    if message.localizedCaseInsensitiveContains("100.0% packet loss")
        || message.localizedCaseInsensitiveContains("100% packet loss") {
        return "目标无响应：\(target)"
    }

    return "Ping 失败：\(message.isEmpty ? target : message)"
}

enum CaseMode: String, CaseIterable, Identifiable {
    case upper = "转大写"
    case lower = "转小写"
    case capitalized = "首字母大写"

    var id: String { rawValue }

    func title(language: AppLanguage) -> String {
        switch language.resolved {
        case .english:
            switch self {
            case .upper:
                "Uppercase"
            case .lower:
                "Lowercase"
            case .capitalized:
                "Capitalized"
            }
        case .system, .zhHans:
            rawValue
        }
    }
}

enum ToolError: LocalizedError {
    case invalidInput(String)
    case processingFailed(String)
    case commandFailed(command: String, status: Int32, stderr: String)

    var errorDescription: String? {
        switch self {
        case .invalidInput(let message), .processingFailed(let message):
            message
        case .commandFailed(let command, let status, let stderr):
            "命令失败：\(command)，状态码：\(status)，错误：\(stderr.isEmpty ? "无 stderr 输出" : stderr)"
        }
    }
}
