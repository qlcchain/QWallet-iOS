//
//  BalanceInfo.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BalanceInfo.h"
//#import "NSString+RemoveZero.h"
#import "RLArithmetic.h"

@implementation BalanceInfo
// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"qlc" : @"QLC",
              @"neo" : @"NEO",
              @"gas" : @"GAS"
             };
}

//- (void)setGas:(NSString *)gas
//{
//    NSNumberFormatter *amountFormatter = [[NSNumberFormatter alloc] init];
//    amountFormatter.minimumFractionDigits = 0;
//    amountFormatter.maximumFractionDigits = 8;
//    amountFormatter.numberStyle = kCFNumberFormatterDecimalStyle;
//    NSNumber *nubmer  = [amountFormatter numberFromString:gas];
//    _gas = [amountFormatter stringFromNumber:nubmer];
//   // _gas = amountFormatter.string(from:strTemp as! NSNumber)!
//
//}

- (NSString *)getWinqGas {
    NSString *num = self.qlc.mul(@(1));
//    NSString *num = [[NSString stringWithFormat:@"%@",self.qlc] removeFloatAllZero];
    return num;
}

@end
