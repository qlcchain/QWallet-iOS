//
//  QSwapHashModel.h
//  Qlink
//
//  Created by 旷自辉 on 2020/8/20.
//  Copyright © 2020 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QSwapHashModel : BBaseModel


/// 原文
@property (nonatomic, strong) NSString *rOrigin;

/// 原文hash
@property (nonatomic, strong) NSString *rHash;

/// 交易hash
@property (nonatomic, strong) NSString *txHash;
/// 最后认领交易hash
@property (nonatomic, strong) NSString *swaptxHash;

/// 1:neo->eth 2:eth->neo
@property (nonatomic, assign) NSInteger type;

/// swap状态
@property (nonatomic, assign) NSInteger state;

/// swap数量
@property (nonatomic, assign) NSInteger amount;

/// swap时间
@property (nonatomic, assign) NSInteger lockTime;

/// swap钱包地址
@property (nonatomic, strong) NSString *fromAddress;

/// swap 钱包私钥
@property (nonatomic, strong) NSString *privateKey;

/// swap to 钱包地址
@property (nonatomic, strong) NSString *toAddress;

/// wrapper 钱包地址
@property (nonatomic, strong) NSString *wrapperAddress;

+ (void) deleteAllLocationHashs;
+ (NSArray *) getLocalAllQSwapHashModels;
+ (QSwapHashModel *) checkSwapHashWithHash:(NSString *) rhash;
+ (BOOL) isExitsWithHash:(NSString *) rhash;
+ (void) addSwapHashWithSwapHashModel:(QSwapHashModel *) hashM;
+ (void) deleteSwapHashWithHash:(NSString *) rHash;
+ (void) updateSwapHashStateWithHash:(NSString *) rHash withState:(NSInteger) state swapTxhash:(NSString *) swapTxhash;
+ (void) updateSwapHashStateWithHash:(NSString *) rHash  withState:(NSInteger) state;
@end

NS_ASSUME_NONNULL_END
