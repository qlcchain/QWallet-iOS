//
//  ChooseTokenCell.m
//  Qlink
//
//  Created by Jelly Foo on 2020/2/11.
//  Copyright © 2020 pan. All rights reserved.
//

#import "ChooseTokenCell.h"
#import "TopupDeductionTokenModel.h"
#import <UIImageView+WebCache.h>
#import "GlobalConstants.h"

@interface ChooseTokenCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation ChooseTokenCell

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
    
    _icon.image = nil;
    _titleLab.text = nil;
}

- (void)config:(TopupDeductionTokenModel *)model {
    kWeakSelf(self);
    NSURL *url = [NSURL URLWithString:model.logoPng];
    [_icon sd_setImageWithURL:url placeholderImage:[model getDeductionTokenImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        UIImage *img = [image sd_resizedImageWithSize:CGSizeMake(28, 28) scaleMode:SDImageScaleModeAspectFit];
        if (image) {
            weakself.icon.image = img;
        }
    }];
    
    _titleLab.text = model.symbol;
}


@end
