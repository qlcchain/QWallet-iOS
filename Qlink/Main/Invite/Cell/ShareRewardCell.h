//
//  ShareRewardCell.h
//  Qlink
//
//  Created by Jelly Foo on 2020/1/15.
//  Copyright © 2020 pan. All rights reserved.
//

#import "QBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class InviteeListModel,InviteRankingModel;

static NSString *ShareRewardCell_Reuse = @"ShareRewardCell";
#define ShareRewardCell_Height 64

@interface ShareRewardCell : QBaseTableCell

- (void)config_friend:(InviteeListModel *)model;
- (void)config_delegate:(InviteRankingModel *)model;

@end

NS_ASSUME_NONNULL_END
