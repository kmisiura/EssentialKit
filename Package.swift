// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EssentialKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EssentialKit",
            targets: ["EssentialKit"]),
    ],
    dependencies: [
        .package(url: "git@github.com:kmisiura/OSLogger.git", from: "1.0.0"),
        .package(url: "git@github.com:kmisiura/CoreNetwork.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "EssentialKit",
            dependencies: ["OSLogger", "CoreNetwork"]),
        .testTarget(
            name: "EssentialKitTests",
            dependencies: ["EssentialKit"]),
    ]
)
