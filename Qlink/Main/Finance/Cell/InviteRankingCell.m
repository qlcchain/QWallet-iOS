//
//  InviteRankingCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "InviteRankingCell.h"
#import "InviteRankingModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GlobalConstants.h"

@implementation InviteRankingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    _icon.layer.cornerRadius = _icon.width/2.0;
    _icon.layer.masksToBounds = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _numLab.text = nil;
    _icon.image = nil;
    _nameLab.text = nil;
    _inviteLab.text = nil;
}

- (void)configCell:(InviteRankingModel *)model {
    _numLab.text = [NSString stringWithFormat:@"%@",model.sequence];
    _nameLab.text = model.showName;
    _inviteLab.text = [NSString stringWithFormat:@"%@ %@ %@",kLang(@"invited__"),model.totalInvite,kLang(@"friends__")];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.head]];
    [_icon sd_setImageWithURL:url placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
