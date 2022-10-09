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
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "FeedLoader", targets: ["FeedLoader"]),
        .library(name: "GenericResourceView", targets: ["GenericResourceView"]),
        .library(name: "GhibliAPI", targets: ["GhibliAPI"]),
        .library(name: "GhibliDetailFeature", targets: ["GhibliDetailFeature"]),
        .library(name: "GhibliListFeature", targets: ["GhibliListFeature"]),
        .library(name: "GhibliRowFeature", targets: ["GhibliRowFeature"]),
        .library(name: "Presentation", targets: ["Presentation"]),
        .library(name: "SharedAPI", targets: ["SharedAPI"]),
        .library(name: "SharedAPIInfra", targets: ["SharedAPIInfra"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: .init(1, 10, 0)
        ),
    ],
    targets: [
        .target(name: "Domain"),
        .target(name: "FeedLoader"),
        .testTarget(
            name: "FeedLoaderTests",
            dependencies: ["FeedLoader"]
        ),
        .target(
            name: "GenericResourceView",
            dependencies: ["Presentation"]
        ),
        .testTarget(
            name: "GenericResourceViewTests",
            dependencies: [
                "GenericResourceView",
                "Presentation",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
        .target(
            name: "GhibliAPI",
            dependencies: ["Domain"]
        ),
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
        .target(name: "SharedAPI"),
        .target(
            name: "SharedAPIInfra",
            dependencies: ["SharedAPI"]
        ),
        .testTarget(
            name: "SharedAPIInfraTests",
            dependencies: ["SharedAPIInfra"]
        ),
    ]
)
