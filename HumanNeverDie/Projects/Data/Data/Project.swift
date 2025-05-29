import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.Data.name,
    product: .staticFramework,
    dependencies: [
        .baseNetwork,
        .baseDomain
    ]
)

