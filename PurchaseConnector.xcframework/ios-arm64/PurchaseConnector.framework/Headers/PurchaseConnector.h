//
//  PurchaseConnector.h
//  PurchaseConnector project
//
//  Created by ivan.obodovskyi on 16.02.2022.
//

#import <Foundation/Foundation.h>
#import <PurchaseConnector/AFSDKAutoLogPurchaseOptions.h>

NS_ASSUME_NONNULL_BEGIN

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
@property(weak, nonatomic, nullable) id<AppsFlyerPurchaseRevenueDelegate> purchaseRevenueDelegate;
@property(weak, nonatomic, nullable) id<AppsFlyerPurchaseRevenueDataSource> purchaseRevenueDataSource;
@property(nonatomic) BOOL isSandbox;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (PurchaseConnector *)shared;

- (void)startObservingTransactions;
- (void)stopObservingTransactions;



@end

NS_ASSUME_NONNULL_END
