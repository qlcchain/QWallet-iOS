//
//  ConfigUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ConfigUtil.h"

@implementation ConfigUtil
    
+ (NSDictionary *)getConfig {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *serverNetwork = [HWUserdefault getStringWithKey:SERVER_NETWORK];
    NSString *path = @"";
    if ([serverNetwork isEqualToString:@"0"]) {
       path = [bundle pathForResource:@"ConfigurationDebug" ofType:@"plist"];
    } else {
        path = [bundle pathForResource:@"ConfigurationRelease" ofType:@"plist"];
    }
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:path];
    return config;
}

+ (NSString *)getServerDomain {
    NSDictionary *config = [ConfigUtil getConfig];
    NSString *serverDomain = config[@"ServerDomain"];
//    NSLog(@"配置文件url = %@",serverDomain);
    return serverDomain;
}
    
+ (NSString *)getMIFI {
    NSDictionary *config = [ConfigUtil getConfig];
    NSString *mifi = config[@"MIFI"];
    return mifi;
}

+ (NSString *)getChannel {
    NSDictionary *config = [ConfigUtil getConfig];
    NSString *channel = config[@"Channel"];
    return channel;
}

@end
