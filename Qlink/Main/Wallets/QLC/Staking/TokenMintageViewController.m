//
//  TokenMintageViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2019/8/15.
//  Copyright © 2019 pan. All rights reserved.
//

#import "TokenMintageViewController.h"
#import "WalletSelectViewController.h"
#import "QNavigationController.h"
#import "WalletCommonModel.h"
#import "QContractView.h"
#import "NEOWalletInfo.h"
#import "QLCWalletInfo.h"
#import "NEOAddressInfoModel.h"
#import "Qlink-Swift.h"
#import "NSDate+Category.h"
#import "StakingProcessView.h"

@interface TokenMintageViewController ()

// Stake From
@property (weak, nonatomic) IBOutlet UITextField *stakeFromTF;
@property (weak, nonatomic) IBOutlet UIView *stakeFromWalletBack;
@property (weak, nonatomic) IBOutlet UIImageView *stakeFromWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *stakeFromWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *stakeFromWalletAddressLab;

// Stake To
@property (weak, nonatomic) IBOutlet UITextField *stakeToTF;
@property (weak, nonatomic) IBOutlet UIView *stakeToWalletBack;
@property (weak, nonatomic) IBOutlet UIImageView *stakeToWalletIcon;
@property (weak, nonatomic) IBOutlet UILabel *stakeToWalletNameLab;
@property (weak, nonatomic) IBOutlet UILabel *stakeToWalletAddressLab;

@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextField *stakingPeriodTF;
@property (weak, nonatomic) IBOutlet UILabel *stakingPeriodTimeLab;
@property (weak, nonatomic) IBOutlet UITextField *tokenNameTF;
@property (weak, nonatomic) IBOutlet UITextField *tokenSymbolTF;
@property (weak, nonatomic) IBOutlet UITextField *tokenSupplyTF;
@property (weak, nonatomic) IBOutlet UITextField *tokenAmountTF;
@property (weak, nonatomic) IBOutlet UIButton *invokeBtn;

@property (nonatomic, strong) WalletCommonModel *stakeFromWalletM;
@property (nonatomic, strong) WalletCommonModel *stakeToWalletM;
@property (nonatomic, strong) NEOAssetModel *currentNEOAsset;
@property (nonatomic, strong) StakingProcessView *stakingProcessV;
@property (nonatomic, strong) QContractView *contractV;

@end

@implementation TokenMintageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;

    [self configInit];
}

