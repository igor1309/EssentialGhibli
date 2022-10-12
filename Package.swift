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
        .library(name: "Cache", targets: ["Cache"]),
        .library(name: "CacheInfra", targets: ["CacheInfra"]),
        .library(name: "GhibliDetailFeature", targets: ["GhibliDetailFeature"]),
        .library(name: "GhibliDomain", targets: ["GhibliDomain"]),
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
            dependencies: ["GhibliDomain"]
        ),
        .testTarget(
            name: "GhibliAPITests",
            dependencies: ["GhibliAPI"]
        ),
        .target(
            name: "Cache",
            dependencies: ["GhibliDomain"]
        ),
        .testTarget(
            name: "CacheTests",
            dependencies: ["Cache"]
        ),
        .target(
            name: "CacheInfra",
            dependencies: ["Cache"]
        ),
        .testTarget(
            name: "CacheInfraTests",
            dependencies: [
                "Cache",
                "CacheInfra"
            ]
        ),
        .target(name: "GhibliDetailFeature"),
        .testTarget(
            name: "GhibliDetailFeatureTests",
            dependencies: [
                "GhibliDetailFeature",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
        .target(name: "GhibliDomain"),
        .testTarget(
            name: "GhibliCacheIntegrationTests",
            dependencies: [
                "Cache",
                "CacheInfra",
                "GhibliDomain"
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
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"]
        ),
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
