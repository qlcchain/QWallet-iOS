//
//  VPNUtil.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/20.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPNFileUtil : NSObject

+ (void) saveVPNDataToLibrayPath:(NSData *) data withFileName:(NSString *) fileName;
// 得到所有vpn名字
+ (NSArray *) getAllVPNName;
// vpnname是否存在
+ (BOOL) vpnNameIsExitWithName:(NSString *) fileName;
// 根据文件名得到路径
+ (NSString *) getVPNPathWithFileName:(NSString *) fileName;
 //将keychain vpn文件 导入沙盒
+ (void) keychainVPNFileToLibray;

+ (int) getServerVPNFileWithServerId:(NSString *) serverP2pId;

+ (void) removeVPNFile;
+ (NSString *)getTempPath;

+ (void)sendRegisterSuccessToServer:(NSString *)toP2pId vpnName:(NSString *)vpnName vpnfileName:(NSString *)vpnfileName userName:(NSString *)userName password:(NSString *)password privateKey:(NSString *)privateKey;
/**
 改变VPN上报的状态
 */
+ (void) sendAndChangeVPNSendStatus;
/**
 开启vpn上报服务器定时器
 */
+ (void) startVPNSendServerTimer;
@end
