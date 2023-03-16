// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PurchaseConnector",
    platforms: [.iOS(.v9)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "PurchaseConnector", targets: ["PurchaseConnector"]),
        
    ],
    dependencies: [
        .package(url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework.git", from: "6.8.0"),
    ],
    targets: [
        .binaryTarget(name: "PurchaseConnector", path: "PurchaseConnector.xcframework"),
//        .binaryTarget(name: "PurchaseConnector-Dynamic", path: "Dynamic/PurchaseConnector.xcframework"),
    ]
)
