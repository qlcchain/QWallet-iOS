//
//  NSString+RemoveZero.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/9.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NSString+RemoveZero.h"

@implementation NSString (RemoveZero)

- (NSString *)removeFloatAllZero {
    NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:self];
    return [dn stringValue];
}

- (NSString *)show4floatStr {
    NSDecimalNumberHandler *hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:4 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *dn = [[NSDecimalNumber decimalNumberWithString:self] decimalNumberByRoundingAccordingToBehavior:hander];
    return [dn stringValue];
}

- (NSString *)showfloatStr:(NSInteger)decimal {
    NSDecimalNumberHandler *hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:decimal raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSDecimalNumber *dn = [[NSDecimalNumber decimalNumberWithString:str] decimalNumberByRoundingAccordingToBehavior:hander];
    return [dn stringValue];
}

@end
