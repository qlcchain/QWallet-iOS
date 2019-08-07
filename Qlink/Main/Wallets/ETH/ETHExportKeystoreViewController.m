//
//  ETHExportKeystoreViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/11/8.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHExportKeystoreViewController.h"
#import <ETHFramework/ETHFramework.h>
#import "WalletCommonModel.h"
#import "LoginPWModel.h"

@interface ETHExportKeystoreViewController ()

@property (weak, nonatomic) IBOutlet UIView *textBack;
@property (weak, nonatomic) IBOutlet UIButton *copKeystoreBtn;
@property (weak, nonatomic) IBOutlet UITextView *textV;


@end

@implementation ETHExportKeystoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    UIColor *btnShadowColor = [UIColorFromRGB(0x1F314A) colorWithAlphaComponent:0.12];
    [_copKeystoreBtn addShadowWithOpacity:1 shadowColor:btnShadowColor shadowOffset:CGSizeMake(0, 2) shadowRadius:4 andCornerRadius:6];
    
    UIColor *borderColor = UIColorFromRGB(0xE8EAEC);
    [_textBack cornerRadius:6 strokeSize:1 color:borderColor];
}

- (void)configInit {
    WalletCommonModel *currentWalletM = [WalletCommonModel getCurrentSelectWallet];
//    NSString *pw = [LoginPWModel getLoginPW];
    NSString *pw = _inputPW?:@"";
    kWeakSelf(self);
    [TrustWalletManage.sharedInstance exportKeystoreWithAddress:currentWalletM.address?:@"" newPassword:pw :^(NSString * keystore) {
        weakself.textV.text = keystore;
    }];
}

- (void)copyKeystore {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _textV.text;
    [kAppD.window makeToastDisappearWithText:kLang(@"copied")];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)copKeystoreAction:(id)sender {
    [self copyKeystore];
}


@end
