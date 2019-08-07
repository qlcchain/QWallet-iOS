//
//  NEOBackupDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/12.
//  Copyright © 2018 pan. All rights reserved.
//

#import "NEOBackupDetailViewController.h"
#import "NEOWalletInfo.h"
#import "QlinkTabbarViewController.h"
#import "SuccessTipView.h"
#import "BackupKeyView.h"

@interface NEOBackupDetailViewController () {
    BOOL isTip;
}

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *publicAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *encryptedKeyLab;
@property (weak, nonatomic) IBOutlet UILabel *privateKeyLab;


@end

@implementation NEOBackupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    UIColor *shadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_confirmBtn addShadowWithOpacity:1 shadowColor:shadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
    
}

- (void)configInit {
    _publicAddressLab.text = _walletInfo.publicKey;
    _encryptedKeyLab.text = _walletInfo.wif;
    _privateKeyLab.text = _walletInfo.privateKey;
}

- (void)showCreateSuccessView {
    SuccessTipView *tip = [SuccessTipView getInstance];
    [tip showWithTitle:kLang(@"create_success")];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Action
- (IBAction)confirmAction:(id)sender {
    if (!isTip) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_agree_first")];
        return;
    }
    
    [self showCreateSuccessView];
//    [self performSelector:@selector(jumpToTabbar) withObject:nil afterDelay:2];
    [self performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tipAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    isTip = sender.selected;
}

- (IBAction)copyEncryptedKeyAction:(id)sender {
    BackupKeyView *view = [BackupKeyView getInstance];
    [view showWithPrivateKey:_encryptedKeyLab.text title:kLang(@"encrypted_key_wif")];
}

- (IBAction)copyPrivateKeyAction:(id)sender {
    BackupKeyView *view = [BackupKeyView getInstance];
    [view showWithPrivateKey:_privateKeyLab.text title:kLang(@"private_key_hex")];
}

#pragma mark - Transition
- (void)jumpToTabbar {
    [kAppD setRootTabbar];
    kAppD.tabbarC.selectedIndex = TabbarIndexWallet;
}


@end
