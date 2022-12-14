
import PackagePlugin

@main
struct SwiftLintPrebuildFix: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        return [
            .prebuildCommand(
                displayName: "Running `swiftlint --fix` for \(target.name)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "--fix",
                    "--config",
                    "\(context.package.directory.string)/.swiftlint.yml",
                    "--cache-path",
                    "\(context.pluginWorkDirectory.string)/cache",
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
        return [
            .prebuildCommand(
                displayName: "Running `swiftlint --fix` for \(target.displayName)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "--fix",
                    "--config",
                    "\(context.xcodeProject.directory.string)/.swiftlint.yml",
                    "--cache-path",
                    "\(context.pluginWorkDirectory.string)/cache",
                    context.xcodeProject.directory.string
                ],
                outputFilesDirectory: context.pluginWorkDirectory
            )
        ]
    }
}
#endif
