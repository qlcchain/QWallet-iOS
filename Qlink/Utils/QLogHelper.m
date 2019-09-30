//
//  QLogHelper.m
//  Qlink
//
//  Created by Jelly Foo on 2019/9/29.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QLogHelper.h"
#import "GlobalConstants.h"
#import "NSDate+Category.h"

@implementation QLogHelper

+ (void)requestLog_saveWithClass:(NSString *)className method:(NSString *)method logStr:(NSString *)logStr {
    NSString *appName = APP_NAME;
    NSString *version = [NSString stringWithFormat:@"%@(%@)",APP_Version,APP_Build];
    //设备名称
    NSString *deviceName = [[UIDevice currentDevice] systemName];
    //手机系统版本
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    //手机型号
    NSString *phoneModel = [[UIDevice currentDevice] model];
    //地方型号  （国际化区域名称）
//    NSString *localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSString *os = @"iOS";
    NSString *deviceModel = [NSString stringWithFormat:@"%@/%@/%@",deviceName,phoneVersion,phoneModel];
    NSString *mode = className?:@"";
    NSString *operation = method?:@"";
    NSString *happenDate = [NSString stringWithFormat:@"%@",@([NSDate getTimestampFromDate:[NSDate date]]?:0)];
    NSString *log = logStr?:@"";
    NSDictionary *params = @{@"appName":appName,@"version":version,@"os":os,@"deviceModel":deviceModel,@"mode":mode,@"operation":operation,@"happenDate":happenDate,@"log":log};
    [RequestService requestWithUrl5:log_save_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([responseObject[Server_Code] integerValue] == 0) {
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

@end
