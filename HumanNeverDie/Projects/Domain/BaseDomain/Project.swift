import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.BaseDomain.name,
    product: .framework,
    dependencies: [
        .domain(module: .Auth),
        .domain(module: .Beverage),
        .domain(module: .User)
    ],
    hasTests: false
)
