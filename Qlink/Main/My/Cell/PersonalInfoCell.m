//
//  PersonalInfoCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import "PersonalInfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PersonalInfoShowModel

@end

@implementation PersonalInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _iconHead.layer.cornerRadius = _iconHead.width/2.0;
    _iconHead.layer.masksToBounds = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _keyLab.text = nil;
    _valLab.text = nil;
}


- (void)configCell:(PersonalInfoShowModel *)model {
    _keyLab.text = model.key;
    _valLab.text = model.val;
    _iconCopy.hidden = !model.showCopy;
    _iconArrow.hidden = !model.showArrow;
    _iconHead.hidden = !model.showHead;
    _valLab.hidden = model.showHead;
    if (model.showHead) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.val]];
        [_iconHead sd_setImageWithURL:url placeholderImage:User_PlaceholderImage1 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
