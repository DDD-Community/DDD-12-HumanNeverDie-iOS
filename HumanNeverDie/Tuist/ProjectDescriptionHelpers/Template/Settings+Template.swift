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
                "CODE_SIGN_STYLE": .string("Manual"),
                "PRODUCT_BUNDLE_IDENTIFIER": .string(AppConfiguration.bundleIdentifier),
                "DEVELOPMENT_TEAM": .string("8LJ2P85FNV"),
                "MARKETING_VERSION": .string(AppConfiguration.marketingVesion),
                "CURRENT_PROJECT_VERSION": .string(AppConfiguration.projectBuildVersion),
                "OTHER_LDFLAGS": .array(["$(inherited)", "-ObjC"]),
                "SWIFT_VERSION": .string("6.0"),
            ],
            configurations: [
                .debug(
                    name: .debug,
                    settings: [
                        "PROVISIONING_PROFILE_SPECIFIER": .string("match Development \(AppConfiguration.bundleIdentifier)"),
                        "CODE_SIGN_IDENTITY": .string("Apple Development"),
                        "ASSETCATALOG_COMPILER_APPICON_NAME": .string("DevAppIcon")
                    ],
                    xcconfig: .relativeToRoot("XCConfig/DEV.xcconfig")
                ),
                .release(
                    name: .release,
                    settings: [
                        "PROVISIONING_PROFILE_SPECIFIER": .string("match AppStore \(AppConfiguration.bundleIdentifier)"),
                        "CODE_SIGN_IDENTITY": .string("Apple Distribution"),
                        "ASSETCATALOG_COMPILER_APPICON_NAME": .string("AppIcon")
                    ],
                    xcconfig: .relativeToRoot("XCConfig/PROD.xcconfig")
                )
            ]
        )
    }
}
