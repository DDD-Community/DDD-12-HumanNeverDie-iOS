import Foundation

public enum Modules {}

// MARK: - rootFeature
public extension Modules {
    struct RootFeature {
        public static let name: String = "RootFeature"
    }
}

// MARK: - Feature
public extension Modules {
    enum Feature: String {
        case Splash
        case Home
        case History
        case BeverageRecordList
        
        var name: String {
            return "\(rawValue)Feature"
        }
    }
}

// MARK: - CommonFeature & designSystem
public extension Modules {
    struct CommonFeature {
        public static let name: String = "CommonFeature"
    }
    
    struct DesignSystem {
        public static let name: String = "DesignSystem"
    }
}

// MARK: - Domain
public extension Modules {
    struct BaseDomain {
        public static let name: String = "BaseDomain"
    }
    
    enum Domain: String {
        case Main
        case Beverage
        
        var name: String {
            return "\(rawValue)Domain"
        }
    }
}

// MARK: - Data
public extension Modules {
    struct Data {
        public static let name: String = "Data"
    }
    
    struct BaseNetwork {
        public static let name: String = "BaseNetwork"
    }
}

// MARK: - Shared
public extension Modules {
    struct Shared {
        public static let name: String = "Shared"
    }
    
    struct ThirdParty {
        public static let name: String = "ThirdParty"
    }
}
