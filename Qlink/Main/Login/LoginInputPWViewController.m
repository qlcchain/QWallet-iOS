//
//  LoginInputPWViewController.m
//  Qlink
//
//  Created by Jelly Foo on 2018/10/30.
//  Copyright © 2018 pan. All rights reserved.
//

#import "LoginInputPWViewController.h"
#import "LoginPWModel.h"
#import "QlinkTabbarViewController.h"
#import "FingerprintVerificationUtil.h"
#import "ConfigUtil.h"

@interface LoginInputPWViewController ()

@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIView *passwrodBack;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UIButton *fingerprintBtn;

@property (nonatomic, copy) LoginPWCompleteBlock completeBlock;

@end

@implementation LoginInputPWViewController

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
    if ([ConfigUtil getLocalTouch]) {
        [self fingerprintLoginAction:nil];
    }
}

- (void)textFieldDidEnd {
    if (_pwTF.text && _pwTF.text.length > 0) {
//        [_joinBtn setBackgroundColor:MAIN_BLUE_COLOR];
        _joinBtn.theme_backgroundColor = globalBackgroundColorPicker;
        _joinBtn.userInteractionEnabled = YES;
    } else {
        [_joinBtn setBackgroundColor:UIColorFromRGB(0xD5D8DD)];
        _joinBtn.userInteractionEnabled = NO;
    }
}

- (void)dismissWithComplete:(BOOL)isComplete {
    kWeakSelf(self)
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (isComplete) {
            if (weakself.completeBlock) {
                weakself.completeBlock();
            }
        }
    }];
}

- (void)configCompleteBlock:(LoginPWCompleteBlock)block {
    _completeBlock = block;
}

#pragma mark - Action

- (IBAction)closeAction:(id)sender {
    [self dismissWithComplete:NO];
}

- (IBAction)joinAction:(id)sender {
    NSString *localPW = [LoginPWModel getLoginPW];
    if (![localPW isEqualToString:_pwTF.text]) {
        [kAppD.window makeToastDisappearWithText:@"Password Wrong"];
        return;
    }
    
    kAppD.needFingerprintVerification = NO; // 设置已经输入过密码
    [self dismissWithComplete:YES];
//    [self jumpToTabbar];
}

- (IBAction)fingerprintLoginAction:(id)sender {
    kWeakSelf(self);
    [FingerprintVerificationUtil show:^(BOOL success) {
        if (success) {
//            [weakself jumpToTabbar];
            kAppD.needFingerprintVerification = NO; // 设置已经输入过密码
            [weakself dismissWithComplete:YES];
        }
    }];
}

#pragma mark - Transition
- (void)jumpToTabbar {
    [kAppD setRootTabbar];
    kAppD.tabbarC.selectedIndex = TabbarIndexWallet;
}

@end
