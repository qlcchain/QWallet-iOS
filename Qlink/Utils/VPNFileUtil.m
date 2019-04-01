//
//  VPNUtil.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/20.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNFileUtil.h"
#import "NEOWalletUtil.h"
#import "ToxRequestModel.h"
#import "P2pMessageManage.h"
#import "VPNMode.h"
#import "VPNOperationUtil.h"
#import "ToxRequestModel1.h"
#import "VPNDataUtil.h"

static NSString *vpnPath = @"/ios/vpn/";
@implementation VPNFileUtil

dispatch_source_t _serverTimer;

// 获取vpn存储路径
+ (NSString *) getVPNDataPath
{
    NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);// 沙盒路径
    return [library[0] stringByAppendingString:vpnPath];
}

+ (NSString *)getTempPath {
    NSString *tmpDir = NSTemporaryDirectory();
    return tmpDir;
}

/**
 获得所有vpnnames

 @return vpnnames
 */
+ (NSArray *) getAllVPNName
{
    return  [NEOWalletUtil getVPNAllName];
}

/**
 检查vpnname是否存在

 @param fileName 文件名
 @return 是否存在
 */
+ (BOOL) vpnNameIsExitWithName:(NSString *) fileName
{
    NSArray *vpnNames = [NEOWalletUtil getVPNAllName];
    if (vpnNames) {
        if ([vpnNames containsObject:fileName]){
            return YES;
        }
    }
    
    return NO;
}
/**
将vpn配置文件保存到沙盒并保存到keychain

 @param data vpn配置文件
 @param fileName vpn名字
 */
+ (void) saveVPNDataToLibrayPath:(NSData *) data withFileName:(NSString *) fileName
{
    NSString *dataPath = [VPNFileUtil getVPNDataPath];
    NSLog(@"dataPath = %@",dataPath);
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if (![fileManage fileExistsAtPath:dataPath]) {
        [fileManage createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [data writeToFile:[dataPath stringByAppendingString:fileName] atomically:YES];
    [NEOWalletUtil setDataKey:fileName Datavalue:data];
    [NEOWalletUtil setWalletkeyWithKey:VPN_FILE_KEY withWalletValue:fileName];
    
}

/**
 将keychain vpn文件 导入沙盒
 */
+ (void) keychainVPNFileToLibray
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *vpnNames = [NEOWalletUtil getVPNAllName];
        if (vpnNames && vpnNames.count > 0) {
            NSString *dataPath = [VPNFileUtil getVPNDataPath];
            NSData *data = [NSData dataWithContentsOfFile:[dataPath stringByAppendingString:vpnNames[0]]];
            if (!data){
                for (int i = 0; i<vpnNames.count; i++){
                    NSData *vpnData = [NEOWalletUtil getKeyDataValue:vpnNames[i]];
                    [VPNFileUtil saveVPNDataToLibrayPath:vpnData withFileName:vpnNames[i]];
                }
            }
        }
    });
}


// 根据文件名得到路径
+ (NSString *) getVPNPathWithFileName:(NSString *) fileName
{
    NSString *dataPath = [VPNFileUtil getVPNDataPath];
    return [dataPath stringByAppendingPathComponent:fileName];
}

+ (void) removeVPNFile
{
    NSArray *vpnNames = [NEOWalletUtil getVPNAllName];
    if (vpnNames) {
        [vpnNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [NEOWalletUtil removeChainKey:obj];
        }];
    }
}


/**
 getServerVPNFileWithServerId

 @param serverP2pId serverP2pId
 @return -1:添加好友失败   -2:好友不在线  >0 成功
 */
+ (int) getServerVPNFileWithServerId:(NSString *) serverP2pId
{
    int result = [ToxManage getFriendNumInFriendlist:serverP2pId];
    if (result < 0 && ![serverP2pId isEqualToString:[ToxManage getOwnP2PId]]) {
        // 需要添加好友
       int friendLocation =  [ToxManage addFriend:serverP2pId];
        if (friendLocation >= 0) { // 添加好友成功
             NSLog(@"添加好友成功 ---");
        } else { // 添加好友失败
             NSLog(@"添加好友失败 ---");
            return -1;
        }
    } else {
        NSLog(@"已经是好友 ---");
    }
    
    // 判断好友是否在线
    if ([ToxManage getFriendConnectionStatus:serverP2pId])  {
        return 1;
    } else {
        DDLogDebug(@"好友不在线，拿不了vpnName");
        return -2;
    }
    
    return 1;
}

