import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Shared.name,
    product: .staticFramework,
    dependencies: [
        .SPM.amplitude,
        .thirdParty
    ],
    hasTests: false
)

