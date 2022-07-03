// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Artisan",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Artisan",
            targets: ["Artisan"]
        )
    ],
    dependencies: [
        // uncomment this two line to test
//        .package(url: "https://github.com/Quick/Quick.git", from: "5.0.1"),
//        .package(url: "https://github.com/Quick/Nimble.git", from: "10.0.0"),
        .package(url: "https://github.com/hainayanda/Draftsman.git", from: "3.0.6"),
        .package(url: "https://github.com/hainayanda/Pharos.git", from: "2.3.5"),
        .package(url: "https://github.com/ra1028/DiffableDataSources.git", from: "0.5.0")
    ],
    targets: [
        .target(
            name: "Artisan",
            dependencies: ["Draftsman", "Pharos", "DiffableDataSources"],
            path: "Artisan/Classes"
        ),
        // uncomment this two line to test
//        .testTarget(
//            name: "ArtisanTests",
//            dependencies: [
//                "Artisan", "Quick", "Nimble"
//            ],
//            path: "Example/Tests",
//            exclude: ["Info.plist"]
//        )
    ]
)
