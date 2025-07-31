import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.LocalDataBase.name,
    product: .staticFramework,
    dependencies: [
        .shared
    ]
)