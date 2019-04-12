//
//  FinanceCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/4/11.
//  Copyright © 2019 pan. All rights reserved.
//

#import "FinanceCell.h"
#import "FinanceProductModel.h"

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
    _nameLab.text = model.name;
    _rateValLab.text = [NSString stringWithFormat:@"%@%%",@([model.annualIncomeRate floatValue]*100)];
    _dayLab.text = [NSString stringWithFormat:@"%@ Days",model.timeLimit];
    _fromQLCLab.text = [NSString stringWithFormat:@"From %@ QLC",model.leastAmount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
