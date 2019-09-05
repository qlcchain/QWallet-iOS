//
//  FinanceCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import "FinanceCell.h"
#import "FinanceProductModel.h"
#import "GlobalConstants.h"

@implementation FinanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _nameLab.text = nil;
    _rateValLab.text = nil;
    _dayLab.text = nil;
    _fromQLCLab.text = nil;
}

- (void)configCell:(FinanceProductModel *)model {
    _nameLab.text = model.nameEn;
    _rateValLab.text = [NSString stringWithFormat:@"%.2f%%",[model.annualIncomeRate floatValue]*100];
    _dayLab.text = [NSString stringWithFormat:@"%@ Days",model.timeLimit];
    _fromQLCLab.text = [NSString stringWithFormat:@"From %@ QLC",model.leastAmount];
    _arrow.hidden = NO;
    _statusLab.hidden = YES;
    _nameLab.textColor = UIColorFromRGB(0x4d4d4d);
    _rateValLab.textColor = UIColorFromRGB(0x01B5AB);
    _dayLab.textColor = UIColorFromRGB(0x29282A);
    UIColor *color99 = UIColorFromRGB(0x999999);
    if ([model.status isEqualToString:@"ON_SALE"]) {
        
    } else if ([model.status isEqualToString:@"NEW"]) {
        
    } else if ([model.status isEqualToString:@"SELL_OUT"]) {
        _nameLab.textColor = color99;
        _rateValLab.textColor = color99;
        _dayLab.textColor = color99;
        _statusLab.hidden = NO;
        _statusLab.text = @"SOLD OUT";
        _arrow.hidden = YES;
    } else if ([model.status isEqualToString:@"END"]) {
        _nameLab.textColor = color99;
        _rateValLab.textColor = color99;
        _dayLab.textColor = color99;
        _statusLab.hidden = NO;
        _statusLab.text = @"END";
        _arrow.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
