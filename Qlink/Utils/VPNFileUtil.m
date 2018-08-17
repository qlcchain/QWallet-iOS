//
//  VPNUtil.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/20.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "VPNFileUtil.h"
#import "WalletUtil.h"
#import "ToxRequestModel.h"
#import "P2pMessageManage.h"

static NSString *vpnPath = @"/ios/vpn/";
@implementation VPNFileUtil


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
    return  [WalletUtil getVPNAllName];
}

/**
 检查vpnname是否存在

 @param fileName 文件名
 @return 是否存在
 */
+ (BOOL) vpnNameIsExitWithName:(NSString *) fileName
{
    NSArray *vpnNames = [WalletUtil getVPNAllName];
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
    [WalletUtil setDataKey:fileName Datavalue:data];
    [WalletUtil setWalletkeyWithKey:VPN_FILE_KEY withWalletValue:fileName];
    
}

/**
 将keychain vpn文件 导入沙盒
 */
+ (void) keychainVPNFileToLibray
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *vpnNames = [WalletUtil getVPNAllName];
        if (vpnNames && vpnNames.count > 0) {
            NSString *dataPath = [VPNFileUtil getVPNDataPath];
            NSData *data = [NSData dataWithContentsOfFile:[dataPath stringByAppendingString:vpnNames[0]]];
            if (!data){
                for (int i = 0; i<vpnNames.count; i++){
                    NSData *vpnData = [WalletUtil getKeyDataValue:vpnNames[i]];
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
    NSArray *vpnNames = [WalletUtil getVPNAllName];
    if (vpnNames) {
        [vpnNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [WalletUtil removeChainKey:obj];
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
   BOOL isFriend = [ToxManage getFriendNumInFriendlist:serverP2pId];
    if (!isFriend && ![serverP2pId isEqualToString:[ToxManage getOwnP2PId]]) {
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
        
        ToxRequestModel *model = [[ToxRequestModel alloc] init];
        model.type = sendVpnFileRequest;
        NSDictionary *tempDic = @{VPN_NAME:@"", @"filePath":@""};
        model.data = tempDic.mj_JSONString;
        NSString *str = model.mj_JSONString;
        [ToxManage sendMessageWithMessage:str withP2pid:serverP2pId];
        
    } else {
        return -2;
    }
    
    return 1;
}

@end
