
import Foundation
import PackagePlugin

@main
struct SwiftLintFix: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {
        let tool = try context.tool(named: "swiftlint")
        let toolURL = URL(fileURLWithPath: tool.path.string)

        for target in context.package.targets {
            guard let target = target as? SourceModuleTarget else { continue }

            let swiftFilePaths = target.sourceFiles(withSuffix: "swift").map(\.path)
            if swiftFilePaths.isEmpty { continue }

            let arguments = [
                target.directory.string,
                "--fix",
                "--cache-path",
                context.pluginWorkDirectory.string
            ]

            let process = Process()
            process.executableURL = toolURL
            process.arguments = arguments

            try process.run()
            process.waitUntilExit()

            guard process.terminationReason == .exit && process.terminationStatus == 0 else {
                Diagnostics.error("SwiftLint failed fixing \(target.directory)")
                return
            }
        }
    }
}
