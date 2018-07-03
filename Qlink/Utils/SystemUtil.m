//
//  SystemUtil.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/11.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "SystemUtil.h"
#import "Qlink-Swift.h"

@implementation SystemUtil

+ (NSString *) uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    
    CFRelease(uuid_ref);
    
    CFRelease(uuid_string_ref);
    
    NSString *stringWithoutQuotation = [[uuid lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return stringWithoutQuotation;
    
}

/**
 获取时间戳

 @return 时间戳
 */
+ (NSString *) getTimeInterval
{
   NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f",timeInterval];
}

/**
 app退出时。配置
 */
+ (void) configureAPPTerminate {
    
//    NSLog(@"applicationState = %ld",(long)[UIApplication sharedApplication].applicationState);
    
    if (![SystemUtil isSpecialDevice]) {
        // 断开vpn连接
        [VPNUtil.shareInstance stopVPN];
        // 删除vpn本地配置
        [VPNUtil.shareInstance removeFromPreferences];
        // 删除当前VPNInfo
        [HWUserdefault deleteObjectWithKey:Current_Connenct_VPN];
    }
    
    [ToxManage readDataToKeychain];
    // 结束p2p连接
   // if ([ToxManage getP2PConnectionStatus]) {
    //    [ToxManage endP2PConnection];
   // }
}

+ (BOOL)isSpecialDevice {
//    NSString *deviceName = [UIDevice currentDevice].name;
//    NSArray *dadaArr = @[@"JellyFoo I7"];
//    NSArray *dadaArr = @[];
//    return [dadaArr containsObject:deviceName];
    return NO;
}

@end
