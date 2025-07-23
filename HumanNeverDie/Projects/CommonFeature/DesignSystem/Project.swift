import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.DesignSystem.name,
    product: .framework,
    dependencies: [
        .SPM.nuke,
        .SPM.lottie
    ],
    hasTests: false,
    hasResource: true,
    hasDemo: true
)
