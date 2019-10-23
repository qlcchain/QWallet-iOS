//
//  NSNumber+Operation.h
//  NSNumberOperation
//  https://github.com/YHQiu/NSNumberOperation
//  Created by 邱弘宇 on 2018/3/3.
//  Copyright © 2018年 邱弘宇. All rights reserved.
//

/**
 * 1、适用于金融类APP等对计算精度要求的场合
 * 2、为方便代码阅读采用线性运算，不讲究运算优先级
 */

#import <Foundation/Foundation.h>

#ifndef __custom_nsnumber_operation_precisionlength_define__

/**
 计算过程中的精度
 */
//#define kPrecisionLength 6
#define kPrecisionLength NSDecimalMaxSize

/**
 比较过程中的精度
 */
//#define kComparePrecisionLength 3
#define kComparePrecisionLength NSDecimalMaxSize

#endif

#ifndef __custom_nsnumber_operation_simple_define__
/**
 计算之前将NSNumber对象包装成NSDeciamlNumber
 如:N(@12).add(@12).div(@12).mul(@12).scale2();
 ((12+12)/12)*12再格式化为2位小数
 */
#define NSD(A) [NSDecimalNumber initWithT:A]
#endif

typedef NSArray<NSNumber *> NSNumberOperationType;

@interface NSOperationNumber : NSNumber

@end

@interface NSDecimalNumber (Operation)

/**
 初始化为NSDecimal对象
 */
+ (NSDecimalNumber *)initWithT:(id)T;

/**
 等于
 */
- (BOOL (^)(NSNumber *))equal;

/**
 小于
 */
- (BOOL (^)(NSNumber *))lessThan;

/**
 小于等于
 */
- (BOOL (^)(NSNumber *))lessThanOrEqual;

/**
 大于
 */
- (BOOL (^)(NSNumber *))greaterThan;

/**
 大于等于
 */
- (BOOL (^)(NSNumber *))greaterThanOrEqual;

/**
 乘
 */
- (NSDecimalNumber* (^)(NSNumber *))mul;

/**
 除
 */
- (NSDecimalNumber* (^)(NSNumber *))div;

/**
 加
 */
- (NSDecimalNumber* (^)(NSNumber *))add;

/**
 减
 */
- (NSDecimalNumber* (^)(NSNumber *))sub;

/**
 保留小数点后2位数
 */
- (NSDecimalNumber* (^)(void))scale2;

/**
 保留小数点2位数,向下取整
 */
- (NSDecimalNumber* (^)(void))scale2D;

/**
 保留指定小数点位数,useRoundDownMode 是否向下取整
 */
- (NSDecimalNumber* (^)(int scalePoint,bool useRoundDownMode))scale;

@end


