//
//  HomeBuySellCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/9.
//  Copyright © 2019 pan. All rights reserved.
//

#import "HomeBuySellCell.h"
#import "EntrustOrderListModel.h"
#import "UIView+Visuals.h"
#import <UIImageView+WebCache.h>

@interface HomeBuySellCell ()

@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UILabel *usdtLab;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *volumeSettingLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dealsLab;
@property (weak, nonatomic) IBOutlet UIButton *operatorBtn;


@end

@implementation HomeBuySellCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _icon.layer.cornerRadius = _icon.width/2.0;
    _icon.layer.masksToBounds = YES;
    
    _operatorBtn.layer.cornerRadius = 4;
    _operatorBtn.layer.masksToBounds = YES;
    
    [_contentBack addShadowWithOpacity:1.0 shadowColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5] shadowOffset:CGSizeMake(0,4) shadowRadius:10 andCornerRadius:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
}

- (void)config:(EntrustOrderListModel *)model {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.head]];
    [_icon sd_setImageWithURL:url placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    _usdtLab.textColor = [model.type isEqualToString:@"BUY"]?UIColorFromRGB(0xFF3669):MAIN_BLUE_COLOR;
    _usdtLab.text = model.unitPrice;
    _totalAmountLab.text = [NSString stringWithFormat:@"%@ QGAS",@([model.totalAmount integerValue] - [model.lockingAmount integerValue] - [model.completeAmount integerValue])];
    _volumeSettingLab.text = [NSString stringWithFormat:@"%@-%@ QGAS",model.minAmount,model.maxAmount];
    _nameLab.text = model.nickname;
    _dealsLab.text = [NSString stringWithFormat:@"%@ Deals",model.otcTimes];
    _operatorBtn.backgroundColor = [model.type isEqualToString:@"BUY"]?UIColorFromRGB(0xFF3669):MAIN_BLUE_COLOR;
    [_operatorBtn setTitle:[model.type isEqualToString:@"BUY"]?@"SELL":@"BUY" forState:UIControlStateNormal];
}

@end
