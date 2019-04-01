//
//  NSStringUtil.m
//  Qlink
//
//  Created by 旷自辉 on 2018/3/29.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "NSStringUtil.h"

@implementation NSStringUtil

+ (NSString *)getNotNullValue:(NSString *)str
{
    if (str == nil) {
        str = @"";
    }
    return str;
}
@end
