//
//  DailyEarningsCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/10/9.
//  Copyright © 2019 pan. All rights reserved.
//

#import "DailyEarningsCell.h"
#import "RewardListModel.h"
#import "NSDate+Category.h"

@implementation DailyEarningsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
//    _titleLab.text = nil;
//    _statusLab.text = nil;
    _timeLab.text = nil;
    _qgasLab.text = nil;
}

- (void)config:(RewardListModel *)model {
//    _titleLab.text = nil;
//    _statusLab.text = nil;
    _timeLab.text = [NSDate getOutputDate:model.rewardDate formatStr:yyyyMMddHHmmss];
    _qgasLab.text = [NSString stringWithFormat:@"+%@ QGAS",model.rewardAmount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
