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
#import "DBManageUtil.h"
#import "Qlink-Swift.h"
#import "VPNDataUtil.h"

@implementation P2pMessageManage

+ (void)handleWithMessage:(NSString *)message publickey:(NSString *)publickey {
    
    NSDictionary *messageDic = message.mj_JSONObject;
    NSString *data = messageDic[@"data"];
    NSDictionary *dataDic = data.mj_JSONObject;
    NSString *type = messageDic[@"type"];
   // NSLog(@"--------------------------------type = %@-------------data = %@",type,data);
#pragma mark - 消息回复
    if ([type isEqualToString:wifibasicinfoRsp]) { //
        
    } else if ([type isEqualToString:wifipasswordRsp]) { //
        
    } else if ([type isEqualToString:wifiCurrentWifiInfoRsp]) { //
        
    } else if ([type isEqualToString:vpnBasicInfoRsp]) { // vpn基础信息的返回
        
    } else if ([type isEqualToString:allVpnBasicInfoRsp]) { // 所有vpn资产信息的返回
        
    } else if ([type isEqualToString:sendVpnFileRsp]) { // winq server获取VPN文件
        
        if (dataDic) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *vpnFileName = [dataDic objectForKey:@"vpnfileName"];
                NSString *dataStr = [dataDic objectForKey:@"fileData"];
                NSData *fileData = nil;
                if (dataStr) {
                    fileData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
                }
                if (![[NSStringUtil getNotNullValue:vpnFileName] isEmptyString]) {
                    NSArray *keys = [VPNDataUtil.shareInstance.vpnDataDic allKeys];
                    if (!keys || keys.count == 0) {
                        if (fileData) {
                            [VPNDataUtil.shareInstance.vpnDataDic setObject:fileData forKey:vpnFileName];
                        }
                    } else {
                        if ([keys containsObject:vpnFileName]) {
                            if (fileData) {
                                NSMutableData *vpnData = [NSMutableData dataWithData:[VPNDataUtil.shareInstance.vpnDataDic objectForKey:vpnFileName]];
                                [vpnData appendData:fileData];
                                [VPNDataUtil.shareInstance.vpnDataDic setObject:vpnData forKey:vpnFileName];
                            }
                        } else {
                            if (fileData) {
                                [VPNDataUtil.shareInstance.vpnDataDic setObject:fileData forKey:vpnFileName];
                            }
                        }
                    }
                }
            });
        } else {
             NSLog(@"allVpnBasicInfoRsp = %@------%@-------%zd",dataDic,[VPNDataUtil shareInstance].vpnDataDic,[VPNDataUtil shareInstance].vpnDataDic.count);
        }
        
       
    } else if ([type isEqualToString:vpnPrivateKeyRsp]) { // vpn私钥的返回
        NSString *privateKey = dataDic[@"privateKey"];
        VPNUtil.shareInstance.vpnPrivateKey = privateKey;
        [[NSNotificationCenter defaultCenter] postNotificationName:Receive_PrivateKey_Noti object:nil];
    } else if ([type isEqualToString:vpnUserAndPasswordRsp]) { // vpn账号和密码的返回
//        NSString *vpnName = dataDic[@"vpnName"];
        NSString *userName = dataDic[@"userName"];
        NSString *password = dataDic[@"password"];
        VPNUtil.shareInstance.vpnUserName = userName;
        VPNUtil.shareInstance.vpnPassword = password;
        [[NSNotificationCenter defaultCenter] postNotificationName:Receive_UserPass_Noti object:nil];
    } else if ([type isEqualToString:vpnUserPassAndPrivateKeyRsp]) { // vpn账号和密码和私钥的返回
        //        NSString *vpnName = dataDic[@"vpnName"];
        NSString *userName = dataDic[@"userName"];
        NSString *password = dataDic[@"password"];
        NSString *privateKey = dataDic[@"privateKey"];
        VPNUtil.shareInstance.vpnUserName = userName;
        VPNUtil.shareInstance.vpnPassword = password;
        VPNUtil.shareInstance.vpnPrivateKey = privateKey;
        [[NSNotificationCenter defaultCenter] postNotificationName:Receive_UserPass_PrivateKey_Noti object:nil];
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
//        NSString *p2pid = dataDic[P2P_ID];
//        if (p2pid == nil || [p2pid isEmptyString]) {
//            p2pid = publickey;
//        }
        filePath = [VPNFileUtil getVPNPathWithFileName:filePath];
        [ToxManage sendFileWithFileName:[filePath trim] withP2pid:publickey];
    } else if ([type isEqualToString:heartBetSend]) { // 发送心跳，可以不需要回应
        
    } else if ([type isEqualToString:vpnBasicInfoReq]) { // vpn基础信息的请求
        
    } else if ([type isEqualToString:allVpnBasicInfoReq]) { // 所有vpn资产信息的请求
        
    } else if ([type isEqualToString:vpnPrivateKeyReq]) { // vpn私钥的请求而
        NSString *vpnName = dataDic[VPN_NAME]?:@"";
        NSString *isMainNet = dataDic[IS_MAINNET]?:@"0";
        VPNInfo *vpnInfo = [DBManageUtil getVpnInfo:vpnName isMainNet:isMainNet];
        if (!vpnInfo) {
            return;
        }
        NSString *privateKey = vpnInfo.privateKeyPassword?:@"";
        
        ToxRequestModel *model = [[ToxRequestModel alloc] init];
        model.type = vpnPrivateKeyRsp;
        NSDictionary *tempDic = @{VPN_NAME:vpnName, @"privateKey":privateKey};
        model.data = tempDic.mj_JSONString;
        NSString *str = model.mj_JSONString;
        [ToxManage sendMessageWithMessage:str withP2pid:publickey];
    } else if ([type isEqualToString:vpnUserAndPasswordReq]) { // vpn账号和密码的请求
        NSString *vpnName = dataDic[VPN_NAME]?:@"";
        NSString *isMainNet = dataDic[IS_MAINNET]?:@"0";
        VPNInfo *vpnInfo = [DBManageUtil getVpnInfo:vpnName isMainNet:isMainNet];
        if (!vpnInfo) {
            return;
        }
        NSString *userName = vpnInfo.username?:@"";
        NSString *password = vpnInfo.password?:@"";
        
        ToxRequestModel *model = [[ToxRequestModel alloc] init];
        model.type = vpnUserAndPasswordRsp;
        NSDictionary *tempDic = @{VPN_NAME:vpnName, @"userName":userName, @"password":password};
        model.data = tempDic.mj_JSONString;
        NSString *str = model.mj_JSONString;
        [ToxManage sendMessageWithMessage:str withP2pid:publickey];
    } else if ([type isEqualToString:vpnUserPassAndPrivateKeyReq]) { // vpn账号和密码和私钥的请求
        NSString *vpnName = dataDic[VPN_NAME]?:@"";
        NSString *isMainNet = dataDic[IS_MAINNET]?:@"0";
        VPNInfo *vpnInfo = [DBManageUtil getVpnInfo:vpnName isMainNet:isMainNet];
        if (!vpnInfo) {
            return;
        }
        NSString *userName = vpnInfo.username?:@"";
        NSString *password = vpnInfo.password?:@"";
        NSString *privateKey = vpnInfo.privateKeyPassword?:@"";
        
        ToxRequestModel *model = [[ToxRequestModel alloc] init];
        model.type = vpnUserPassAndPrivateKeyRsp;
        NSDictionary *tempDic = @{VPN_NAME:vpnName, @"userName":userName, @"password":password, @"privateKey":privateKey};
        model.data = tempDic.mj_JSONString;
        NSString *str = model.mj_JSONString;
        [ToxManage sendMessageWithMessage:str withP2pid:publickey];
    } else if ([type isEqualToString:recordSaveReq]) { // vpn或者wifi连接成功后，告诉提供端做连接记录的请求
        // 通知提供端收到记录
        ToxRequestModel *model = [[ToxRequestModel alloc] init];
        model.type = recordSaveRsp;
        NSDictionary *rspDicc = @{TX_ID:[NSStringUtil getNotNullValue:[dataDic objectForKey:TX_ID]],SUCCESS:@"1"};
        model.data = rspDicc.mj_JSONString;
        NSString *str = model.mj_JSONString;
        [ToxManage sendMessageWithMessage:str withP2pid:publickey];
        
        NSString *recordType = [dataDic objectForKey:@"transactiomType"];
        if ([[NSStringUtil getNotNullValue:recordType] integerValue] == 3 || [[NSStringUtil getNotNullValue:recordType] integerValue] == 5) { // VPN
            
             NSString *netStr = [dataDic objectForKey:IS_MAINNET]?:@"0";
            /**
             同步查询所有数据.  去重复
             */
            NSArray* finfAlls = [HistoryRecrdInfo bg_find:HISTORYRECRD_TABNAME where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",bg_sqlKey(@"txid"),bg_sqlValue([NSStringUtil getNotNullValue:[dataDic objectForKey:TX_ID]]),bg_sqlKey(@"isMainNet"),bg_sqlValue(@([netStr boolValue]))]];
            if (finfAlls && finfAlls.count > 0) {
                return;
            }
            BOOL isMain = [netStr boolValue];
            [WalletUtil saveTranQLCRecordWithQlc:[NSStringUtil getNotNullValue:[dataDic objectForKey:QLC_COUNT]] txtid:[NSStringUtil getNotNullValue:[dataDic objectForKey:TX_ID]] neo:@"0" recordType:[recordType intValue]  assetName:[NSStringUtil getNotNullValue:[dataDic objectForKey:ASSETS_NAME]] friendNum:0 p2pID:[NSStringUtil getNotNullValue:publickey] connectType:1 isReported:NO isMianNet:isMain];
            // 发送本地通知
            [TransferUtil sendLocalNotificationWithQLC:[NSStringUtil getNotNullValue:[dataDic objectForKey:QLC_COUNT]] isIncome:YES];
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
        NSString *fromP2pid = [ToxManage getOwnP2PId];
        NSDictionary *dataDic = @{APPVERSION:APP_Build,P2P_ID:fromP2pid};
        model.data = dataDic.mj_JSONString;
//        model.data = data;
//        NSString *toP2pid = dataDic[@"p2pId"];
//        if (toP2pid == nil || [toP2pid isEmptyString]) {
//            toP2pid = publickey;
//        }
        NSString *str = model.mj_JSONString;
        [ToxManage sendMessageWithMessage:str withP2pid:publickey];
    }
}

@end
