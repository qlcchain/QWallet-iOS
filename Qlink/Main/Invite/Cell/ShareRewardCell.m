//
//  ShareRewardCell.m
//  Qlink
//
//  Created by Jelly Foo on 2020/1/15.
//  Copyright © 2020 pan. All rights reserved.
//

#import "ShareRewardCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GlobalConstants.h"
#import "NSString+RemoveZero.h"
#import "RLArithmetic.h"
#import "InviteRankingModel.h"
#import "InviteeListModel.h"
#import "OTCUtil.h"

@interface ShareRewardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *inviteLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@end

@implementation ShareRewardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
        
    _icon.layer.cornerRadius = _icon.width/2.0;
    _icon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _typeLab.text = nil;
    _icon.image = nil;
    _nameLab.text = nil;
    _inviteLab.text = nil;
}

- (void)config_friend:(InviteeListModel *)model {
    _typeLab.text = kLang(@"referred");
    _nameLab.text = [OTCUtil getShowNickName:model.nickname];
    _inviteLab.text = @"";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.head]];
    [_icon sd_setImageWithURL:url placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}

- (void)config_delegate:(InviteRankingModel *)model {
    NSString *typeStr = @"";
    if ([model.level integerValue] < 7) {
        typeStr = kLang(@"recharge_commission");
    } else {
        typeStr = kLang(@"group_plan_commission");
    }
    _typeLab.text = typeStr;
    _nameLab.text = [OTCUtil getShowNickName:model.name];
    
    _inviteLab.text = [NSString stringWithFormat:@"%@ QGAS",model.totalReward.mul(@"1")];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.head]];
    [_icon sd_setImageWithURL:url placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}

@end