/**
 vpn上报服务器
 */
+ (void) sendServerVPN {
    [VPNInfo bg_findAsync:VPNREGISTER_TABNAME where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",bg_sqlKey(@"isMainNet"),bg_sqlValue(@([ConfigUtil isMainNetOfServerNetwork])),bg_sqlKey(@"isServerVPN"),bg_sqlValue(@(1))] complete:^(NSArray * _Nullable array) {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VPNInfo *vpnInfo = (VPNInfo *)obj;
            if (!vpnInfo.isSendSuccess) {
                // 发送空消息看对方在不在线
                ToxRequestModel *model = [[ToxRequestModel alloc] init];
                model.type = checkConnectReq;
                NSString *p2pid = [ToxManage getOwnP2PId];
                NSDictionary *dataDic = @{APPVERSION:APP_Build,P2P_ID:p2pid,@"vpnServer":@"1",@"type":@(2)}; // type:0-注册  1-连接 2-vpn上报服务器
                model.data = dataDic.mj_JSONString;
                NSString *str = model.mj_JSONString;
                [ToxManage sendMessageWithMessage:str withP2pid:vpnInfo.p2pId];
                *stop = YES;
            }
        }];
    }];
}
/**
 开启vpn上报服务器定时器--1分钟执行一次
 */
+ (void) startVPNSendServerTimer
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _serverTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC); // 开始时间
    dispatch_source_set_timer(_serverTimer,dispatch_walltime(NULL, 0),60*1*NSEC_PER_SEC, 0); //每30秒执行
    dispatch_source_set_event_handler(_serverTimer, ^{
        
        [VPNFileUtil sendServerVPN];
    });
    dispatch_resume(_serverTimer);
}
/**
 改变VPN上报的状态
  */
+ (void) sendAndChangeVPNSendStatus {
    [VPNInfo bg_findAsync:VPNREGISTER_TABNAME where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",bg_sqlKey(@"isMainNet"),bg_sqlValue(@([ConfigUtil isMainNetOfServerNetwork])),bg_sqlKey(@"isServerVPN"),bg_sqlValue(@(1))] complete:^(NSArray * _Nullable array) {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VPNInfo *vpnInfo = (VPNInfo *)obj;
            if (!vpnInfo.isSendSuccess) {
                // 发送VPN给服务器
                [VPNFileUtil sendRegisterSuccessToServer:vpnInfo.p2pId vpnName:vpnInfo.vpnName vpnfileName:vpnInfo.profileLocalPath.lastPathComponent userName:vpnInfo.username password:vpnInfo.password privateKey:vpnInfo.privateKeyPassword];
                vpnInfo.isSendSuccess = YES;
                [vpnInfo bg_saveOrUpdateAsync:^(BOOL isSuccess) {
                    [VPNOperationUtil saveArrayToKeyChain];
                }];
            }
        }];
    }];
}
+ (void)sendRegisterSuccessToServer:(NSString *)toP2pId vpnName:(NSString *)vpnName vpnfileName:(NSString *)vpnfileName userName:(NSString *)userName password:(NSString *)password privateKey:(NSString *)privateKey {
    // 告诉WINQ服务器注册成功的消息
    ToxRequestModel *model = [[ToxRequestModel alloc] init];
    model.type = vpnUserPassAndPrivateKeyRsp;
    NSDictionary *dataDic = @{@"vpnName":vpnName,@"vpnfileName":vpnfileName,@"userName":userName,@"password":password,@"privateKey":privateKey};
    model.data = dataDic.mj_JSONString;
    NSString *str = model.mj_JSONString;
    str = [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"]; // 替换转义字符
    [ToxManage sendMessageWithMessage:str withP2pid:toP2pId];
}

@end
