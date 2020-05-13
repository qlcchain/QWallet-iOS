//
//  NSString+RemoveZero.h
//  Qlink
//
//  Created by Jelly Foo on 2018/11/9.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSNumber+RemoveZero.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (RemoveZero)

//- (NSString*)removeFloatAllZero;
- (NSString *)show4floatStr;
- (NSString *)showfloatStr:(NSInteger)decimal;
- (NSString *)showfloatStr_Defi:(NSInteger)decimal;
- (BOOL)isBiggerAndEqual:(NSString *)compareStr;
- (BOOL)isSmallerAndEqual:(NSString *)compareStr;
//- (NSString *)showfloatStrWith2Decimal;
//+ (double)doubleFormString:(NSString *)str;
//+ (NSString*)stringFromDouble:(double)doubleVal;

/** 有关浮点型数据，后台传字符串的格式，防止丢失精度。*/
/** 直接传入精度丢失有问题的Double类型*/
+ (NSString *)doubleToString:(double)doubleV;

@end

NS_ASSUME_NONNULL_END
