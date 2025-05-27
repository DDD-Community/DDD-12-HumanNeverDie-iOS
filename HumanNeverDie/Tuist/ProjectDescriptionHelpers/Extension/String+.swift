import Foundation

public extension String {
    static func appBundleID(name: String) -> String {
        return "\(AppConfiguration.bundleIdentifier)\(name)"
    }
}

public extension String {
    static var defaultYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: Date())
    }
    
    static var defaultDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: Date())
    }
    
    static var defaultAuthor: String {
        return ProcessInfo.processInfo.fullUserName
    }
}
