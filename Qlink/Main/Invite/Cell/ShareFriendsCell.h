//
//  ShareFriendsCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseTableCell.h"

@class InviteRankingModel;

static NSString *ShareFriendsCellReuse = @"ShareFriendsCell";
#define ShareFriendsCell_Height 64

typedef void(^ShareFriendsMoreBlock)(void);

@interface ShareFriendsCell : QBaseTableCell

@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *inviteLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight; // 30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight; // 30
@property (weak, nonatomic) IBOutlet UIView *contentBack;


@property (nonatomic, copy) ShareFriendsMoreBlock moreB;

- (void)configCell:(InviteRankingModel *)model qgasUnit:(NSString *)qgasUnit color:(UIColor *)color;
- (void)configCell_MiningReward:(InviteRankingModel *)model color:(UIColor *)color;

@end
