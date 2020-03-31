//
//  ETHAddressTransactionsModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/15.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHAddressTransactionsModel.h"
//#import "NSString+RemoveZero.h"
#import "RLArithmetic.h"
#import "NSString+RemoveZero.h"

@implementation ETHAddressTransactionsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Hash" : @"hash"};
}

- (NSString *)value_str {
    return [NSString doubleToString:_value];
}

- (NSString *)getTokenNum {
    NSString *num = self.value_str.mul(@(1));
//    NSString *num = [[NSString stringWithFormat:@"%@",self.value] removeFloatAllZero];
    return num;
}

- (NSString *)getSymbol {
    return @"ETH";
}

@end
