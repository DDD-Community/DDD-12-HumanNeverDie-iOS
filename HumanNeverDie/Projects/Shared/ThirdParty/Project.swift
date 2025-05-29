import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.ThirdParty.name,
    product: .framework,
    dependencies: [
        .SPM.swinject,
        .SPM.dependencies,
        .SPM.nuke
    ],
    hasTests: false
)
