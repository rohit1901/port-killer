// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PortKiller",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "port-killer", targets: ["CLI"]),
        .executable(name: "PortKillerApp", targets: ["App"]),
        .library(name: "Core", targets: ["Core"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: []
        ),
        .executableTarget(
            name: "CLI",
            dependencies: [
                "Core",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .executableTarget(
            name: "App",
            dependencies: ["Core"],
            linkerSettings: [
                .unsafeFlags(["-Xlinker", "-sectcreate", "-Xlinker", "__TEXT", "-Xlinker", "__info_plist", "-Xlinker", "Sources/App/Info.plist"])
            ]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]
        ),
    ]
)
