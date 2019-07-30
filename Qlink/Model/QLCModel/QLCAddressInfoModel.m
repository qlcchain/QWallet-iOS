//
//  QLCAddressInfoModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/5/27.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QLCAddressInfoModel.h"
#import "TokenPriceModel.h"
#import "NSString+RemoveZero.h"
#import "QLCTokenInfoModel.h"
#import "NSNumber+RemoveZero.h"

@implementation QLCTokenModel

- (NSUInteger)getTransferNum:(NSString *)input {
    NSString *decimals = [NSString stringWithFormat:@"1e%@",self.tokenInfoM.decimals];
    NSNumber *decimalsNum = @([[NSString stringWithFormat:@"%@",decimals] doubleValue]);
    NSNumber *balanceNum = @([[NSString stringWithFormat:@"%@",input] doubleValue]);
    NSNumber *numberNum = @([decimalsNum doubleValue]*[balanceNum doubleValue]);
    NSString *num = [[NSString stringWithFormat:@"%@",numberNum] removeFloatAllZero];
    return [num longLongValue];
}

- (NSString *)getTokenNum {
    NSString *decimals = [NSString stringWithFormat:@"1e-%@",self.tokenInfoM.decimals];
    NSNumber *decimalsNum = @([[NSString stringWithFormat:@"%@",decimals] doubleValue]);
    NSNumber *balanceNum = @([[NSString stringWithFormat:@"%@",self.balance] doubleValue]);
    NSNumber *numberNum = @([decimalsNum doubleValue]*[balanceNum doubleValue]);
    NSString *num = [[NSString stringWithFormat:@"%@",numberNum] showfloatStr:[self.tokenInfoM.decimals integerValue]?:8];
//    NSString *num = [[NSString stringWithFormat:@"%@",numberNum] removeFloatAllZero];
    return num;
}

- (NSString *)getPrice:(NSArray *)tokenPriceArr {
    __block NSString *price = @"";
    NSString *num = [self getTokenNum];
    [tokenPriceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TokenPriceModel *tempM = obj;
        if ([tempM.symbol isEqualToString:self.tokenName]) {
            NSNumber *usdNum = @([num doubleValue]*[tempM.price doubleValue]);
            price = [[NSString stringWithFormat:@"%@",usdNum] removeFloatAllZero];
            *stop = YES;
        }
    }];
    return price;
}

@end

@implementation QLCAddressInfoModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"tokens" : @"QLCTokenModel"};
}

@end
