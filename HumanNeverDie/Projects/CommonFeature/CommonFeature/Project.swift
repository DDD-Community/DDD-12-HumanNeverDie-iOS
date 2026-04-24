import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.CommonFeature.name,
    product: .staticFramework,
    dependencies: [
        .designSystem,
        .baseDomain
    ],
    hasTests: false
)
