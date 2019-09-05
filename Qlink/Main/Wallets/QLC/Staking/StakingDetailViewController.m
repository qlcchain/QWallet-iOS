//
//  StakingDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "StakingDetailViewController.h"
#import "PledgeInfoByBeneficialModel.h"
#import "NSDate+Category.h"
#import "QLCWalletInfo.h"
#import "QContractView.h"
#import "AFJSONRPCClient.h"
#import "ConfigUtil.h"
#import "NSString+RandomStr.h"

@interface StakingDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *stakingAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *votingEarningsLab;
@property (weak, nonatomic) IBOutlet UILabel *miningEarningsLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UIImageView *stateArrow;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *revokeOnLab;
@property (weak, nonatomic) IBOutlet UILabel *stakingTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *stakeFromLab;
@property (weak, nonatomic) IBOutlet UILabel *stakeToLab;
@property (weak, nonatomic) IBOutlet UILabel *transactionLab;


@end

@implementation StakingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    UIImage *iconImg = nil;
    NSString *title = @"";
    NSString *typeStr = @"";
    if ([_inputPledgeM.pType isEqualToString:@"vote"]) {
        iconImg = [UIImage imageNamed:@"icon_node"];
        title = @"Voting/Mining Node";
        typeStr = [NSString stringWithFormat:@"For %@",title];
    }
    NSString *stateStr = @"";
    BOOL stateArrowHidden = NO;
    if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeStart]) {
        stateStr = @"Not succeed, continue to invoke";
        stateArrowHidden = NO;
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeProcess]) {
        stateArrowHidden = YES;
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeDone]) {
        stateStr = _inputPledgeM.state;
        stateArrowHidden = NO;
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawStart]) {
        stateStr = _inputPledgeM.state;
        stateArrowHidden = NO;
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawProcess]) {
        stateArrowHidden = YES;
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawDone]) {
        stateStr = @"Withdraw Complete";
        stateArrowHidden = YES;
    }
    _icon.image = iconImg;
    _titleLab.text = title;
    _stakingAmountLab.text = [NSString stringWithFormat:@"%@",@([_inputPledgeM.amount doubleValue]/QLC_UnitNum)];
    _votingEarningsLab.text = @"--";
    _miningEarningsLab.text = @"--";
    _stateLab.text = stateStr;
    _stateArrow.hidden = stateArrowHidden;
    _amountLab.text = [NSString stringWithFormat:@"%@",@([_inputPledgeM.qgas doubleValue]/QLC_UnitNum)];
    if (_inputPledgeM.withdrawTime) {
        _revokeOnLab.text = [NSDate getTimeWithTimestamp:_inputPledgeM.withdrawTime format:@"HH:mm:ss yyyy-MM-dd" isMil:NO];
    }
    _stakingTypeLab.text = typeStr;
    _stakeFromLab.text = _inputPledgeM.pledge;
    _stakeToLab.text = _inputPledgeM.beneficial;
    _transactionLab.text = _inputPledgeM.nep5TxId;
}

- (void)startBenefitWithdraw {
    if (!_inputPledgeM) {
        return;
    }
    NSString *qlcAddress = _inputPledgeM.beneficial;
    NSString *qlc_publicKey = [QLCWalletInfo getQLCPublicKeyWithAddress:qlcAddress];
    NSString *qlc_privateKey = [QLCWalletInfo getQLCPrivateKeyWithAddress:qlcAddress];
    NSString *beneficial = qlcAddress;
    NSString *qlcAmount = _inputPledgeM.amount;
    NSString *lockTxId = _inputPledgeM.nep5TxId;
    kWeakSelf(self);
    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___")];
    [[QContractView shareInstance] nep5_benefitWithdraw:lockTxId beneficial:beneficial amount:qlcAmount qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:^(NSString * _Nonnull result, BOOL success) {
        [kAppD.window hideToast];
        if (success) {
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
            [weakself ledger_pledgeInfoByTransactionID];
        } else {
            [kAppD.window makeToastDisappearWithText:kLang(@"failed_")];
        }
    }];
}

- (void)vote_continueInvoke {
    if (!_inputPledgeM) {
        return;
    }
    NSString *qlcAddress = _inputPledgeM.beneficial;
    NSString *qlc_publicKey = [QLCWalletInfo getQLCPublicKeyWithAddress:qlcAddress];
    NSString *qlc_privateKey = [QLCWalletInfo getQLCPrivateKeyWithAddress:qlcAddress];
    NSString *lockTxId = _inputPledgeM.nep5TxId;
    kWeakSelf(self);
    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___")];
    [[QContractView shareInstance] benefit_getnep5transferbytxid:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:^(NSString * _Nonnull result, BOOL success) {
        [kAppD.window hideToast];
        if (success) {
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
            [weakself ledger_pledgeInfoByTransactionID];
        } else {
            [kAppD.window makeToastDisappearWithText:kLang(@"failed_")];
        }
    }];
}

- (void)startMintageWithdraw {
    if (!_inputPledgeM) {
        return;
    }
    NSString *tokenId = @"";
    NSString *lockTxId = _inputPledgeM.nep5TxId;
    kWeakSelf(self);
    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___")];
    [[QContractView shareInstance] nep5_mintageWithdraw:lockTxId tokenId:tokenId resultHandler:^(NSString * _Nonnull result, BOOL success) {
        [kAppD.window hideToast];
        if (success) {
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
            [weakself ledger_pledgeInfoByTransactionID];
        } else {
            [kAppD.window makeToastDisappearWithText:kLang(@"failed_")];
        }
    }];
}

#pragma mark - Request
- (void)ledger_pledgeInfoByTransactionID {
    AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:[ConfigUtil get_qlc_staking_node]]];
    // Invocation with Parameters and Request ID
    NSString *requestId = [NSString randomOf32];
    kWeakSelf(self);
    NSArray *params = @[_inputPledgeM.nep5TxId?:@""];
    DDLogDebug(@"ledger_pledgeInfoByTransactionID params = %@",params);
    [client invokeMethod:@"ledger_pledgeInfoByTransactionID" withParameters:params requestId:requestId success:^(NSURLSessionDataTask *task, id responseObject) {
        DDLogDebug(@"ledger_pledgeInfoByTransactionID responseObject=%@",responseObject);
        
        if (responseObject) {
            weakself.inputPledgeM = [PledgeInfoByBeneficialModel mj_objectWithKeyValues:responseObject];
            [weakself configInit];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error=%@",error);
    }];
    
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)stateBtnAction:(id)sender {
    if ([_inputPledgeM.pType isEqualToString:@"vote"]) {
        if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeStart]) {
            [self vote_continueInvoke];
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeProcess]) {
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeDone]) {
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawStart]) {
            [self startBenefitWithdraw];
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawProcess]) {
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawDone]) {
        }
    } else if ([_inputPledgeM.pType isEqualToString:@"mintage"]) {
        if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeStart]) {
            
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeProcess]) {
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeDone]) {
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawStart]) {
            [self startMintageWithdraw];
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawProcess]) {
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawDone]) {
        }
    }
}


@end
