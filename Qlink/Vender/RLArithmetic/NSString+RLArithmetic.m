//
//  NSString+RLArithmetic.m
//  精确计算
//
//  Created by LLZ on 2016/11/22.
//  Copyright © 2016年 LLZ. All rights reserved.
//

#import "NSString+RLArithmetic.h"

#ifdef DEBUG
#define RLLog(...) NSLog(__VA_ARGS__)
#else
#define RLLog(...) do { } while (0)
#endif

#define CheckNaN(num) [num isEqual:[NSDecimalNumber notANumber]]
#define CheckZero(num) [num isEqual:[NSDecimalNumber zero]]

@implementation NSString (UCSDecimalNumber)

static NSDecimalNumber *firNum;
static NSDecimalNumber *secNum;
static NSDecimalNumber *result;
static NSDecimalNumber *tempNum;

- (NSString *(^)(id))itself
{
    //返回一个block
    return ^NSString *(id num) {
        //转换成功才进行后面的操作
        if (!(secNum = [self decimalNumberWithNum:num])) return [[NSDecimalNumber notANumber] stringValue];
        
        if (CheckNaN(secNum)) {
            RLLog(@"RLArithmetic--NaN:(%@)", num);
            return ErrorResult;
        } else {
            return [secNum stringValue];
        }
    };
}

- (NSString *(^)(id))add
{
    //返回一个block
    return ^NSString *(id num) {
        //转换成功才进行后面的操作
        if (!(firNum = [self decimalNumberWithNum:self])) return [[NSDecimalNumber notANumber] stringValue];
        if (!(secNum = [self decimalNumberWithNum:num])) return [[NSDecimalNumber notANumber] stringValue];
        
        if (CheckNaN(firNum) || CheckNaN(secNum)) {
            RLLog(@"RLArithmetic--NaN:(%@).add(%@)", self, num);
            return ErrorResult;
        }
        result = [firNum decimalNumberByAdding:secNum];
        return [result stringValue];
    };
}

- (NSString *(^)(id))sub
{
    //返回一个block
    return ^NSString *(id num) {
        //转换成功才进行后面的操作
        if (!(firNum = [self decimalNumberWithNum:self])) return [[NSDecimalNumber notANumber] stringValue];
        if (!(secNum = [self decimalNumberWithNum:num])) return [[NSDecimalNumber notANumber] stringValue];
        
        if (CheckNaN(firNum) || CheckNaN(secNum)) {
            RLLog(@"RLArithmetic--NaN:(%@).sub(%@)", self, num);
            return ErrorResult;
        }
        result = [firNum decimalNumberBySubtracting:secNum];
        return [result stringValue];
    };
}

- (NSString *(^)(id))mul
{
    //返回一个block
    return ^NSString *(id num) {
        //转换成功才进行后面的操作
        if (!(firNum = [self decimalNumberWithNum:self])) return [[NSDecimalNumber notANumber] stringValue];
        if (!(secNum = [self decimalNumberWithNum:num])) return [[NSDecimalNumber notANumber] stringValue];
        
        if (CheckNaN(firNum) || CheckNaN(secNum)) {
            RLLog(@"RLArithmetic--NaN:(%@).mul(%@)", self, num);
            return ErrorResult;
        }
        NSDecimalNumber *result = [firNum decimalNumberByMultiplyingBy:secNum];
        return [result stringValue];
    };
}

- (NSString *(^)(id))div
{
    //返回一个block
    return ^NSString *(id num) {
        //转换成功才进行后面的操作
        if (!(firNum = [self decimalNumberWithNum:self])) return [[NSDecimalNumber notANumber] stringValue];
        if (!(secNum = [self decimalNumberWithNum:num])) return [[NSDecimalNumber notANumber] stringValue];
        
        if (CheckNaN(firNum) || CheckNaN(secNum)) {
            RLLog(@"RLArithmetic--NaN:(%@).div(%@)", self, num);
            return ErrorResult;
        } else if (CheckZero(secNum)) {
            RLLog(@"Divisor cannot be zero:(%@).div(%@)", self, num);
            return ErrorResult;
        }
        NSDecimalNumber *result = [firNum decimalNumberByDividingBy:secNum];
        return [result stringValue];
    };
}

