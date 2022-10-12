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
        .library(name: "API", targets: ["API"]),
        .library(name: "Cache", targets: ["Cache"]),
        .library(name: "CacheInfra", targets: ["CacheInfra"]),
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "GenericResourceView", targets: ["GenericResourceView"]),
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
        .target(
            name: "API",
            dependencies: ["Domain"]
        ),
        .testTarget(
            name: "APITests",
            dependencies: ["API"]
        ),
        .target(
            name: "Cache",
            dependencies: ["Domain"]
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
        .target(name: "Domain"),
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
        .target(name: "GhibliDetailFeature"),
        .testTarget(
            name: "GhibliDetailFeatureTests",
            dependencies: [
                "GhibliDetailFeature",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
        .testTarget(
            name: "CacheIntegrationTests",
            dependencies: [
                "Cache",
                "CacheInfra",
                "Domain"
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
