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
#import "RefreshHelper.h"

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

@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (nonatomic, strong) RevokingProcessView *revokingProcessV;
@property (nonatomic, strong) QContractView *contractV;

@end

@implementation StakingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configRefresh];
    [self configInit];
}

#pragma mark - Operation
- (void)configRefresh {
    kWeakSelf(self);
    _mainScroll.mj_header = [RefreshHelper headerWithRefreshingBlock:^{
        [weakself ledger_pledgeInfoByTransactionID];
    }];
}

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
//        stateStr = _inputPledgeM.state;
        stateStr = kLang(@"pledge_process");
        stateArrowHidden = NO;
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeDone]) {
        if ([StakingUtil isRedeemable:[_inputPledgeM.withdrawTime doubleValue]]) {
            stateStr = kLang(@"revoke");
            stateArrowHidden = NO;
        } else {
            stateStr = kLang(@"staking_in_progress");
            stateArrowHidden = YES;
        }
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawStart]) {
        stateStr = kLang(@"withdraw_start");
        stateArrowHidden = NO;
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawProcess]) {
        stateStr = kLang(@"withdraw_process");
        stateArrowHidden = NO;
    } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawDone]) {
        stateStr = kLang(@"withdraw_done");
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
    NSString *multisigAddress = _inputPledgeM.multiSigAddress;
    kWeakSelf(self);
    _contractV = [QContractView addQContractView];
    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___")];
    [_contractV nep5_getLockInfo:lockTxId resultHandler:^(id result, BOOL success, NSString * _Nullable message) {
        if (success) {
            NSString *neo_address = result[@"neoAddress"];
            NSString *neo_publicKey = [NEOWalletInfo getNEOPublickKeyWithAddress:neo_address];
            NSString *neo_privateKey = [NEOWalletInfo getNEOPrivateKeyWithAddress:neo_address];
            if (!neo_publicKey) {
                [kAppD.window hideToast];
                [QContractView removeQContractView:weakself.contractV];
                [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@(%@)",kLang(@"the_wallet_is_none___"),neo_address]];
                return;
            }
            [weakself.contractV nep5_benefitWithdraw:lockTxId beneficial:beneficial amount:qlcAmount qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey neo_publicKey:neo_publicKey neo_privateKey:neo_privateKey multisigAddress:multisigAddress resultHandler:^(id result, BOOL success, NSString * _Nullable message) {
                [kAppD.window hideToast];
                [QContractView removeQContractView:weakself.contractV];
                if (success) {
                    [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
//                    [weakself ledger_pledgeInfoByTransactionID];
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    NSString *tip = [kLang(@"failed_") stringByAppendingFormat:@"(%@)",message ?: @""];
                    [kAppD.window makeToastDisappearWithText:tip];
                }
            }];
        } else {
            [kAppD.window hideToast];
            [QContractView removeQContractView:weakself.contractV];
            NSString *tip = [kLang(@"failed_") stringByAppendingFormat:@"(%@)",message ?: @""];
            [kAppD.window makeToastDisappearWithText:tip];
        }
    }];
}

- (void)vote_continueInvoke_pledgestart {
    if (!_inputPledgeM) {
        return;
    }
//    NSString *qlcAddress = _inputPledgeM.beneficial;
//    NSString *qlc_publicKey = [QLCWalletInfo getQLCPublicKeyWithAddress:qlcAddress];
//    NSString *qlc_privateKey = [QLCWalletInfo getQLCPrivateKeyWithAddress:qlcAddress];
    NSString *lockTxId = _inputPledgeM.nep5TxId;
    kWeakSelf(self);
    _contractV = [QContractView addQContractView];
    [self showRevokingProcessView];
//    [_contractV benefit_getnep5transferbytxid:lockTxId qlc_publicKey:qlc_publicKey qlc_privateKey:qlc_privateKey resultHandler:^(id result, BOOL success, NSString * _Nullable message) {
//        [weakself hideRevokingProcessView];
//        [QContractView removeQContractView:weakself.contractV];
//        if (success) {
//            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
//            [weakself.navigationController popToRootViewControllerAnimated:YES];
//        } else {
//            NSString *tip = [kLang(@"failed_") stringByAppendingFormat:@"(%@)",message ?: @""];
//            [kAppD.window makeToastDisappearWithText:tip];
//        }
//    }];
    
    [_contractV nep5_getLockInfo:lockTxId resultHandler:^(id result, BOOL success, NSString * _Nullable message) {
        if (success) {
            NSDictionary *dic = result;
            NSString *neoAddress = dic[@"neoAddress"];
            NSString *qlcAddress = dic[@"qlcAddress"];
            NSString *neo_publicKey = [NEOWalletInfo getNEOPublickKeyWithAddress:neoAddress];
//            NSString *neo_privateKey = [NEOWalletInfo getNEOPrivateKeyWithAddress:neoAddress];
            NSString *qlc_publicKey = [QLCWalletInfo getQLCPublicKeyWithAddress:qlcAddress];
            NSString *qlc_privateKey = [QLCWalletInfo getQLCPrivateKeyWithAddress:qlcAddress];
            NSString *multiSigAddress = dic[@"multiSigAddress"];
            NSString *qlcAmount = dic[@"amount"];
            NSString *state = dic[@"state"];
            if (!neo_publicKey) {
                [weakself hideRevokingProcessView];
                [QContractView removeQContractView:weakself.contractV];
                [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@(%@)",kLang(@"the_wallet_is_none___"),neoAddress]];
                return;
            }
            if (!qlc_publicKey) {
                [weakself hideRevokingProcessView];
                [QContractView removeQContractView:weakself.contractV];
                [kAppD.window makeToastDisappearWithText:[NSString stringWithFormat:@"%@(%@)",kLang(@"the_wallet_is_none___"),qlcAddress]];
                return;
            }
            if ([state integerValue] == 0) {
                [weakself hideRevokingProcessView];
                [QContractView removeQContractView:weakself.contractV];
                return;
            }

            NSString *qlc_amount = [NSString stringWithFormat:@"%@",@([qlcAmount doubleValue]/QLC_UnitNum)];
            [weakself.contractV nep5_prePareBenefitPledge:qlcAddress qlcAmount:qlc_amount multiSigAddress:multiSigAddress neo_publicKey:neo_publicKey lockTxId:lockTxId qlc_privateKey:qlc_privateKey qlc_publicKey:qlc_publicKey resultHandler:^(NSString * _Nullable result, BOOL success, NSString * _Nullable message) {
                [weakself hideRevokingProcessView];
                [QContractView removeQContractView:weakself.contractV];
                if (success) {
                    [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    NSString *tip = [kLang(@"failed_") stringByAppendingFormat:@"(%@)",message ?: @""];
                    [kAppD.window makeToastDisappearWithText:tip];
                }
            }];
            
        } else {
            [weakself hideRevokingProcessView];
            [QContractView removeQContractView:weakself.contractV];
//            NSString *tip = [kLang(@"failed_") stringByAppendingFormat:@"(%@)",message ?: @""];
//            [kAppD.window makeToastDisappearWithText:tip];
        }
    }];
}

- (void)vote_continueInvoke_pledgeprocess {
    [self vote_continueInvoke_pledgestart];
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
    [_contractV nep5_mintageWithdraw:lockTxId tokenId:tokenId resultHandler:^(id result, BOOL success, NSString * _Nullable message) {
        [kAppD.window hideToast];
        [QContractView removeQContractView:weakself.contractV];
        if (success) {
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
//            [weakself ledger_pledgeInfoByTransactionID];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        } else {
            NSString *tip = [kLang(@"failed_") stringByAppendingFormat:@"(%@)",message ?: @""];
            [kAppD.window makeToastDisappearWithText:tip];
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
        [weakself.mainScroll.mj_header endRefreshing];
        if (responseObject) {
            weakself.inputPledgeM = [PledgeInfoByBeneficialModel mj_objectWithKeyValues:responseObject];
            [weakself configInit];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakself.mainScroll.mj_header endRefreshing];
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
            [self vote_continueInvoke_pledgestart];
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeProcess]) {
            [self vote_continueInvoke_pledgeprocess];
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_PledgeDone]) {
            if ([StakingUtil isRedeemable:[_inputPledgeM.withdrawTime doubleValue]]) { // 可赎回
                 [self startBenefitWithdraw];
            } else {
            }
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawStart]) {
            [self startBenefitWithdraw];
        } else if ([_inputPledgeM.state isEqualToString:PledgeState_WithdrawProcess]) {
//            [self startBenefitWithdraw];
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
//            [self startMintageWithdraw];
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