- (NSString *(^)(short))roundPlain
{
    //返回一个block
    return ^NSString *(short scale) {
        firNum = [self decimalNumberWithNum:self];
        if (firNum == nil) return [[NSDecimalNumber notANumber] stringValue];
        if (CheckNaN(firNum)) {
            RLLog(@"roundPlain--NaN:%@", self);
            return ErrorResult;
        }
        return [firNum roundingWithMode:NSRoundPlain scale:scale];
    };
}

- (NSString *(^)(short))roundPlainWithZeroFill
{
    //返回一个block
    return ^NSString *(short scale) {
        firNum = [self decimalNumberWithNum:self];
        if (firNum == nil) return [[NSDecimalNumber notANumber] stringValue];
        if (CheckNaN(firNum)) {
            RLLog(@"roundPlainWithZeroFill--NaN:%@", self);
            return ErrorResult;
        }
        
        return [firNum roundingZeroFillWithMode:NSRoundPlain scale:scale];
    };
}

- (NSString *(^)(short))formatToThousandsWithRoundPlain
{
    return ^NSString *(short scale) {
        firNum = [self decimalNumberWithNum:self];
        if (firNum == nil) return [[NSDecimalNumber notANumber] stringValue];
        if (CheckNaN(firNum)) {
            RLLog(@"formatToThousandsWithRoundPlain--NaN:%@", self);
            return ErrorResult;
        }
        
        return [firNum formatToThousandsWithRoundingMode:NSRoundPlain scale:scale];
    };
}

- (NSString *(^)(short))roundUp
{
    //返回一个block
    return ^NSString *(short scale) {
        firNum = [self decimalNumberWithNum:self];
        if (firNum == nil) return [[NSDecimalNumber notANumber] stringValue];
        if (CheckNaN(firNum)) {
            RLLog(@"roundUp--NaN:%@", self);
            return ErrorResult;
        }
        
        return [firNum roundingWithMode:NSRoundUp scale:scale];
    };
}
- (NSString *(^)(short))roundUpWithZeroFill
{
    //返回一个block
    return ^NSString *(short scale) {
        firNum = [self decimalNumberWithNum:self];
        if (firNum == nil) return [[NSDecimalNumber notANumber] stringValue];
        if (CheckNaN(firNum)) {
            RLLog(@"roundUpWithZeroFill--NaN:%@", self);
            return ErrorResult;
        }
        
        return [firNum roundingZeroFillWithMode:NSRoundUp scale:scale];
    };
}

- (NSString *(^)(short))formatToThousandsWithRoundUp
{
    return ^NSString *(short scale) {
        firNum = [self decimalNumberWithNum:self];
        if (firNum == nil) return [[NSDecimalNumber notANumber] stringValue];
        if (CheckNaN(firNum)) {
            RLLog(@"formatToThousandsWithRoundUp--NaN:%@", self);
            return ErrorResult;
        }
        
        return [firNum formatToThousandsWithRoundingMode:NSRoundUp scale:scale];
    };
}

