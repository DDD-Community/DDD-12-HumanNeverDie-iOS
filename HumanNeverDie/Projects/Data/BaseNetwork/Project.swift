import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.BaseNetwork.name,
    product: .staticFramework,
    dependencies: [
        .SPM.alamofire,
        .SPM.auth0,
        .shared
    ]
)
