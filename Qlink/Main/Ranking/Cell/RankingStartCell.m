//
//  RankingCell.m
//  Qlink
//
//  Created by Jelly Foo on 2018/8/1.
//  Copyright © 2018年 pan. All rights reserved.
//

#import "RankingStartCell.h"
#import "VPNRankMode.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import "RequestService.h"

@implementation RankingStartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _headImageView.layer.cornerRadius = _headImageView.frame.size.height/2;
    _headImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _headImageView.layer.borderWidth = 1.0f;
    _headImageView.layer.masksToBounds = YES;
}

- (void) setVPNRankMode:(VPNRankMode *) mode withRow:(NSInteger)row {
    _lblconnet.textColor = RGB(51, 51, 51);
    _lblCount.textColor = RGB(51, 51, 51);
    _lblNumber.textColor = RGB(51, 51, 51);
    
    if (row == 0) {
        _trophyImgView.hidden = mode.totalQlc < 50?YES:NO;
        _lblNumber.hidden = YES;
    } else {
        _trophyImgView.hidden = YES;
        if (mode.totalQlc < 50) {
            _lblNumber.hidden = YES;
        } else {
            _lblNumber.hidden = NO;
            _lblNumber.text = [NSString stringWithFormat:@"%ld",row+1];
        }
    }
    _lblconnet.text = mode.assetName?:@"";
    _lblCount.text = [NSString stringWithFormat:@"%zd",mode.totalQlc] ?:@"";
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],mode.imgUrl?:@""]] placeholderImage:User_PlaceholderImage1 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
