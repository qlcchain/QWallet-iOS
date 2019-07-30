//
//  EntrustOrderDetailCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/7/18.
//  Copyright © 2019 pan. All rights reserved.
//

#import "EntrustOrderDetailCell.h"
#import "TradeOrderListModel.h"
#import <UIImageView+WebCache.h>
#import "UserModel.h"
#import "OrderStatusUtil.h"

@interface EntrustOrderDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;


@end

@implementation EntrustOrderDetailCell

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
    
    
}

- (void)config:(TradeOrderListModel *)model {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.head]];
    [_icon sd_setImageWithURL:url placeholderImage:User_DefaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    _nameLab.text = model.nickname;
    _timeLab.text = model.createDate;
    UserModel *loginM = [UserModel fetchUserOfLogin];
    _typeLab.text = [loginM.ID isEqualToString:model.buyerId]?@"Seller":@"Buyer";
    _typeLab.textColor = [loginM.ID isEqualToString:model.buyerId]?UIColorFromRGB(0xFF3669):MAIN_BLUE_COLOR;
    _amountLab.text = model.usdtAmount;
    _statusLab.text = [OrderStatusUtil getStatusStr:model.status];
    _statusLab.textColor = [OrderStatusUtil getStatusColor:model.status];
}

@end
