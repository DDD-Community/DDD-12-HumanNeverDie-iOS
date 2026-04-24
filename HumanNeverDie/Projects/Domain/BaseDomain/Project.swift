import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.BaseDomain.name,
    product: .staticFramework,
    dependencies: [
        .domain(module: .Auth),
        .domain(module: .Beverage),
        .domain(module: .User)
    ],
    hasTests: false
)
