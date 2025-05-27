import ProjectDescription

public struct InfoPlist {
    public static let appInfoPlist: [String: Plist.Value] = [
        "UILaunchScreen": [
            "BackgroundColor": "systemBackgroundColor"
        ],
        "UIUserInterfaceStyle": "Light",
        "LSSupportsOpeningDocumentsInPlace": true,
        "ITSAppUsesNonExemptEncryption": false,
        "UISupportedInterfaceOrientations": [
            "UIInterfaceOrientationPortrait"
        ],
        "UISupportedInterfaceOrientations~ipad": [
            "UIInterfaceOrientationPortrait",
            "UIInterfaceOrientationPortraitUpsideDown"
        ],
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleShortVersionString": .string(AppConfiguration.marketingVesion),
        "CFBundleVersion": .string(AppConfiguration.projectBuildVersion),
        "CFBundleDisplayName": "$(BUNDLE_DISPLAY_NAME)",
        "CFBundleURLTypes": [],
        "BASE_URL": "$(BASE_URL)"
    ]
}


