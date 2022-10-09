// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "EssentialGhibli",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(name: "GenericResourceView", targets: ["GenericResourceView"]),
        .library(name: "GhibliAPI", targets: ["GhibliAPI"]),
        .library(name: "GhibliDetailFeature", targets: ["GhibliDetailFeature"]),
        .library(name: "GhibliHTTPClient", targets: ["GhibliHTTPClient"]),
        .library(name: "GhibliListFeature", targets: ["GhibliListFeature"]),
        .library(name: "GhibliRowFeature", targets: ["GhibliRowFeature"]),
        .library(name: "Presentation", targets: ["Presentation"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: .init(1, 10, 0)
        ),
    ],
    targets: [
        .target(name: "GenericResourceView"),
        .testTarget(
            name: "GenericResourceViewTests",
            dependencies: [
                "GenericResourceView",
                "Presentation",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
        .target(name: "GhibliAPI"),
        .testTarget(
            name: "GhibliAPITests",
            dependencies: ["GhibliAPI"]
        ),
        .target(name: "GhibliDetailFeature"),
        .testTarget(
            name: "GhibliDetailFeatureTests",
            dependencies: [
                "GhibliDetailFeature",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
        .target(name: "GhibliHTTPClient"),
        .testTarget(
            name: "GhibliHTTPClientTests",
            dependencies: ["GhibliHTTPClient"]
        ),
        .target(name: "GhibliListFeature"),
        .testTarget(
            name: "GhibliListFeatureTests",
            dependencies: [
                "GhibliListFeature",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
        .target(name: "GhibliRowFeature"),
        .testTarget(
            name: "GhibliRowFeatureTests",
            dependencies: [
                "GhibliRowFeature",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
        .target(name: "Presentation"),
    ]
)
