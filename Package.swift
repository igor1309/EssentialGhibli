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
        .library(name: "GhibliAPI", targets: ["GhibliAPI"]),
        .library(name: "EssentialGhibliHTTPClient", targets: ["EssentialGhibliHTTPClient"]),
        .library(name: "EssentialGhibliList", targets: ["EssentialGhibliList"]),
        .library(name: "EssentialGhibliListRow", targets: ["EssentialGhibliListRow"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: .init(1, 10, 0)
        ),
    ],
    targets: [
        .target(name: "GhibliAPI"),
        .testTarget(
            name: "GhibliAPITests",
            dependencies: ["GhibliAPI"]
        ),
        .target(name: "EssentialGhibliHTTPClient"),
        .testTarget(
            name: "EssentialGhibliHTTPClientTests",
            dependencies: ["EssentialGhibliHTTPClient"]
        ),
        .target(name: "EssentialGhibliList"),
        .testTarget(
            name: "EssentialGhibliListTests",
            dependencies: [
                "EssentialGhibliList",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
        .target(name: "EssentialGhibliListRow"),
        .testTarget(
            name: "EssentialGhibliListRowTests",
            dependencies: [
                "EssentialGhibliListRow",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        ),
    ]
)
