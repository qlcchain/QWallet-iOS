//
//  DDLogUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/16.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "DDLogUtil.h"

@implementation DDLogUtil

+ (void)getDDLog {
    //获取DDLog打印的日志
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    //获取log文件夹路径
    NSString *logDirectory = [fileLogger.logFileManager logsDirectory];
    DDLogDebug(@"%@", logDirectory);
    //获取排序后的log名称
    NSArray <NSString *>*logsNameArray = [fileLogger.logFileManager sortedLogFileNames];
    DDLogDebug(@"%@", logsNameArray);
}

+ (void)getDDLogStr:(void (^)(NSString *text))block {
    __block NSString *result = @"";
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    NSString *logDirectory = [fileLogger.logFileManager logsDirectory];
    NSArray <NSString *>*logsNameArray = [fileLogger.logFileManager sortedLogFileNames];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // log文件按时间排序
        NSArray *sortArr = [logsNameArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return NSOrderedDescending;
        }];
        
        // 拼接文件log
        [sortArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *logPath = [logDirectory stringByAppendingPathComponent:obj];
            NSString *logStr = [[NSString alloc] initWithContentsOfFile:logPath encoding:NSUTF8StringEncoding error:nil];
            result = [result stringByAppendingString:logStr];
            result = [result stringByAppendingString:@"\n&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*\n"];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(result);
            }
        });
    });
}

@end
