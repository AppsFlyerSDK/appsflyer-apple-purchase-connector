<img src="https://massets.appsflyer.com/wp-content/uploads/2018/06/20092440/static-ziv_1TP.png"  width="400" > 

# iOS Purchase Connector

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/AppsFlyerSDK/android-purchase-connector/blob/main/LICENSE)

🛠 In order for us to provide optimal support, we would kindly ask you to submit any issues to
support@appsflyer.com

> *When submitting an issue please specify your AppsFlyer sign-up (account) email , your app ID , production steps, logs, code snippets and any additional relevant information.

## Table Of Content
  * [This Module is Built for](#plugin-build-for)
  * [Adding The Connector To Your Project](#install-connector)
    + [Cocoapods](#cocoapods)
    + [Carthage](#carthage)
    + [SPM](#spm)
  * [StoreKit 2 Overview](#storekit2-overview)
    + [New Purchase Connector Capabilities](#pc-capabilities)
  * [Basic Integration Of The Connector](#basic-integration)
    + [Set up Purchase Connector](#create-instance)
    + [Log Auto-Renewable Subscriptions and In-App Purchases](#log-subscriptions)
    + [Conform to Purchase Connector Data Source and Delegate protocols](#conforming)
    + [Log Consumable Transaction](#logging-consumable-transactions)
    + [Info.plist Flag for iOS 18+](#infoplist-flag-for-ios-18)
    + [Start Observing Transactions](#start)
    + [Stop Observing Transactions](#stop)
  * [Testing the implementation in Sandbox](#testing)
  * [Full Code Examples](#example)


## <a id="plugin-build-for"> This Module is Built for
- AppsFlyer SDK:
- iOS AppsFlyer SDK **6.17.1** .
- 6.8.0+: StoreKit 1 support
- 6.16.2+: StoreKit 1 & 2 support
- Minimum iOS Version: 12

> *IMPORTNANT NOTE: Please, be sure to check Purchase Connector and AppsFlyerFramework version compatability table and use corresponding versions to avoid unexpected behaviour *

|  PurchaseConnector  | AppsFlyerSDK |
| :------: | :--------: |
| 6.8.0    | 6.8.0 - 6.9.2 |
| 6.8.1    | 6.8.0 - 6.9.2 |
| 6.10.0   |  6.10.0 |
| 6.10.1   |  6.10.1 |
| 6.12.2   |  6.12.2 |
| 6.12.3   |  6.12.2 |
| 6.15.3   |  6.15.2 |
| 6.16.2   |  6.16.2 |
| 6.17.0   |  6.17.0 |
| 6.17.1   |  6.17.1 |

## <a id="cocoapods">  Adding The Connector To Your Project via Cocoapods: 
Add to your Podfile and run `pod install`:
```
// for statically linked dependency
pod 'PurchaseConnector'

// for dynamically linked dependency
pod 'PurchaseConnector/Dynamic'

// for statically linked Strict dependency (disabled IDFA collection)
pod 'PurchaseConnector/Strict'
```


## <a id="carthage">  Adding The Connector To Your Project via Carthage: 
Go to the `Carthage` folder in the root of the repository. Open `purchase-connector-dynamic.json` or `purchase-connector-static.json`, click raw, copy and paste the URL of the file to your `Cartfile`: 
```
binary "https://raw.githubusercontent.com/AppsFlyerSDK/appsflyer-apple-purchase-connector/main/Carthage/purchase-connector-dynamic.json" == BIINARY_VERSION
binary "https://raw.githubusercontent.com/AppsFlyerSDK/AppsFlyerFramework/master/Carthage/appsflyer-ios.json" ~> 6.16.2
```
Then open project folder in the terminal and use command `carthage update --use-xcframeworks`, then, drag and drop PurchaseConnector.xcframework binary and AppsFlyerLib.framework (from Carthage/Build/iOS folder).

More reference on Carthage binary artifacts integration [here](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md).

## <a id="spm">  Adding The Connector To Your Project via SPM: 
Please, follow standard SPM dependency manager instructions.

> *Note: This repository contains statically linked `PurchaseConnector.xcframework`. If you want to use dynamic .xcframework, please integrate it for SPM from this repository:
https://github.com/AppsFlyerSDK/PurchaseConnector-Dynamic* 

> *Note: as PurchaseConnector has a dependency on [AppsFlyerLib framework](https://github.com/AppsFlyerSDK/AppsFlyerFramework), please, make sure to integrate it as well for Carthage and SPM.*

## <a id="storekit2-overview"> StoreKit 2 Overview (Beta)
StoreKit 2, introduced by Apple, offers a modern Swift-first API for managing in-app purchases. It simplifies tasks such as fetching product information, handling transactions, and managing subscriptions by leveraging Swift concurrency features like async/await. Additionally, StoreKit 2 provides enhanced tools for testing and debugging in-app purchases, improving the overall developer experience. ￼
### <a id="pc-capabilities"> New Purchase Connector Capabilities
With the release of AppsFlyer SDK 6.16.2 and Purchase Connector 6.16.2, the Purchase Connector now supports both StoreKit 1 and StoreKit 2, enabling automatic capture of various transaction types, including:
- Auto-Renewable Subscriptions
- Non-Renewing Subscriptions
- Non-Consumable Purchases
- Consumable Purchases (from iOS 18+ with appropriate configuration)

Due to limitations in earlier iOS versions, consumable purchases require manual logging, which is detailed later in this document.
To specify which StoreKit version to use, utilize the `setStoreKitVersion:` method with the AFSDKStoreKitVersion enum:
```obj-c
typedef NS_ENUM(NSUInteger, AFSDKStoreKitVersion) {
    AFSDKStoreKitVersionSK1 = 0, // StoreKit 1
    AFSDKStoreKitVersionSK2 = 1, // StoreKit 2
};
```
For example, to set StoreKit 2:
```obj-c
[[PurchaseConnector shared] setStoreKitVersion:AFSDKStoreKitVersionSK2];
```
```swift
PurchaseConnector.shared().setStoreKitVersion(.SK2)
```
In addition, the Purchase Connector provides wrapper classes to encapsulate StoreKit 2’s Transaction and Product objects due to Objective-c <> Swift interoperability, allowing for seamless integration with the Purchase Connector.
Example:
```swift
if #available(iOS 15.0, *) {
    let afTransaction = AFSDKTransactionSK2(transaction: transaction)
    // Now you can use afTransaction with Purchase Connector methods
    let originalTransaction = afTransaction.value.originalID
    let transactionDescription = afTransaction.value.debugDescription
    let afProduct = AFSDKProductSK2(product: product)
    // Now you can use afProduct
    let productId = afProduct.value.id
    let productDescription = product.value.description
}
```

**Important!**  
Before implementing Purchase Connector for StoreKit 2, ensure that your App Store credentials are updated in the AppsFlyer Revenue settings.  
For detailed instructions, refer to our  [Help Center article](https://support.appsflyer.com/hc/en-us/articles/27880822483985-Bulletin-Update-App-Store-credendials-for-iOS-ROI360-receipt-validation).



## <a id="basic-integration"> Basic Integration of the Connector
> *Note: before the implementation of the Purchase connector, please make sure to set up AppsFlyer `appId` and `devKey`*

### <a id="create-instance"> Set up Purchase Connector
- Swift 
```swift
// Import the library
    import AppsFlyerLib
    import StoreKit
    import PurchaseConnector

// Default SDK Implementation
    AppsFlyerLib.shared().appsFlyerDevKey = "DEV_KEY"
    AppsFlyerLib.shared().appleAppID = "APPLE_APP_ID"
    //AppsFlyerLib.shared().isDebug = true

// Purchase connector implementation 
    PurchaseConnector.shared().purchaseRevenueDelegate = self
    PurchaseConnector.shared().purchaseRevenueDataSource = self

    // Set StoreKit version; defaults to StoreKit 1 if not specified (.SK1) or not triggered.
    PurchaseConnector.shared().setStoreKitVersion(.SK2)
```

- Objective-C 
```objective-c
// Import the library
    #import "AppDelegate.h"
    #import <AppsFlyerLib/AppsFLyerLib.h>
    #import <PurchaseConnector/PurchaseConnector.h>

// Default SDK implementation
    [[AppsFlyerLib shared] setAppleAppID:@"APPLE_APP_ID"];
    [[AppsFlyerLib shared] setAppsFlyerDevKey:@"DEV_KEY"];
    //[[AppsFlyerLib shared] setIsDebug:YES];

// Purchase Connecor implementation
    [[PurchaseConnector shared] setPurchaseRevenueDelegate:self];
    [[PurchaseConnector shared] setPurchaseRevenueDataSource:self];

    [[PurchaseConnector shared] setStoreKitVersion:AFSDKStoreKitVersionSK2];
```

### <a id="log-subscriptions"> Log Auto-Renewable Subscriptions and In-App Purchases

Enables automatic logging of In-App purchases and Auto-renewable subscriptions.

- Swift 
```swift
PurchaseConnector.shared().autoLogPurchaseRevenue = [.autoRenewableSubscriptions, .inAppPurchases]
```

- Objective-C 
```objective-c
[[PurchaseConnector shared] setAutoLogPurchaseRevenue:AFSDKAutoLogPurchaseRevenueOptionsRenewable | AFSDKAutoLogPurchaseRevenueOptionsInAppPurchases];
```

> *Note: if `autoLogPurchaseRevenue` has not been set, it is disabled by default. The value is an option set, so you can choose what kind of user purchases you want to observe.*

### <a id="conforming"> Conform to Purchase Connector Data Source and Delegate protocols

* In order to receive purchase validation event callbacks, you should conform to and implement `PurchaseRevenueDelegate`(Swift) or `AppsFlyerPurchaseRevenueDelegate`(Objc-C) protocol.
* {StoreKit v1} To be able to add your custom parameters to the purchase event, that Connector sends, please conform to  and implement `PurchaseRevenueDataSource`(Swift) or `AppsFlyerPurchaseRevenueDataSource`(Obj-C) protocol.
* {StoreKit v2} To add custom parameters to the purchase events sent by the connector, conform to and implement the PurchaseRevenueDataSource protocol. For StoreKit 2-specific implementations, conform to the `PurchaseRevenueDataSourceStoreKit2` (Swift) or `AppsFlyerPurchaseRevenueDataSourceStoreKit2` (Obj-c) protocol.

- Swift 
```swift
extension AppDelegate: PurchaseRevenueDataSource, PurchaseRevenueDelegate  PurchaseRevenueDataSourceStoreKit2 {

    @available(iOS 15.0, *)
    func purchaseRevenueAdditionalParametersStoreKit2(forProducts products: Set<AFSDKProductSK2>, transactions: Set<AFSDKTransactionSK2>?) -> [String: Any]? {
        let additionalParameters: [String: Any] = [
            "products": products.map { ["product_id": $0.value.id] },
            "transactions": transactions?.map { ["transaction_id": $0.value.id] } ?? []
        ]
        return additionalParameters.isEmpty ? nil : additionalParameters
    }

    // PurchaseRevenueDelegate method implementation
    func didReceivePurchaseRevenueValidationInfo(_ validationInfo: [AnyHashable : Any]?, error: Error?) {
        print("PurchaseRevenueDelegate: \(validationInfo)")
        print("PurchaseRevenueDelegate: \(error)")
      // process validationInfo here 
}
    // PurchaseRevenueDataSource method implementation
    func purchaseRevenueAdditionalParameters(for products: Set<SKProduct>, transactions: Set<SKPaymentTransaction>?) -> [AnyHashable : Any]? {
        // Add additional parameters for SKTransactions here.
        return ["additionalParameters":["param1":"value1", "param2":"value2"]];
    }
}
```

- Objective-C 
```objective-c
@interface AppDelegate () <AppsFlyerPurchaseRevenueDelegate, AppsFlyerPurchaseRevenueDataSource, AppsFlyerPurchaseRevenueDataSourceStoreKit2>
@end

@implementation AppDelegate

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[AppsFlyerLib shared] start];
    [[PurchaseConnector shared] startObservingTransactions];
}

- (NSDictionary<NSString *, id> * _Nullable)purchaseRevenueAdditionalParametersStoreKit2ForProducts:(NSSet<AFSDKProductSK2 *> *)products transactions:(NSSet<AFSDKTransactionSK2 *> *)transactions API_AVAILABLE(ios(15.0)) {
    NSMutableArray *productArray = [NSMutableArray array];
    for (AFSDKProductSK2 *product in products) {
        [productArray addObject:@{@"product_id": product.value.productIdentifier}];
    }

    NSMutableArray *transactionArray = [NSMutableArray array];
    for (AFSDKTransactionSK2 *transaction in transactions) {
        [transactionArray addObject:@{@"transaction_id": transaction.value.transactionIdentifier}];
    }

    NSMutableDictionary *additionalParameters = [NSMutableDictionary dictionary];
    if (productArray.count > 0) {
        additionalParameters[@"products"] = productArray;
    }
    if (transactionArray.count > 0) {
        additionalParameters[@"transactions"] = transactionArray;
    }

    return additionalParameters.count > 0 ? additionalParameters : nil;
}


- (void)didReceivePurchaseRevenueValidationInfo:(NSDictionary *)validationInfo error:(NSError *)error {
    NSLog(@"Validation info: %@", validationInfo);
    NSLog(@"Error: %@", error);
    
    // Process validation info
}

- (NSDictionary *)purchaseRevenueAdditionalParametersForProducts:(NSSet<SKProduct *> *)products transactions:(NSSet<SKPaymentTransaction *> *)transactions {
    return @{@"key1" : @"param1"};
}

@end
```

### <a id="log-transaction"> Logging Consumable Transactions (Storekit 2 only)

For iOS versions prior to 18 or when the `SKIncludeConsumableInAppPurchaseHistory` flag is not enabled, consumable purchases must be manually logged. This requires a verified transaction to be wrapped in an `AFSDKTransactionSK2` object before invoking the `logConsumableTransaction` API.

Key Behavior:
-    Automatic Logging:
    -   Non-consumable products, non-renewable subscriptions, and auto-renewable subscriptions are automatically captured by the framework and do not require manual logging.
    - Starting from iOS 18, consumable purchases will also be automatically logged if the `SKIncludeConsumableInAppPurchaseHistory` flag is set to `YES` in the Info.plist file.
-    Manual Logging for Consumables:
    - For iOS versions 15 to 18 or when the `SKIncludeConsumableInAppPurchaseHistory` flag cannot be used, consumable purchases must be manually logged.
    - This requires a verified transaction to be wrapped in an `AFSDKTransactionSK2` object before invoking the `logConsumableTransaction` API.

Code example:
```swift
private func purchaseProductSK2(with productId: String, completion: @escaping (String) -> Void) {
        if #available(iOS 15.0, *) {
            Task {
                do {
                    // Fetch the product
                    let products = try await Product.products(for: [productId])
                    guard let product = products.first else {
                        completion("Product not found for product ID: \(productId)")
                        return
                    }
                    // Attempt to purchase the product
                    let result = try await product.purchase()
                    switch result {
                    case .success(let verificationResult):
                        switch verificationResult {
                        case .verified(let transaction):
                            //We only log ConsumableTransaction. nonConsumable , nonRenewable ,autoRenewable are automatically caught.
                            if transaction.productType == Product.ProductType.consumable{
                                let afTransaction = AFSDKTransactionSK2(transaction: transaction)
                                PurchaseConnector.shared().logConsumableTransaction(afTransaction)
                            await transaction.finish()
                            completion("Purchase successful for \(productId), and the transaction is verfied!")
                        case .unverified(let transaction, let verificationError):
                            completion("Transaction unverified: \(transaction), error: \(verificationError)")
                        }
                    case .pending:
                        completion("Purchase is pending.")
                    case .userCancelled:
                        completion("User cancelled the purchase.")
                    @unknown default:
                        completion("Unexpected purchase result.")
                    }
                }
            }
        }else{
            completion("StoreKit 2 is not supported on this device.")
        }
    }
```

### <a id="infoplist-flag-for-ios-18"> Info.plist Flag for iOS 18+
For iOS 18+, enable automatic logging of consumable purchases by adding the following to your Info.plist:

```xml
<key>SKIncludeConsumableInAppPurchaseHistory</key>
<true/>
```

### <a id="start"> Start Observing Transactions

`startObservingTransactions` should be called to start observing transactions.<br>
 > *Note: This should be called right after the AppsFlyer iOS SDK's start method..*

- Swift 
```swift
    PurchaseConnector.shared().startObservingTransactions()
```

- Objective-C 
```objective-c
    [[PurchaseConnector shared] startObservingTransactions];
```

### <a id="stop"> Stop Observing Transactions

To stop observing transactions, you need to call `stopObservingTransactions`.

- Swift 
```swift
    PurchaseConnector.shared().stopObservingTransactions()
```

- Objective-C 
```objective-c
    [[PurchaseConnector shared] stopObservingTransactions];
```

> *Note: if you called `stopObservingTransactions` API, you should set `autoLogPurchaseRevenue` value before you call `startObservingTransactions` next time.*

## <a id="testing"> Testing the implementation in Sandbox

In order to test purchases in Xcode environment on a real device with TestFlight sandbox account, you need to set `isSandbox` to true.

- Swift 
```swift
    PurchaseConnector.shared().isSandbox = true
```

- Objective-C 
```objective-c
    [[PurchaseConnector shared] setIsSandbox:YES];
```

> *IMPORTANT NOTE: Before releasing your app to production please be sure to remove `isSandbox` or set it to `false`. If the production purchase event will be sent in sandbox mode, your event will not be validated properly! *

***

## <a id="example"> Full Code Examples

### Swift Example 
```swift
import AppsFlyerLib
import StoreKit
import PurchaseConnector

class AppDelegate: UIResponder, UIApplicationDelegate {
   func application(_ _: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Default SDK Implementation
        AppsFlyerLib.shared().appsFlyerDevKey = "DEV_KEY"
        AppsFlyerLib.shared().appleAppID = "APLE_APP_ID"
        // AppsFlyerLib.shared().isDebug = true
      
   // Purchase Connector implementation
        PurchaseConnector.shared().purchaseRevenueDelegate = self
        PurchaseConnector.shared().purchaseRevenueDataSource = self
        PurchaseConnector.shared().setStoreKitVersion(.SK2)
        PurchaseConnector.shared().autoLogPurchaseRevenue = .autoRenewableSubscriptions
   }

   func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
        PurchaseConnector.shared().startObservingTransactions()
    }
}

extension AppDelegate: PurchaseRevenueDataSource, PurchaseRevenueDelegate PurchaseRevenueDataSourceStoreKit2 {
    
    // PurchaseRevenueDataSourceStoreKit2 method implementation
    @available(iOS 15.0, *)
    func purchaseRevenueAdditionalParametersStoreKit2(forProducts products: Set<AFSDKProductSK2>,transactions: Set<AFSDKTransactionSK2>?) -> [String: Any]? {
        let additionalParameters: [String: Any] = [
            "products": products.map { ["product_id": $0.value.id] },
            "transactions": transactions?.map { ["transaction_id": $0.value.id] } ?? []
        ]
        return additionalParameters.isEmpty ? nil : additionalParameters
    }

    // PurchaseRevenueDelegate method implementation
    func didReceivePurchaseRevenueValidationInfo(_ validationInfo: [AnyHashable : Any]?, error: Error?) {
        print("PurchaseRevenueDelegate: \(validationInfo)")
        print("PurchaseRevenueDelegate: \(error)")
      // process validationInfo here 
}
    // PurchaseRevenueDataSource method implementation
    func purchaseRevenueAdditionalParameters(for products: Set<SKProduct>, transactions: Set<SKPaymentTransaction>?) -> [AnyHashable : Any]? {
        // Add additional parameters for SKTransactions here.
        return ["additionalParameters":["param1":"value1", "param2":"value2"]];
    }
}
```

###  Objective-C Example 
```objective-c
#import "AppDelegate.h"
#import <PurchaseConnector/PurchaseConnector.h>
#import <AppsFlyerLib/AppsFLyerLib.h>

@interface AppDelegate () <AppsFlyerPurchaseRevenueDelegate, AppsFlyerPurchaseRevenueDataSource, AppsFlyerPurchaseRevenueDataSourceStoreKit2 >

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Set up AppsFlyerLib first
    [[AppsFlyerLib shared] setAppleAppID:@"APPLE_APP_ID"];
    [[AppsFlyerLib shared] setAppsFlyerDevKey:@"DEV_KEY"];
    // [[AppsFlyerLib shared] setIsDebug:YES];
    
    // Set up PurchaseConnector
    [[PurchaseConnector shared] setPurchaseRevenueDelegate:self];
    [[PurchaseConnector shared] setPurchaseRevenueDataSource:self];
    [[PurchaseConnector shared] setAutoLogPurchaseRevenue:AFSDKAutoLogPurchaseRevenueOptionsAutoRenewableSubscriptions];
    [[PurchaseConnector shared] setStoreKitVersion:AFSDKStoreKitVersionSK2];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
     [[AppsFlyerLib shared] start];
     [[PurchaseConnector shared] startObservingTransactions];
}

- (NSDictionary<NSString *, id> * _Nullable)purchaseRevenueAdditionalParametersStoreKit2ForProducts:(NSSet<AFSDKProductSK2 *> *)products transactions:(NSSet<AFSDKTransactionSK2 *> *)transactions API_AVAILABLE(ios(15.0)) {
    NSMutableArray *productArray = [NSMutableArray array];
    for (AFSDKProductSK2 *product in products) {
        [productArray addObject:@{@"product_id": product.value.productIdentifier}];
    }

    NSMutableArray *transactionArray = [NSMutableArray array];
    for (AFSDKTransactionSK2 *transaction in transactions) {
        [transactionArray addObject:@{@"transaction_id": transaction.value.transactionIdentifier}];
    }

    NSMutableDictionary *additionalParameters = [NSMutableDictionary dictionary];
    if (productArray.count > 0) {
        additionalParameters[@"products"] = productArray;
    }
    if (transactionArray.count > 0) {
        additionalParameters[@"transactions"] = transactionArray;
    }

    return additionalParameters.count > 0 ? additionalParameters : nil;
}

- (void)didReceivePurchaseRevenueValidationInfo:(NSDictionary *)validationInfo error:(NSError *)error {
    NSLog(@"Validation info: %@", validationInfo);
    NSLog(@"Error: %@", error);
    
    // Process validation info
}

- (NSDictionary *)purchaseRevenueAdditionalParametersForProducts:(NSSet<SKProduct *> *)products transactions:(NSSet<SKPaymentTransaction *> *)transactions {
    return @{@"key1" : @"param1"};
}

@end
```

