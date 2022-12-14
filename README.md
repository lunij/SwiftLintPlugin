# SwiftLintPlugin

A Swift Package Plugin for [SwiftLint](https://github.com/realm/SwiftLint/).

It can run SwiftLint as a pre-build command and show errors and warnings in Xcode.

It can make use of `swiftlint --fix` either manually by using the package menu item in Xcode 14+ or automatically by using the pre-build command plugin.

This SwiftLint plugin uses the official SwiftLint binary.
It does not fetch any source dependencies as it does with the official SwiftLint plugin.

## Usage

```swift
.package(url: "https://github.com/lunij/SwiftLintPlugin", from: "x.y.z")
```

```swift
.target(
    name: "...",
    plugins: [
        .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
        // and/or
        .plugin(name: "SwiftLintPrebuildFix", package: "SwiftLintPlugin")
    ]
)
```
