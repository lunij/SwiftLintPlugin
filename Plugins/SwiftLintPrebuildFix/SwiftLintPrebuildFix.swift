
import PackagePlugin

@main
struct SwiftLintPrebuildFix: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        [
            .prebuildCommand(
                displayName: "Running `swiftlint --fix` for \(target.name)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "--fix",
                    "--cache-path",
                    context.pluginWorkDirectory.string,
                    target.directory.string
                ],
                outputFilesDirectory: context.pluginWorkDirectory
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintPrebuildFix: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        [
            .prebuildCommand(
                displayName: "Running `swiftlint --fix` for \(target.displayName)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "--fix",
                    "--cache-path",
                    context.pluginWorkDirectory.string,
                    context.xcodeProject.directory.string
                ],
                outputFilesDirectory: context.pluginWorkDirectory
            )
        ]
    }
}
#endif
