//
//  InviteRankingModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "InviteRankingModel.h"
#import "OTCUtil.h"

@implementation InviteRankingModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID": @"id"
             };
}

- (NSString *)showName {
    return [OTCUtil getShowNickName:_name];
}

@end
