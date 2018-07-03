//
//  ToxManage.m
//  Qlink
//
//  Created by 旷自辉 on 2018/4/17.
//  Copyright © 2018年 pan. All rights reserved.
//


#import "WalletUtil.h"
#import "NSDateFormatter+Category.h"
#import "NSDate+Category.h"
#import "FriendStatusModel.h"
#import "VPNFileUtil.h"
#import "P2pMessageManage.h"
#import "ChatUtil.h"
#import "GroupChatMessageModel.h"
#import "SystemUtil.h"

@interface ToxManage ()

@property (nonatomic, copy) NSString *vpnLocalPathName;

@end

@implementation ToxManage

NSString *sendFileDataStr = @""; // 接收vpn文件

static ToxManage *toxManage = nil;
+ (instancetype) shareMange  {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (toxManage == nil) {
            toxManage = [[self alloc] init];
            setcallback(friendStatusChange, selfStatusChange, messageProcess, fileProcess, groupChatMessageProcess, sendGroupNum, getJson, getPath);
        }
    });
    return toxManage;
}

/**
 创建p2b网络
 
 @param dataPath int
 */
+ (void)createdP2PNetwork
{
    char *dataPath = [[ToxManage getToxDataPath] UTF8String];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @try {
            CreatedP2PNetwork(dataPath);
        } @catch (NSException *exception) {
            DDLogDebug(@"CreatedP2PNetwork crash : %@",exception);
        } @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SystemUtil configureAPPTerminate];
            });
        }
    });
}

// 获取data存储路径
+ (NSString *) getToxDataPath
{
    NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES); // 沙盒路径
    return [library[0] stringByAppendingString:@"/"];
}

/**
 读取沙盒data 存储到keychain
 */
+ (void) readDataToKeychain
{
   NSString *dataPath = [[ToxManage getToxDataPath] stringByAppendingString:toxPath];
   NSData *data = [NSData dataWithContentsOfFile:dataPath];
    if (data) {
        [WalletUtil setDataKey:DATA_KEY Datavalue:data];
    }
}

/**
 读取keychaindata 存储到沙盒
 */
+ (void) readKeychainToLibary
{
    // 如果本地没有则从keychain读取
    NSString *dataPath = [[ToxManage getToxDataPath] stringByAppendingString:toxPath];
    NSData *libData = [NSData dataWithContentsOfFile:dataPath];
   
    if (!libData) {
        DDLogDebug(@"----本地没有data文件----");
        NSData *data = [WalletUtil getKeyDataValue:DATA_KEY];
        if (data) {
            NSString *dataPath = [[ToxManage getToxDataPath] stringByAppendingString:toxPath];
            [data writeToFile:dataPath atomically:YES];
            DDLogDebug(@"----keychain有data文件----");
        } else {
            DDLogDebug(@"----keychain没有data文件----");
        }
    } else {
        DDLogDebug(@"----本地有data文件----");
    }
}

/**
 获取自己连接状态

 @return 好友状态
 ** 1如果qlinkNode无效。
 * * 0不连接
 ** 1连接p2p网络，TCP。
 ** 2接入p2p网络，UDP。
 */
+ (BOOL) getP2PConnectionStatus
{
    int result = GetP2PConnectionStatus();
    if (result > 0) {
        return YES;
    }
    return NO;
    
}

/**
 结束p2p_network
 当app退出或停止p2p网络时，将调用它。
 */
+ (void) endP2PConnection
{
    EndP2PConnection();
}


/**
 调用这个函数来获得我们自己的点对点ID，和lenth TOX_ADDRESS_SIZE(38字节)

 @param ownp2pid 自己p2pid
 @return 自己的点对点ID
 */
+ (NSString *) getOwnP2PId;
{
    NSString *p2pid = [WalletUtil getKeyValue:P2P_KEY];
   // DDLogDebug(@"p2pid = %@",p2pid);
    if ([[NSStringUtil getNotNullValue:p2pid] isEmptyString]) {
        char p2pId[38*2+1];
        int result =ReturnOwnP2PId(&p2pId);
        if (result == 0) {
            p2pid = [NSString stringWithUTF8String:p2pId];
            [WalletUtil setKeyValue:P2P_KEY value:p2pid];
        } else {
            return @"";
        }
    }
    return p2pid;
    
//    NSString *p2pid = @"";
//    char p2pId[38*2+1];
//    int result =ReturnOwnP2PId(&p2pId);
//    if (result == 0) {
//        p2pid = [NSString stringWithUTF8String:p2pId];
//        [WalletUtil setKeyValue:P2P_KEY value:p2pid];
//         DDLogDebug(@"data-p2pid = %@",p2pid);
//    } else {
//        p2pid = [WalletUtil getKeyValue:P2P_KEY];
//         DDLogDebug(@"keychain-p2pid = %@",p2pid);
//    }
//    return [NSStringUtil getNotNullValue:p2pid];
    
}

