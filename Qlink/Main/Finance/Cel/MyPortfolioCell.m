//
//  MyPortfolioCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/12.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyPortfolioCell.h"
#import "FinanceOrderListModel.h"
#import "NSDate+Category.h"
#import "UIColor+Random.h"
#import "NSString+EmptyUtil.h"

@interface MyPortfolioCell ()

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
    _maturityDateKeyLab.text = nil;
    _maturityDateValLab.text = nil;
}

- (void)configCell:(FinanceOrderModel *)model {
    _cumulativeEarnKeyLab.hidden = NO;
    _cumulativeEarnValLab.hidden = NO;
    _maturityDateKeyLab.hidden = NO;
    _maturityDateValLab.hidden = NO;
    _redeemBtn.hidden = NO;
    
    _nameLab.text = model.productName;
    _principalValLab.text = [NSString stringWithFormat:@"%@",model.amount];
    _cumulativeEarnValLab.text = [NSString stringWithFormat:@"%@",model.addRevenue];
    _maturityDateValLab.text = [NSString stringWithFormat:@"%@",model.maturityTime.length>10?[model.maturityTime substringToIndex:10]:model.maturityTime];
    
    if ([model.status isEqualToString:@"PAY"]) {
        _maturityDateKeyLab.text = @"Maturity Date";
        _redeemBtn.hidden = YES;
        if ([model.maturityTime isEmptyString]) { // 日日盈
            if ([model.dueDays integerValue] == 0) {
                _redeemBtn.hidden = NO;
                _maturityDateKeyLab.hidden = YES;
                _maturityDateValLab.hidden = YES;
            } else { // 显示明天
                NSString *tomorrow = [NSDate getTimeWithFromDate:[NSDate date] addDay:1];
                _maturityDateValLab.text = [NSString stringWithFormat:@"%@",tomorrow.length>10?[tomorrow substringToIndex:10]:tomorrow];
            }
            
        }
    } else if ([model.status isEqualToString:@"END"]) {
        if (![model.maturityTime isEmptyString]) { // 其他
            _redeemBtn.hidden = NO;
            _maturityDateKeyLab.hidden = YES;
            _maturityDateValLab.hidden = YES;
        }
    } else if ([model.status isEqualToString:@"REDEEM"]) {
        _redeemBtn.hidden = YES;
        _maturityDateKeyLab.hidden = NO;
        _maturityDateValLab.hidden = YES;
        _maturityDateKeyLab.text = @"Redeemed";
    } else if ([model.status isEqualToString:@"CANCEL"]) {
        
    } else if ([model.status isEqualToString:@"BUY"]) {
        
    }
}

- (IBAction)redeemAction:(id)sender {
    if (_redeemB) {
        _redeemB(_row);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
