//
//  InviteRankingModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

@interface InviteRankingModel : BBaseModel

@property (nonatomic, strong) NSString *head; // = "/data/dapp/head/decdfb15f58e4ddd9ac91ac6ce8ee94a.jpg";
@property (nonatomic, strong) NSString *ID; // = "";
@property (nonatomic, strong) NSString *name; // = "";
@property (nonatomic, strong) NSNumber *sequence; // = 29;
@property (nonatomic, strong) NSNumber *totalInvite; // = 0;

@property (nonatomic, strong) NSNumber *myRanking; // = 29;
@property (nonatomic, strong) NSString *number; // = "";
@property (nonatomic, strong) NSNumber *totalReward; // = 0;
@property (nonatomic, strong) NSNumber *level; // 1:一级  2:二级  3:三级  7:团长   8:团员一级  9:团员二级

@property (nonatomic, strong) NSString *showName;

@end
