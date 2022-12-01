//
//  AFSDKAutoLogPurchaseOptions.h
//  PurchaseConnector
//
//  Created by ivan.obodovskyi on 29.11.2022.
//


// Purchase revenue API
typedef NS_OPTIONS(NSInteger, AFSDKAutoLogPurchaseRevenueOptions) {
    AFSDKAutoLogPurchaseRevenueOptionsDisabled = 0,
    AFSDKAutoLogPurchaseRevenueOptionsAutoRenewableSubscriptions = 1 << 0,
    AFSDKAutoLogPurchaseRevenueOptionsInAppPurchases = 1 << 1,
} NS_SWIFT_NAME(AutoLogPurchaseRevenueOptions);

