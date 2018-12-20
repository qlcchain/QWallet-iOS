//
//  NEOImportViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/12.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSImportViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "QlinkTabbarViewController.h"
#import "SuccessTipView.h"
#import "Qlink-Swift.h"
//#import <NEOFramework/NEOFramework.h>
#import "WalletQRViewController.h"
#import "ReportUtil.h"
#import "EOSWalletUtil.h"
#import <eosFramework/EOS_Key_Encode.h>

@interface EOSImportViewController () {
    BOOL privatekeyAgree;
}

@property (weak, nonatomic) IBOutlet UITextField *accountNameTF;
@property (weak, nonatomic) IBOutlet UIView *ownerPrivateTVBack;
@property (weak, nonatomic) IBOutlet UITextView *ownerPrivateTV;
@property (weak, nonatomic) IBOutlet UIView *activePrivateTVBack;
@property (weak, nonatomic) IBOutlet UITextView *activePrivateTV;
@property (weak, nonatomic) IBOutlet UIButton *privateStartImportBtn;

@end

@implementation EOSImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];

}

#pragma mark - Operation
- (void)renderView {
    [_ownerPrivateTVBack cornerRadius:6 strokeSize:1 color:UIColorFromRGB(0xECEFF1)];
    _ownerPrivateTV.placeholder = @"Please input owner private key";
    [_activePrivateTVBack cornerRadius:6 strokeSize:1 color:UIColorFromRGB(0xECEFF1)];
    _activePrivateTV.placeholder = @"Please input active private key";
    
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
        if (weakself.ownerPrivateTV.text == nil) {
            weakself.ownerPrivateTV.text = codeValue;
        }
        if (weakself.activePrivateTV.text == nil) {
            weakself.activePrivateTV.text = codeValue;
        }
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
    if (_ownerPrivateTV.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:@"Please Input owner private key"];
        return;
    }
    if (_activePrivateTV.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:@"Please Input active private key"];
        return;
    }
    if (_accountNameTF.text.length <= 0) {
        [kAppD.window makeToastDisappearWithText:@"Please Input Account name"];
        return;
    }
    
    if (![EOS_Key_Encode validateWif:_ownerPrivateTV.text]) {
        [kAppD.window makeToastDisappearWithText:@"owner private key format error"];
        return;
    }
    if (![EOS_Key_Encode validateWif:_activePrivateTV.text]) {
        [kAppD.window makeToastDisappearWithText:@"active private key format error"];
        return;
    }
    
    NSString *private_activeKey = _activePrivateTV.text.trim;
    NSString *private_ownerKey = _ownerPrivateTV.text.trim;
    NSString *accountName = _accountNameTF.text.trim;
    [kAppD.window makeToastInView:kAppD.window];
    kWeakSelf(self)
    [[EOSWalletUtil shareInstance] importWithAccountName:accountName private_activeKey:private_activeKey private_ownerKey:private_ownerKey complete:^(BOOL success) {
        [kAppD.window hideToast];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Add_NEO_Wallet_Noti object:nil];
            [weakself showImportSuccessView];
            [weakself performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
        }
    }];
}

#pragma mark - Transition
- (void)jumpToTabbar {
    [kAppD setRootTabbar];
    kAppD.tabbarC.selectedIndex = TabbarIndexWallet;
}

@end
