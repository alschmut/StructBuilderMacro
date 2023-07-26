// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "StructBuilder",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(name: "StructBuilder", targets: ["StructBuilder"]),
        .executable(name: "StructBuilderClient", targets: ["StructBuilderClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-07-10-a"),
    ],
    targets: [
        .macro(
            name: "StructBuilderMacro",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "StructBuilder", dependencies: ["StructBuilderMacro"]),
        .executableTarget(name: "StructBuilderClient", dependencies: ["StructBuilder"]),
        .testTarget(
            name: "StructBuilderMacroTests",
            dependencies: [
                "StructBuilderMacro",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
