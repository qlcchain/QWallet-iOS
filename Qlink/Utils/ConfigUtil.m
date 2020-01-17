//
//  ConfigUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ConfigUtil.h"
#import "GlobalConstants.h"

@interface ConfigUtil ()

//@property (nonatomic, strong) NSNumber *mainNet;

@end

@implementation ConfigUtil

+ (instancetype)shareInstance {
    static dispatch_once_t pred = 0;
    __strong static ConfigUtil *sharedObj  = nil;
    dispatch_once(&pred, ^{
        sharedObj = [[self alloc] init];
    });
    return sharedObj;
}

//+ (void)setServerNetworkEnvironment:(BOOL)mainNet {
//    [ConfigUtil shareInstance].mainNet = @(mainNet);
//}

+ (BOOL)isMainNetOfServerNetwork {
    NSString *environment = [HWUserdefault getObjectWithKey:QLCServer_Environment];
    if (environment == nil || [environment integerValue] == 1) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isMainNetOfChainNetwork {
    NSString *environment = [HWUserdefault getObjectWithKey:QLCChain_Environment];
    if (environment == nil || [environment integerValue] == 1) {
        return YES;
    } else {
        return NO;
    }
}
    
+ (NSDictionary *)getConfig {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = @"";
    if ([ConfigUtil isMainNetOfServerNetwork]) {
        path = [bundle pathForResource:@"ConfigurationRelease" ofType:@"plist"];
    } else {
        path = [bundle pathForResource:@"ConfigurationDebug" ofType:@"plist"];
    }
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:path];
    return config;
}

+ (NSDictionary *)getReleaseConfig {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"ConfigurationRelease" ofType:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:path];
    return config;
}

+ (NSDictionary *)getDebugConfig {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"ConfigurationDebug" ofType:@"plist"];
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:path];
    return config;
}

+ (NSString *)getServerDomain {
    NSDictionary *config = [ConfigUtil getConfig];
    NSString *serverDomain = config[@"ServerDomain"];
//    NSLog(@"配置文件url = %@",serverDomain);
    return serverDomain;
}

+ (NSString *)getReleaseServerDomain {
    NSDictionary *config = [ConfigUtil getReleaseConfig];
    NSString *serverDomain = config[@"ServerDomain"];
    return serverDomain;
}

+ (NSString *)getDebugServerDomain {
    NSDictionary *config = [ConfigUtil getDebugConfig];
    NSString *serverDomain = config[@"ServerDomain"];
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

+ (NSString *)get_qlc_staking_node {
    NSDictionary *config = [ConfigUtil getConfig];
    NSString *channel = config[@"qlc_staking_node"];
    return channel;
}

+ (NSString *)get_qlc_node {
    NSDictionary *config = [ConfigUtil getReleaseConfig];
    NSString *channel = config[@"qlc_node"];
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
