import ProjectDescription


// MARK: - rootFeature
public extension TargetDependency {
    static var rootFeature: Self {
        return .project(
            target: Modules.RootFeature.name,
            path: .relativeToRoot("Projects/\(Modules.RootFeature.name)")
        )
    }
}

// MARK: - Feature
public extension TargetDependency {
    static func feature(module: Modules.Feature) -> Self {
        return .project(
            target: module.name,
            path: .relativeToRoot("Projects/Features/\(module.name)")
        )
    }
}

// MARK: - CommonFeature & designSystem
public extension TargetDependency {
    static var commonFeature: Self {
        return .project(
            target: Modules.CommonFeature.name,
            path: .relativeToRoot("Projects/CommonFeature/\(Modules.CommonFeature.name)")
        )
    }
    
    static var designSystem: Self {
        return .project(
            target: Modules.DesignSystem.name,
            path: .relativeToRoot("Projects/CommonFeature/\(Modules.DesignSystem.name)")
        )
    }
}

// MARK: - Domain
public extension TargetDependency {
    static var baseDomain: Self {
        return .project(
            target: Modules.BaseDomain.name,
            path: .relativeToRoot("Projects/Domain/\(Modules.BaseDomain.name)")
        )
    }
}

public extension TargetDependency {
    static func domain(module: Modules.Domain) -> Self {
        return .project(
            target: module.name,
            path: .relativeToRoot("Projects/Domain/\(module.name)")
        )
    }
}

// MARK: - Data
public extension TargetDependency {
    static var data: Self {
        return .project(
            target: Modules.Data.name,
            path: .relativeToRoot("Projects/Data/\(Modules.Data.name)")
        )
    }
    
    static var baseNetwork: Self {
        return .project(
            target: Modules.BaseNetwork.name,
            path: .relativeToRoot("Projects/Data/\(Modules.BaseNetwork.name)")
        )
    }
}

// MARK: - Shared
public extension TargetDependency {
    static var shared: Self {
        return .project(
            target: Modules.Shared.name,
            path: .relativeToRoot("Projects/Shared/\(Modules.Shared.name)")
        )
    }
    
    static var thirdParty: Self {
        return .project(
            target: Modules.ThirdParty.name,
            path: .relativeToRoot("Projects/Shared/\(Modules.ThirdParty.name)")
        )
    }
}
