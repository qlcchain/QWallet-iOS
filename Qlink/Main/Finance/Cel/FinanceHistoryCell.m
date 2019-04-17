//
//  FinanceHistoryCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/16.
//  Copyright © 2019 pan. All rights reserved.
//

#import "FinanceHistoryCell.h"
#import "FinanceOrderListModel.h"
#import "WalletCommonModel.h"

@implementation FinanceHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _nameLab.text = nil;
    _qlcLab.text = nil;
    _statusLab.text = nil;
    _timeLab.text = nil;
    _toLab.text = nil;
}

- (void)configCell:(FinanceOrderModel *)model {
    _toLab.hidden = YES;
    _toLab.text = nil;
    _statusLab.text = model.status;
    _statusLab.textColor = UIColorFromRGB(0x01B5AB);
    if ([model.status isEqualToString:@"PAY"]) {
        
    } else if ([model.status isEqualToString:@"END"]) {
        
    } else if ([model.status isEqualToString:@"REDEEM"]) {
        _statusLab.textColor = UIColorFromRGB(0xFF3669);
        _toLab.hidden = NO;
        WalletCommonModel *currentWalletM = [WalletCommonModel getWalletWithAddress:model.address];
        _toLab.text = [NSString stringWithFormat:@"TO：%@",currentWalletM.name];
    } else if ([model.status isEqualToString:@"CANCEL"]) {
        
    } else if ([model.status isEqualToString:@"BUY"]) {
        
    }
    _nameLab.text = model.productName;
    _qlcLab.text = [NSString stringWithFormat:@"+%@ QLC",model.addRevenue];
    _timeLab.text = model.orderTime;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
