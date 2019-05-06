//
//  ShareFriendsModel.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import "BBaseModel.h"

@class InviteRankingModel;

@interface GuanggaoListModel : BBaseModel

@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) NSString *imgPathEn;
@property (nonatomic, strong) NSString *url;

@end

@interface ShareFriendsModel : BBaseModel

@property (nonatomic, strong) NSArray *guanggaoList;
@property (nonatomic, strong) InviteRankingModel *myInfo;
@property (nonatomic, strong) NSArray *top5;

@end
