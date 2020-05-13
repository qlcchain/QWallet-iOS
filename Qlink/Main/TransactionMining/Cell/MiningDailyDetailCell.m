//
//  MiningDailyDetailCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/11/13.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MiningDailyDetailCell.h"
#import "MiningRewardListModel.h"
#import "NSDate+Category.h"
#import "RLArithmetic.h"

@implementation MiningDailyDetailCell

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

- (void)config:(MiningRewardListModel *)model {
    //    _titleLab.text = nil;
    //    _statusLab.text = nil;
    _timeLab.text = [NSDate getOutputDate:model.rewardDate formatStr:yyyyMMddHHmmss];
    _qgasLab.text = [NSString stringWithFormat:@"+%@ %@",model.rewardAmount.mul(@"1"),model.symbol];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
