//
//  QLCAddressHistoryModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/5/29.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QLCAddressHistoryModel.h"
#import "NSString+RemoveZero.h"
#import "QLCTokenInfoModel.h"
#import "RLArithmetic.h"

@implementation QLCAddressHistoryModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Hash" : @"hash"};
}

- (NSString *)getTokenNum {
    NSString *decimals = [NSString stringWithFormat:@"1e-%@",self.tokenInfoM.decimals];
    NSNumber *decimalsNum = @([[NSString stringWithFormat:@"%@",decimals] doubleValue]);
    NSNumber *balanceNum = @([[NSString stringWithFormat:@"%@",self.balance] doubleValue]);
//    NSNumber *numberNum = @([decimalsNum doubleValue]*[balanceNum doubleValue]);
//    NSString *num = [[NSString stringWithFormat:@"%@",numberNum] removeFloatAllZero];
    NSString *num = decimalsNum.mul(balanceNum);
    return num;
}

- (NSString *)getAmountNum {
    NSString *decimals = [NSString stringWithFormat:@"1e-%@",self.tokenInfoM.decimals];
    NSNumber *decimalsNum = @([[NSString stringWithFormat:@"%@",decimals] doubleValue]);
    NSNumber *balanceNum = @([[NSString stringWithFormat:@"%@",self.amount] doubleValue]);
//    NSNumber *numberNum = @([decimalsNum doubleValue]*[balanceNum doubleValue]);
//    NSString *num = [[NSString stringWithFormat:@"%@",numberNum] removeFloatAllZero];
    NSString *num = decimalsNum.mul(balanceNum);
    return num;
}

@end
