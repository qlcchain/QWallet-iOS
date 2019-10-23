//
//  NSNumber+Operation.m
//  NSNumberOperation
//  https://github.com/YHQiu/NSNumberOperation
//  Created by 邱弘宇 on 2018/3/3.
//  Copyright © 2018年 邱弘宇. All rights reserved.
//

#import "NSNumber+Operation.h"
@interface NSNumber (Compare)

/**
 比较两个Number值
 
 @param parameter1 参数一
 @param parameter2 参数二
 @param scale 保留位数
 @return NSComparisonResult对象
 */
+ (NSComparisonResult)compareForNumberHandle:(NSNumber *)parameter1 withParameter:(NSNumber *)parameter2 withScale:(short)scale;

@end

@interface NSNumber(Operation)

+ (NSDecimalNumber *)accuracyLostWithNumberHandle:(NSNumber *)value;

+ (NSDecimalNumber *)accuracyLostWithNumberHandle:(NSNumber *)value withScale:(short)scale ;

@end

@implementation NSNumber (Compare)

/**
 处理精度丢失
 
 @param value 数值
 @return 处理的字符串
 */
+ (NSDecimalNumber *)accuracyLostWithNumberHandle:(NSNumber *)value{
    return [self accuracyLostWithNumberHandle:value withScale:kPrecisionLength];
}

/**
 处理精度丢失
 
 @param value 数值
 @param scale 保留位数
 @return 处理的字符串
 */
