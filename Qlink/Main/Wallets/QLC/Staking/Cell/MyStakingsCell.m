//
//  MyStakingsCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyStakingsCell.h"
#import "PledgeInfoByBeneficialModel.h"
#import "QConstants.h"

@implementation MyStakingsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)config:(PledgeInfoByBeneficialModel *)model {
    UIImage *iconImg = nil;
    NSString *name = @"";
    if ([model.pType isEqualToString:@"vote"]) {
        iconImg = [UIImage imageNamed:@"icon_node"];
        name = @"Voting/Mining Node";
    }
    _icon.image = iconImg;
    _nameLab.text = name;
    _stateLab.text = model.state;
    _stakingAmountLab.text = [NSString stringWithFormat:@"%@",@([model.amount doubleValue]/QLC_UnitNum)];
    _earningsLab.text = [NSString stringWithFormat:@"%@",@([model.qgas doubleValue]/QLC_UnitNum)];
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

@end
