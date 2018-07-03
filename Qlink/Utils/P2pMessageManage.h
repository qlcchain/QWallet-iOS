//
//  P2pMessageManage.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/27.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 */
static NSString *wifibasicinfoReq = @"wifibasicinfoReq";
/**
 *
 */
static NSString *wifibasicinfoRsp = @"wifibasicinfoRsp";
/**
 *
 */
static NSString *wifipasswordReq = @"wifipasswordReq";
/**
 *
 */
static NSString *wifipasswordRsp = @"wifipasswordRsp";
/**
 *
 */
static NSString *wifiCurrentWifiInfoReq = @"wifiCurrentWifiInfoReq";
/**
 *
 */
static NSString *wifiCurrentWifiInfoRsp = @"wifiCurrentWifiInfoRsp";
/**
 *wifi连接成功，没有返回
 */
static NSString *wifiConnectSuccess = @"wifiConnectSuccess";
/**
 * 发送文件的请求，这个可以不要回应
 */
static NSString *sendFileRequest = @"sendFileRequest";
/**
 * 发送vpn配置文件的请求
 */
static NSString *sendVpnFileRequest = @"sendVpnFileRequest";
/**
 * 发送心跳，可以不需要回应
 */
static NSString *heartBetSend = @"heartBetSend";
/**
 * vpn基础信息的请求
 */
static NSString *vpnBasicInfoReq = @"vpnBasicInfoReq";
/**
 * vpn基础信息的返回
 */
static NSString *vpnBasicInfoRsp = @"vpnBasicInfoRsp";
/**
 * 所有vpn资产信息的请求
 */
static NSString *allVpnBasicInfoReq = @"allVpnBasicInfoReq";
/**
 * 所有vpn资产信息的返回
 */
static NSString *allVpnBasicInfoRsp = @"allVpnBasicInfoRsp";
/**
 * vpn私钥的请求而
 */
static NSString *vpnPrivateKeyReq = @"vpnPrivateKeyReq";
/**
 * vpn私钥的返回
 */
static NSString *vpnPrivateKeyRsp = @"vpnPrivateKeyRsp";
/**
 * vpn账号和密码的请求
 */
static NSString *vpnUserAndPasswordReq = @"vpnUserAndPasswordReq";
/**
 * vpn账号和密码的返回
 */
static NSString *vpnUserAndPasswordRsp = @"vpnUserAndPasswordRsp";
/**
 * vpn或者wifi连接成功后，告诉提供端做连接记录的请求
 */
static NSString *recordSaveReq = @"recordSaveReq";
/**
 * vpn或者wifi连接成功后，告诉提供端做连接记录的返回
 */
static NSString *recordSaveRsp = @"recordSaveRsp";
/**
 * wifi使用者给提供者打赏成功的通知
 */
static NSString *gratuitySuccess = @"gratuitySuccess";
/**
 * 申请加入群聊的请求
 */
static NSString *joinGroupChatReq = @"joinGroupChatReq";
/**
 * 申请加入群聊的回复
 */
static NSString *joinGroupChatRsp = @"joinGroupChatRsp";
/**
 * 检查是否连接正常的请求，即发一个空消息过去，看对方是否会回消息
 */
static NSString *checkConnectReq = @"checkConnectReq";
/**
 * 检查是否连接正常的回复
 */
static NSString *checkConnectRsp = @"checkConnectRsp";
/**
 * 默认的返回，就是因为版本更新，当前版本没有定义这个类型，就把这个type作为内容原路返回回去
 */
static NSString *defaultRsp = @"defaultRsp";

@interface P2pMessageManage : NSObject

+ (void)handleWithMessage:(NSString *)message publickey:(NSString *)publickey;

@end
