//
//  PurchaseConnector.h
//  PurchaseConnector project
//
//  Created by ivan.obodovskyi on 16.02.2022.
//

#import <Foundation/Foundation.h>
#import <PurchaseConnector/AFSDKAutoLogPurchaseOptions.h>
#import <AppsFlyerLib/AppsFlyerLib-Swift.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(PurchaseRevenueDelegate)
@protocol AppsFlyerPurchaseRevenueDelegate <NSObject>

@optional
- (void)didReceivePurchaseRevenueValidationInfo:(NSDictionary * _Nullable)validationInfo error:(NSError * _Nullable)error;

@end

NS_SWIFT_NAME(PurchaseRevenueDataSourceProtocol)
@protocol AppsFlyerPurchaseRevenueDataSourceProtocol <NSObject>
@end

@class SKPaymentTransaction;
@class SKProduct;

NS_SWIFT_NAME(PurchaseRevenueDataSource)
@protocol AppsFlyerPurchaseRevenueDataSource <NSObject,AppsFlyerPurchaseRevenueDataSourceProtocol>

@optional
- (NSDictionary * _Nullable)purchaseRevenueAdditionalParametersForProducts:(NSSet<SKProduct *> *_Nonnull)products
                                                              transactions:(NSSet<SKPaymentTransaction *> *_Nullable)transactions;
@end

@class AFSDKProductSK2;
@class AFSDKTransactionSK2;

NS_SWIFT_NAME(PurchaseRevenueDataSourceStoreKit2)
@protocol AppsFlyerPurchaseRevenueDataSourceStoreKit2 <NSObject,AppsFlyerPurchaseRevenueDataSourceProtocol>

@optional
- (NSDictionary<NSString *, id> * _Nullable)purchaseRevenueAdditionalParametersStoreKit2ForProducts:(NSSet<AFSDKProductSK2 *> *_Nonnull)products
                                                                                       transactions:(NSSet<AFSDKTransactionSK2 *> *_Nullable)transactions API_AVAILABLE(ios(15.0));
@end

/// Enum representing StoreKit versions.
typedef NS_ENUM(NSUInteger, AFSDKStoreKitVersion) {
    AFSDKStoreKitVersionSK1 = 0, // StoreKit 1
    AFSDKStoreKitVersionSK2 = 1, // StoreKit 2
};

@class AFSDKTransactionSK2;
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

/// Sets the version of StoreKit to be used, must be called before startObserving.
/// @param storeKitVersion The version of StoreKit.
- (void)setStoreKitVersion:(AFSDKStoreKitVersion)storeKitVersion;

/// Logs a consumable transaction for StoreKit 2.
/// @param transaction The SK2 transaction to be logged. Available only on iOS 15.0 and later.
- (void)logConsumableTransaction:(AFSDKTransactionSK2 *)transaction API_AVAILABLE(ios(15.0));

/// Logs a message related to StoreKit.
/// @param stringToLog The message to be logged.
+ (void)storeKitLoggerWrapper:(NSString *)stringToLog;

@end

NS_ASSUME_NONNULL_END
