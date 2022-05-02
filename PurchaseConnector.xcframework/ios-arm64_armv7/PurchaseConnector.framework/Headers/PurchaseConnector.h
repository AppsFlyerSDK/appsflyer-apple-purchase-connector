//
//  AppsFlyerARS.h
//  AppsFlyerARS-Dynamic
//
//  Created by ivan.obodovskyi on 16.02.2022.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


// Purchase revenue API
typedef NS_OPTIONS(NSInteger, AFSDKAutoLogPurchaseRevenueOptions) {
    AFSDKAutoLogPurchaseRevenueOptionsDisabled = 0,
    AFSDKAutoLogPurchaseRevenueOptionsRenewable = 1 << 0,
    AFSDKAutoLogPurchaseRevenueOptionsCounsumable NS_UNAVAILABLE = 1 << 1,
    AFSDKAutoLogPurchaseRevenueOptionsNonCounsumable NS_UNAVAILABLE = 1 << 2,
    AFSDKAutoLogPurchaseRevenueOptionsNonRenewing NS_UNAVAILABLE = 1 << 3,
} NS_SWIFT_NAME(AutoLogPurchaseRevenueOptions);


NS_SWIFT_NAME(PurchaseRevenueDelegate)
@protocol AppsFlyerPurchaseRevenueDelegate <NSObject>


@optional
- (void)didReceivePurchaseRevenueValidationInfo:(NSDictionary * _Nullable)validationInfo error:(NSError * _Nullable)error;


@end

@class SKPaymentTransaction;
@class SKProduct;

NS_SWIFT_NAME(PurchaseRevenueDataSource)
@protocol AppsFlyerPurchaseRevenueDataSource <NSObject>


@optional
- (NSDictionary * _Nullable)purchaseRevenueAdditionalParametersForProducts:(NSSet<SKProduct *> *_Nonnull)products
                                                              transactions:(NSSet<SKPaymentTransaction *> *_Nullable)transactions;


@end



@interface PurchaseConnector : NSObject


@property(nonatomic) AFSDKAutoLogPurchaseRevenueOptions autoLogPurchaseRevenue;
@property(nonatomic) id<AppsFlyerPurchaseRevenueDelegate> purchaseRevenueDelegate;
@property(nonatomic) id<AppsFlyerPurchaseRevenueDataSource> purchaseRevenueDataSource;
@property(nonatomic) BOOL isSandbox;

- (instancetype)init NS_UNAVAILABLE;
- (void)startObservingTransactions;

+ (PurchaseConnector *)shared;


@end

NS_ASSUME_NONNULL_END
