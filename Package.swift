// swift-tools-version:5.1
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
        .package(url: "https://github.com/Quick/Quick.git", from: "3.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.0.0"),
        .package(url: "https://github.com/nayanda1/Draftsman.git", from: "1.0.4"),
        .package(url: "https://github.com/nayanda1/Pharos.git", from: "1.1.5")
    ],
    targets: [
        .target(
            name: "Artisan",
            dependencies: ["Draftsman", "Pharos"],
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
