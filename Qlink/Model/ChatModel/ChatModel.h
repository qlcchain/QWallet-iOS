//
//  ChatModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/5/3.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"

@class  JSQMessagesBubbleImage;

@interface ChatModel : BBaseModel

@property (nonatomic) BOOL isOwner;
@property (nonatomic) BOOL inGroup;
@property (nonatomic) NSUInteger groupNum;
@property (nonatomic, strong) NSString *assetName;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic) BOOL isUnread;

@end
