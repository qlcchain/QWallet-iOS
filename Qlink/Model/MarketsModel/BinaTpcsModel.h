//
//  BinaTpcsModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/16.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BinaTpcsModel : BBaseModel

@property (nonatomic, strong) NSString * symbol; //" : "QLC",
@property (nonatomic, strong) NSNumber * lowPrice; // " : "0.00000766",
@property (nonatomic, strong) NSNumber *highPrice; //" : "0.00000797",
@property (nonatomic, strong) NSNumber *priceChangePercent; //" : "-1.259",
@property (nonatomic, strong) NSNumber *lastPrice; // " : "0.00000784"
@property (nonatomic, strong) NSNumber *coinVal;

- (NSString *)getNum;
- (NSString *)getPrice;
- (NSString *)getChange;

+ (void)addLocalMarketsSymbol:(NSString *)str;
+ (void)addLocalMarketsSymbolArr:(NSArray *)arr;
+ (NSArray *)getLocalMarketsSymbol;
+ (void)deleteLocalMarketsSymbol:(NSString *)str;
+ (void)deleteAllLocalMarketsSymbol;

@end

NS_ASSUME_NONNULL_END
