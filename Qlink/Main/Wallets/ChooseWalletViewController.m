//
//  ChooseWalletViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/22.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ChooseWalletViewController.h"
#import "ETHCreateWalletViewController.h"
#import "NEOCreateWalletViewController.h"
#import "ETHImportWalletViewController.h"
#import <ETHFramework/ETHFramework.h>
#import "NEOImportViewController.h"
#import "Qlink-Swift.h"
//#import <NEOFramework/NEOFramework.h>
#import "ReportUtil.h"
#import "ETHWalletInfo.h"
#import "EOSImportViewController.h"
#import "EOSRegisterAccountViewController.h"

@interface ChooseWalletViewController () {
    BOOL isAgree;
}

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *importBtn;
@property (weak, nonatomic) IBOutlet UIView *createBtn;
@property (weak, nonatomic) IBOutlet UIButton *ethBtn;
@property (weak, nonatomic) IBOutlet UIButton *eosBtn;
@property (weak, nonatomic) IBOutlet UIButton *neoBtn;


@end

@implementation ChooseWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self renderView];
    [self configInit];
    [self ethAction:_ethBtn];
}

#pragma mark - Operation
- (void)renderView {
    UIColor *shadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_importBtn addShadowWithOpacity:1 shadowColor:shadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
    [_createBtn addShadowWithOpacity:1 shadowColor:shadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
    
}

- (void)configInit {
    _backBtn.hidden = !_showBack;
    
}

- (void)refreshSelectBtn:(UIButton *)sender {
    _ethBtn.selected = sender==_ethBtn?YES:NO;
    _eosBtn.selected = sender==_eosBtn?YES:NO;
    _neoBtn.selected = sender==_neoBtn?YES:NO;
}

- (void)createETHWallet {
//    TrustWalletManage *manage = [[TrustWalletManage alloc] init];
//     [manage createInstantWallet];
    kWeakSelf(self);
    [kAppD.window makeToastInView:kAppD.window];
    [TrustWalletManage.sharedInstance createInstantWallet:^(NSArray<NSString *> * arr, NSString *address) {
        [kAppD.window hideToast];
        
        [TrustWalletManage.sharedInstance exportPrivateKeyWithAddress:address?:@"" :^(NSString * privateKey) {
            
            ETHWalletInfo *walletInfo = [[ETHWalletInfo alloc] init];
            walletInfo.privatekey = privateKey;
            walletInfo.mnemonic = @"";
            walletInfo.keystore = @"";
            walletInfo.password = @"";
            walletInfo.address = address;
            walletInfo.type = @"0"; // 创建
            // 存储keychain
            [walletInfo saveToKeyChain];
            
            [TrustWalletManage.sharedInstance exportPublicKeyWithAddress:walletInfo.address :^(NSString * _Nullable publicKey) {
                [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"ETH" address:address pubKey:publicKey?:@"" privateKey:walletInfo.privatekey]; // 上报钱包创建
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:Add_ETH_Wallet_Noti object:nil];
            
            if (arr) {
                AppConfigUtil.shareInstance.mnemonicArr = arr;
                [weakself jumpToCreateETH];
            }
        }];
    }];
}

- (void)createNEOWallet {
    [kAppD.window makeToastInView:kAppD.window];
    BOOL isSuccess = [NEOWalletManage.sharedInstance createWallet];
    [kAppD.window hideToast];
    if (isSuccess) {
        NEOWalletInfo *walletInfo = [[NEOWalletInfo alloc] init];
        walletInfo.address = [NEOWalletManage.sharedInstance getWalletAddress];
        walletInfo.wif = [NEOWalletManage.sharedInstance getWalletWif];
        walletInfo.privateKey = [NEOWalletManage.sharedInstance getWalletPrivateKey];
        walletInfo.publicKey = [NEOWalletManage.sharedInstance getWalletPublicKey];
        // 存储keychain
        [walletInfo saveToKeyChain];
        
        [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"NEO" address:walletInfo.address pubKey:walletInfo.publicKey privateKey:walletInfo.privateKey]; // 上报钱包创建
        [[NSNotificationCenter defaultCenter] postNotificationName:Add_NEO_Wallet_Noti object:nil];
        [self jumpToCreateNEO:walletInfo];
    } else {
        DDLogDebug(@"创建neo钱包失败");
    }
}

- (void)createEOSWallet {
    [self jumpToEOSRegister];
}

#pragma mark - Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createAction:(id)sender {
    if (!isAgree) {
        [kAppD.window makeToastDisappearWithText:@"Please Agree First"];
        return;
    }
    if (_ethBtn.selected) {
        [self createETHWallet];
    } else if (_eosBtn.selected) {
        [self createEOSWallet];
    } else if (_neoBtn.selected) {
        [self createNEOWallet];
    }
}

- (IBAction)importAction:(id)sender {
    if (!isAgree) {
        [kAppD.window makeToastDisappearWithText:@"Please Agree First"];
        return;
    }
    if (_ethBtn.selected) {
        [self jumpToETHImport];
    } else if (_eosBtn.selected) {
        [self jumpToEOSImport];
    } else if (_neoBtn.selected) {
        [self jumpToNEOImport];
    }
}

- (IBAction)agreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    isAgree = sender.selected;
}

- (IBAction)termAction:(id)sender {
    
}

- (IBAction)ethAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    [self refreshSelectBtn:sender];
}

- (IBAction)eosAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    [self refreshSelectBtn:sender];
}

- (IBAction)neoAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    [self refreshSelectBtn:sender];
}


#pragma mark - Transition
- (void)jumpToCreateETH {
    ETHCreateWalletViewController *vc = [[ETHCreateWalletViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToCreateNEO:(NEOWalletInfo *)walletInfo {
    NEOCreateWalletViewController *vc = [[NEOCreateWalletViewController alloc] init];
    vc.walletInfo = walletInfo;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToEOSRegister {
    EOSRegisterAccountViewController *vc = [[EOSRegisterAccountViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToETHImport {
    ETHImportWalletViewController *vc = [[ETHImportWalletViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToNEOImport {
    NEOImportViewController *vc = [[NEOImportViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToEOSImport {
    EOSImportViewController *vc = [[EOSImportViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
