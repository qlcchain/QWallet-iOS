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
#import "RevokingProcessView.h"
#import "StakingUtil.h"
#import "NEOWalletInfo.h"

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

@property (nonatomic, strong) RevokingProcessView *revokingProcessV;
@property (nonatomic, strong) QContractView *contractV;

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
        title = kLang(@"voting_mining_node");
        typeStr = [NSString stringWithFormat:@"%@ %@",kLang(@"for"),title];
    }
    NSString *stateStr = @"";
    BOOL stateArrowHidden = NO;
    if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeStart]) {
        stateStr = kLang(@"not_succeed_continue_to_invoke");
        stateArrowHidden = NO;
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeProcess]) {
        stateStr = _inputPledgeM.state;
        stateArrowHidden = YES;
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeDone]) {
        if ([StakingUtil isRedeemable:[_inputPledgeM.withdrawTime doubleValue]]) {
            stateStr = kLang(@"revoke");
            stateArrowHidden = NO;
        } else {
            stateStr = kLang(@"staking_in_progress");
            stateArrowHidden = YES;
        }
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawStart]) {
        stateStr = _inputPledgeM.state;
        stateArrowHidden = NO;
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawProcess]) {
        stateStr = _inputPledgeM.state;
        stateArrowHidden = YES;
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawDone]) {
        stateStr = kLang(@"withdraw_complete");
        stateArrowHidden = YES;
    }
    _icon.image = iconImg;
    _titleLab.text = title;
    _stakingAmountLab.text = [NSString stringWithFormat:@"%@",@([_inputPledgeM.amount doubleValue]/QLC_UnitNum)];
    _votingEarningsLab.text = [NSString stringWithFormat:@"+%@",@([_inputPledgeM.qgas doubleValue]/QLC_UnitNum)];
    _miningEarningsLab.text = @"--";
    _stateLab.text = stateStr;
    _stateArrow.hidden = stateArrowHidden;
    _amountLab.text = [NSString stringWithFormat:@"%@",@([_inputPledgeM.amount doubleValue]/QLC_UnitNum)];
    NSString *withdrawTimeStr = @"--";
    if (![_inputPledgeM.withdrawTime isEmptyString] && [_inputPledgeM.withdrawTime integerValue] != 0) {
        withdrawTimeStr = [NSDate getTimeWithTimestamp:_inputPledgeM.withdrawTime format:@"HH:mm:ss yyyy-MM-dd" isMil:NO];
    }
    _revokeOnLab.text = withdrawTimeStr;
    _stakingTypeLab.text = typeStr;
    _stakeFromLab.text = _inputPledgeM.multiSigAddress;
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
    _contractV = [QContractView addQContractView];
    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___")];
    [_contractV request_benefit_neo_address:lockTxId resultHandler:^(NSString * _Nonnull result, BOOL success) {
        if (success) {
            NSString *neo_publicKey = [NEOWalletInfo getNEOPublickKeyWithAddress:result];
            if (!neo_publicKey) {
                [kAppD.window hideToast];
                [kAppD.window makeToastDisappearWithText:kLang(@"failed_")];
                return;
            }
            [weakself.contractV nep5_benefitWithdraw:lockTxId beneficial:beneficial amount:qlcAmount qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey neo_publicKey:neo_publicKey resultHandler:^(NSString * _Nonnull result, BOOL success) {
                [kAppD.window hideToast];
                [QContractView removeQContractView:weakself.contractV];
                if (success) {
                    [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
                    [weakself ledger_pledgeInfoByTransactionID];
                } else {
                    [kAppD.window makeToastDisappearWithText:kLang(@"failed_")];
                }
            }];
        } else {
            [kAppD.window hideToast];
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
//    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___")];
    _contractV = [QContractView addQContractView];
    [self showRevokingProcessView];
    [_contractV benefit_getnep5transferbytxid:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:^(NSString * _Nonnull result, BOOL success) {
//        [kAppD.window hideToast];
        [weakself hideRevokingProcessView];
        [QContractView removeQContractView:weakself.contractV];
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
    _contractV = [QContractView addQContractView];
    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___")];
    [_contractV nep5_mintageWithdraw:lockTxId tokenId:tokenId resultHandler:^(NSString * _Nonnull result, BOOL success) {
        [kAppD.window hideToast];
        [QContractView removeQContractView:weakself.contractV];
        if (success) {
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
            [weakself ledger_pledgeInfoByTransactionID];
        } else {
            [kAppD.window makeToastDisappearWithText:kLang(@"failed_")];
        }
    }];
}

- (void)showRevokingProcessView {
    _revokingProcessV = [RevokingProcessView getInstance];
    [_revokingProcessV show];
}

- (void)hideRevokingProcessView {
    if (_revokingProcessV) {
        [_revokingProcessV hide];
        _revokingProcessV = nil;
    }
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
            if ([StakingUtil isRedeemable:[_inputPledgeM.withdrawTime doubleValue]]) { // 可赎回
                 [self startBenefitWithdraw];
            } else {

            }
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawStart]) {
            [self startBenefitWithdraw];
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawProcess]) {
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawDone]) {
        }
    } else if ([_inputPledgeM.pType isEqualToString:@"mintage"]) {
        if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeStart]) {
            
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeProcess]) {
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeDone]) {
            if ([StakingUtil isRedeemable:[_inputPledgeM.withdrawTime doubleValue]]) { // 可赎回
                [self startMintageWithdraw];
            } else {
                
            }
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawStart]) {
            [self startMintageWithdraw];
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawProcess]) {
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawDone]) {
        }
    }
}

- (IBAction)stakeFromCopyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _stakeFromLab.text?:@"";
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
}

- (IBAction)stakeToCopyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _stakeToLab.text?:@"";
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
}

- (IBAction)trasactionCopyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _transactionLab.text?:@"";
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
}

@end