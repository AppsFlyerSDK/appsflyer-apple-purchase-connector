// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "PurchaseConnector",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PurchaseConnector",
            targets: ["PurchaseConnector"]),
        .library(
            name: "PurchaseConnector-Dynamic",
            targets: ["PurchaseConnector-Dynamic"])
    ],
    dependencies: [
        .package(url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework.git", from: "6.10.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .binaryTarget(
            name: "PurchaseConnector",
            path: "PurchaseConnector.xcframework"
        ),
        .binaryTarget(
            name: "PurchaseConnector-Dynamic",
            path: "Dynamic/PurchaseConnector.xcframework"
        )
    ]
)
