
import PackagePlugin

@main
struct SwiftLint: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let parameters = Environment.isCachingDisabled ? ["--no-cache"] : ["--cache-path", context.pluginWorkDirectory.string]
        return [
            .buildCommand(
                displayName: "Running SwiftLint for \(target.name)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "lint",
                    target.directory.string
                ] + parameters,
                environment: [:]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLint: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let parameters = Environment.isCachingDisabled ? ["--no-cache"] : ["--cache-path", context.pluginWorkDirectory.string]
        return [
            .buildCommand(
                displayName: "Running SwiftLint for \(target.displayName)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [
                    "lint",
                    context.xcodeProject.directory.string
                ] + parameters,
                environment: [:]
            )
        ]
    }
}
#endif

import Foundation

enum Environment {
    static var isCachingDisabled: Bool {
        if let _ = ProcessInfo.processInfo.environment["SWIFTLINT_NO_CACHE"] {
            return true
        }
        return false
    }
}
