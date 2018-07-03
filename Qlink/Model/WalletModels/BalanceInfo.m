//
//  BalanceInfo.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BalanceInfo.h"

@implementation BalanceInfo
// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"qlc" : @"QLC",
              @"neo" : @"NEO",
              @"gas" : @"GAS"
             };
}


@end
