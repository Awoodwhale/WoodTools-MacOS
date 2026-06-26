// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "WoodTools",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "WoodTools", targets: ["WoodTools"])
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.1.3")
    ],
    targets: [
        .executableTarget(
            name: "WoodTools",
            dependencies: ["Yams"],
            path: "Sources/WoodTools"
        )
    ]
)
