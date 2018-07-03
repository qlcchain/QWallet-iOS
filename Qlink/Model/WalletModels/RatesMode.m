//
//  RatesMode.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/8.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "RatesMode.h"

@implementation RatesMode
// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"neoInfo" : @"NEO",
             @"gasInfo" : @"GAS",
             @"bnbInfo" : @"BNB",
             };
}
@end

@implementation NEO
// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"qlc" : @"QLC",
             };
}
@end

@implementation GAS
// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"qlc" : @"QLC",
             };
}
@end

@implementation BNB
// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"qlc" : @"QLC",
             };
}
@end
