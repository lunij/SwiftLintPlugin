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
            url: "https://github.com/realm/SwiftLint/releases/download/0.54.0/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "963121d6babf2bf5fd66a21ac9297e86d855cbc9d28322790646b88dceca00f1"
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
