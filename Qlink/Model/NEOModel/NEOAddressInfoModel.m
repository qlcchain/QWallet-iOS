//
//  NEOAddressInfoModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/12.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NEOAddressInfoModel.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import "RLArithmetic.h"

@implementation NEOUnspentModel

@end

@implementation NEOAssetModel

+ (NSDictionary *) mj_objectClassInArray
{
    return @{@"unspent" : @"NEOUnspentModel"};
}

- (NSString *)getTokenNum {
    NSString *num = self.amount.mul(@(1));
//    NSString *num = [[NSString stringWithFormat:@"%@",self.amount] removeFloatAllZero];
    return num;
}

- (NSString *)getPrice:(NSArray *)tokenPriceArr {
    __block NSString *price = @"";
    NSString *num = [self getTokenNum];
    [tokenPriceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TokenPriceModel *tempM = obj;
        if ([tempM.symbol isEqualToString:self.asset_symbol]) {
//            NSNumber *usdNum = @([num doubleValue]*[tempM.price doubleValue]);
//            price = [[NSString stringWithFormat:@"%@",usdNum] removeFloatAllZero];
            price = num.mul(tempM.price);
            *stop = YES;
        }
    }];
    return price;
}

@end

@implementation NEOAddressInfoModel

+ (NSDictionary *) mj_objectClassInArray
{
    return @{@"balance" : @"NEOAssetModel"};
}

@end
