//
//  LoginInputPWViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ETHVerifyPWViewController.h"
#import "LoginPWModel.h"
#import "QlinkTabbarViewController.h"
#import "FingetprintVerificationUtil.h"
#import "ConfigUtil.h"
#import "ETHExportMnemonicViewController.h"

@interface ETHVerifyPWViewController ()

@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIView *passwrodBack;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UIButton *fingerprintBtn;

@end

@implementation ETHVerifyPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = MAIN_WHITE_COLOR;
    
    [self renderView];
    [self configInit];
}

#pragma mark - Operation
- (void)renderView {
    [_joinBtn cornerRadius:6];
    
    UIColor *cornerColor = UIColorFromRGB(0xE8EAEC);
    [_passwrodBack cornerRadius:6 strokeSize:1 color:cornerColor];
}

- (void)configInit {
    [_joinBtn setBackgroundColor:UIColorFromRGB(0xD5D8DD)];
    _joinBtn.userInteractionEnabled = NO;
    [_pwTF addTarget:self action:@selector(textFieldDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    _fingerprintBtn.hidden = ![ConfigUtil getLocalTouch];
}

- (void)textFieldDidEnd {
    if (_pwTF.text && _pwTF.text.length > 0) {
        [_joinBtn setBackgroundColor:MAIN_PURPLE_COLOR];
        _joinBtn.userInteractionEnabled = YES;
    } else {
        [_joinBtn setBackgroundColor:UIColorFromRGB(0xD5D8DD)];
        _joinBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)joinAction:(id)sender {
    [self.view endEditing:YES];
    NSString *localPW = [LoginPWModel getLoginPW];
    if (![localPW isEqualToString:_pwTF.text]) {
        [kAppD.window makeToastDisappearWithText:@"Password Wrong"];
        return;
    }
    
//    [self jumpToTabbar];
}

- (IBAction)fingerprintLoginAction:(id)sender {
    [self.view endEditing:YES];
    kWeakSelf(self);
    [FingetprintVerificationUtil show:^(BOOL success) {
        if (success) {
            [weakself jumpToETHExportMnemonic];
        }
    }];
}



#pragma mark - Transition
- (void)jumpToETHExportMnemonic {
    ETHExportMnemonicViewController *vc = [[ETHExportMnemonicViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
