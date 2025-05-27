//
//  Settings+Template.swift
//  ProjectDescriptionHelpers
//
//  Created by 김규철 on 5/12/25.
//

import ProjectDescription

extension ProjectDescription.Settings {
    public static var appSettings: Self {
        return .settings(
            base: [
                "MARKETING_VERSION": .string(AppConfiguration.marketingVesion),
                "CURRENT_PROJECT_VERSION": .string(AppConfiguration.projectBuildVersion),
                "OTHER_LDFLAGS": .array(["$(inherited)", "-ObjC"]),
                "SWIFT_VERSION": .string("6.0")
            ],
            configurations: [
                .debug(
                    name: .debug,
                    settings: ["ASSETCATALOG_COMPILER_APPICON_NAME": .string("DevAppIcon")],
                    xcconfig: .relativeToRoot("XCConfig/DEV.xcconfig")
                ),
                .release(
                    name: .release,
                    settings: ["ASSETCATALOG_COMPILER_APPICON_NAME": .string("AppIcon")],
                    xcconfig: .relativeToRoot("XCConfig/PROD.xcconfig")
                )
            ]
        )
    }
}
