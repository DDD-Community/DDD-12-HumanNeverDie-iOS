//
//  Project+Template.swift
//  ModulerprojectManifests
//
//  Created by 김규철 on 5/12/25.
//

import ProjectDescription

let isDev = Environment.isDev.getBoolean(default: false)

// MARK: - App Project
public extension Project {
    static func makeApp(
        dependencies: [TargetDependency],
        packages: [Package] = []
    ) -> Project {
        var targets: [Target] = []
        var schemes: [Scheme] = []
        
        let appTarget = Target.target(
            name: AppConfiguration.projectName,
            destinations: AppConfiguration.destination,
            product: .app,
            bundleId: AppConfiguration.bundleIdentifier,
            deploymentTargets: AppConfiguration.deploymentTarget,
            infoPlist: .extendingDefault(with: InfoPlist.appInfoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: dependencies,
            settings: .appSettings
        )
                
        targets.append(appTarget)
        schemes.append(contentsOf: Scheme.makeAppScheme())
        
        return Project(
            name: AppConfiguration.projectName,
            options: .defaultOption,
            packages: packages,
            settings: .appSettings,
            targets: targets,
            schemes: schemes
        )
    }
}

// MARK: - Feature Project
public extension Project {
    static func makeFeature(
        name: String,
        dependencies: [TargetDependency],
        packages: [Package] = [],
        hasTests: Bool = true,
    ) -> Project {
        var targets: [Target] = []
        
        let featureTarget = Target.target(
            name: "\(name)Feature",
            destinations: AppConfiguration.destination,
            product: isDev ? .framework : .staticFramework,
            bundleId: .appBundleID(name: "\(name)Feature"),
            deploymentTargets: AppConfiguration.deploymentTarget,
            sources: ["Sources/**"],
            dependencies: dependencies
        )
        targets.append(featureTarget)
        
        if hasTests {
            let featureTestTarget = Target.target(
                name: "\(name)FeatureTest",
                destinations: AppConfiguration.destination,
                product: .unitTests,
                bundleId: .appBundleID(name: "\(name)FeatureTest"),
                deploymentTargets: AppConfiguration.deploymentTarget,
                sources: ["Tests/Sources/**"],
                dependencies: [.target(name: "\(name)Feature")]
            )
            targets.append(featureTestTarget)
        }
        
        return Project(
            name: "\(name)Feature",
            options: .defaultOption,
            packages: packages,
            targets: targets
        )
    }
}


// MARK: - Domain Project
public extension Project {
    static func makeDomain(
        name: String,
        dependencies: [TargetDependency],
        packages: [Package] = [],
        hasTests: Bool = true,
    ) -> Project {
        var targets: [Target] = []
        
        let domainTarget =  Target.target(
            name: "\(name)Domain",
            destinations: AppConfiguration.destination,
            product: .framework,
            bundleId: .appBundleID(name: "\(name)Domain"),
            deploymentTargets: AppConfiguration.deploymentTarget,
            sources: ["Sources/**"],
            dependencies: dependencies
        )
        targets.append(domainTarget)
        
        if hasTests {
            let domainTestTarget = Target.target(
                name: "\(name)DomainTest",
                destinations: AppConfiguration.destination,
                product: .unitTests,
                bundleId: .appBundleID(name: "\(name)DomainTest"),
                deploymentTargets: AppConfiguration.deploymentTarget,
                sources: ["Tests/Sources/**"],
                dependencies: [.target(name: "\(name)Domain")]
            )
            targets.append(domainTestTarget)
        }
        
        return Project(
            name: "\(name)Domain",
            options: .defaultOption,
            packages: packages,
            targets: targets
        )
    }
}

// MARK: - Default Module Project
public extension Project {
    static func makeModule(
        name: String,
        product: Product,
        dependencies: [TargetDependency],
        packages: [Package] = [],
        hasTests: Bool = true,
        hasResource: Bool = false
    ) -> Project {
        var targets: [Target] = []
        
        let moduleTarget = Target.target(
            name: name,
            destinations: AppConfiguration.destination,
            product: product,
            bundleId: .appBundleID(name: name),
            deploymentTargets: AppConfiguration.deploymentTarget,
            sources: ["Sources/**"],
            resources: hasResource ? ["Resource/**"] : [],
            dependencies: dependencies
        )
        targets.append(moduleTarget)
        
        if hasTests {
            let moduleTestTarget = Target.target(
                name: "\(name)Test",
                destinations: AppConfiguration.destination,
                product: .unitTests,
                bundleId: .appBundleID(name: "\(name)Test"),
                deploymentTargets: AppConfiguration.deploymentTarget,
                sources: ["Tests/Sources/**"],
                dependencies: [.target(name: name)]
            )
            targets.append(moduleTestTarget)
        }
        
        return Project(
            name: name,
            options: .defaultOption,
            packages: packages,
            targets: targets,
        )
    }
}


private extension ProjectDescription.Project.Options {
    static var defaultOption: Self {
        return .options(
            automaticSchemesOptions: .disabled,
            defaultKnownRegions: ["ko"],
            developmentRegion: "ko",
            textSettings: .textSettings(usesTabs: false, indentWidth: 2, tabWidth: 2)
        )
    }
}
