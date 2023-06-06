// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "PurchaseConnector",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "PurchaseConnector",
            targets: ["PurchaseConnector"]),
        .library(
            name: "PurchaseConnector-Dynamic",
            targets: ["PurchaseConnector-Dynamic"])
    ],
    dependencies: [
        .package(url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework.git", exact: "6.10.1")
    ],
    targets: [
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
