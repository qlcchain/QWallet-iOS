//
//  TransferUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/27.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "TransferUtil.h"
#import "WalletUtil.h"
#import "ToxRequestModel.h"
#import "P2pMessageManage.h"
#import "Qlink-Swift.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"
#import "HistoryRecrdInfo.h"


int requestCont = 0;

dispatch_source_t _timer;

@implementation TransferUtil

/**
 获取当前连接vpn

 @return vpn
 */
+ (VPNInfo *) currentConnectVPNInfo
{
    //
    NEVPNStatus status = [VPNUtil.shareInstance vpnConnectStatus];
    if (status != NEVPNStatusConnected) {
        [HWUserdefault deleteObjectWithKey:Current_Connenct_VPN];
        return nil;
    }
    NSDictionary *dc = [HWUserdefault getObjectWithKey:Current_Connenct_VPN];
    if (dc) {
        return [VPNInfo getObjectWithKeyValues:dc];
    }
    return nil;
}

/**
 获取当前连接vpn name

 @return vpn name
 */
+ (NSString *) currentVPNName
{
    VPNInfo *connectInfo = [TransferUtil currentConnectVPNInfo];
    if (connectInfo) {
        return connectInfo.vpnName;
    }
    return @"";
}

/**
 开启vpn连接定时扣费
 */
+ (void) startVPNConnectTran
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC); // 开始时间
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),60.0*NSEC_PER_SEC, 0); //每60秒执行
    dispatch_source_set_event_handler(_timer, ^{
        [TransferUtil sendFundsRequestWithType:3 withVPNInfo:[TransferUtil currentConnectVPNInfo]];
    });
    dispatch_resume(_timer);
}

/**
 是否可以连接资产

 @return 是。不是
 */
+ (BOOL) isConnectionAssetsAllowedWithCost:(NSString *)cost
{
    BOOL isConnect = NO;
    if (AppD.balanceInfo) {
        if ([AppD.balanceInfo.gas floatValue] > 0.00000001 && [AppD.balanceInfo.qlc floatValue] >= [cost floatValue]) {
            isConnect = YES;
        }
    }
    return isConnect;
}
/**
 交易 qlc 请求
 @param type 交易类型
 @param vpnInfo vpnInfo
 */
+ (void) sendFundsRequestWithType:(int)type withVPNInfo:(VPNInfo *) vpnInfo {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!vpnInfo) {
            NSLog(@"当前没有连接VPN");
            return;
        }
        
        if (type == 3) { // vpn连接自己时不用扣费
            if ([[CurrentWalletInfo getShareInstance].address isEqualToString:vpnInfo.address]) {
                return;
            } else {
                // 获取vpn上次连接时间
                NSString *connectTime = [HWUserdefault getStringWithKey:vpnInfo.vpnName];
                if (![[NSStringUtil getNotNullValue:connectTime] isEmptyString]) {
                    // 判断上次连接时间 超过一时间扣费
                    NSDateFormatter *dateFormatrer = [NSDateFormatter defaultDateFormatter];
                    NSDate *backDate = [dateFormatrer dateFromString:connectTime];
                    // 判断日期相隔时间
                    NSInteger hours = [[NSDate date] hoursAfterDate:backDate];
                    //超过一时间扣费
                    if (labs(hours) < 1) {
                        return;
                    }
                }
            }
        }
        // type =3 vpn连接
        if (type == 3) {
            // 是否有足够资产连接VPN
            if ([TransferUtil isConnectionAssetsAllowedWithCost:vpnInfo.cost]) {
                // 保存最后VPN连接扣费时间
                NSString *enterBackTime = [[NSDate date] formattedDateYearYueRi:@"yyyy-MM-dd HH:mm:ss"];
                [HWUserdefault insertString:enterBackTime withkey:vpnInfo.vpnName];
                
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [TransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:type];
                });
            } else {
                // 断开VPN连接
                [[VPNUtil shareInstance] stopVPN];
            }
        } else if (type == 6) { // type =6 vpn注册
            [TransferUtil sendTranAddressRequestWithVPNInfo:vpnInfo withType:type];
        } else if (type == 5) { //type =5 vpn抢注
            // 发送交易
            [TransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:type];
        }
    });
    
    
}

