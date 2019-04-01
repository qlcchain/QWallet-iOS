//
//  ChatUtil.h
//  Qlink
//
//  Created by Jelly Foo on 2018/5/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatModel;

@interface ChatUtil : NSObject

@property (nonatomic, strong) NSString *joinAssetName;
@property (nonatomic, strong) NSString *joinGroupName;
@property (nonatomic, strong) ChatModel *currentChatM;

+ (instancetype)shareInstance;

- (ChatModel *)getChat:(NSString *)assetName;
- (void)setChatRead:(NSString *)assetName;

@end
