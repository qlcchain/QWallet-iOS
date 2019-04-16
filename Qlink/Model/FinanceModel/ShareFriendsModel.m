//
//  ShareFriendsModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ShareFriendsModel.h"
#import "InviteRankingModel.h"

@implementation GuanggaoListModel

@end

@implementation ShareFriendsModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"top5" : @"InviteRankingModel", @"guanggaoList":@"GuanggaoListModel"};
}

@end
