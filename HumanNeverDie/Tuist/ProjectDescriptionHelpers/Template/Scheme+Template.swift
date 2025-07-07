//
//  Scheme+Template.swift
//  ProjectDescriptionHelpers
//
//  Created by 김규철 on 5/12/25.
//

import ProjectDescription

extension Scheme {
    public static func makeAppScheme() -> [Scheme] {
        return [
            .scheme(
                name: "release-AhMatdang",
                shared: true,
                buildAction: .buildAction(targets: ["\(AppConfiguration.projectName)"]),
                runAction: .runAction(configuration: .release),
                archiveAction: .archiveAction(configuration: .release),
                profileAction: .profileAction(configuration: .release),
                analyzeAction: .analyzeAction(configuration: .release)
            ),
            .scheme(
                name: "dev-AhMatdang",
                shared: true,
                buildAction: .buildAction(targets: ["\(AppConfiguration.projectName)"]),
                runAction: .runAction(configuration: .debug),
                archiveAction: .archiveAction(configuration: .debug),
                profileAction: .profileAction(configuration: .debug),
                analyzeAction: .analyzeAction(configuration: .debug)
            )
        ]
    }
}

extension Scheme {
    public static func makeDemoScheme(moduleName: String) -> Scheme {
        return .scheme(
            name: "\(moduleName)Demo",
            shared: true,
            buildAction: .buildAction(targets: ["\(moduleName)Demo"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        )
    }
}
