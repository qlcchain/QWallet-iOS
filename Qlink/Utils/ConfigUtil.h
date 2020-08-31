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

// QLC
+ (NSString *)get_qlc_node_release;
+ (NSString *)get_qlc_node_normal;

// Wraper
+ (NSString *)get_wraper_node_normal;
+ (NSString *)get_wraper_node_debug;
+ (NSString *)get_wraper_node_release;
// eth合约
+ (NSString *)get_eth_node_normal;
+ (NSString *)get_qlc_hub_node_normal;
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
