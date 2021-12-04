// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "GKStorageKit",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_11)
    ],
    products: [
        .library(
            name: "GKStorageKit",
            targets: ["GKStorageKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/gligorkot/GKBaseKit.git", from: Version("2.0.0")),
        .package(url: "https://github.com/square/Valet.git", from: Version("4.1.2")),
        .package(url: "https://github.com/mattgallagher/CwlPreconditionTesting.git", from: Version("2.0.0"))
    ],
    targets: [
        .target(
            name: "GKStorageKit",
            dependencies: [
                "GKBaseKit",
                "Valet"
            ]),
        .testTarget(
            name: "GKStorageKitTests",
            dependencies: [
                "GKStorageKit",
                "CwlPreconditionTesting"
            ]),
    ],
    swiftLanguageVersions: [.v4]
)
