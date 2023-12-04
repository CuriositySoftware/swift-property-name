// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "swift-property-name",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "PropertyName",
            targets: ["PropertyName"]
        ),
        .executable(
            name: "PropertyNameMacroClient",
            targets: ["PropertyNameMacroClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", .upToNextMajor(from: "509.0.2")),
    ],
    targets: [
        .macro(
            name: "Implementation",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "PropertyName",
            dependencies: ["Implementation"]
        ),
        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(
            name: "PropertyNameMacroClient",
            dependencies: [
                "PropertyName",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "ImplementationMacroTests",
            dependencies: [
                "Implementation",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