- (NSString *(^)(short))roundDown
{
    //返回一个block
    return ^NSString *(short scale) {
        firNum = [self decimalNumberWithNum:self];
        if (firNum == nil) return [[NSDecimalNumber notANumber] stringValue];
        if (CheckNaN(firNum)) {
            RLLog(@"roundDown--NaN:%@", self);
            return ErrorResult;
        }
        
        return [firNum roundingWithMode:NSRoundDown scale:scale];
    };
}
- (NSString *(^)(short))roundDownWithZeroFill
{
    //返回一个block
    return ^NSString *(short scale) {
        firNum = [self decimalNumberWithNum:self];
        if (firNum == nil) return [[NSDecimalNumber notANumber] stringValue];
        if (CheckNaN(firNum)) {
            RLLog(@"roundDownWithZeroFill--NaN:%@", self);
            return ErrorResult;
        }
        
        return [firNum roundingZeroFillWithMode:NSRoundDown scale:scale];
    };
}
- (NSString *(^)(short))formatToThousandsWithRoundDown
{
    return ^NSString *(short scale) {
        firNum = [self decimalNumberWithNum:self];
        if (firNum == nil) return [[NSDecimalNumber notANumber] stringValue];
        if (CheckNaN(firNum)) {
            RLLog(@"formatToThousandsWithRoundDown--NaN:%@", self);
            return ErrorResult;
        }
        
        return [firNum formatToThousandsWithRoundingMode:NSRoundDown scale:scale];
    };
}

- (RLComparisonResult (^)(id))compare
{
    //返回一个block
    return ^RLComparisonResult (id num){
        //转换成功才进行后面的操作
        if (!(firNum = [self decimalNumberWithNum:self])) return RLNaNError;
        if (!(secNum = [self decimalNumberWithNum:num])) return RLNaNError;
        if (CheckNaN(firNum) || CheckNaN(secNum)) {
            RLLog(@"compare--NaN:(%@)compare(%@)", self, num);
            return RLNaNError;
        }
        return (NSInteger)[firNum compare:secNum];
    };
}

#pragma mark ------------------------------------------------------------
#pragma mark 私有方法
//转NSDecimalNumber
- (NSDecimalNumber *)decimalNumberWithNum:(id)num
{
    if ([num isKindOfClass:[NSString class]]) {
        if ([num isEqualToString:ErrorResult]) {//如果传进来的是约定的ErrorResult，就返回nil，后面计算步骤省去
            tempNum = nil;
        } else {
            tempNum = [NSDecimalNumber decimalNumberWithString:num];
        }
    } else if ([num isKindOfClass:[NSNumber class]]) {
        tempNum = [NSDecimalNumber decimalNumberWithDecimal:[num decimalValue]];
    } else {
        tempNum = [NSDecimalNumber notANumber];
    }
    return tempNum;
}

@end

#pragma mark ------------------------------------------------------------
#pragma mark 用于格式化的分类方法实现
@implementation NSDecimalNumber (Round)

- (NSString *)roundingWithMode:(NSRoundingMode)mode scale:(short)scale
{
    NSDecimalNumberHandler *handel = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:mode scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    return [self decimalNumberByRoundingAccordingToBehavior:handel].stringValue;//小数末尾有零自动省略
}

- (NSString *)roundingZeroFillWithMode:(NSRoundingMode)mode scale:(short)scale
{
    NSString *result = [self roundingWithMode:mode scale:scale];
    NSString *format = [NSString stringWithFormat:@"%%.%df", scale];
    [NSString stringWithFormat:format, result.doubleValue];
    return [NSString stringWithFormat:format, result.doubleValue];//小数末尾有零的话会补零
}

- (NSString *)formatToThousandsWithRoundingMode:(NSRoundingMode)mode scale:(short)scale
{
    NSString *formatterStr = nil;
    if (scale > 0) {
        NSString *str = @".";
        for (int i = scale; i > 0; i --) {
            str = [str stringByAppendingString:@"0"];//小数末尾有零的话会补零
//            str = [str stringByAppendingString:@"#"];//小数末尾有零自动省略
        }
        formatterStr = [NSString stringWithFormat:@"###,##0%@;", str];
    } else {
        formatterStr = @"###,##0;";
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;//四舍五入的小数
    if (mode == NSRoundDown) numberFormatter.roundingMode = kCFNumberFormatterRoundDown;
    if (mode == NSRoundUp) numberFormatter.roundingMode = kCFNumberFormatterRoundUp;
    [numberFormatter setPositiveFormat:formatterStr];
    
    return [numberFormatter stringFromNumber:self];
}
@end