+ (void ) vpnConnectTranReqeustWithVpnInfo:(VPNInfo *) vpnInfo tranType:(int) type
{
    //@weakify_self
    NSString *tokenHash = AESSET_TEST_HASH;
    if ([WalletUtil checkServerIsMian]) {
        tokenHash = AESSET_MAIN_HASH;
    }
    
    vpnInfo.recordId = [WalletUtil getExChangeId];
    
    __block int tranType = type;
    [WalletManage.shareInstance3 sendQLCWithAddressWithIsQLC:true address:[NSStringUtil getNotNullValue:vpnInfo.address] tokeHash:tokenHash qlc:vpnInfo.cost completeBlock:^(NSString *complete) {
        
        if ([[NSStringUtil getNotNullValue:complete] isEmptyString]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DDLogDebug(@"转账失败：%@",NSStringLocalizable(@"send_qlc"));
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [TransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:tranType];
                });
            });
        } else {
            
            // 发送交易请求
            NSNumber *typeNum = @(3);
            NSDictionary *parames = @{@"recordId":[NSStringUtil getNotNullValue:vpnInfo.recordId],@"assetName":vpnInfo.vpnName,@"type":typeNum,@"addressFrom":[CurrentWalletInfo getShareInstance].address ,@"tx":complete,@"qlc":vpnInfo.cost,@"fromP2pId":[NSStringUtil getNotNullValue:[ToxManage getOwnP2PId]],@"addressTo":[NSStringUtil getNotNullValue:vpnInfo.address],@"toP2pId":[NSStringUtil getNotNullValue:vpnInfo.p2pId]};
            if (tranType == 6 || tranType == 5) { // 注册 抢注vpn转账
                typeNum = @(1);
                parames = @{@"recordId":[NSStringUtil getNotNullValue:vpnInfo.recordId],@"type":typeNum,@"addressFrom":[CurrentWalletInfo getShareInstance].address ,@"tx":complete,@"qlc":vpnInfo.cost,@"addressTo":[NSStringUtil getNotNullValue:vpnInfo.address]};
            }

            [RequestService requestWithUrl:transTypeOperate_Url params:parames httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
                [AppD.window hideHud];
                if ([[responseObject objectForKey:Server_Code] integerValue] == 0){
                    NSDictionary *dataDic = [responseObject objectForKey:@"data"];
                    if (dataDic) {
                        BOOL result = [[dataDic objectForKey:@"operationResult"] boolValue];
                        if (result) { // 交易成功
                            if (tranType == 3 || tranType == 5) { // vpn连接
                                //TODO:转账成功之后发p2p消息告诉接收者
                                [TransferUtil sendVPNConnectSuccessMessageWithVPNInfo:vpnInfo withType:type];
                            }
                            if (tranType == 6) {
                                tranType = 5;
                            }
                            // 获取当前资产
                            [TransferUtil sendGetBalanceRequest];
                            // 发送扣款通知
                            [TransferUtil sendLocalNotificationWithQLC:vpnInfo.cost isIncome:NO];
                            [WalletUtil saveTranQLCRecordWithQlc:vpnInfo.cost txtid:[NSStringUtil getNotNullValue:vpnInfo.recordId] neo:@"0" recordType:tranType assetName:vpnInfo.vpnName friendNum:0 p2pID:[NSStringUtil getNotNullValue:vpnInfo.p2pId] connectType:0 isReported:NO];
                        } else {
                            DDLogDebug(@"转账失败：%@",NSStringLocalizable(@"send_qlc"));
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [TransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:tranType];
                            });
                        }
                    } else {
                        DDLogDebug(@"转账失败：%@",NSStringLocalizable(@"send_qlc"));
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [TransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:tranType];
                        });
                    }
                } else {
                    DDLogDebug(@"转账失败：%@",NSStringLocalizable(@"send_qlc"));
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [TransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:tranType];
                    });
                }
                
            } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
                DDLogDebug(@"转账失败：%@",NSStringLocalizable(@"send_qlc"));
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [TransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:tranType];
                });
            }];
        }
        
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [AppD.window hideHud];
//            if (!complete) {
//                DDLogDebug(@"转账失败：%@",NSStringLocalizable(@"send_qlc"));
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [TransferUtil vpnConnectTranReqeustWithVpnInfo:vpnInfo tranType:tranType];
//                });
//            } else {
//                if (tranType == 3 || tranType == 5) { // vpn连接
//                    //TODO:转账成功之后发p2p消息告诉接收者
//                    [TransferUtil sendVPNConnectSuccessMessageWithVPNInfo:vpnInfo withType:type];
//                }
//                if (tranType == 6) {
//                    tranType = 5;
//                }
//                // 获取当前资产
//                [TransferUtil sendGetBalanceRequest];
//                // 发送扣款通知
//                [TransferUtil sendLocalNotificationWithQLC:vpnInfo.cost isIncome:NO];
//                [WalletUtil saveTranQLCRecordWithQlc:vpnInfo.cost txtid:@"" neo:@"0" recordType:tranType assetName:vpnInfo.vpnName friendNum:0 p2pID:@"" connectType:0 isReported:NO];
//            }
//        });
    }];
}

