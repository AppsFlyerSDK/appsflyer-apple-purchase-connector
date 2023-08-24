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
            targets: ["PurchaseConnector"])
    ],
    dependencies: [
        .package(url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework.git", exact: "6.12.2")
    ],
    targets: [
        .binaryTarget(
            name: "PurchaseConnector",
            path: "PurchaseConnector.xcframework"
        )
    ]
)
