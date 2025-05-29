import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.RootFeature.name,
    product: .staticFramework,
    dependencies: [
        .data,
        .feature(module: .Main),
        .feature(module: .Splash)
    ]
)