/**
 获取注册vpn时扣费地址

 @param info 注册vpninfo
 @param type 操作类型
 */
+ (void) sendTranAddressRequestWithVPNInfo:(VPNInfo *) info withType:(int) type
{
    // 获取NEO交换地址
    [RequestService requestWithUrl:mainAddress_Url params:@[] httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        if (dataDic) {
            NSString *toAddress = [dataDic objectForKey:@"address"];
            info.address = toAddress;
            // 发送交易
            [TransferUtil vpnConnectTranReqeustWithVpnInfo:info tranType:type];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [TransferUtil sendTranAddressRequestWithVPNInfo:info withType:type];
            });
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [TransferUtil sendTranAddressRequestWithVPNInfo:info withType:type];
        });
    }];
}



#pragma -mark 获取资产
+ (void) sendGetBalanceRequest
{
    [RequestService requestWithUrl:getTokenBalance_Url params:@{@"address":[CurrentWalletInfo getShareInstance].address} httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dataDic = [responseObject objectForKey:Server_Data];
            if(dataDic)  {
                AppD.balanceInfo= [BalanceInfo mj_objectWithKeyValues:dataDic];
            }
        } else {
            DDLogDebug(@"获取资产失败");
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        DDLogDebug(@"获取资产失败：%@",error.description);
        requestCont ++;
        if (requestCont <2) {
             [TransferUtil sendGetBalanceRequest];
        } else {
            requestCont = 0;
        }
        
    }];
}

#pragma -mark 连接成功后，发消息给提供方记录
+ (void) sendVPNConnectSuccessMessageWithVPNInfo:(VPNInfo *) vpnInfo withType:(NSInteger) type
{
    
    // 发送获取配置文件消息
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = recordSaveReq;
    NSString *p2pid = [ToxManage getOwnP2PId];
   
    NSDictionary *dataDic = @{@"appVersion":APP_Build,@"assetName":vpnInfo.vpnName,@"qlcCount ":vpnInfo.cost,@"p2pId":p2pid,@"transactiomType":[NSString stringWithFormat:@"%ld",(long)type],@"exChangeId":[NSStringUtil getNotNullValue:vpnInfo.recordId],@"timestamp":[NSString stringWithFormat:@"%llud",[NSDate getMillisecondTimestampFromDate:[NSDate date]]],@"txid":[NSStringUtil getNotNullValue:vpnInfo.recordId]};
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    [ToxManage sendMessageWithMessage:str withP2pid:vpnInfo.p2pId];
}

#pragma -mark 设置本地通知

/**
 发送本地通知

 @param qlc qlc
 @param isIncome 是否是收入
 */
+ (void) sendLocalNotificationWithQLC:(id) qlc isIncome:(BOOL) isIncome {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    UNMutableNotificationContent *notiContent = [[UNMutableNotificationContent alloc] init];
    
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:.5 repeats:NO];
    
    NSString *qlcCount = [NSString stringWithFormat:@"%.2f",[qlc floatValue]];
                                                
    NSString *alertBody = [NSString stringWithFormat:@"%@ %@ qlc",NSStringLocalizable(@"spending"),qlcCount];
    NSString *alertTitle = NSStringLocalizable(@"spend_account");
    if (isIncome) {
        alertBody = [NSString stringWithFormat:@"%@ %@ qlc",NSStringLocalizable(@"income"),qlcCount];
        alertTitle = NSStringLocalizable(@"into_account");
    }
    notiContent.title = [NSString localizedUserNotificationStringForKey:alertTitle arguments:nil];
    notiContent.body =  [NSString localizedUserNotificationStringForKey:alertBody arguments:nil];
    notiContent.userInfo = @{@"type":@"1",@"qlc":qlcCount,@"title":alertTitle,@"body":alertBody};
    // 执行通知注册
    
     UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"sendQLC" content:notiContent trigger:trigger1];
    
    [center addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"error = %@",error);
    }];
}


@end
