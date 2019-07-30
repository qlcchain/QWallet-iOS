//
//  TransferUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/27.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPNMode.h"

// 连接vpn扣费
@interface NeoTransferUtil : NSObject

@property (nonatomic , strong) NSMutableArray *vpnList;
@property (nonatomic, strong) NSString *neoMainAddress;

+ (instancetype) getShareObject;

//+ (void) sendFundsRequestWithType:(int)type withVPNInfo:(VPNInfo *) vpnInfo;
+ (void) sendLocalNotificationWithQLC:(NSString *) qlc isIncome:(BOOL) isIncome;
+ (void) sendGetBalanceRequest;
+ (void) startVPNConnectTran;
// 检查钱包 gas qlc 是否允许连接资产
+ (BOOL) isConnectionAssetsAllowedWithCost:(NSString *) cost;
// 获取当前连接VPN信息
+ (VPNInfo *) currentConnectVPNInfo;
+ (NSString *) currentVPNName;
+ (void) sendVPNConnectSuccessMessageWithVPNInfo:(VPNInfo *) vpnInfo withType:(NSInteger) type;
+ (void)udpateTransferModel:(VPNInfo *) vpnInfo;
//将本地及当前VPNList中的连接VPN状态置为NO
+ (void) updateUserDefaultVPNListCurrentVPNConnectStatus;
//pragma mark - 获取免费连接次数
+ (void) checkFreeConnectCount;

@end
