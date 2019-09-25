//
//  MyStakingsCell.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "MyStakingsCell.h"
#import "PledgeInfoByBeneficialModel.h"
#import "GlobalConstants.h"
#import "StakingUtil.h"

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
        name = kLang(@"voting_mining_node");
    }
    _icon.image = iconImg;
    _nameLab.text = name;
    NSString *stateStr = @"";
    if ([model.state isEqualToString:PledgeState_PledgeStart]) {
        stateStr = kLang(@"not_succeed");
    } else if ([model.state isEqualToString:PledgeState_PledgeProcess]) {
        stateStr = kLang(@"pledge_process");
    } else if ([model.state isEqualToString:PledgeState_PledgeDone]) {
        if ([StakingUtil isRedeemable:[model.withdrawTime doubleValue]]) {
            stateStr = kLang(@"staking_in_progress_redeemable");
        } else {
            stateStr = kLang(@"staking_in_progress");
        }
    } else if ([model.state isEqualToString:PledgeState_WithdrawStart]) {
        stateStr = kLang(@"withdraw_start");
    } else if ([model.state isEqualToString:PledgeState_WithdrawProcess]) {
        stateStr = kLang(@"withdraw_process");
    } else if ([model.state isEqualToString:PledgeState_WithdrawDone]) {
        stateStr = kLang(@"withdraw_done");
    }
    _stateLab.text = stateStr;
    
    _stakingAmountLab.text = [NSString stringWithFormat:@"%@",@([model.amount doubleValue]/QLC_UnitNum)];
    _earningsLab.text = [NSString stringWithFormat:@"%@",@([model.qgas doubleValue]/QLC_UnitNum)];
    
    
    
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

@end
