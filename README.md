# appsflyer-framework-ars-beta
## Adding SDK to your project 

To install the SDK using `CocoaPods`, add  `'pod 'PurchaseConnector'` to your Podfile and run `pod update`.

Note: Please make sure to install and set up AppsFlyerFramework pod version `6.6.0` or later `pod 'AppsFlyerFramework'`

## ARS SDK Initialization - Swift Example 

```
import StoreKit
import PurchaseConnector

class AppDelegate: UIResponder, UIApplicationDelegate {
   func application(_ _: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Default SDK Implementation
        AppsFlyerLib.shared().appsFlyerDevKey = "DEV_KEY"
        AppsFlyerLib.shared().appleAppID = "APLE_APP_ID"
        AppsFlyerLib.shared().isDebug = true
      
   // ARS implementation
        PurchaseConnector.shared().isSandbox = true
        PurchaseConnector.shared().purchaseRevenueDelegate = self
        PurchaseConnector.shared().purchaseRevenueDataSource = self
        PurchaseConnector.shared().autoLogPurchaseRevenue = .renewable
   }

   func applicationDidBecomeActive(_ application: UIApplication) {
        PurchaseConnector.shared().startObservingTransactions()
        AppsFlyerLib.shared().start()
    }
}

extension AppDelegate: PurchaseRevenueDataSource, PurchaseRevenueDelegate {
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

## ARS SDK Initialization - Objective-C Example 

```
#import "AppDelegate.h"
#import <PurchaseConnector/PurchaseConnector.h>
#import <AppsFlyerLib/AppsFLyerLib.h>

@interface AppDelegate () <AppsFlyerPurchaseRevenueDelegate, AppsFlyerPurchaseRevenueDataSource>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Set up AppsFlyerLib first
    [[AppsFlyerLib shared] setAppleAppID:@"APPLE_APP_ID"];
    [[AppsFlyerLib shared] setAppsFlyerDevKey:@"DEV_KEY"];
    [[AppsFlyerLib shared] setIsDebug:YES];
    
    // Set up PurchaseConnector
    [[PurchaseConnector shared] startObservingTransactions];
    [[PurchaseConnector shared] setIsSandbox:YES];
    [[PurchaseConnector shared] setPurchaseRevenueDelegate:self];
    [[PurchaseConnector shared] setPurchaseRevenueDataSource:self];
    [[PurchaseConnector shared] setAutoLogPurchaseRevenue:AFSDKAutoLogPurchaseRevenueOptionsRenewable];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[PurchaseConnector shared] startObservingTransactions];
    [[AppsFlyerLib shared] start];
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
## ARS SDK - Setting CUID

You might wish to consider delaying the SDK initialization until setting CUID to ensure that the SDK doesn't begin functioning until the CUID is provided. Setting customer user id can be done as follows:

```
AppsFlyerLib.shared().customerUserID = "CUID"
```



