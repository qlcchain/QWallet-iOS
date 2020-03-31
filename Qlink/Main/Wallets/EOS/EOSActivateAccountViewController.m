//
//  EOSActivateAccountViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/12/12.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSActivateAccountViewController.h"
#import "WalletsSwitchViewController.h"
#import "WalletCommonModel.h"
#import "QNavigationController.h"
#import "EOSTransferConfirmView.h"
#import "EOSWalletUtil.h"
#import "SuccessTipView.h"
#import "EOSResourcePriceModel.h"
#import "NSString+RemoveZero.h"
#import "RLArithmetic.h"
//#import "GlobalConstants.h"

@interface EOSActivateAccountViewController () {
    BOOL stakeCpuAndNetOK;
    BOOL buyRamOK;
}

@property (weak, nonatomic) IBOutlet UILabel *accountNameLab;
@property (weak, nonatomic) IBOutlet UITextView *ownerKeyTV;
@property (weak, nonatomic) IBOutlet UITextView *activeKeyTV;
@property (weak, nonatomic) IBOutlet UILabel *paymentAccountLab;
@property (weak, nonatomic) IBOutlet UIButton *activeBtn;

@property (nonatomic, strong) EOSResourcePriceModel *resourcePriceM;
@property (nonatomic, strong) NSString *eosAmount;

@end

@implementation EOSActivateAccountViewController

#pragma mark - Observe
- (void)addObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(walletChange:) name:Wallet_Change_Noti object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stakeSuccess:) name:EOS_Approve_Success_Noti object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stakeFail:) name:EOS_Approve_Fail_Noti object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyRamSuccess:) name:EOS_BuyRam_Success_Noti object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyRamFail:) name:EOS_BuyRam_Fail_Noti object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createAccountSuccess:) name:EOS_CreateAccount_Success_Noti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createAccountFail:) name:EOS_CreateAccount_Fail_Noti object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self addObserve];
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    [_activeBtn cornerRadius:4];
}

- (void)configInit {
    // @{@"accountName":_eosCreateSourceM.accountName,@"activePublicKey":_eosCreateSourceM.ownerPublicKey,@"ownerPublicKey":_eosCreateSourceM.activePublicKey}
    _accountNameLab.text = _qrDic[@"accountName"];
    _ownerKeyTV.text = _qrDic[@"ownerPublicKey"];
    _activeKeyTV.text = _qrDic[@"activePublicKey"];
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeEOS) {
        _paymentAccountLab.text = currentWalletM.name;
        _paymentAccountLab.alpha = 1;
    } else {
        _paymentAccountLab.text = kLang(@"please_switch_to_eos_wallet");
        _paymentAccountLab.alpha = 0.3;
    }
    
    [self requestEosEos_resource_price];
}

- (void)showEOSTransferConfirmView:(NSString *)showAmount {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    NSString *to = _accountNameLab.text?:@"";
    NSString *amount = showAmount;
    NSString *memo = @"";
    EOSTransferConfirmView *view = [EOSTransferConfirmView getInstance];
    [view configWithWallet:currentWalletM to:to amount:amount memo:memo showMemo:NO];
    kWeakSelf(self);
    view.confirmBlock = ^{
        [weakself activeAccount];
    };
    [view show];
}

- (void)activeAccount {
    // 创建费  0.1883 EOS, stake_net_quantity: '0.0400 EOS',stake_cpu_quantity: '0.2500 EOS',RAM 4KB
    
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    NSString *from = currentWalletM.account_name?:@"";
    NSString *to = _accountNameLab.text?:@"";
    NSString *ownerPublicKey = _ownerKeyTV.text?:@"";
    NSString *activePublicKey = _activeKeyTV.text?:@"";
//    NSString *createAccountAmount = @"0.1883";
    NSString *cpuAmount = @"0.2500";
    NSString *netAmount = @"0.0400";
    NSString *buyRamAmount = _eosAmount;
    [EOSWalletUtil.shareInstance createAccountWithFrom:from to:to ownerPublicKey:ownerPublicKey activePublicKey:activePublicKey buyRamEOSAmount:buyRamAmount stakeCpuAmount:cpuAmount stakeNetAmount:netAmount];
//    [EOSWalletUtil.shareInstance createAccountWithAccountName:accountName ownerPublicKey:ownerPublicKey activePublicKey:activePublicKey complete:^(BOOL success) {
//        if (success) {
//            stakeCpuAndNetOK = NO;
//            buyRamOK = NO;
//
//            [weakself stakeCpuAndNet];
//        } else {
//            NSLog(@"创建账户失败");
//        }
//    }];
}

