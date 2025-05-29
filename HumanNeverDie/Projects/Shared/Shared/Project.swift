import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Shared.name,
    product: .framework,
    dependencies: [
        .thirdParty
    ],
    hasTests: false
)

