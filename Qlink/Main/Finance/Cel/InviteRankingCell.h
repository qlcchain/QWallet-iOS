//
//  InviteRankingCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/4/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InviteRankingModel;

static NSString *InviteRankingCellReuse = @"InviteRankingCell";
#define InviteRankingCell_Height 64

@interface InviteRankingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *inviteLab;

- (void)configCell:(InviteRankingModel *)model;

@end
