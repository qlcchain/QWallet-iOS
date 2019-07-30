//
//  NEOImportViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/12.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NEOImportViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "QlinkTabbarViewController.h"
#import "SuccessTipView.h"
#import "Qlink-Swift.h"
//#import <NEOFramework/NEOFramework.h>
#import "WalletQRViewController.h"
#import "ReportUtil.h"
#import "WebViewController.h"

@interface NEOImportViewController () {
    BOOL privatekeyAgree;
}

@property (weak, nonatomic) IBOutlet UIView *privateTVBack;
@property (weak, nonatomic) IBOutlet UITextView *privateTV;
@property (weak, nonatomic) IBOutlet UIButton *privateStartImportBtn;

@end

@implementation NEOImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];

}

#pragma mark - Operation
- (void)renderView {
    [_privateTVBack cornerRadius:6 strokeSize:1 color:UIColorFromRGB(0xECEFF1)];
    _privateTV.placeholder = @"Please input your private key";
    UIColor *btnShadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_privateStartImportBtn addShadowWithOpacity:1 shadowColor:btnShadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
}

- (void)showImportSuccessView {
    SuccessTipView *tip = [SuccessTipView getInstance];
    [tip showWithTitle:@"Import Success"];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)scanAction:(id)sender {
    kWeakSelf(self);
    WalletQRViewController *vc = [[WalletQRViewController alloc] initWithCodeQRCompleteBlock:^(NSString *codeValue) {
        weakself.privateTV.text = codeValue;
    } needPop:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)privatekeyAgreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    privatekeyAgree = sender.selected;
}

- (IBAction)importAction:(id)sender {
    if (!privatekeyAgree) {
        [kAppD.window makeToastDisappearWithText:@"Please Agree First"];
        return;
    }
    if (_privateTV.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:@"Please Input Success"];
        return;
    }
    
    NSString *privatekey = _privateTV.text.trim;
    [kAppD.window makeToastInView:kAppD.window];
    BOOL isScueess = [NEOWalletManage.sharedInstance getWalletWithPrivatekeyWithPrivatekey:privatekey];
    [kAppD.window hideToast];
    if (isScueess) {
        NEOWalletInfo *walletInfo = [[NEOWalletInfo alloc] init];
        walletInfo.address = [NEOWalletManage.sharedInstance getWalletAddress];
        walletInfo.wif = [NEOWalletManage.sharedInstance getWalletWif];
        walletInfo.privateKey = [NEOWalletManage.sharedInstance getWalletPrivateKey];
        walletInfo.publicKey = [NEOWalletManage.sharedInstance getWalletPublicKey];
        // 存储keychain
        [walletInfo saveToKeyChain];
        
        [ReportUtil requestWalletReportWalletCreateWithBlockChain:@"NEO" address:walletInfo.address pubKey:walletInfo.publicKey privateKey:walletInfo.privateKey]; // 上报钱包创建
        [[NSNotificationCenter defaultCenter] postNotificationName:Add_NEO_Wallet_Noti object:nil];
        [self showImportSuccessView];
//        [self performSelector:@selector(jumpToTabbar) withObject:nil afterDelay:2];
        [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
    } else {
        [kAppD.window makeToastDisappearWithText:@"Import fail"];
    }
}

- (IBAction)termsAction:(id)sender {
    [self jumpToTerms];
}


#pragma mark - Transition
- (void)jumpToTabbar {
    [kAppD setRootTabbar];
    kAppD.tabbarC.selectedIndex = TabbarIndexWallet;
}

- (void)jumpToTerms {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.inputUrl = TermsOfServiceAndPrivatePolicy_Url;
    vc.inputTitle = TermsOfTitle;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
