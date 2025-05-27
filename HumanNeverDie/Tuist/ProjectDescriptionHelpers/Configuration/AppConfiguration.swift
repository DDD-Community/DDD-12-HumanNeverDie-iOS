import ProjectDescription

public enum AppConfiguration {
    public static let projectName: String = "HumanNeverDie"
    public static let bundleIdentifier: String = "com.humanNeverDie.ddd"
    public static let destination: Set<Destination> = [.iPhone]
    public static let deploymentTarget: DeploymentTargets = .iOS("18.0")
    public static let marketingVesion = "1.0.0"
    public static let projectBuildVersion: String = "1"
}