/**
 添加好友

 @param friendp2pid 好友p2pid
 @return -1 qlinkNode是无效的。
        -2无效的friendid地址。
        num是朋友列表中朋友的位置，例如，如果这是第一个朋友，num是0，第二个朋友，num是1。
 */
+ (int) addFriend:(NSString *) friendp2pid
{
   return AddFriend([friendp2pid UTF8String]);
}

/**
 获取好友数量

 @return -1 qlinkNode是无效的。
            friendnum > = 0
 */
+ (int) getNumOfFriends
{
    return GetNumOfFriends();
/**
 输入friendnum (0 ~ (friendnum1))并获取好友的pubKey。
 Pubkey 32字节长，它只是朋友p2p ID的前32字节

 @param int 好友号码
 @return    ** 0获得pubkey。
            ** -1 qlinkNode是无效的。
            ** -2无效输入好友num。
            ** -3无效的pubKey地址。
 */
}
+ (NSString *) getFriendP2PPublicKey:(NSString *)p2pid
{
    char friendPublicKey[32];
    int result = GetFriendP2PPublicKey([p2pid UTF8String],&friendPublicKey);
    if (result == 0) {
        return [NSString stringWithUTF8String:friendPublicKey];
    }
    return @"";
}

/**
 输入好友ID并让好友num返回。
 ** app从区块链上获得朋友点对点ID后，app可以调用这个函数得到friendnum。
 **朋友num在其他函数中可能非常有用。

 @param friendid 入好友ID
 @return    ** -1 qlinkNode是无效的。
            ** -2无效输入friendId。
            ** -3朋友不在名单上。
            ** >=0好友num。
 */
+ (int) getFriendNumInFriendlist:(NSString *) friendid
{
    return GetFriendNumInFriendlist([friendid UTF8String]);
}

/**
 获取好友状态

 @param friendnum 好友号码
 @return    ** 0 not connected
            ** 1 tcp connected
            ** 2 udp connected
 */
+ (BOOL) getFriendConnectionStatus:(NSString *)p2pid
{
    
    int result = GetFriendConnectionStatus([p2pid UTF8String]);
    if (result > 0) {
        return YES;
    }
    return NO;
}

/**
 给朋友发信息

 @param message 发送内容
 @param friendNum 好友号码
 @return    * * 0 SendRequest ok
            ** -1 qlinkNode无效。
            ** -2信息无效。
            * * 3 friend_not_valid
 */
+ (int) sendMessageWithMessage:(NSString *) message withP2pid:(NSString *)p2pid
{
    DDLogDebug(@"发送SendRequest：message=%@ p2pid:%@",message,p2pid);
    return  SendRequest([p2pid UTF8String], [message UTF8String]);
}


/**
 给朋友发文件
 
 @param fileName 发送文件路径
 @param friendNum 好友号码
 @return   ** >0 文件发送ok。
            ** -1 qlinkNode无效。
            ** -2文件名无效。
            ** -3 friendnum无效。
            ** -4文件打开失败。
            ** -5文件发送失败。
 */
+ (int) sendFileWithFileName:(NSString *) fileName withP2pid:(NSString *)p2pid
{
    int result = Addfilesender([p2pid UTF8String], [fileName UTF8String]);
    DDLogDebug(@"发送文件路径 = %d",result);
    return result;
}

/**
 创建群组
 @return    * * groupnum:创建成功
            ** -1:qlinkNode无效。
            * * -2:创建失败
 */
+ (int) createdNewGroupChat
{
    return CreatedNewGroupChat();
}

/**
 邀请好友加入群组

 @param friendnum 好友号码
 @param groupNum 群主号码
 @return    0:成功邀请
            -1:qlinkNode无效。
            -2:邀请失败
            -3 friendnum无效。
 */
+ (int) inviteFriendToGroupChat:(NSString *)p2pid groupNum:(int) groupNum
{
    int result = InviteFriendToGroupChat([p2pid UTF8String], groupNum);
    return result;
}

