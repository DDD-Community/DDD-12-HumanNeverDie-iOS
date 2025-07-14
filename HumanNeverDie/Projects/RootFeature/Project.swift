import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: Modules.RootFeature.name,
    product: .staticFramework,
    dependencies: [.data,
        .feature(module: .Splash),
        .feature(module: .Home),
        .feature(module: .History),
        .feature(module: .BeverageRecordList),
        .feature(module: .Onboarding)
    ]
)
