import ProjectDescription

public extension TargetDependency {
    enum SPM {}
}

public extension TargetDependency.SPM {
    static let dependencies = TargetDependency.external(name: "Dependencies", condition: .none)
    static let alamofire = TargetDependency.external(name: "Alamofire", condition: .none)
    static let nuke = TargetDependency.external(name: "NukeUI", condition: .none)
    static let lottie = TargetDependency.external(name: "Lottie", condition: .none)
    static let asyncAlgorithms = TargetDependency.external(name: "AsyncAlgorithms", condition: .none)
    static let auth0 = TargetDependency.external(name: "Auth0", condition: .none)
    static let amplitude = TargetDependency.external(name: "AmplitudeSwift", condition: .none)
    static let firebaseMessaging = TargetDependency.external(name: "FirebaseMessaging", condition: .none)
}

