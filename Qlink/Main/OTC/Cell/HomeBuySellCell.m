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
#import <SDWebImage/UIImageView+WebCache.h>
#import "RLArithmetic.h"
#import "GlobalConstants.h"

@interface HomeBuySellCell ()

@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UILabel *usdtLab;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountKeyLab;
@property (weak, nonatomic) IBOutlet UILabel *volumeSettingLab;
@property (weak, nonatomic) IBOutlet UILabel *volumeSettingKeyLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dealsLab;
@property (weak, nonatomic) IBOutlet UIButton *operatorBtn;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLab;

@property (weak, nonatomic) IBOutlet UIView *teamBack;
@property (weak, nonatomic) IBOutlet UILabel *teamLab;

@property (nonatomic, copy) HomeBuySellClickBlock clickB;
@property (nonatomic, strong) EntrustOrderListModel *model;


@end

@implementation HomeBuySellCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _icon.layer.cornerRadius = _icon.width/2.0;
    _icon.layer.masksToBounds = YES;
    
    _operatorBtn.layer.cornerRadius = 4;
    _operatorBtn.layer.masksToBounds = YES;
    
    _teamBack.layer.cornerRadius = 2;
    _teamBack.layer.masksToBounds = YES;
    
    [_contentBack addShadowWithOpacity:1.0 shadowColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5] shadowOffset:CGSizeMake(0,4) shadowRadius:10 andCornerRadius:4];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
}

- (void)config:(EntrustOrderListModel *)model clickB:(nonnull HomeBuySellClickBlock)clickB {
    _clickB = clickB;
    _model = model;
    if ([model.isBurnQgasOrder integerValue] == 1) { // QGAS销毁订单
        _icon.image = [UIImage imageNamed:@"buyback_tx"];
        _nameLab.text = kLang(@"buyback_destruction_plan");
        _teamBack.hidden = NO;
    } else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.head]];
        [_icon sd_setImageWithURL:url placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        _nameLab.text = model.showNickName;
        _teamBack.hidden = YES;
    }
    
    _usdtLab.textColor = [model.type isEqualToString:@"BUY"]?UIColorFromRGB(0xFF3669):MAIN_BLUE_COLOR;
    _usdtLab.text = [NSString stringWithFormat:@"%@ %@",model.unitPrice_str,model.payToken];
    _unitPriceLab.text = kLang(@"unit_price");
    _totalAmountKeyLab.text = kLang(@"amount");
    
    _totalAmountLab.text = [NSString stringWithFormat:@"%@ %@",model.totalAmount_str.sub(model.lockingAmount_str).sub(model.completeAmount_str),model.tradeToken];
    _volumeSettingKeyLab.text = kLang(@"limits");
    _volumeSettingLab.text = [NSString stringWithFormat:@"%@-%@ %@",model.minAmount,model.maxAmount,model.tradeToken];
    
    _dealsLab.text = [NSString stringWithFormat:@"%@ Deals",model.otcTimes];
    _operatorBtn.backgroundColor = [model.type isEqualToString:@"BUY"]?UIColorFromRGB(0xFF3669):MAIN_BLUE_COLOR;
    [_operatorBtn setTitle:[model.type isEqualToString:@"BUY"]?kLang(@"sell"):kLang(@"buy") forState:UIControlStateNormal];
    
    _teamLab.text = kLang(@"team");
}


- (IBAction)clickAction:(id)sender {
    if (_clickB) {
        _clickB(_model);
    }
}


@end
