//
//  ETHAddressInfoModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Price : BBaseModel

@property (nonatomic, strong) NSString * currency;
@property (nonatomic, strong) NSNumber * diff7d;
@property (nonatomic, strong) NSString * rate;
@property (nonatomic, strong) NSNumber * diff30d;
@property (nonatomic, strong) NSString * ts;
@property (nonatomic, strong) NSString * volume24h;
@property (nonatomic, strong) NSString * marketCapUsd;
@property (nonatomic, strong) NSString * availableSupply;
@property (nonatomic, strong) NSNumber * diff;

@end

@interface ETH : BBaseModel

@property (nonatomic, strong) NSNumber *balance;

@end

@interface TokenInfo : BBaseModel

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * decimals;
@property (nonatomic, strong) NSNumber * holdersCount;
@property (nonatomic, strong) NSNumber * issuancesCount;
@property (nonatomic, strong) NSNumber * lastUpdated;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * owner;
@property (nonatomic, strong) Price *price;
@property (nonatomic, strong) NSString * symbol;
@property (nonatomic, strong) NSString * totalSupply;
@property (nonatomic, strong) NSNumber *ethTransfersCount;
@property (nonatomic, strong) NSNumber *txsCount;
@property (nonatomic, strong) NSNumber *transfersCount;

@end

@interface Token : BBaseModel

@property (nonatomic, strong) NSNumber *balance;
@property (nonatomic, strong) TokenInfo * tokenInfo;
@property (nonatomic, assign) NSInteger totalIn;
@property (nonatomic, assign) NSInteger totalOut;

- (NSString *)getTokenNum;
- (NSString *)getPrice:(NSArray *)tokenPriceArr;

@end

@interface ETHAddressInfoModel : BBaseModel

@property (nonatomic, strong) ETH * ETH;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) NSInteger countTxs;
@property (nonatomic, strong) NSArray * tokens;
@property (nonatomic, strong) NSString * name;

@end

NS_ASSUME_NONNULL_END
