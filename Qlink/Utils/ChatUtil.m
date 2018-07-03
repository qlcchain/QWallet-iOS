//
//  ChatUtil.m
//  Qlink
//
//  Created by Jelly Foo on 2018/5/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "ChatUtil.h"
#import "ChatModel.h"
#import "VPNMode.h"
#import "ToxManage.h"
#import "GroupChatMessageModel.h"
//#import "ChatMessage.h"
#import "ZXMessageModel.h"
#import "UserManage.h"

@interface ChatUtil ()

@property (nonatomic, strong) NSMutableArray *chatArr;

@end

@implementation ChatUtil

+ (instancetype)shareInstance {
    static id shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObject = [[self alloc] init];
        [shareObject addObserve];
    });
    return shareObject;
}

- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p2pOnline:) name:P2P_ONLINE_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinGroup:) name:P2P_JOINGROUP_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupChatMessage:) name:GROUP_CHAT_MESSAGE_NOTI object:nil];
}

#pragma mark - Operation
static BOOL createGroupOnce = YES;
- (void)createGroup {
    @weakify_self
    if (createGroupOnce) {
        createGroupOnce = NO;
        
        _chatArr = [NSMutableArray array];
        // 获取VPN资产
        NSArray *vpnArr = [VPNInfo bg_findAll:VPNREGISTER_TABNAME];
        // 创建群聊model
        [vpnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VPNInfo *vpnInfo = obj;
            NSUInteger groupNum = [ToxManage createdNewGroupChat];
            ChatModel *chatM = [ChatModel new];
            chatM.groupNum = groupNum;
            chatM.isOwner = YES;
            chatM.inGroup = YES;
            chatM.assetName = vpnInfo.vpnName;
            chatM.groupName = vpnInfo.vpnName;
            [weakSelf.chatArr addObject:chatM];
        }];
    }
}

- (ChatModel *)getChat:(NSString *)assetName {
    __block ChatModel *chatM = nil;
    [self.chatArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChatModel *model = obj;
        if ([model.assetName isEqualToString:assetName]) {
            chatM = model;
            *stop = YES;
        }
    }];
    return chatM;
}

- (void)addJoinGroupChat:(NSUInteger)groupNum {
    __block BOOL isExist = NO;
    [self.chatArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChatModel *model = obj;
        if ([model.assetName isEqualToString:_joinAssetName]) {
            isExist = YES;
            model.groupNum = groupNum;
            *stop = YES;
        }
    }];
    if (!isExist) {
        ChatModel *chatM = [ChatModel new];
        chatM.groupNum = groupNum;
        chatM.isOwner = NO;
        chatM.inGroup = YES;
        chatM.assetName = _joinAssetName?:@"";
        chatM.groupName = _joinGroupName?:@"";
        [self.chatArr addObject:chatM];
    }
}

- (void)setChatRead:(NSString *)assetName {
    [self.chatArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChatModel *model = obj;
        if ([model.assetName isEqualToString:assetName]) {
            model.isUnread = NO;
            *stop = YES;
        }
    }];
}

#pragma mark - Noti
- (void)p2pOnline:(NSNotification *)noti {
    [self createGroup];
}

- (void)joinGroup:(NSNotification *)noti {
    NSUInteger groupNum = [noti.object integerValue];
    [self addJoinGroupChat:groupNum];
    [[NSNotificationCenter defaultCenter] postNotificationName:P2P_JOINGROUP_SUCCESS_NOTI object:nil];
}

- (void)groupChatMessage:(NSNotification *)noti {
    GroupChatMessageModel *model = noti.object;
    [self.chatArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ChatModel *chatM = obj;
        if (chatM.groupNum == model.groupnum) {
            chatM.isUnread = YES; // 置为未读
            NSDictionary *messageDic = model.message.mj_JSONObject;
            if (!messageDic) {
                DDLogDebug(@"收到聊天消息未解析出来");
                return;
            }
            NSTimeInterval dateTime = [messageDic[@"messageTime"] integerValue]/1000; // 毫秒/1000
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateTime];
            ZXMessageModel *message = [ZXMessageModel new];
            NSString *messageType = messageDic[@"messageType"];
            if (!messageType) {
                message.messageType = ZXMessageTypeText;
            } else {
                message.messageType = (ZXMessageType)[messageType integerValue];
            }
            message.ownerTyper = ZXMessageOwnerTypeOther;
            message.senderId = messageDic[@"p2pId"];
//            message.senderDisplayName = [UserManage.shareInstance getRandomName];
            message.senderDisplayName = messageDic[@"nickName"];
            message.date = date;
            message.text = messageDic[@"content"];
            message.message = model.message;
            message.groupnum = model.groupnum;
            [chatM.messages addObject:message];
            [[NSNotificationCenter defaultCenter] postNotificationName:ADD_GROUP_CHAT_MESSAGE_COMPLETE_NOTI object:@(chatM.groupNum)];
            *stop = YES;
        }
    }];
}

#pragma mark - Lazy
- (NSMutableArray *)chatArr {
    if (!_chatArr) {
        _chatArr = [NSMutableArray array];
    }
    return _chatArr;
}

@end
