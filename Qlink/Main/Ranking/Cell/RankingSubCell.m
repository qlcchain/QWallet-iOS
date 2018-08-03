//
//  RankingSubCell.m
//  Qlink
//
//  Created by 旷自辉 on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "RankingSubCell.h"
#import "VPNRankMode.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation RankingSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.cornerRadius = _headImageView.frame.size.height/2;
    _headImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _headImageView.layer.borderWidth = 1.0f;
    _headImageView.layer.masksToBounds = YES;
}

- (void) setVPNRankMode:(VPNRankMode *) mode
{
    _lblconnet.text = mode.assetName?:@"";
    _lblCount.text = [NSString stringWithFormat:@"%zd",mode.connectSuccessNum] ?:@"";
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],mode.imgUrl?:@""]] placeholderImage:User_PlaceholderImage1 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
