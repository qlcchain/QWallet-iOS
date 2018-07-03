//
//  GroupChatMessageModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/5/4.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface GroupChatMessageModel : BBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *message;
@property (nonatomic) NSUInteger groupnum;

@end
