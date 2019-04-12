//
//  MyPortfolioCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/12.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyPortfolioCell.h"
#import "FinanceOrderListModel.h"

@interface MyPortfolioCell ()

@property (nonatomic, strong) FinanceOrderModel *orderM;

@end

@implementation MyPortfolioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _redeemBtn.layer.cornerRadius = 4;
    _redeemBtn.layer.masksToBounds = YES;
    _redeemBtn.layer.borderWidth = 1;
    _redeemBtn.layer.borderColor = [UIColor mainColor].CGColor;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _nameLab.text = nil;
    _principalValLab.text = nil;
    _cumulativeEarnValLab.text = nil;
    _maturityDateValLab.text = nil;
}

- (void)configCell:(FinanceOrderModel *)model {
    _orderM = model;
    _cumulativeEarnKeyLab.hidden = NO;
    _cumulativeEarnValLab.hidden = NO;
    _maturityDateKeyLab.hidden = NO;
    _maturityDateValLab.hidden = NO;
    _redeemBtn.hidden = NO;
    
    if ([model.status isEqualToString:@"PAY"]) {
        _redeemBtn.hidden = YES;
    } else if ([model.status isEqualToString:@"END"]) {
        _maturityDateKeyLab.hidden = YES;
        _maturityDateValLab.hidden = YES;
    }
    
    _nameLab.text = model.productName;
    _principalValLab.text = [NSString stringWithFormat:@"%@",model.amount];
    _cumulativeEarnValLab.text = [NSString stringWithFormat:@"%@",model.addRevenue];
    _maturityDateValLab.text = [NSString stringWithFormat:@"%@",model.dueDays];
}

- (IBAction)redeemAction:(id)sender {
    if (_redeemB) {
        _redeemB(_orderM.ID);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
