//
//  TransferUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/27.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNMode.h"

@interface TransferUtil : NSObject

+ (void) sendFundsRequestWithType:(int)type withVPNInfo:(VPNInfo *) vpnInfo;
+ (void) sendLocalNotificationWithQLC:(NSString *) qlc isIncome:(BOOL) isIncome;

+ (void) sendGetBalanceRequest;
+ (void) startVPNConnectTran;
// 检查钱包 gas qlc 是否允许连接资产
+ (BOOL) isConnectionAssetsAllowedWithCost:(NSString *) cost;
// 获取当前连接VPN信息
+ (VPNInfo *) currentConnectVPNInfo;
+ (NSString *) currentVPNName;
+ (void) sendVPNConnectSuccessMessageWithVPNInfo:(VPNInfo *) vpnInfo withType:(NSInteger) type;
@end
