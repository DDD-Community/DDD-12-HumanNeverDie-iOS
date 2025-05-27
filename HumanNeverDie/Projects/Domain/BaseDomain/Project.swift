import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.BaseDomain.name,
    product: .framework,
    dependencies: [
        .domain(module: .Main)
    ],
    hasTests: false
)
