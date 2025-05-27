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
                name: "release-HumanNeverDie",
                shared: true,
                buildAction: .buildAction(targets: ["\(AppConfiguration.projectName)"]),
                runAction: .runAction(configuration: .release),
                archiveAction: .archiveAction(configuration: .release),
                profileAction: .profileAction(configuration: .release),
                analyzeAction: .analyzeAction(configuration: .release)
            ),
            .scheme(
                name: "dev-HumanNeverDie",
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
