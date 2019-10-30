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
- (NSString *)showfloatStrWith2Decimal;
//+ (double)doubleFormString:(NSString *)str;
//+ (NSString*)stringFromDouble:(double)doubleVal;

@end

NS_ASSUME_NONNULL_END
