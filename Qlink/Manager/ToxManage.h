//
//  ToxManage.h
//  Qlink
//
//  Created by 旷自辉 on 2018/4/17.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ToxFramework/ToxFramework.h>

static NSString *toxPath = @"data";
static NSString *jsonURL = @"https://nodes.tox.chat/json";

typedef void (^HTTPRequestSuccessBlock)(NSString *jsonStr);

@interface ToxManage : NSObject

@property (nonatomic, copy) NSString *vpnSourceName;

+ (instancetype) shareMange;

// 读取沙盒data 存储到keychain
+ (void) readDataToKeychain;

// 读取keychaindata 存储到沙盒
+ (void) readKeychainToLibary;
/**
 创建p2p网络

 @param dataPath data路径
 */
+ (void) createdP2PNetwork;

// 检查自己是否连接到p2p网络。
+ (BOOL) getP2PConnectionStatus;

// 结束p2p连接
+ (void) endP2PConnection;
// 获得我们自己的p2pID
+ (NSString *) getOwnP2PId;
// 添加好友
+ (int) addFriend:(NSString *) friendp2pid;
// 得到好友数量
+ (int) getNumOfFriends;
// 获取好友的pubKey
+ (NSString *) getFriendP2PPublicKey:(NSString *)p2pid;
// 根据好友id 获取好友num
+ (int) getFriendNumInFriendlist:(NSString *) friendid;
// 得到好友连接状态
+ (BOOL) getFriendConnectionStatus:(NSString *)p2pid;


// 发送消息
+ (int) sendMessageWithMessage:(NSString *) message withP2pid:(NSString *)p2pid;
// 发送文件
+ (int) sendFileWithFileName:(NSString *) fileName withP2pid:(NSString *)p2pid;
// 创建群组
+ (int) createdNewGroupChat;
// 邀请好友加入群组
+ (int) inviteFriendToGroupChat:(NSString *)p2pid groupNum:(int) groupNum;
// 发送消息到群组
+ (int) sendMessageToGroupChat:(int) groupNum message:(NSString *) message;
// 删除所有好友
+ (int) deleteFriendAll;
// 发送json请求
+ (void) sendReqeuestToxJson;
+ (NSString *) encrypt:(NSString *) encryptStr;
+ (NSString *) dencrypt:(NSString *) dencryptStr;
@end
