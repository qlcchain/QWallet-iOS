//
//  NSNumber+RemoveZero.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/19.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NSNumber+RemoveZero.h"

@implementation NSNumber (RemoveZero)

- (NSString *)show4floatStr {
    NSDecimalNumberHandler *hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:4 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSDecimalNumber *dn = [[NSDecimalNumber decimalNumberWithString:str] decimalNumberByRoundingAccordingToBehavior:hander];
    return [dn stringValue];
}

- (NSString *)showfloatStr:(NSNumber *)decimal {
    NSDecimalNumberHandler *hander = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:[decimal integerValue] raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSDecimalNumber *dn = [[NSDecimalNumber decimalNumberWithString:str] decimalNumberByRoundingAccordingToBehavior:hander];
    return [dn stringValue];
}

@end
