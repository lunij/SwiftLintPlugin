// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "SwiftLintPlugin",
    platforms: [
        .iOS(.v13),
        .watchOS(.v6),
        .macOS(.v10_15),
        .tvOS(.v13)
    ],
    products: [
        .plugin(name: "SwiftLint", targets: ["SwiftLint"]),
        .plugin(name: "SwiftLintPrebuildFix", targets: ["SwiftLintPrebuildFix"]),
        .plugin(name: "SwiftLintCommand", targets: ["SwiftLintCommand"])
    ],
    targets: [
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.50.3/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "abe7c0bb505d26c232b565c3b1b4a01a8d1a38d86846e788c4d02f0b1042a904"
        ),
        .plugin(
            name: "SwiftLint",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]
        ),
        .plugin(
            name: "SwiftLintPrebuildFix",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]
        ),
        .plugin(
            name: "SwiftLintCommand",
            capability: .command(
                intent: .custom(verb: "swiftlint", description: "Runs SwiftLint"),
                permissions: [
                    .writeToPackageDirectory(reason: "SwiftLint might try to clean up lints")
                ]
            ),
            dependencies: ["SwiftLintBinary"]
        )
    ]
)
