// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "PurchaseConnector",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "PurchaseConnector",
            targets: ["PurchaseConnector"])
    ],
    dependencies: [
        .package(url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework-Static.git", exact: "6.17.1")
    ],
    targets: [
        .binaryTarget(
            name: "PurchaseConnector",
            path: "PurchaseConnector.xcframework"
        )
    ]
)
