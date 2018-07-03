//
//  NSString+EmptyUtil.h
//  WanAiProject
//
//  Created by Jelly on 15/7/29.
//  Copyright (c) 2015年 WanAi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EmptyUtil)

- (BOOL)isEmptyString;
- (BOOL)isBlankString;
- (NSString *)trim;;
// 时间戳 转换成 当前时间
- (NSString *) getTimeStampTimeString;
@end
