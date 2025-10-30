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
        "NSAppTransportSecurity": [
            "NSAllowsArbitraryLoads": true
        ],
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleShortVersionString": .string(AppConfiguration.marketingVesion),
        "CFBundleVersion": .string(AppConfiguration.projectBuildVersion),
        "CFBundleDisplayName": "$(BUNDLE_DISPLAY_NAME)",
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "None",
                "CFBundleURLName": "auth0",
                "CFBundleURLSchemes": ["$(PRODUCT_BUNDLE_IDENTIFIER)"]
            ]
        ],
        "BASE_URL": "$(BASE_URL)",
        "ClientId": "$(AUTH0_CLIENT_ID)",
        "Domain": "$(AUTH0_DOMAIN)",
        "AMPLITUDE_API_KEY": "$(AMPLITUDE_API_KEY)",
        "FirebaseAppDelegateProxyEnabled": false
    ]
}


