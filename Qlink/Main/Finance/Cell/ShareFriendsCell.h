//
//  ShareFriendsCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InviteRankingModel;

static NSString *ShareFriendsCellReuse = @"ShareFriendsCell";
#define ShareFriendsCell_Height 64

typedef void(^ShareFriendsMoreBlock)(void);

@interface ShareFriendsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *inviteLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight; // 30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight; // 30

@property (nonatomic, copy) ShareFriendsMoreBlock moreB;

//- (void)configCell:(InviteRankingModel *)model isFirst:(BOOL)isFirst isSecond:(BOOL)isSecond isLast:(BOOL)isLast;
- (void)configCell:(InviteRankingModel *)model qgasUnit:(NSString *)qgasUnit;

@end
