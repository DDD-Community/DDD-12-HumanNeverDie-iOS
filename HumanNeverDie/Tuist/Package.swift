// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    productTypes: [
        "Swinject": .framework,
        "Dependencies": .framework,
        "Nuke": .framework,
        "Alamofire": .framework
    ]
)
#endif

let package = Package(
    name: "HumanNeverDie",
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject", branch: "master"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2"),
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.10.2"),
        .package(url: "https://github.com/kean/Nuke", branch: "main")
    ]
)
