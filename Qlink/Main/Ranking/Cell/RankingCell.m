//
//  RankingCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "RankingCell.h"
#import "VPNRankMode.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import "RequestService.h"

@implementation RankingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _headImageView.layer.cornerRadius = _headImageView.frame.size.height/2;
    _headImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _headImageView.layer.borderWidth = 1.0f;
    _headImageView.layer.masksToBounds = YES;
}

- (void) setVPNRankMode:(VPNRankMode *) mode withType:(NSString *) type
{
    if ([type isEqualToString:@"END"] || [type isEqualToString:@"PRIZED"]) {
        _lblSub1.text = [NSString stringWithFormat:@"%f QLC",mode.rewardTotal];
        _lblSub2.text = NSStringLocalizable(@"rewards");
    } else {
        _lblSub1.text = @"50%";
        _lblSub2.text = NSStringLocalizable(@"price_pool");
    }
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
