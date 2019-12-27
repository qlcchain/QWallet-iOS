//
//  MiningRewardIndexModel.m
//  Qlink
//
//  Created by Jelly Foo on 2019/11/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MiningRewardIndexModel.h"
#import "InviteRankingModel.h"

@implementation MiningRewardIndexModel

+ (NSDictionary *) mj_objectClassInArray
{
    return @{@"rewardRankings" : @"InviteRankingModel"};
}

@end
