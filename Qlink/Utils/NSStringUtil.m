//
//  NSStringUtil.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "NSStringUtil.h"
#import "QConstants.h"

@implementation NSStringUtil

+ (NSString *)getNotNullValue:(NSString *)str
{
    if (str == nil) {
        str = @"";
    }
    return str;
}
+ (NSString *)notRounding:(NSString*)price afterPoint:(NSInteger)position

{

    NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:price];
    NSDecimalNumber *numberB = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",ERC20_UnitNum]];
    
    NSDecimalNumber *numResult = [numberA decimalNumberByDividingBy:numberB];
    
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                         scale:2
                                                                                              raiseOnExactness:NO
                                                                                               raiseOnOverflow:NO
                                                                                              raiseOnUnderflow:NO
                                                                                           raiseOnDivideByZero:NO];
      
      
       NSString *tempStr =[[numResult decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
       NSLog(@"NSDecimalNumber method  rounding = %@",tempStr);
    return tempStr;

}
@end
