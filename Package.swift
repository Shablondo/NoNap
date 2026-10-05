// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "NoNap",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "NoNapCore", targets: ["NoNapCore"]),
        .executable(name: "NoNap", targets: ["NoNap"])
    ],
    targets: [
        .target(name: "NoNapCore"),
        .executableTarget(name: "NoNap", dependencies: ["NoNapCore"]),
        .testTarget(name: "NoNapCoreTests", dependencies: ["NoNapCore"])
    ]
)
