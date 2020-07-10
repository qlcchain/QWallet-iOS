//
//  PairsModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/8/19.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PairsModel : BBaseModel

@property (nonatomic, strong) NSString *ID; // = 0460d819a551494496338b2c1bfe5ec7;
@property (nonatomic, strong) NSString *payToken; // = USDT;
@property (nonatomic, strong) NSString *payTokenChain; // = QLCCHAIN;
@property (nonatomic, strong) NSString *payTokenHash;// = 0xdac17f958d2ee523a2206206994597c13d831ec7;
@property (nonatomic, strong) NSString *tradeToken;// = DLT;
@property (nonatomic, strong) NSString *tradeTokenChain;// = QLCCHAIN;
@property (nonatomic, strong) NSString *tradeTokenHash;// = 0xdac17f958d2ee523a2206206994597c13d831ec7;

@property (nonatomic, assign) double minTradeTokenAmount;

@property (nonatomic, assign) double minPayTokenAmount;

//@property (nonatomic, strong) NSNumber *payTokenDecimal;
//
//@property (nonatomic, strong) NSNumber *tradeTokenDecimal;

@property (nonatomic, strong) NSString *payTokenLogo;
@property (nonatomic, strong) NSString *tradeTokenLogo;

+ (void)storeLocalSelect:(NSArray *)arr;
+ (NSArray *)fetchLocalSelect;
+ (void)removeLocalSelect;

@end

NS_ASSUME_NONNULL_END
