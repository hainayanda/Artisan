// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Artisan",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "Artisan",
            targets: ["Artisan"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "5.0.1"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "10.0.0"),
        .package(url: "https://github.com/hainayanda/Draftsman.git", from: "3.0.3"),
        .package(url: "https://github.com/hainayanda/Pharos.git", from: "2.3.1"),
        .package(url: "https://github.com/hainayanda/Builder.git", from: "1.0.3"),
        .package(url: "https://github.com/ra1028/DiffableDataSources.git", from: "0.5.0")
    ],
    targets: [
        .target(
            name: "Artisan",
            dependencies: ["Draftsman", "Pharos", "Builder"],
            path: "Artisan/Classes"
        ),
        .testTarget(
            name: "ArtisanTests",
            dependencies: [
                "Artisan", "Quick", "Nimble"
            ],
            path: "Example/Tests",
            exclude: ["Info.plist"]
        )
    ]
)