//- (void)stakeCpuAndNet {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    NSString *cpuAmount = @"0.2500";
//    NSString *netAmount = @"0.0400";
//    NSString *from = currentWalletM.account_name?:@"";
//    NSString *to = _accountNameLab.text?:@"";
//
//    [EOSWalletUtil.shareInstance stakeWithCpuAmount:cpuAmount netAmount:netAmount from:from to:to operationType:EOSOperationTypeStake]; // 先抵押cpu、net
//}
//
//- (void)buyRam {
//    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    NSString *from = currentWalletM.account_name?:@"";
//    NSString *to = _accountNameLab.text?:@"";
//    NSString *buyRamAmount = _eosAmount;
//    [EOSWalletUtil.shareInstance stakeWithEosAmount:buyRamAmount from:from to:to bytes:@"" operationType:EOSOperationTypeBuyRam]; // 再买ram
//}

- (void)showSuccessView {
    SuccessTipView *tip = [SuccessTipView getInstance];
    [tip showWithTitle:kLang(@"success")];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchWalletAction:(id)sender {
    [self jumpToWalletsSwitch];
}

- (IBAction)activeAction:(id)sender {
    //创建费  0.1883 EOS, stake_net_quantity: '0.0400 EOS',stake_cpu_quantity: '0.2500 EOS',RAM 4KB
    if (!_paymentAccountLab.text || _paymentAccountLab.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_switch_to_eos_wallet")];
        return;
    }
    
//    _eosAmount = [[NSString stringWithFormat:@"%@",@(0.1883+0.0400+0.2500+[_resourcePriceM.ramPrice doubleValue]*4)] removeFloatAllZero];
    _eosAmount = @(0.1883+0.0400+0.2500+[_resourcePriceM.ramPrice doubleValue]*4).mul(@(1));
    NSString *showAmount = [NSString stringWithFormat:@"≈%@ EOS",_eosAmount];
    
    [self showEOSTransferConfirmView:showAmount];
}

#pragma mark - Request
- (void)requestEosEos_resource_price {
    kWeakSelf(self);
    NSDictionary *params = @{};
    [RequestService requestWithUrl5:eosEos_resource_price_Url params:params httpMethod:HttpMethodPost successBlock:^(NSURLSessionDataTask *dataTask, id responseObject) {
        if ([[responseObject objectForKey:Server_Code] integerValue] == 0) {
            NSDictionary *dic = responseObject[Server_Data];
            weakself.resourcePriceM = [EOSResourcePriceModel getObjectWithKeyValues:dic];
        }
    } failedBlock:^(NSURLSessionDataTask *dataTask, NSError *error) {
    }];
}

#pragma mark - Transition
- (void)jumpToWalletsSwitch {
    WalletsSwitchViewController *vc = [[WalletsSwitchViewController alloc] init];
    QNavigationController *nav = [[QNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Noti
- (void)walletChange:(NSNotification *)noti {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
    if (currentWalletM.walletType == WalletTypeEOS) {
        _paymentAccountLab.text = currentWalletM.name;
        _paymentAccountLab.alpha = 1;
    }
}

//- (void)stakeSuccess:(NSNotification *)noti {
//    stakeCpuAndNetOK = YES;
//
//    [self buyRam];
//}
//
//- (void)stakeFail:(NSNotification *)noti {
//
//}
//
//- (void)buyRamSuccess:(NSNotification *)noti {
//    buyRamOK = YES;
//
//    [self showSuccessView];
//
//    [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
//}
//
//- (void)buyRamFail:(NSNotification *)noti {
//
//}

- (void)createAccountSuccess:(NSNotification *)noti {
    [self showSuccessView];
    
    [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
}

- (void)createAccountFail:(NSNotification *)noti {
    
}

@end