/**
 发送消息到群组

 @param groupNum 群组号码
 @param message 发送消息
 @return   0:发送消息成功。
    -1:qlinkNode无效。
    -2:消息为空。
    -3发送消息失败。
 */
+ (int) sendMessageToGroupChat:(int) groupNum message:(NSString *) message
{
    return SendMessageToGroupChat(groupNum, [message UTF8String]);
}

/**
 删除所有好友

 @return    0 success
            -1 qlinkNode not valid
            -2 delete fail
 */
+ (int) deleteFriendAll
{
    return DeleteFriendAll();
}


#pragma mark - p2p回调c方法

/**
 当好友状态改变时，这个回调函数会触发。
 @param friendnum 好友的号码
 @param status 好友的状态
 @return int
 */
int friendStatusChange (char *publickey,uint32_t status)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        FriendStatusModel *friendStatusM = [[FriendStatusModel alloc] init];
        friendStatusM.publickey = [NSString stringWithUTF8String:publickey];
        friendStatusM.status = status;
        [[NSNotificationCenter defaultCenter] postNotificationName:FRIEND_STATUS_CHANGE_NOTI object:friendStatusM];
    });
    
    return 1;
}
/* 当自我状态改变时，这个回调函数会触发。
   ios app需要定义这个功能的具体实现，
   和调用setcallback func将方法传递给c代码。
   状态:自我状态 */


/**
 当自己状态改变时，这个回调函数会触发

 @param status 自己状态
 @return int
 */
int selfStatusChange (uint32_t status)
{
//    NSString *p2pid = [ToxManage getOwnP2PId];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:P2P_ONLINE_NOTI object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:P2P_OFFLINE_NOTI object:nil];
        }
    });
    return 1;
}

/**
 当收到朋友的信息时，这个函数会被调用。

 @param message 具体的消息
 @param publickey 朋友的号码
 @return int
 */
int messageProcess (char *message,char *publickey)
{
    NSString *messageStr = [NSString stringWithUTF8String:message];
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLogDebug(@"收到message:%@ friendnum:%s",messageStr,publickey);
        [P2pMessageManage handleWithMessage:messageStr publickey:[NSString stringWithUTF8String:publickey]];
    });
    return 1;
}

/**
 该函数在收到文件时调用。

 @param filename 文件路径
 @param filesize 文件大小
 @param friendnum 好友号码
 @return int
 */
int fileProcess (char *filename, int filesize,char * publickey)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLogDebug(@"收到file:%s filesize:%i publickey:%s",filename,filesize,publickey);
        
        // 连接收到的线上vpn
        NSString *vpnPath = ToxManage.shareMange.vpnLocalPathName;
        NSData *vpnData = [NSData dataWithContentsOfFile:vpnPath];
        // 连接本地vpn
//        NSURL *vpnURL = [[NSBundle mainBundle] URLForResource:@"winqvpn" withExtension:@"ovpn"];
//        NSData *vpnData = [NSData dataWithContentsOfURL:vpnURL];
        if (vpnData && vpnData.length > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_VPN_FILE_NOTI object:vpnData];
        }
        //判断文件是否存在和删除文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:vpnPath]) {
            NSError *error = nil;
            if ([fileManager removeItemAtPath:vpnPath error:&error]) {
                DDLogDebug(@"移除文件成功%@",vpnPath);
            } else {
                DDLogDebug(@"移除文件失败%@",error.localizedDescription);
            }
        }
    });
    return 1;
}

/**
 当收到群组聊天信息时，该函数将被调用。

 @param name 发送消息的人的姓名
 @param message 发送消息
 @param groupnum 群组号码
 @return int
 */
int groupChatMessageProcess (char *name,const uint8_t *message, int groupnum)
{
    GroupChatMessageModel *model = [GroupChatMessageModel new];
    model.name = [NSString stringWithUTF8String:name];
    model.message = [NSString stringWithUTF8String:message];
    model.groupnum = groupnum;
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLogDebug(@"收到groupChatMessage:%@ name:%@ groupnum:%lu",model.message,model.name,(unsigned long)model.groupnum);
        if (model.message == nil || model.message.length <= 0) {
            DDLogDebug(@"收到群聊空消息");
            return;
        }
        if (model.message) {
            NSDictionary *messageDic = model.message.mj_JSONObject;
            NSString *p2pId = [ToxManage getOwnP2PId];
            if ([p2pId isEqualToString:messageDic[@"p2pId"]]) { // 收到自己发送的消息不用处理
                return;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:GROUP_CHAT_MESSAGE_NOTI object:model];
    });
    return 1;
}

