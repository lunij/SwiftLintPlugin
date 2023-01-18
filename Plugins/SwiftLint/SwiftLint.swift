
import PackagePlugin

@main
struct SwiftLint: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        return [
            .buildCommand(
                displayName: "Running SwiftLint for \(target.name)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "lint",
                    "--cache-path",
                    context.pluginWorkDirectory.string,
                    target.directory.string
                ],
                environment: [:]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLint: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        return [
            .buildCommand(
                displayName: "Running SwiftLint for \(target.displayName)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "lint",
                    "--cache-path",
                    context.pluginWorkDirectory.string,
                    context.xcodeProject.directory.string
                ],
                environment: [:]
            )
        ]
    }
}
#endif
