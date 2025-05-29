import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
    name: Modules.Feature.Main.rawValue,
    dependencies: [
        .commonFeature
    ]
)

