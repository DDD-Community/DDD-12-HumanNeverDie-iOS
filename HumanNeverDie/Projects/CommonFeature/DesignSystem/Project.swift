import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.DesignSystem.name,
    product: .framework,
    dependencies: [
    ],
    hasTests: false,
    hasResource: true
)
