# appsflyer-framework-ars-beta
## Adding SDK to your project 

To install the SDK using `CocoaPods`, add  `'pod 'appsflyer-framework-ars-beta''` to your Podfile and run `pod update`.

## ARS SDK Initialization - Swift Example 

```
import StoreKit
import AppsFlyerLib

class AppDelegate: UIResponder, UIApplicationDelegate {
   func application(_ _: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Default SDK Implementation
      AppsFlyerLib.shared().appsFlyerDevKey = "DEV_KEY"
      AppsFlyerLib.shared().appleAppID = "APLE_APP_ID"
      AppsFlyerLib.shared().isDebug = true
      
   // ARS implementation
      AppsFlyerLib.shared().useReceiptValidationSandbox = true // Use in sandbox environment only
      AppsFlyerLib.shared().autoLogPurchaseRevenue = [.renewable]
      AppsFlyerLib.shared().purchaseRevenueDataSource = self
      AppsFlyerLib.shared().purchaseRevenueDelegate = self
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
#import <UIKit/UIKit.h>
#import "AppsFlyerLib.h"
#import "AFSDKStoreKit.h"
#import <StoreKit/StoreKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, AppsFlyerPurchaseRevenueDataSource, AppsFlyerPurchaseRevenueDelegate>

@end


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Default SDK Implementation
    [[AppsFlyerLib shared] setAppleAppID:@"APPLE_APP_ID"];
    [[AppsFlyerLib shared] setAppsFlyerDevKey:@"DEV_KEY"];
    [[AppsFlyerLib shared] setIsDebug:YES];
    
    //ARS implementation
    [[AppsFlyerLib shared] setUseReceiptValidationSandbox:YES]; // Use only in sandbox environment
    [[AppsFlyerLib shared] setAutoLogPurchaseRevenue:AFSDKAutoLogPurchaseRevenueOptionsRenewable];
    [[AppsFlyerLib shared] setPurchaseRevenueDelegate:self];
    [[AppsFlyerLib shared] setPurchaseRevenueDataSource:self];
    
    
    return YES;
}

- (void)didReceivePurchaseRevenueValidationInfo:(NSDictionary *)validationInfo error:(NSError *)error {
    NSLog(@"Validation info: %@", validationInfo);
    NSLog(@"Error: %@", error);
    
    // Process validation info
}

- (NSDictionary *)purchaseRevenueAdditionalParametersForProducts:(NSSet<SKProduct *> *)products transactions:(NSSet<SKPaymentTransaction *> *)transactions {
    return @{@"key1" : @"param1"};
}
```
## ARS SDK - Setting CUID

You might wish to consider delaying the SDK initialization until setting CUID to ensure that the SDK doesn't begin functioning until the CUID is provided. Setting customer user id can be done as follows:

```
AppsFlyerLib.shared().customerUserID = "CUID"
```



