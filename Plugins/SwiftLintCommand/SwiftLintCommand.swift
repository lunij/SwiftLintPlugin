
import Foundation
import PackagePlugin

@main
struct SwiftLintCommand: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {
        let tool = try context.tool(named: "swiftlint")
        let toolURL = URL(fileURLWithPath: tool.path.string)

        let (arguments, excludedTargets) = arguments.extractExcludedTargets()
        let targets = context.package.targets.filter { !excludedTargets.contains($0.name) }

        for target in targets {
            guard let target = target as? SourceModuleTarget else { continue }

            let swiftFilePaths = target.sourceFiles(withSuffix: "swift").map(\.path)
            if swiftFilePaths.isEmpty { continue }

            let arguments = arguments + [
                target.directory.string,
                "--cache-path",
                context.pluginWorkDirectory.string
            ]

            let process = Process()
            process.executableURL = toolURL
            process.arguments = arguments

            try process.run()
            process.waitUntilExit()

            guard process.terminationReason == .exit && process.terminationStatus == 0 else {
                Diagnostics.error("SwiftLint failed linting \(target.directory)")
                return
            }
        }
    }
}

private extension [String] {
    func extractExcludedTargets() -> ([String], [String]) {
        guard let index = firstIndex(where: { $0 == "--exclude-targets" }) else {
            return (self, [])
        }
        let indexAfter = index.advanced(by: 1)
        let excludedTargets = self[indexAfter]
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespaces) }
        let filteredElements = enumerated()
            .filter { ![index, indexAfter].contains($0.offset) }
            .map(\.element)
        return (filteredElements, excludedTargets)
    }
}
