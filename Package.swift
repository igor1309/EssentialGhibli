// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "EssentialGhibli",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(name: "EssentialGhibli", targets: ["EssentialGhibli"]),
    ],
    targets: [
        .target(name: "EssentialGhibli"),
        .testTarget(
            name: "EssentialGhibliTests",
            dependencies: ["EssentialGhibli"]
        ),
    ]
)
