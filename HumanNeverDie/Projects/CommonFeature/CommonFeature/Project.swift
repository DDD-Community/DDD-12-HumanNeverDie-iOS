import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.CommonFeature.name,
    product: .framework,
    dependencies: [
        .designSystem,
        .baseDomain
    ],
    hasTests: false
)
