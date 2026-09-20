// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Patchwork",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "Patchwork", targets: ["Patchwork"])
    ],
    dependencies: [
        .package(url: "https://github.com/SoundBlaster/ScreenKit.git", exact: "0.2.0")
    ],
    targets: [
        .target(name: "Patchwork", dependencies: ["ScreenKit"]),
        .testTarget(name: "PatchworkTests", dependencies: ["Patchwork", "ScreenKit"])
    ]
)
