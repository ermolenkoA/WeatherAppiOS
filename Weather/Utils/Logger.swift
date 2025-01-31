import UIKit

class Logger {
    enum LogLevel: String {
        case debug = "🐞 DEBUG"
        case info = "ℹ️ INFO"
        case warning = "⚠️ WARNING"
        case error = "❗️ ERROR"
    }

    static func log(level: LogLevel, instance: AnyObject?, message: String) {
        let className = instance != nil ? NSStringFromClass(type(of: instance!)) : ""
        let logMessage = "\(getCurrentTimestamp()) \(level.rawValue) \(className.isEmpty ? "" : "\(className): ") \(message)"
        print(logMessage)
    }

    private static func getCurrentTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}
