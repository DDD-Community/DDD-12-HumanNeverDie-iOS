// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    productTypes: [
        "Dependencies": .framework,
        "Nuke": .framework,
        "Alamofire": .framework,
        "Lottie": .framework,
        "AsyncAlgorithms": .framework,
        "Auth0": .framework,
        "AmplitudeSwift": .framework
    ]
)
#endif

let package = Package(
    name: "HumanNeverDie",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2"),
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.10.2"),
        .package(url: "https://github.com/kean/Nuke", branch: "main"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.2"),
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/auth0/Auth0.swift", from: "2.14.0"),
        .package(url: "https://github.com/amplitude/Amplitude-Swift", from: "1.15.0")
    ]
)
