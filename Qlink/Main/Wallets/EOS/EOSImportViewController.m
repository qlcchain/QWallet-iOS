//
//  NEOImportViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/12.
//  Copyright © 2018 pan. All rights reserved.
//

#import "EOSImportViewController.h"
#import "UITextView+ZWPlaceHolder.h"
//#import "QlinkTabbarViewController.h"
#import "MainTabbarViewController.h"
#import "SuccessTipView.h"
#import "Qlink-Swift.h"
//#import <NEOFramework/NEOFramework.h>
#import "WalletQRViewController.h"
#import "ReportUtil.h"
#import "EOSWalletUtil.h"
#import <eosFramework/EOS_Key_Encode.h>
#import "WebViewController.h"
//#import "GlobalConstants.h"
#import "NSString+Trim.h"

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
    _ownerPrivateTV.placeholder = kLang(@"please_input_owner_private_key");
    [_activePrivateTVBack cornerRadius:6 strokeSize:1 color:UIColorFromRGB(0xECEFF1)];
    _activePrivateTV.placeholder = kLang(@"please_input_active_private_key");
    
    UIColor *btnShadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_privateStartImportBtn addShadowWithOpacity:1 shadowColor:btnShadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
}

- (void)showImportSuccessView {
    SuccessTipView *tip = [SuccessTipView getInstance];
    [tip showWithTitle:kLang(@"import_success")];
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
        if (weakself.ownerPrivateTV.text.trim_whitespace == nil) {
            weakself.ownerPrivateTV.text = codeValue;
        }
        if (weakself.activePrivateTV.text.trim_whitespace == nil) {
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
        [kAppD.window makeToastDisappearWithText:kLang(@"please_agree_first")];
        return;
    }
    if (_ownerPrivateTV.text.trim_whitespace.length <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_input_owner_private_key")];
        return;
    }
    if (_activePrivateTV.text.trim_whitespace.length <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_input_active_private_key")];
        return;
    }
    if (_accountNameTF.text.trim_whitespace.length <= 0) {
        [kAppD.window makeToastDisappearWithText:kLang(@"please_input_account_name")];
        return;
    }
    
    if (![EOS_Key_Encode validateWif:_ownerPrivateTV.text.trim_whitespace]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"owner_private_key_format_error")];
        return;
    }
    if (![EOS_Key_Encode validateWif:_activePrivateTV.text.trim_whitespace]) {
        [kAppD.window makeToastDisappearWithText:kLang(@"active_private_key_format_error")];
        return;
    }
    
    NSString *private_activeKey = _activePrivateTV.text.trim_whitespace;
    NSString *private_ownerKey = _ownerPrivateTV.text.trim_whitespace;
    NSString *accountName = _accountNameTF.text.trim_whitespace;
    [kAppD.window makeToastInView:kAppD.window];
    kWeakSelf(self)
    [[EOSWalletUtil shareInstance] importWithAccountName:accountName private_activeKey:private_activeKey private_ownerKey:private_ownerKey complete:^(BOOL success) {
        [kAppD.window hideToast];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Add_EOS_Wallet_Noti object:nil];
            [weakself showImportSuccessView];
            [weakself performSelector:@selector(backToRoot) withObject:nil afterDelay:2];
        } else {
            [kAppD.window makeToastDisappearWithText:kLang(@"import_fail")];
        }
    }];
}

- (IBAction)termsAction:(id)sender {
    [self jumpToTerms];
}


#pragma mark - Transition
- (void)jumpToTabbar {
    [kAppD setRootTabbar];
    kAppD.mtabbarC.selectedIndex = MainTabbarIndexWallet;
}

- (void)jumpToTerms {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.inputUrl = TermsOfServiceAndPrivatePolicy_Url;
    vc.inputTitle = TermsOfTitle;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