#pragma mark - Operation
- (void)configInit {
    _invokeBtn.layer.cornerRadius = 4;
    _invokeBtn.layer.masksToBounds = YES;
    _invokeBtn.userInteractionEnabled = NO; // D5D8DD
    _invokeBtn.backgroundColor = UIColorFromRGB(0xD5D8DD);
    
    _stakeFromWalletBack.hidden = YES;
    _stakeToWalletBack.hidden = YES;
    
    _stakingPeriodTimeLab.text = [NSString stringWithFormat:@"%@%@, %@",kLang(@"staking_will_end_on"),@"",kLang(@"the_minimum_period_is_180_days")];
    [_amountTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [_stakingPeriodTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [_tokenNameTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [_tokenAmountTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [_tokenSupplyTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [_tokenSymbolTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}

- (void)changedTextField:(id)textField {
    [self refreshInvokeBtnState];
    
    if (textField == _stakingPeriodTF) {
        if ([_stakingPeriodTF.text integerValue]) {
            NSString *timeStr = [NSDate getTimeWithFromDate:[NSDate date] addDay:[_stakingPeriodTF.text integerValue]];
            if (![timeStr isEmptyString]) {
                NSString *periodTime = [timeStr substringToIndex:10];
                _stakingPeriodTimeLab.text = [NSString stringWithFormat:@"%@%@, %@",kLang(@"staking_will_end_on"),periodTime,kLang(@"the_minimum_period_is_180_days")];
            }
        }
    }
}

- (void)refreshInvokeBtnState {
    if (![_amountTF.text isEmptyString] && ![_stakingPeriodTF.text isEmptyString] && ![_tokenNameTF.text isEmptyString] && ![_tokenSymbolTF.text isEmptyString] && ![_tokenSupplyTF.text isEmptyString] && ![_tokenAmountTF.text isEmptyString] && _stakeToWalletM && _stakeFromWalletM) {
        _invokeBtn.userInteractionEnabled = YES;
        _invokeBtn.backgroundColor = MAIN_BLUE_COLOR;
    } else {
        _invokeBtn.userInteractionEnabled = NO;
        _invokeBtn.backgroundColor = UIColorFromRGB(0xD5D8DD);
    }
}

- (void)refreshBalanceView {
    NSString *balanceStr = [NSString stringWithFormat:@"%@: 0.00 QLC",kLang(@"balance")];
    if (_currentNEOAsset) {
        balanceStr = [NSString stringWithFormat:@"%@: %@ %@",kLang(@"balance"),[_currentNEOAsset getTokenNum],_currentNEOAsset.asset_symbol];
    }
    _balanceLab.text = balanceStr;
}

- (void)showStakingProcessView {
    _stakingProcessV = [StakingProcessView getInstance];
    [_stakingProcessV show];
}

- (void)hideStakingProcessView {
    if (_stakingProcessV) {
        [_stakingProcessV hide];
        _stakingProcessV = nil;
    }
}

#pragma mark - Request
- (void)requestNEOAddressInfo:(NSString *)address {
    // 检查地址有效性
    BOOL validateNEOAddress = [NEOWalletManage.sharedInstance validateNEOAddressWithAddress:address];
    if (!validateNEOAddress) {
        return;
    }
    kWeakSelf(self);
    NSDictionary *params = @{@"address":address};
    [RequestService requestWithUrl10:neoAddressInfo_Url params:params httpMethod:HttpMethodPost serverType:RequestServerTypeRelease successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = [responseObject objectForKey:Server_Data];
            NEOAddressInfoModel *neoAddressInfoM = [NEOAddressInfoModel getObjectWithKeyValues:dic];
            __block NEOAssetModel *model = nil;
            [neoAddressInfoM.balance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NEOAssetModel *temp = obj;
                if ([temp.asset_symbol isEqualToString:@"QLC"]) {
                    model = temp;
                    *stop = YES;
                }
            }];
            weakself.currentNEOAsset = model;
            [weakself refreshBalanceView];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
    }];
}

#pragma mark - Action

- (IBAction)stakeFromShowAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    vc.inputWalletType = WalletTypeNEO;
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        weakself.stakeFromWalletBack.hidden = NO;
        weakself.stakeFromWalletM = model;
        weakself.stakeFromWalletIcon.image = [WalletCommonModel walletIcon:model.walletType];
        weakself.stakeFromWalletNameLab.text = model.name;
        weakself.stakeFromWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        weakself.stakeFromTF.text = model.address;
        
        [weakself requestNEOAddressInfo:model.address];
        [weakself refreshInvokeBtnState];
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)stakeFromCloseAction:(id)sender {
    _stakeFromWalletM = nil;
    _stakeFromWalletBack.hidden = YES;
    _stakeFromTF.text = nil;
    
    [self refreshInvokeBtnState];
}

- (IBAction)stakeToShowAction:(id)sender {
    kWeakSelf(self);
    WalletSelectViewController *vc = [[WalletSelectViewController alloc] init];
    vc.inputWalletType = WalletTypeQLC;
    [vc configSelectBlock:^(WalletCommonModel * _Nonnull model) {
        weakself.stakeToWalletBack.hidden = NO;
        weakself.stakeToWalletM = model;
        weakself.stakeToWalletIcon.image = [WalletCommonModel walletIcon:model.walletType];
        weakself.stakeToWalletNameLab.text = model.name;
        weakself.stakeToWalletAddressLab.text = [NSString stringWithFormat:@"%@...%@",[model.address substringToIndex:8],[model.address substringWithRange:NSMakeRange(model.address.length - 8, 8)]];
        weakself.stakeToTF.text = model.address;
        
        [weakself refreshInvokeBtnState];
    }];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)stakeToCloseAction:(id)sender {
    _stakeToWalletM = nil;
    _stakeToWalletBack.hidden = YES;
    _stakeToTF.text = nil;
    
    [self refreshInvokeBtnState];
}

- (IBAction)invokeAction:(id)sender {
    [self.view endEditing:YES];
    if (!_stakeFromWalletM) {
        [kAppD.window makeToastDisappearWithText:kLang(@"stake_from_is_empty")];
        return;
    }
    if (!_stakeToWalletM) {
        [kAppD.window makeToastDisappearWithText:kLang(@"stake_to_is_empty")];
        return;
    }
    if ([_amountTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"amount_is_empty")];
        return;
    }
    if ([_amountTF.text doubleValue] < 1) {
        [kAppD.window makeToastDisappearWithText:kLang(@"amount_is_at_least_1_qlc")];
        return;
    }
    if ([_amountTF.text doubleValue] > [[_currentNEOAsset getTokenNum] doubleValue]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"balance_is_not_enough")];
        return;
    }
    if ([_stakingPeriodTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"staking_period_is_empty")];
        return;
    }
    if ([_stakingPeriodTF.text doubleValue] < 10) {
        [kAppD.window makeToastDisappearWithText:kLang(@"staking_period_is_at_least_180_days")];
        return;
    }
    if ([_tokenSymbolTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"token_symbol_is_empty")];
        return;
    }
    if ([_tokenSupplyTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"token_supply_is_empty")];
        return;
    }
    if ([_tokenAmountTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"token_amount_is_empty")];
        return;
    }
    if ([_tokenNameTF.text isEmptyString]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"token_name_is_empty")];
        return;
    }
    
    NSString *neo_publicKey = [NEOWalletInfo getNEOPublickKeyWithAddress:_stakeFromWalletM.address];
    NSString *neo_wifKey = [NEOWalletInfo getNEOEncryptedKeyWithAddress:_stakeFromWalletM.address];
    NSString *qlc_publicKey = [QLCWalletInfo getQLCPublicKeyWithAddress:_stakeToWalletM.address];
    NSString *qlc_privateKey = [QLCWalletInfo getQLCPrivateKeyWithAddress:_stakeToWalletM.address];
    NSString *fromAddress = _stakeFromWalletM.address;
    NSString *qlcAddress = _stakeToWalletM.address;
    NSString *qlcAmount = _amountTF.text;
    NSString *lockTime = _stakingPeriodTF.text;
    NSString *tokenName = _tokenNameTF.text;
    NSString *tokenSymbol = _tokenSymbolTF.text;
    NSString *totalSupply = _tokenSupplyTF.text;
    NSString *decimals = @"8";
    kWeakSelf(self);
//    [kAppD.window makeToastInView:kAppD.window text:kLang(@"process___")];
    _contractV = [QContractView addQContractView];
    [self showStakingProcessView];
    [_contractV mintage_createMultiSig:neo_publicKey neo_wifKey:neo_wifKey fromAddress:fromAddress qlcAddress:qlcAddress qlcAmount:qlcAmount lockTime:lockTime qlc_privateKey:qlc_privateKey qlc_publicKey:qlc_publicKey tokenName:tokenName tokenSymbol:tokenSymbol totalSupply:totalSupply decimals:decimals resultHandler:^(id result, BOOL success, NSString * _Nullable message) {
//        [kAppD.window hideToast];
        [weakself hideStakingProcessView];
        [QContractView removeQContractView:weakself.contractV];
        if (success) {
            [kAppD.window makeToastDisappearWithText:kLang(@"success_")];
//            [weakself.navigationController popViewControllerAnimated:YES];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        } else {
            NSString *tip = [kLang(@"failed_") stringByAppendingFormat:@"(%@)",message ?: @""];
            [kAppD.window makeToastDisappearWithText:tip];
        }
    }];
}

@end
