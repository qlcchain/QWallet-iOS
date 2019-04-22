//
//  ConfigUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ConfigUtil.h"

@implementation ConfigUtil

+ (BOOL)isMainNetOfServerNetwork {
//    return YES;
    return NO;
}
    
+ (NSDictionary *)getConfig {
    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *serverNetwork = [HWUserdefault getStringWithKey:SERVER_NETWORK];
    NSString *path = @"";
    if (![ConfigUtil isMainNetOfServerNetwork]) {
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

+ (void)setLocalUsingCurrency:(NSString *)currency {
    [HWUserdefault insertObj:currency withkey:Local_Currency];
}

+ (NSString *)getLocalUsingCurrency {
    NSString *currency = [HWUserdefault getObjectWithKey:Local_Currency];
    if (![currency isKindOfClass:[NSString class]]) {
        return @"USD";
    }
    return currency?:@"USD";
}

+ (NSString *)getLocalUsingCurrencySymbol {
    NSString *currency = [ConfigUtil getLocalUsingCurrency];
    NSInteger index = [[ConfigUtil getLocalCurrencyArr] indexOfObject:currency];
    return [ConfigUtil getLocalCurrencySymbolArr][index];
}

+ (NSArray *)getLocalCurrencyArr {
    return @[@"USD",@"CNY"];
}

+ (NSArray *)getLocalCurrencySymbolArr {
    return @[@"$",@"￥"];
}

+ (void)setLocalTouch:(BOOL)show {
    [HWUserdefault insertObj:@(show) withkey:Local_Show_Touch];
}

+ (BOOL)getLocalTouch {
    
    return YES;
    
    NSNumber *localTouch = [HWUserdefault getObjectWithKey:Local_Show_Touch]?:@(YES);
    if (![localTouch isKindOfClass:[NSNumber class]]) {
        localTouch = @(YES);
    }
    return [localTouch boolValue];
}

@end
