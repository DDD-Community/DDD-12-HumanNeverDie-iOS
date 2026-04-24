import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.ThirdParty.name,
    product: .framework,
    dependencies: [
        .SPM.dependencies,
        .SPM.dependenciesMacros,
        .SPM.asyncAlgorithms
    ],
    hasTests: false
)
