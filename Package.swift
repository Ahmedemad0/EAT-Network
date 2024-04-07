// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EAT_Network",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "EAT_Network",
            targets: ["EAT_Network"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "EAT_Network"),
        .testTarget(
            name: "EAT_NetworkTests",
            dependencies: ["EAT_Network"]),
    ]
)
