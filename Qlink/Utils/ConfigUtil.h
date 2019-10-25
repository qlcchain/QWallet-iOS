//
//  ConfigUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/28.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigUtil : NSObject

+ (instancetype)shareInstance;
//+ (void)setServerNetworkEnvironment:(BOOL)mainNet;
+ (BOOL)isMainNetOfServerNetwork;
+ (BOOL)isMainNetOfChainNetwork;
    
+ (NSString *)getServerDomain;
+ (NSString *)getReleaseServerDomain;
+ (NSString *)getDebugServerDomain;
+ (NSString *)getMIFI;
+ (NSString *)getChannel;

// QLC Staking
+ (NSString *)get_qlc_staking_node;

// 货币
+ (void)setLocalUsingCurrency:(NSString *)currency;
+ (NSString *)getLocalUsingCurrency;
+ (NSString *)getLocalUsingCurrencySymbol;
+ (NSArray *)getLocalCurrencyArr;
+ (NSArray *)getLocalCurrencySymbolArr;

// 密码管理(Touch/Face ID)
+ (void)setLocalTouch:(BOOL)show;
+ (BOOL)getLocalTouch;


@end