/**
 当你被邀请参加一个小组时，这个功能就会被调用。

 @param groupnum 群组号码
 @return int
 */
int sendGroupNum (int groupnum)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DDLogDebug(@"收到邀请加入群聊sendGroupNum  groupnum:%i",groupnum);
        [[NSNotificationCenter defaultCenter] postNotificationName:P2P_JOINGROUP_NOTI object:@(groupnum)];
    });
    return 1;
}

/**
 在连接p2p引导之前需要调用这个func，
 您需要访问“https://nodes.tox.chat/json”。聊天/ json”得到json
 
 @param json json
 @return int
 */
char *getJson ()
//int getJson (char *json)
{
   char *json = (char *) [[ToxManage getToxJson] UTF8String];
   return json;
}

/**
 <#Description#>

 @param oldfilepathname <#oldfilepathname description#>
 @param newfilepathname <#newfilepathname description#>
 @return <#return value description#>
 */
char *getPath (char *oldfilepathname) {
    NSString *sourceName = ToxManage.shareMange.vpnSourceName;
    NSString *oldName = @"";
    NSString *newPathName = @"";
    if (sourceName) {
        oldName = [[sourceName componentsSeparatedByString:@"/"] lastObject]?:@"";
        newPathName = [[VPNFileUtil getTempPath] stringByAppendingPathComponent:oldName];
        ToxManage.shareMange.vpnLocalPathName = newPathName;
    }
    oldfilepathname = (char *)[sourceName UTF8String];
    char *newfilepathname = (char *)[newPathName UTF8String];
    DDLogDebug(@"oldfilepathname=%s  \nnewfilepathname=%s",oldfilepathname,newfilepathname);
    return newfilepathname;
}

/**
 获取本地tox.json

 @return json
 */
+ (NSString *) getToxJsonWithjsonPath:(NSString *) jsonPath
{
   return [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
}

+ (NSString *) getToxJson
{
    
   NSString *jsonPath = [[ToxManage getToxDataPath] stringByAppendingString:@"tox.json"];
    NSString *jsonStr = [ToxManage getToxJsonWithjsonPath:jsonPath];
    if (jsonStr && ![jsonStr isEmptyString]) {
        return jsonStr;
    } else {
        jsonPath = [[NSBundle mainBundle] pathForResource:@"tox" ofType:@"json"];
        return [ToxManage getToxJsonWithjsonPath:jsonPath];
    }
}

+ (void) sendReqeuestToxJson
{
    BOOL isRequest = NO;
    NSDate *backDate = [HWUserdefault getObjectWithKey:JSON_REQUEST_TIME_KEY];
    if (backDate) {
        // 判断日期相隔时间
        NSInteger dayCount = [[NSDate date] daysAfterDate:backDate];
        if (labs(dayCount) >= 7) {
            isRequest = YES;
        }
    } else {
        isRequest = YES;
    }
    
    if (isRequest) {
        // 记录请求时间
        [HWUserdefault insertObj:[NSDate date] withkey:JSON_REQUEST_TIME_KEY];
        
        [RequestService requestWithJsonUrl:jsonURL params:@{} httpMethod:HttpMethodGet successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
            if (responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
                NSString *toxjson = [responseObject mj_JSONString];
                if (toxjson && ![toxjson isEmptyString]) {
                    NSString *jsonPath = [[ToxManage getToxDataPath] stringByAppendingString:@"tox.json"];
                    NSError *error;
                    [toxjson writeToFile:jsonPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                }
            }
        } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
            
        }];
    }
}

+ (NSString *) encrypt:(NSString *) encryptStr
{
    char tempChar[encryptStr.length];
    strcpy(tempChar,(char *)[encryptStr UTF8String]);
    char *encryptChar = AES(tempChar, 0);
    NSString *encryptResult = [[NSString alloc] initWithUTF8String:encryptChar];
  //  free(encryptChar);
    return encryptResult;
}

+ (NSString *) dencrypt:(NSString *) dencryptStr
{
    char tempChar[dencryptStr.length];
    strcpy(tempChar,(char *)[dencryptStr UTF8String]);
    char *dencryptChar =  AES(tempChar, 1);
//    char t[64];
//    strncpy(t,0,63);
//    NSString *dencryptResult = [[NSString alloc] initWithUTF8String:t];
    NSString *dencryptResult = [[NSString alloc] initWithUTF8String:dencryptChar];
    //free(dencryptChar);
    return dencryptResult;
}
@end
