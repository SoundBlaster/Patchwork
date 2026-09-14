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
        // Keep the first standalone snapshot reproducible. Replace this revision
        // with a version requirement after the package is tagged upstream.
        .package(
            url: "https://github.com/SoundBlaster/ScreenKit.git",
            revision: "44395605bed56cac78784583454d086a6227d16e"
        )
    ],
    targets: [
        .target(name: "Patchwork", dependencies: ["ScreenKit"]),
        .testTarget(name: "PatchworkTests", dependencies: ["Patchwork", "ScreenKit"])
    ]
)
