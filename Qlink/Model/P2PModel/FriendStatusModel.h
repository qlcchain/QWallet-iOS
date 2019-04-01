//
//  FriendStatusModel.h
//  Qlink
//
//  Created by Jelly Foo on 2018/4/20.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface FriendStatusModel : BBaseModel

@property (nonatomic) NSString *publickey;
@property (nonatomic) NSInteger status;

@end
