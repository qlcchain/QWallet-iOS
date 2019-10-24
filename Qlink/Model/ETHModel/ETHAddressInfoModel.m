//
//  ETHAddressInfoModel.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHAddressInfoModel.h"
#import "NSString+RemoveZero.h"
#import "TokenPriceModel.h"
#import "RLArithmetic.h"

@implementation Price

@end

@implementation ETH

@end

@implementation TokenInfo

@end

@implementation Token

- (NSString *)getTokenNum {
    NSString *decimals = [NSString stringWithFormat:@"1e-%@",self.tokenInfo.decimals];
    NSNumber *decimalsNum = @([[NSString stringWithFormat:@"%@",decimals] doubleValue]);
    NSNumber *balanceNum = @([[NSString stringWithFormat:@"%@",self.balance] doubleValue]);
    
    NSString *num = decimalsNum.mul(balanceNum);

    return num;
//    NSNumber *numberNum = @([decimalsNum doubleValue]*[balanceNum doubleValue]);
//    NSString *num = [[NSString stringWithFormat:@"%@",numberNum] removeFloatAllZero];
//    return num;
}

- (NSString *)getPrice:(NSArray *)tokenPriceArr {
    __block NSString *price = @"";
    NSString *num = [self getTokenNum];
    [tokenPriceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TokenPriceModel *tempM = obj;
        if ([tempM.symbol isEqualToString:self.tokenInfo.symbol]) {
//            NSNumber *usdNum = @([num doubleValue]*[tempM.price doubleValue]);
//            price = [[NSString stringWithFormat:@"%@",usdNum] removeFloatAllZero];
            price = num.mul(tempM.price);
            *stop = YES;
        }
    }];
    return price;
}

@end

@implementation ETHAddressInfoModel

+ (NSDictionary *) mj_objectClassInArray
{
    return @{@"tokens" : @"Token"};
}


@end
