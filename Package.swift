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
        .library(name: "DetailFeature", targets: ["DetailFeature"]),
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "GenericResourceView", targets: ["GenericResourceView"]),
        .library(name: "ListFeature", targets: ["ListFeature"]),
        .library(name: "Presentation", targets: ["Presentation"]),
        .library(name: "RowFeature", targets: ["RowFeature"]),
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
        .testTarget(
            name: "CacheIntegrationTests",
            dependencies: [
                "Cache",
                "CacheInfra",
                "Domain"
            ]
        ),
        .target(name: "DetailFeature"),
        .testTarget(
            name: "DetailFeatureTests",
            dependencies: [
                "DetailFeature",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
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
        .target(name: "ListFeature"),
        .testTarget(
            name: "ListFeatureTests",
            dependencies: [
                "ListFeature",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
        .target(name: "Presentation"),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"]
        ),
        .target(name: "RowFeature"),
        .testTarget(
            name: "RowFeatureTests",
            dependencies: [
                "RowFeature",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
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
