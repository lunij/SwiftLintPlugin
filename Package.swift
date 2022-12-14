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
        .plugin(name: "SwiftLintFix", targets: ["SwiftLintFix"]),
        .plugin(name: "SwiftLintCommand", targets: ["SwiftLintCommand"])
    ],
    targets: [
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.50.1/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "487c57b5a39b80d64a20a2d052312c3f5ff1a4ea28e3cf5556e43c5b9a184c0c"
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
            name: "SwiftLintFix",
            capability: .command(
                intent: .sourceCodeFormatting(),
                permissions: [
                    .writeToPackageDirectory(reason: "SwiftLint tries to clean up lints")
                ]
            ),
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
