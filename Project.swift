import ProjectDescription

let project = Project(
    name: "DripNote",
    packages: [
        .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "11.9.0")),
        .remote(url: "https://github.com/google/promises.git", requirement: .upToNextMajor(from: "2.3.1"))
    ],
        settings: .settings(
        base: [
            "OTHER_LDFLAGS": "$(inherited) -ObjC",
        ]
    ),
    targets: [
        .target(
            name: "DripNote",
            destinations: .iOS,
            product: .app,
            bundleId: "com.krwd.dripnote",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "CFBundleDisplayName": "드립노트"
                ]
            ),
            sources: ["DripNote/Sources/App/**"],
            resources: ["DripNote/Resources/**"],
            scripts: [
                .post(
                    script: """
                        #!/bin/bash
                        set -e

                        echo "🔍 Locating GoogleService-Info.plist..."
                        GOOGLE_SERVICE_PLIST="${PROJECT_DIR}/DripNote/Resources/GoogleService-Info.plist"
                        if [ ! -f "$GOOGLE_SERVICE_PLIST" ]; then
                            echo "❌ GoogleService-Info.plist not found at $GOOGLE_SERVICE_PLIST"
                            exit 1
                        fi

                        echo "🔄 Finding all dSYM files..."
                        DSYM_PATH="${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}"
                        if [ ! -d "$DSYM_PATH" ]; then
                            echo "⚠️ dSYM folder not found at $DSYM_PATH"
                            exit 0
                        fi

                        echo "🚀 Uploading dSYM file using Firebase Crashlytics script"
                        "${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run" -gsp "${GOOGLE_SERVICE_PLIST}" -p ios "${DSYM_PATH}"

                        echo "✅ dSYM upload complete!"
                    """,
                    name: "Upload dSYM to Crashlytics",
                    basedOnDependencyAnalysis: false
                ),
            ],
            dependencies: [
                .package(product: "FirebaseCore"),
                .package(product: "FirebaseAnalytics"),
                .package(product: "FirebaseCrashlytics"),
                .package(product: "FirebaseMessaging"), 
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
            deploymentTargets: .iOS("17.0"),
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
            deploymentTargets: .iOS("17.0"),
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
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["DripNote/Sources/Data/**"],
            resources: [],
            dependencies: [
                .target(name: "DripNoteDomain"),
                .package(product: "FirebaseFirestore")
            ]
        ),
        .target(
            name: "DripNotePresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.krwd.dripnote.presentation",
            deploymentTargets: .iOS("17.0"),
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
            deploymentTargets: .iOS("17.0"),
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
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["DripNote/Tests/**"],
            resources: [],
            dependencies: [.target(name: "DripNote")]
        )
    ]
)
