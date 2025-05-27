import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDomain(
    name: Modules.Domain.Main.rawValue,
    dependencies: [
        .shared
    ]
)

