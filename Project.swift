import ProjectDescription

let project = Project(
    name: "DripNote",
    packages: [
        .remote(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", requirement: .upToNextMajor(from: "12.2.0")),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "11.9.0")),
        .remote(url: "https://github.com/google/promises.git", requirement: .upToNextMajor(from: "2.3.1")),
        .remote(url: "https://github.com/youtube/youtube-ios-player-helper.git", requirement: .upToNextMajor(from: "1.0.4")),
        .remote(url: "https://github.com/supabase-community/supabase-swift.git", requirement: .upToNextMajor(from: "0.2.0")),
    ],
        settings: .settings(
        base: [
            "OTHER_LDFLAGS": "$(inherited) -ObjC",
        ]
    ),
    targets: [
        .target(
            name: "DripNote",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.krwd.dripnote",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen",
                    "ITSAppUsesNonExemptEncryption": false,
                    "UIUserInterfaceStyle": "Light",
                    "GADApplicationIdentifier": "ca-app-pub-2148938110853335~1511824962",
                    "NSUserTrackingUsageDescription": "This app uses your data for personalized advertising and to improve the user experience.",
                    "SKAdNetworkItems": [
                        ["SKAdNetworkIdentifier": "cstr6suwn9.skadnetwork"],
                        ["SKAdNetworkIdentifier": "4fzdc2evr5.skadnetwork"],
                        ["SKAdNetworkIdentifier": "2fnua5tdw4.skadnetwork"],
                        ["SKAdNetworkIdentifier": "ydx93a7ass.skadnetwork"],
                        ["SKAdNetworkIdentifier": "p78axxw29g.skadnetwork"],
                        ["SKAdNetworkIdentifier": "v72qych5uu.skadnetwork"],
                        ["SKAdNetworkIdentifier": "ludvb6z3bs.skadnetwork"],
                        ["SKAdNetworkIdentifier": "cp8zw746q7.skadnetwork"],
                        ["SKAdNetworkIdentifier": "3sh42y64q3.skadnetwork"],
                        ["SKAdNetworkIdentifier": "c6k4g5qg8m.skadnetwork"],
                        ["SKAdNetworkIdentifier": "s39g8k73mm.skadnetwork"],
                        ["SKAdNetworkIdentifier": "3qy4746246.skadnetwork"],
                        ["SKAdNetworkIdentifier": "f38h382jlk.skadnetwork"],
                        ["SKAdNetworkIdentifier": "hs6bdukanm.skadnetwork"],
                        ["SKAdNetworkIdentifier": "mlmmfzh3r3.skadnetwork"],
                        ["SKAdNetworkIdentifier": "v4nxqhlyqp.skadnetwork"],
                        ["SKAdNetworkIdentifier": "wzmmz9fp6w.skadnetwork"],
                        ["SKAdNetworkIdentifier": "su67r6k2v3.skadnetwork"],
                        ["SKAdNetworkIdentifier": "yclnxrl5pm.skadnetwork"],
                        ["SKAdNetworkIdentifier": "t38b2kh725.skadnetwork"],
                        ["SKAdNetworkIdentifier": "7ug5zh24hu.skadnetwork"],
                        ["SKAdNetworkIdentifier": "gta9lk7p23.skadnetwork"],
                        ["SKAdNetworkIdentifier": "vutu7akeur.skadnetwork"],
                        ["SKAdNetworkIdentifier": "y5ghdn5j9k.skadnetwork"],
                        ["SKAdNetworkIdentifier": "v9wttpbfk9.skadnetwork"],
                        ["SKAdNetworkIdentifier": "n38lu8286q.skadnetwork"],
                        ["SKAdNetworkIdentifier": "47vhws6wlr.skadnetwork"],
                        ["SKAdNetworkIdentifier": "kbd757ywx3.skadnetwork"],
                        ["SKAdNetworkIdentifier": "9t245vhmpl.skadnetwork"],
                        ["SKAdNetworkIdentifier": "a2p9lx4jpn.skadnetwork"],
                        ["SKAdNetworkIdentifier": "22mmun2rn5.skadnetwork"],
                        ["SKAdNetworkIdentifier": "44jx6755aq.skadnetwork"],
                        ["SKAdNetworkIdentifier": "k674qkevps.skadnetwork"],
                        ["SKAdNetworkIdentifier": "4468km3ulz.skadnetwork"],
                        ["SKAdNetworkIdentifier": "2u9pt9hc89.skadnetwork"],
                        ["SKAdNetworkIdentifier": "8s468mfl3y.skadnetwork"],
                        ["SKAdNetworkIdentifier": "klf5c3l5u5.skadnetwork"],
                        ["SKAdNetworkIdentifier": "ppxm28t8ap.skadnetwork"],
                        ["SKAdNetworkIdentifier": "kbmxgpxpgc.skadnetwork"],
                        ["SKAdNetworkIdentifier": "uw77j35x4d.skadnetwork"],
                        ["SKAdNetworkIdentifier": "578prtvx9j.skadnetwork"],
                        ["SKAdNetworkIdentifier": "4dzt52r2t5.skadnetwork"],
                        ["SKAdNetworkIdentifier": "tl55sbb4fm.skadnetwork"],
                        ["SKAdNetworkIdentifier": "c3frkrj4fj.skadnetwork"],
                        ["SKAdNetworkIdentifier": "e5fvkxwrpn.skadnetwork"],
                        ["SKAdNetworkIdentifier": "8c4e2ghe7u.skadnetwork"],
                        ["SKAdNetworkIdentifier": "3rd42ekr43.skadnetwork"],
                        ["SKAdNetworkIdentifier": "97r2b46745.skadnetwork"],
                        ["SKAdNetworkIdentifier": "3qcr597p9d.skadnetwork"]
                    ]
                ]
            ),
            sources: ["DripNote/Sources/App/**"],
            resources: ["DripNote/Resources/**"],
            scripts: [
                .post(
                    script: """
                        #!/bin/bash
                        set -e

                        # Debug 빌드인 경우 dSYM 업로드를 건너뛰기
                        if [ "$CONFIGURATION" = "Debug" ]; then
                            echo "⚠️ Skipping Crashlytics dSYM upload in Debug configuration."
                            exit 0
                        fi

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
                .target(name: "DripNoteCore"),
                .target(name: "DripNoteDomain"),
                .target(name: "DripNoteData"),
                .target(name: "DripNotePresentation"),
                .package(product: "FirebaseCore")
            ]
        ),
        .target(
            name: "DripNoteCore",
            destinations: [.iPhone],
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
            destinations: [.iPhone],
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
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.krwd.dripnote.data",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["DripNote/Sources/Data/**"],
            resources: [],
            dependencies: [
                .target(name: "DripNoteDomain"),
                .package(product: "FirebaseFirestore"),
                .package(product: "Supabase")
            ]
        ),
        .target(
            name: "DripNotePresentation",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.krwd.dripnote.presentation",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["DripNote/Sources/Presentation/**"],
            resources: [],
            dependencies: [
                .target(name: "DripNoteDomain"),
                .target(name: "DripNoteDI"),
                .target(name: "DripNoteThirdParty")
            ],
            settings: .settings(
                configurations: [
                    .debug(name: "Debug", settings: [
                        "SWIFT_OPTIMIZATION_LEVEL": "-Onone"
                    ]),
                    .release(name: "Release", settings: [
                        "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule"
                    ])
                ]
            )
        ),
        .target(
            name: "DripNoteDI",
            destinations: [.iPhone],
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
            name: "DripNoteThirdParty",
            destinations: [.iPhone],
            product: .framework,
            bundleId: "com.krwd.dripnote.thirdparty",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: ["DripNote/Sources/ThirdParty/**"],
            resources: [],
            dependencies: [
                .package(product: "YouTubeiOSPlayerHelper"),
                .package(product: "FirebaseAnalytics"),
                .package(product: "FirebaseCrashlytics"),
                .package(product: "FirebaseMessaging"), 
            ]
        ),
        .target(
            name: "DripNoteTests",
            destinations: [.iPhone],
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
