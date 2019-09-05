//
//  BinaTpcsModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/16.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BinaTpcsModel.h"
#import "NSString+RemoveZero.h"
#import "TokenPriceModel.h"
#import "GlobalConstants.h"

@implementation BinaTpcsModel

- (NSString *)getNum {
    NSString *num = [[NSString stringWithFormat:@"%@",self.lastPrice] removeFloatAllZero];
    return num;
}

- (NSString *)getPrice {
    NSString *num = [[NSString stringWithFormat:@"%@",self.coinVal] removeFloatAllZero];
    return num;
}

- (NSString *)getChange {
    NSString *num = [[NSString stringWithFormat:@"%@",self.priceChangePercent] removeFloatAllZero];
    return num;
}

+ (void)addLocalMarketsSymbol:(NSString *)str {
    NSArray *localArr = [BinaTpcsModel getLocalMarketsSymbol];
    NSMutableArray *muArr = [NSMutableArray array];
    [muArr addObjectsFromArray:localArr];
    if (![localArr containsObject:str]) {
        [muArr addObject:str];
    }
    [HWUserdefault insertObj:muArr withkey:Local_Markets_Symbol];
}

+ (void)addLocalMarketsSymbolArr:(NSArray *)arr {
    [HWUserdefault insertObj:arr withkey:Local_Markets_Symbol];
}

+ (NSArray *)getLocalMarketsSymbol {
    return [HWUserdefault getObjectWithKey:Local_Markets_Symbol]?:@[@"ETH",@"NEO",@"EOS"];
}

+ (void)deleteLocalMarketsSymbol:(NSString *)str {
    NSArray *localArr = [BinaTpcsModel getLocalMarketsSymbol];
    NSMutableArray *muArr = [NSMutableArray array];
    [muArr addObjectsFromArray:localArr];
    if ([muArr containsObject:str]) {
        [muArr removeObject:str];
    }
    [HWUserdefault insertObj:muArr withkey:Local_Markets_Symbol];
}

+ (void)deleteAllLocalMarketsSymbol {
    [HWUserdefault deleteObjectWithKey:Local_Markets_Symbol];
}

@end
