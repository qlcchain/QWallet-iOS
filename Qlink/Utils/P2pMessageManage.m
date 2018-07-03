//
//  P2pMessageManage.m
//  Qlink
//
//  Created by Jelly Foo on 2018/4/27.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "P2pMessageManage.h"
#import "ToxRequestModel.h"
#import "VPNFileUtil.h"
#import "WalletUtil.h"
#import "TransferUtil.h"
#import "ChatUtil.h"
#import "ChatModel.h"

@implementation P2pMessageManage

+ (void)handleWithMessage:(NSString *)message publickey:(NSString *)publickey {
    
    NSDictionary *messageDic = message.mj_JSONObject;
    NSString *data = messageDic[@"data"];
    NSDictionary *dataDic = data.mj_JSONObject;
    NSString *type = messageDic[@"type"];
    NSLog(@"--------------------------------type = %@-------------data = %@",type,data);
#pragma mark - 消息回复
    if ([type isEqualToString:wifibasicinfoRsp]) { //
        
    } else if ([type isEqualToString:wifipasswordRsp]) { //
        
    } else if ([type isEqualToString:wifiCurrentWifiInfoRsp]) { //
        
    } else if ([type isEqualToString:vpnBasicInfoRsp]) { // vpn基础信息的返回
        
    } else if ([type isEqualToString:allVpnBasicInfoRsp]) { // 所有vpn资产信息的返回
        
    } else if ([type isEqualToString:vpnPrivateKeyRsp]) { // vpn私钥的返回
        
    } else if ([type isEqualToString:vpnUserAndPasswordRsp]) { // vpn账号和密码的返回
        
    } else if ([type isEqualToString:recordSaveRsp]) { // vpn或者wifi连接成功后，告诉提供端做连接记录的返回
       
    } else if ([type isEqualToString:joinGroupChatRsp]) { // 申请加入群聊的回复
        
    } else if ([type isEqualToString:checkConnectRsp]) { // 检查是否连接正常的回复
        [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_CONNECT_RSP_NOTI object:nil];
    } else if ([type isEqualToString:defaultRsp]) { // 默认的返回，就是因为版本更新，当前版本没有定义这个类型，就把这个type作为内容原路返回回去
        
    }
    
#pragma mark - 消息请求
    if ([type isEqualToString:wifibasicinfoReq]) { //
        
    } else if ([type isEqualToString:wifipasswordReq]) { //
        
    } else if ([type isEqualToString:wifiCurrentWifiInfoReq]) { //
        
    } else if ([type isEqualToString:sendFileRequest]) { // 发送文件的请求，这个可以不要回应
    } else if ([type isEqualToString:sendVpnFileRequest]) { // 发送vpn配置文件的请求
        NSString *filePath = dataDic[@"filePath"];
        NSString *p2pid = dataDic[@"p2pId"];
        if (p2pid == nil || [p2pid isEmptyString]) {
            p2pid = publickey;
        }
        filePath = [VPNFileUtil getVPNPathWithFileName:filePath];
        [ToxManage sendFileWithFileName:[filePath trim] withP2pid:p2pid];
    } else if ([type isEqualToString:heartBetSend]) { // 发送心跳，可以不需要回应
        
    } else if ([type isEqualToString:vpnBasicInfoReq]) { // vpn基础信息的请求
        
    } else if ([type isEqualToString:allVpnBasicInfoReq]) { // 所有vpn资产信息的请求
        
    } else if ([type isEqualToString:vpnPrivateKeyReq]) { // vpn私钥的请求而
        
    } else if ([type isEqualToString:vpnUserAndPasswordReq]) { // vpn账号和密码的请求
        
    } else if ([type isEqualToString:recordSaveReq]) { // vpn或者wifi连接成功后，告诉提供端做连接记录的请求
        NSString *recordType = [dataDic objectForKey:@"transactiomType"];
        
//         NSDictionary *dataDic = @{@"appVersion":APP_Build,@"assetName":vpnInfo.vpnName,@"qlcCount ":vpnInfo.cost,@"p2pId":p2pid,@"transactiomType":[NSString stringWithFormat:@"%ld",(long)type],@"exChangeId":[WalletUtil getExChangeId],@"timestamp":[NSString stringWithFormat:@"%llud",[NSDate getMillisecondTimestampFromDate:[NSDate date]]]};
        
        if ([[NSStringUtil getNotNullValue:recordType] integerValue] == 3 || [[NSStringUtil getNotNullValue:recordType] integerValue] == 5) { // VPN
            [WalletUtil saveTranQLCRecordWithQlc:[NSStringUtil getNotNullValue:[dataDic objectForKey:@"qlcCount"]] txtid:[NSStringUtil getNotNullValue:[dataDic objectForKey:@"txid"]] neo:@"0" recordType:[recordType intValue]  assetName:[NSStringUtil getNotNullValue:[dataDic objectForKey:@"assetName"]] friendNum:0 p2pID:[NSStringUtil getNotNullValue:[dataDic objectForKey:@"p2pId"]] connectType:1 isReported:NO];
            // 发送本地通知
           
            [TransferUtil sendLocalNotificationWithQLC:[NSStringUtil getNotNullValue:[dataDic objectForKey:@"qlcCount"]] isIncome:YES];
        }
    } else if ([type isEqualToString:joinGroupChatReq]) { // 申请加入群聊的请求
        // 发送 申请加入群聊的回复
        ToxRequestModel *model = [[ToxRequestModel alloc] init];
        model.type = joinGroupChatRsp;
        model.data = data;
        NSString *str = model.mj_JSONString;
        [ToxManage sendMessageWithMessage:str withP2pid:publickey];
        // 邀请加入群聊
        ChatModel *chatM = [ChatUtil.shareInstance getChat:dataDic[ASSETNAME]];
        if (chatM) {
            [ToxManage inviteFriendToGroupChat:publickey groupNum:chatM.groupNum];
        } else {
            DDLogDebug(@"未找到群聊 未邀请加入群聊");
        }
    } else if ([type isEqualToString:checkConnectReq]) { // 检查是否连接正常的请求，即发一个空消息过去，看对方是否会回消息
        ToxRequestModel *model = [[ToxRequestModel alloc] init];
        model.type = checkConnectRsp;
        model.data = data;
        NSString *p2pid = dataDic[@"p2pId"];
        if (p2pid == nil || [p2pid isEmptyString]) {
            p2pid = publickey;
        }
        NSString *str = model.mj_JSONString;
        [ToxManage sendMessageWithMessage:str withP2pid:p2pid];
    }
}

@end
