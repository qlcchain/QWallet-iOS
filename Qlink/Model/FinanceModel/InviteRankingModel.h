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

@end
