// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SnapkitImageURL",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "SnapkitImageURL",
            targets: ["SnapkitImageURL"]),
    ],
    targets: [
        .target(
            name: "SnapkitImageURL"),
        .testTarget(
            name: "SnapkitImageURLTests",
            dependencies: ["SnapkitImageURL"]),
    ]
)
