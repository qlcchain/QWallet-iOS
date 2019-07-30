//
//  NEOBackupDetailViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/12.
//  Copyright © 2018 pan. All rights reserved.
//

#import "QLCBackupDetailViewController.h"
#import "QLCWalletInfo.h"
#import "QlinkTabbarViewController.h"
#import "SuccessTipView.h"
#import "QLCWalletManage.h"

@interface QLCBackupDetailViewController () {
    BOOL isTip;
}

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *publicAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *mnemonicLab;
@property (weak, nonatomic) IBOutlet UILabel *seedLab;


@end

@implementation QLCBackupDetailViewController

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
    _publicAddressLab.text = _walletInfo.address;
    _mnemonicLab.text = [[QLCWalletManage shareInstance] exportMnemonicWithSeed:_walletInfo.seed];
    _seedLab.text = _walletInfo.seed;
}

- (void)showCreateSuccessView {
    SuccessTipView *tip = [SuccessTipView getInstance];
    [tip showWithTitle:@"Create Success"];
}

- (void)backToRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Action
- (IBAction)confirmAction:(id)sender {
    if (!isTip) {
        [kAppD.window makeToastDisappearWithText:@"Please Agree First"];
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

- (IBAction)copyMnemonicAction:(id)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:_mnemonicLab.text?:@""];
    [kAppD.window makeToastDisappearWithText:@"Copied"];
}

- (IBAction)copySeedAction:(id)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:_seedLab.text?:@""];
    [kAppD.window makeToastDisappearWithText:@"Copied"];
}


#pragma mark - Transition
- (void)jumpToTabbar {
    [kAppD setRootTabbar];
    kAppD.tabbarC.selectedIndex = TabbarIndexWallet;
}


@end
