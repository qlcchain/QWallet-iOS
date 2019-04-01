//
//  NSString+EmptyUtil.m
//  WanAiProject
//
//  Created by Jelly on 15/7/29.
//  Copyright (c) 2015年 WanAi. All rights reserved.
//

#import "NSString+EmptyUtil.h"

@implementation NSString (EmptyUtil)

- (BOOL)isEmptyString {
    BOOL empty = NO;
    if ([self isEqualToString:@""] || self == nil) {
        empty = YES;
    }
    return empty;
}

//判断字符串是否为空
- (BOOL)isBlankString {
    NSString *str = [NSString stringWithFormat:@"%@", self];
    if (str == nil || str == NULL) {
        return YES;
    }else if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }else if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) getTimeStampTimeString
{
    if ([self isEmptyString]) {
        return @"";
    }
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[self doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return  [formatter stringFromDate: date];
    
}
@end