+ (NSDecimalNumber *)accuracyLostWithNumberHandle:(NSNumber *)value withScale:(short)scale {
    if (value == nil) {
        return [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    NSNumber *handleValue = value;
    if (![handleValue isKindOfClass:[NSNumber class]]) {
        if ([handleValue isKindOfClass:[NSString class]]) {
            handleValue = [NSNumber numberWithString:(NSString *)handleValue];
        }
        else{
            NSLog(@"Number Handle_----____Warning %@,Please Check",handleValue);
#if DEBUG
            NSString *errstr = [NSString stringWithFormat:@"Number Handle_----____Warning %@,Please Check",handleValue];
            NSAssert(1,errstr);
#endif
            return [NSDecimalNumber decimalNumberWithString:@"0"];;
        }
    }
    
    NSDecimalNumberHandler *roundBankers = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *mountDecimalNumber = [[NSDecimalNumber alloc] initWithDecimal:[handleValue?:@(0) decimalValue]];
    NSDecimalNumber *dealDecimalNumber = [mountDecimalNumber decimalNumberByRoundingAccordingToBehavior:roundBankers];
    if ([dealDecimalNumber doubleValue] == NAN) {
        dealDecimalNumber = [[NSDecimalNumber alloc]initWithDouble:0];
    }
    return dealDecimalNumber;
}

/**
 比较两个Number值
 @param parameter1 参数一
 @param parameter2 参数二
 @param scale 保留位数
 @return NSComparisonResult对象
 */
+ (NSComparisonResult)compareForNumberHandle:(NSNumber *)parameter1 withParameter:(NSNumber *)parameter2 withScale:(short)scale{
    NSDecimalNumber *parameter1Number = [self accuracyLostWithNumberHandle:parameter1 withScale:scale];
    NSDecimalNumber *parameter2Number = [self accuracyLostWithNumberHandle:parameter2 withScale:scale];
    return [parameter1Number compare:parameter2Number];
}

+ (NSString *)stringByTrimWithString:(NSString *)str {
    if (nil == str) {
        return str;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [str stringByTrimmingCharactersInSet:set];
}

+ (NSNumber *)numberWithString:(NSString *)string {
    NSString *str = [[self stringByTrimWithString:string] lowercaseString];
    if (!str || !str.length) {
        return nil;
    }
    
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{@"true" :   @(YES),
                @"yes" :    @(YES),
                @"false" :  @(NO),
                @"no" :     @(NO),
                @"nil" :    [NSNull null],
                @"null" :   [NSNull null],
                @"<null>" : [NSNull null]};
    });
    id num = dic[str];
    if (num) {
        if (num == [NSNull null]) return nil;
        return num;
    }
    
    // hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) sign = 1;
    else if ([str hasPrefix:@"-0x"]) sign = -1;
    if (sign != 0) {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc)
            return [NSNumber numberWithLong:((long)num * sign)];
        else
            return nil;
    }
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

@end

@implementation NSDecimalNumber(Operation)

+ (NSDecimalNumber *)initWithT:(id)T{
    NSDecimalNumber *rNum;
    if (T) {
        if ([T isKindOfClass:[NSNumber class]]) {
            NSNumber *num = T;
            rNum = [[NSDecimalNumber alloc]initWithDecimal:[num decimalValue]];
        }
        else if ([T isKindOfClass:[NSDecimalNumber class]]){
            rNum = T;
        }
        else if ([T isKindOfClass:[NSString class]]){
            NSNumber *strNumber = [NSNumber numberWithString:T];
            rNum = [NSDecimalNumber decimalNumberWithDecimal:[strNumber decimalValue]];
        }
    }
    if (rNum == nil) {
        rNum = [[NSDecimalNumber alloc]initWithDouble:0];
    }
    if ([rNum floatValue] == NAN) {
        rNum = [[NSDecimalNumber alloc]initWithDouble:0];
    }
    return rNum;
}
- (BOOL (^)(NSNumber *))equal{
    return ^BOOL(NSNumber *value) {
        return [self equal:value];
    };
}
- (BOOL (^)(NSNumber *))lessThan{
    return ^BOOL(NSNumber *value) {
        return [self lessThan:value];
    };
}
- (BOOL (^)(NSNumber *))lessThanOrEqual{
    return ^BOOL(NSNumber *value) {
        return [self lessThanOrEqual:value];
    };
}
- (BOOL (^)(NSNumber *))greaterThan{
    return ^BOOL(NSNumber *value) {
        return [self greaterThan:value];
    };
}
- (BOOL (^)(NSNumber *))greaterThanOrEqual{
    return ^BOOL(NSNumber *value) {
        return [self greaterThanOrEqual:value];
    };
}
- (NSDecimalNumber* (^)(NSNumber *))mul{
    return ^NSDecimalNumber *(NSNumber *value) {
        return [self mul:value];
    };
}
- (NSDecimalNumber* (^)(NSNumber *))div{
    return ^NSDecimalNumber *(NSNumber *value) {
        return [self div:value];
    };
}
- (NSDecimalNumber* (^)(NSNumber *))add{
    return ^NSDecimalNumber *(NSNumber *value) {
        return [self add:value];
    };
}
- (NSDecimalNumber* (^)(NSNumber *))sub{
    return ^NSDecimalNumber *(NSNumber *value) {
        return [self sub:value];
    };
}
/**
 保留小数点2位数
 */
- (NSDecimalNumber* (^)(void))scale2{
    return ^NSDecimalNumber *(void){
        return [self scale:2 isRoundingModeDown:NO];
    };
}
/**
 保留小数点2位数,向下取整
 */
- (NSDecimalNumber* (^)(void))scale2D{
    return ^NSDecimalNumber *(void){
        return [self scale:2 isRoundingModeDown:YES];
    };
}

- (NSDecimalNumber* (^)(int scalePoint,bool useRoundDownMode))scale{
    return ^NSDecimalNumber *(int scalePoint,bool useRoundDownMode){
        return [self scale:scalePoint isRoundingModeDown:useRoundDownMode];
    };
}

- (BOOL)equal:(NSNumber *)number{
    NSComparisonResult result = [NSNumber compareForNumberHandle:self withParameter:number withScale:kComparePrecisionLength];
    if (result == NSOrderedSame) {
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL)lessThan:(NSNumber *)number{
    NSComparisonResult result = [NSNumber compareForNumberHandle:self withParameter:number withScale:kComparePrecisionLength];
    if (result == NSOrderedAscending) {
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL)lessThanOrEqual:(NSNumber *)number{
    NSComparisonResult result = [NSNumber compareForNumberHandle:self withParameter:number withScale:kComparePrecisionLength];
    if (result == NSOrderedAscending || result == NSOrderedSame) {
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL)greaterThan:(NSNumber *)number{
    NSComparisonResult result = [NSNumber compareForNumberHandle:self withParameter:number withScale:kComparePrecisionLength];
    if (result == NSOrderedDescending) {
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL)greaterThanOrEqual:(NSNumber *)number{
    NSComparisonResult result = [NSNumber compareForNumberHandle:self withParameter:number withScale:kComparePrecisionLength];
    if (result == NSOrderedDescending || result == NSOrderedSame) {
        return YES;
    }
    else{
        return NO;
    }
}

/**
 Multiple
 */
- (NSDecimalNumber *)mul:(NSNumber *)number{
    NSDecimalNumber *number1 = [NSNumber accuracyLostWithNumberHandle:self];
    NSDecimalNumber *number2 = [NSNumber accuracyLostWithNumberHandle:number];
    NSDecimalNumber *dNum = [number1 decimalNumberByMultiplyingBy:number2];
    return [[NSDecimalNumber alloc]initWithDecimal:[dNum decimalValue]];
}

/**
 Div
 */
- (NSDecimalNumber *)div:(NSNumber *)number{
    NSDecimalNumber *number1 = [NSNumber accuracyLostWithNumberHandle:self];
    NSDecimalNumber *number2 = [NSNumber accuracyLostWithNumberHandle:number];
    if (number2.equal(@(0))) {
        NSLog(@"Number Handle_----____Warning,Please Check %@ / %@",number1,number2);
#if DEBUG
        NSAssert(1, @"Number Handle_----____Warning,Please Check %@/%@",number1,number2);
#endif
        return number1;
    }
    NSDecimalNumber *dNum = [number1 decimalNumberByDividingBy:number2];
    return [[NSDecimalNumber alloc]initWithDecimal:[dNum decimalValue]];
}

/**
 Addional
 */
- (NSDecimalNumber *)add:(NSNumber *)number{
    NSDecimalNumber *number1 = [NSNumber accuracyLostWithNumberHandle:self];
    NSDecimalNumber *number2 = [NSNumber accuracyLostWithNumberHandle:number];
    NSDecimalNumber *dNum = [number1 decimalNumberByAdding:number2];
    return [[NSDecimalNumber alloc]initWithDecimal:[dNum decimalValue]];
}

/**
 Subtract
 */
- (NSDecimalNumber *)sub:(NSNumber *)number{
    NSDecimalNumber *number1 = [NSNumber accuracyLostWithNumberHandle:self];
    NSDecimalNumber *number2 = [NSNumber accuracyLostWithNumberHandle:number];
    NSDecimalNumber *dNum = [number1 decimalNumberBySubtracting:number2];
    return [[NSDecimalNumber alloc]initWithDecimal:[dNum decimalValue]];
}

//BOOL roundingModeDown = NO;//是否向下取整
- (NSDecimalNumber *)scale:(int)scale isRoundingModeDown:(BOOL)roundingModeDown{
    NSDecimalNumber *inputNumber = self;
    NSUInteger retainDecimal = scale;
    NSRoundingMode mode = NSRoundPlain;
    if (roundingModeDown) {
        mode = NSRoundDown;
        NSDecimalNumberHandler* down_roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode scale:(retainDecimal + 1) raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        inputNumber = [inputNumber decimalNumberByRoundingAccordingToBehavior:down_roundingBehavior];
    }
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *roundedOunces = [inputNumber decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return roundedOunces;
}

@end
