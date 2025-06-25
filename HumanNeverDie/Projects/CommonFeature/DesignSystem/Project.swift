import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.DesignSystem.name,
    product: .framework,
    dependencies: [
        .SPM.nuke
    ],
    hasTests: false,
    hasResource: true,
    hasDemo: true
)
