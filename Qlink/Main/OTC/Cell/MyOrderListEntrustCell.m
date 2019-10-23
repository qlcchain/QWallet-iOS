//
//  MyOrderListCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/10.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyOrderListEntrustCell.h"
#import "EntrustOrderListModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "OrderStatusUtil.h"
#import "NSDate+Category.h"
#import "GlobalConstants.h"

@interface MyOrderListEntrustCell ()

@property (weak, nonatomic) IBOutlet UIView *contentBack;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *volumeSettingLab;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@end

@implementation MyOrderListEntrustCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _icon.layer.cornerRadius = _icon.width/2.0;
    _icon.layer.masksToBounds = YES;
    
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
    _nameLab.text = model.showNickName;
    _timeLab.text = [NSDate getOutputDate:model.orderTime formatStr:yyyyMMddHHmmss];
    _priceLab.text = [NSString stringWithFormat:@"%@ %@",model.unitPrice,model.payToken];
    _volumeSettingLab.text = [NSString stringWithFormat:@"%@-%@ %@",model.minAmount,model.maxAmount,model.tradeToken];
    _totalLab.text = [NSString stringWithFormat:@"%@ %@",model.totalAmount,model.tradeToken];
    _typeLab.text = [model.type isEqualToString:@"SELL"]?[NSString stringWithFormat:@"%@ %@",kLang(@"entrust_sell"),model.tradeToken]:[NSString stringWithFormat:@"%@ %@",kLang(@"entrust_buy"),model.tradeToken];
    _typeLab.textColor = [model.type isEqualToString:@"SELL"]?UIColorFromRGB(0xFF3669):MAIN_BLUE_COLOR;
    NSString *_status = model.status;
    NSString *statusStr = @"";
    UIColor *statusColor = nil;
    if ([_status isEqualToString:ORDER_STATUS_PENDING]) {
        statusStr = kLang(@"pending");
        statusColor = MAIN_BLUE_COLOR;
    } else if ([_status isEqualToString:ORDER_STATUS_NORMAL]) {
        statusStr = kLang(@"active");
        statusColor = MAIN_BLUE_COLOR;
    } else if ([_status isEqualToString:ORDER_STATUS_CANCEL]) {
        statusStr = kLang(@"revoked");
        statusColor = UIColorFromRGB(0x909090);
    } else if ([_status isEqualToString:ORDER_STATUS_END]) {
        statusStr = kLang(@"completed");
        statusColor = UIColorFromRGB(0x21BEB5);
    }
    _statusLab.text = statusStr;
    _statusLab.textColor = statusColor;
}

@end
