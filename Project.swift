import ProjectDescription

let project = Project(
    name: "DripNote",
    targets: [
        .target(
            name: "DripNote",
            destinations: .iOS,
            product: .app,
            bundleId: "com.krwd.dripnote",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["DripNote/Sources/App/**"],
            resources: ["DripNote/Resources/**"],
            dependencies: [
                .target(name: "DripNoteCore"),
                .target(name: "DripNoteDomain"),
                .target(name: "DripNoteData"),
                .target(name: "DripNotePresentation")
            ]
        ),
        .target(
            name: "DripNoteCore",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.krwd.dripnote.core",
            infoPlist: .default,
            sources: ["DripNote/Sources/Core/**"],
            resources: [],
            dependencies: []
        ),
        .target(
            name: "DripNoteDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.krwd.dripnote.domain",
            infoPlist: .default,
            sources: ["DripNote/Sources/Domain/**"],
            resources: [],
            dependencies: [
                .target(name: "DripNoteCore")
            ]
        ),
        .target(
            name: "DripNoteData",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.krwd.dripnote.data",
            infoPlist: .default,
            sources: ["DripNote/Sources/Data/**"],
            resources: [],
            dependencies: [
                .target(name: "DripNoteDomain")
            ]
        ),
        .target(
            name: "DripNotePresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.krwd.dripnote.presentation",
            infoPlist: .default,
            sources: ["DripNote/Sources/Presentation/**"],
            resources: [],
            dependencies: [
                .target(name: "DripNoteDomain"),
                .target(name: "DripNoteDI")
            ]
        ),
        .target(
            name: "DripNoteDI",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.krwd.dripnote.di",
            infoPlist: .default,
            sources: ["DripNote/Sources/DI/**"],
            resources: [],
            dependencies: [
                .target(name: "DripNoteDomain"),
                .target(name: "DripNoteData"),
            ]
        ),
        .target(
            name: "DripNoteTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.krwd.dripnote.tests",
            infoPlist: .default,
            sources: ["DripNote/Tests/**"],
            resources: [],
            dependencies: [.target(name: "DripNote")]
        )
    ]
)
