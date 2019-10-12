//
//  ShareFriendsCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import "ShareFriendsCell.h"
#import "InviteRankingModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GlobalConstants.h"

@implementation ShareFriendsCell

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

//- (void)configCell:(InviteRankingModel *)model isFirst:(BOOL)isFirst isSecond:(BOOL)isSecond isLast:(BOOL)isLast {
//    _topHeight.constant = isSecond?30:0;
//    _bottomHeight.constant = isLast?30:0;
//    NSNumber *num = isFirst?model.myRanking:model.sequence;
//    _numLab.text = [NSString stringWithFormat:@"%@",num==0?@"99+":num];
//    _nameLab.text = model.showName;
//    _inviteLab.text = [NSString stringWithFormat:@"%@ %@ %@",kLang(@"invited__"),model.totalInvite,kLang(@"friends__")];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.head]];
//    [_icon sd_setImageWithURL:url placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//    }];
//}

- (void)configCell:(InviteRankingModel *)model qgasUnit:(NSString *)qgasUnit {
    _topHeight.constant = 0;
    _bottomHeight.constant = 0;
    NSNumber *num = model.sequence;
    _numLab.text = [NSString stringWithFormat:@"%@",num==0?@"99+":num];
    _nameLab.text = model.showName;
//    _inviteLab.text = [NSString stringWithFormat:@"%@ %@ %@",kLang(@"invited__"),model.totalInvite,kLang(@"friends__")];
    _inviteLab.text = [NSString stringWithFormat:@"%@ QGAS",@([model.totalInvite doubleValue]*[qgasUnit doubleValue])];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.head]];
    [_icon sd_setImageWithURL:url placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}

- (IBAction)moreAction:(id)sender {
    if (_moreB) {
        _moreB();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
